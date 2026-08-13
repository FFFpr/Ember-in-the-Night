#!/usr/bin/env python3
"""Pipeline A: high-detail illustration → resize → k-means palette (Aseprite-like convert)."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from pixel_common import convert_image  # noqa: E402

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / "art_style_demo" / "07_hd2d" / "experiment" / "out" / "pipeline_a"
ART = Path("/opt/cursor/artifacts/assets")


JOBS = [
    {
        "src": ROOT / "art_style_demo" / "references" / "workshop_fp_ref.png",
        "name": "workshop_from_demo_a",
        "size": (320, 180),
        "colors": 32,
    },
    {
        "src": ROOT / "art_style_demo" / "references" / "workshop_fp_ref.png",
        "name": "workshop_from_demo_a_48c",
        "size": (384, 256),
        "colors": 48,
    },
    {
        "src": ROOT / "art_style_demo" / "references" / "street_day_ref.png",
        "name": "street_from_demo_a",
        "size": (320, 180),
        "colors": 32,
    },
    {
        "src": ART / "pipeline_a_hammer_src.png",
        "name": "hammer_from_prompt",
        "size": (48, 48),
        "colors": 10,
    },
    {
        "src": ART / "pipeline_a_anvil_src.png",
        "name": "anvil_from_prompt",
        "size": (64, 48),
        "colors": 12,
    },
]


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    for job in JOBS:
        src = Path(job["src"])
        if not src.exists():
            print(f"skip missing {src}")
            continue
        print(f"convert {src.name} -> {job['name']} {job['size']} {job['colors']}c")
        im = convert_image(src, job["size"], job["colors"])
        im.save(OUT / f"{job['name']}.png")
    # Keep a tiny note of prompt sources without committing 7MB originals.
    note = OUT / "SOURCES.txt"
    note.write_text(
        "workshop/street: art_style_demo/references/*_ref.png (Demo A)\n"
        "hammer/anvil isolated: GenerateImage outputs used at convert time from "
        "/opt/cursor/artifacts/assets/pipeline_a_*_src.png\n"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
