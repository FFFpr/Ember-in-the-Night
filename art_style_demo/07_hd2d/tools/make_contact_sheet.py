#!/usr/bin/env python3
"""Build a labeled 1x nearest contact sheet for pipeline comparison."""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[3]
EXP = ROOT / "art_style_demo" / "07_hd2d" / "experiment"
OUT = EXP / "out"


def load(path: Path, scale: int = 4) -> Image.Image:
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    return im.resize((w * scale, h * scale), Image.Resampling.NEAREST)


def panel(title: str, im: Image.Image, width: int) -> Image.Image:
    header = 22
    canvas = Image.new("RGBA", (width, im.height + header), (18, 16, 20, 255))
    draw = ImageDraw.Draw(canvas)
    try:
        font = ImageFont.load_default()
    except OSError:
        font = None
    draw.text((6, 4), title, fill=(230, 220, 200, 255), font=font)
    x = (width - im.width) // 2
    canvas.paste(im, (x, header), im)
    return canvas


def row(parts: list[Image.Image], gap: int = 8) -> Image.Image:
    h = max(p.height for p in parts)
    w = sum(p.width for p in parts) + gap * (len(parts) - 1)
    canvas = Image.new("RGBA", (w, h), (12, 10, 14, 255))
    x = 0
    for p in parts:
        canvas.paste(p, (x, 0), p)
        x += p.width + gap
    return canvas


def main() -> int:
    cells = []
    specs = [
        ("A: Demo A convert 320x180", OUT / "pipeline_a" / "workshop_from_demo_a.png", 2),
        ("A: existing Aseprite copy 384x256", ROOT / "Aseprite-User" / "export" / "scenes" / "workshop_fp" / "workshop_fp_full.png", 2),
        ("B: standard-first workshop 320x180", OUT / "pipeline_b" / "workshop.png", 2),
        ("A: prompt hammer 48", OUT / "pipeline_a" / "hammer_from_prompt.png", 6),
        ("B: standard hammer 48", OUT / "pipeline_b" / "hammer.png", 6),
        ("Aseprite-User hammer 48", ROOT / "Aseprite-User" / "export" / "weapons" / "hammer.png", 6),
        ("LPC hammer", ROOT / "art_style_demo" / "shared" / "imported" / "lpc_blacksmith" / "props" / "hammer_tool.png", 6),
        ("A: prompt anvil 64x48", OUT / "pipeline_a" / "anvil_from_prompt.png", 5),
        ("B: standard anvil 64x48", OUT / "pipeline_b" / "anvil.png", 5),
        ("LPC anvil", ROOT / "art_style_demo" / "shared" / "imported" / "lpc_blacksmith" / "props" / "anvil_block.png", 6),
        ("A: Demo A street convert", OUT / "pipeline_a" / "street_from_demo_a.png", 2),
        ("B: standard-first street", OUT / "pipeline_b" / "street.png", 2),
    ]
    for title, path, scale in specs:
        if not path.exists():
            print(f"missing {path}")
            continue
        im = load(path, scale)
        cells.append(panel(title, im, max(im.width, 280)))

    # Two rows: scenes, then props
    scene = row(cells[:3] + cells[10:12]) if len(cells) >= 5 else row(cells[:3])
    props = row(cells[3:10])
    gap = 12
    sheet = Image.new("RGBA", (max(scene.width, props.width), scene.height + props.height + gap), (8, 8, 10, 255))
    sheet.paste(scene, (0, 0), scene)
    sheet.paste(props, (0, scene.height + gap), props)
    dest = OUT / "contact_sheet.png"
    sheet.convert("RGB").save(dest, quality=90)
    print(f"wrote {dest} {sheet.size}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
