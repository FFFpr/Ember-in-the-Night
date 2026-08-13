#!/usr/bin/env python3
"""Measure unique colors and same-color clusters on sprites / refs.

Cluster = 4-connected component of identical RGBA. Speckles are size-1/2 clusters.
Paintings with huge palettes skip exact clustering and report quantized clusters instead.
"""

from __future__ import annotations

import csv
import json
import math
import sys
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[3]
OUT_DIR = Path(__file__).resolve().parents[1] / "experiment" / "metrics"

QUANTIZE_K = 32


def load_rgba(path: Path) -> np.ndarray:
    im = Image.open(path).convert("RGBA")
    return np.asarray(im)


def opaque_mask(arr: np.ndarray, alpha_min: int = 16) -> np.ndarray:
    return arr[..., 3] >= alpha_min


def unique_colors(arr: np.ndarray, mask: np.ndarray) -> int:
    if not np.any(mask):
        return 0
    packed = (
        arr[..., 0].astype(np.uint32) << 24
        | arr[..., 1].astype(np.uint32) << 16
        | arr[..., 2].astype(np.uint32) << 8
        | arr[..., 3].astype(np.uint32)
    )
    return int(np.unique(packed[mask]).size)


def kmeans_labels(arr: np.ndarray, mask: np.ndarray, k: int, seed: int = 0) -> np.ndarray:
    """Return HxW int labels; transparent pixels = -1."""
    from sklearn.cluster import MiniBatchKMeans

    h, w, _ = arr.shape
    labels = np.full((h, w), -1, dtype=np.int32)
    pts = arr[mask][:, :3].astype(np.float32)
    if pts.shape[0] == 0:
        return labels
    k_eff = int(min(k, pts.shape[0], unique_colors(arr, mask)))
    if k_eff <= 1:
        labels[mask] = 0
        return labels
    km = MiniBatchKMeans(n_clusters=k_eff, random_state=seed, batch_size=min(4096, pts.shape[0]), n_init=3)
    labels[mask] = km.fit_predict(pts)
    return labels


def cluster_sizes_from_labels(labels: np.ndarray) -> list[int]:
    h, w = labels.shape
    seen = np.zeros((h, w), dtype=bool)
    sizes: list[int] = []
    for y in range(h):
        row = labels[y]
        for x in range(w):
            if seen[y, x] or row[x] < 0:
                continue
            color = int(row[x])
            n = 0
            q = deque([(y, x)])
            seen[y, x] = True
            while q:
                cy, cx = q.popleft()
                n += 1
                if cx + 1 < w and not seen[cy, cx + 1] and labels[cy, cx + 1] == color:
                    seen[cy, cx + 1] = True
                    q.append((cy, cx + 1))
                if cx > 0 and not seen[cy, cx - 1] and labels[cy, cx - 1] == color:
                    seen[cy, cx - 1] = True
                    q.append((cy, cx - 1))
                if cy + 1 < h and not seen[cy + 1, cx] and labels[cy + 1, cx] == color:
                    seen[cy + 1, cx] = True
                    q.append((cy + 1, cx))
                if cy > 0 and not seen[cy - 1, cx] and labels[cy - 1, cx] == color:
                    seen[cy - 1, cx] = True
                    q.append((cy - 1, cx))
            sizes.append(n)
    return sizes


def summarize_clusters(sizes: list[int]) -> dict:
    if not sizes:
        return {
            "clusters": 0,
            "mean_cluster": 0.0,
            "median_cluster": 0.0,
            "speckle_ratio": 0.0,
            "readable_clusters": 0,
        }
    arr = np.array(sizes, dtype=np.float64)
    speckles = int(np.sum(arr <= 2))
    readable = int(np.sum(arr >= 4))
    return {
        "clusters": int(arr.size),
        "mean_cluster": float(arr.mean()),
        "median_cluster": float(np.median(arr)),
        "speckle_ratio": float(speckles / arr.size),
        "readable_clusters": readable,
    }


def measure(path: Path, group: str) -> dict:
    arr = load_rgba(path)
    h, w = arr.shape[:2]
    mask = opaque_mask(arr)
    opaque = int(mask.sum())
    colors = unique_colors(arr, mask)
    area = max(opaque, 1)
    sqrt_area = math.sqrt(area)
    rec: dict = {
        "group": group,
        "path": str(path.relative_to(ROOT)),
        "w": w,
        "h": h,
        "canvas": w * h,
        "opaque": opaque,
        "unique_colors": colors,
        "colors_per_sqrt": colors / sqrt_area,
        "pixels_per_color": area / max(colors, 1),
    }

    do_exact = colors > 0 and colors <= 256 and opaque <= 250_000
    if do_exact:
        packed = (
            arr[..., 0].astype(np.int32) << 16
            | arr[..., 1].astype(np.int32) << 8
            | arr[..., 2].astype(np.int32)
        )
        packed = np.where(mask, packed, -1)
        rec.update({f"exact_{k}": v for k, v in summarize_clusters(cluster_sizes_from_labels(packed)).items()})
    else:
        rec.update(
            {
                "exact_clusters": None,
                "exact_mean_cluster": None,
                "exact_median_cluster": None,
                "exact_speckle_ratio": None,
                "exact_readable_clusters": None,
            }
        )

    q_labels = kmeans_labels(arr, mask, QUANTIZE_K)
    rec.update({f"q32_{k}": v for k, v in summarize_clusters(cluster_sizes_from_labels(q_labels)).items()})
    rec["q32_colors"] = int(q_labels.max() + 1) if np.any(q_labels >= 0) else 0
    rec["q32_colors_per_sqrt"] = rec["q32_colors"] / sqrt_area
    rec["q32_pixels_per_color"] = area / max(rec["q32_colors"], 1)
    return rec


def targets() -> list[tuple[str, Path]]:
    items: list[tuple[str, Path]] = []
    refs = ROOT / "art_style_demo" / "references"
    for name in [
        "workshop_fp_ref.png",
        "street_day_ref.png",
        "street_night_ref.png",
        "workshop_fp_pixel_ref.png",
        "street_day_pixel_ref.png",
        "street_night_pixel_ref.png",
    ]:
        items.append(("demo_ref", refs / name))

    ase = ROOT / "Aseprite-User" / "export"
    for p in sorted(ase.rglob("*.png")):
        items.append(("aseprite_user", p))

    lpc_props = ROOT / "art_style_demo" / "shared" / "imported" / "lpc_blacksmith" / "props"
    for p in sorted(lpc_props.glob("*.png")):
        items.append(("lpc_prop", p))

    lpc_slices = ROOT / "art_style_demo" / "shared" / "imported" / "lpc_base_assets" / "slices"
    for name in [
        "barrel_0.png",
        "door_wood.png",
        "window_house.png",
        "sign_sword.png",
        "wall_brick_fill.png",
        "floor_cobble.png",
        "beam_wood.png",
        "horseshoe.png",
    ]:
        p = lpc_slices / name
        if p.exists():
            items.append(("lpc_slice", p))

    exp = ROOT / "art_style_demo" / "07_hd2d" / "experiment" / "out"
    if exp.exists():
        for p in sorted(exp.rglob("*.png")):
            if p.name == "contact_sheet.png":
                continue
            items.append(("experiment", p))
    return [(g, p) for g, p in items if p.exists()]


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    rows = []
    for group, path in targets():
        print(f"measuring {group} {path.name} ...", flush=True)
        rec = measure(path, group)
        rows.append(rec)
        print(
            f"  {rec['w']}x{rec['h']} opaque={rec['opaque']} colors={rec['unique_colors']} "
            f"c/√A={rec['colors_per_sqrt']:.3f} px/c={rec['pixels_per_color']:.1f}",
            flush=True,
        )

    csv_path = OUT_DIR / "sprite_metrics.csv"
    json_path = OUT_DIR / "sprite_metrics.json"
    if rows:
        keys = list(rows[0].keys())
        with csv_path.open("w", newline="") as f:
            wri = csv.DictWriter(f, fieldnames=keys)
            wri.writeheader()
            wri.writerows(rows)
    json_path.write_text(json.dumps(rows, indent=2) + "\n")
    print(f"wrote {csv_path} ({len(rows)} rows)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
