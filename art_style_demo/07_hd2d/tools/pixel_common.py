"""Shared palette, quantize, and pixel-draw helpers for the HD-2D experiment."""

from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image
from sklearn.cluster import MiniBatchKMeans

# Forge-night palette: hue-shifted ramps (shadows cooler, highlights warmer).
# Keep this list short; sprites pick a subset. Names are for Lua/docs.
PALETTE = {
    "empty": (0, 0, 0, 0),
    "outline": (28, 22, 26, 255),
    "metal_d": (48, 46, 58, 255),
    "metal_m": (92, 90, 102, 255),
    "metal_l": (168, 158, 148, 255),
    "metal_hi": (232, 214, 176, 255),
    "wood_d": (62, 38, 28, 255),
    "wood_m": (118, 72, 42, 255),
    "wood_l": (176, 118, 62, 255),
    "wrap": (86, 58, 44, 255),
    "stone_d": (42, 44, 52, 255),
    "stone_m": (74, 72, 78, 255),
    "stone_l": (112, 104, 96, 255),
    "ember_d": (148, 48, 22, 255),
    "ember_m": (220, 96, 28, 255),
    "ember_l": (255, 186, 72, 255),
    "night": (46, 78, 118, 255),
    "night_d": (22, 32, 52, 255),
    "skin_m": (196, 132, 96, 255),
    "leather": (92, 52, 36, 255),
}


def rgba(name: str) -> tuple[int, int, int, int]:
    return PALETTE[name]


def new_canvas(w: int, h: int) -> np.ndarray:
    return np.zeros((h, w, 4), dtype=np.uint8)


def put(img: np.ndarray, x: int, y: int, color: tuple[int, int, int, int]) -> None:
    h, w = img.shape[:2]
    if 0 <= x < w and 0 <= y < h:
        img[y, x] = color


def fill_rect(img: np.ndarray, x: int, y: int, w: int, h: int, color: tuple[int, int, int, int]) -> None:
    for yy in range(y, y + h):
        for xx in range(x, x + w):
            put(img, xx, yy, color)


def hline(img: np.ndarray, x0: int, x1: int, y: int, color: tuple[int, int, int, int]) -> None:
    if x1 < x0:
        x0, x1 = x1, x0
    for x in range(x0, x1 + 1):
        put(img, x, y, color)


def vline(img: np.ndarray, x: int, y0: int, y1: int, color: tuple[int, int, int, int]) -> None:
    if y1 < y0:
        y0, y1 = y1, y0
    for y in range(y0, y1 + 1):
        put(img, x, y, color)


def save_png(img: np.ndarray, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(img, "RGBA").save(path)


def quantize_kmeans(arr: np.ndarray, k: int, seed: int = 0) -> np.ndarray:
    h, w, _ = arr.shape
    opaque = arr[..., 3] >= 16
    out = np.zeros_like(arr)
    pts = arr[opaque][:, :3].astype(np.float32)
    if pts.size == 0:
        return out
    k_eff = int(min(k, pts.shape[0]))
    km = MiniBatchKMeans(n_clusters=k_eff, random_state=seed, batch_size=min(4096, pts.shape[0]), n_init=3)
    labels = km.fit_predict(pts)
    centers = np.clip(km.cluster_centers_, 0, 255).astype(np.uint8)
    mapped = np.zeros((pts.shape[0], 4), dtype=np.uint8)
    mapped[:, :3] = centers[labels]
    mapped[:, 3] = 255
    out[opaque] = mapped
    return out


def convert_image(src: Path, size: tuple[int, int], colors: int) -> Image.Image:
    im = Image.open(src).convert("RGBA")
    # Aseprite-like amateur convert: bicubic resize then indexed palette.
    resized = im.resize(size, Image.Resampling.BICUBIC)
    arr = quantize_kmeans(np.asarray(resized), colors)
    return Image.fromarray(arr, "RGBA")
