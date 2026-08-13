#!/usr/bin/env python3
"""Pipeline B: cluster-first sprites under the locked HD-2D pixel standard."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from pixel_common import fill_rect, hline, new_canvas, rgba, save_png, vline

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / "art_style_demo" / "07_hd2d" / "experiment" / "out" / "pipeline_b"

O = rgba("outline")
MD, MM, ML, MH = rgba("metal_d"), rgba("metal_m"), rgba("metal_l"), rgba("metal_hi")
WD, WM, WL = rgba("wood_d"), rgba("wood_m"), rgba("wood_l")
WRAP = rgba("wrap")
SD, SM, SL = rgba("stone_d"), rgba("stone_m"), rgba("stone_l")
ED, EM, EL = rgba("ember_d"), rgba("ember_m"), rgba("ember_l")
ND, N = rgba("night_d"), rgba("night")
LEATHER = rgba("leather")


def hammer_48() -> None:
    """Left-facing square-head hammer. 48x48, wrap pivot ~(31,23)."""
    img = new_canvas(48, 48)
    # Head: slightly taller face, short peen on left, cheek into handle.
    fill_rect(img, 8, 11, 14, 18, MM)
    fill_rect(img, 9, 12, 12, 5, ML)
    hline(img, 10, 19, 12, MH)
    fill_rect(img, 9, 23, 12, 5, MD)
    fill_rect(img, 4, 16, 4, 8, MM)  # peen
    fill_rect(img, 4, 16, 4, 2, ML)
    fill_rect(img, 4, 22, 4, 2, MD)
    fill_rect(img, 22, 16, 3, 8, MM)
    hline(img, 4, 21, 10, O)
    hline(img, 4, 21, 29, O)
    vline(img, 3, 16, 23, O)
    vline(img, 7, 11, 15, O)
    vline(img, 7, 24, 28, O)
    vline(img, 22, 11, 15, O)
    vline(img, 22, 24, 28, O)
    # Handle tapers into wrap then butt.
    fill_rect(img, 25, 18, 16, 6, WM)
    fill_rect(img, 25, 18, 16, 2, WL)
    fill_rect(img, 25, 22, 16, 2, WD)
    fill_rect(img, 31, 18, 6, 6, WRAP)
    fill_rect(img, 32, 19, 4, 2, WL)
    hline(img, 25, 41, 17, O)
    hline(img, 25, 41, 24, O)
    vline(img, 42, 18, 23, O)
    save_png(img, OUT / "hammer.png")


def anvil_64x48() -> None:
    img = new_canvas(64, 48)
    fill_rect(img, 18, 36, 28, 10, WM)
    fill_rect(img, 18, 36, 28, 2, WL)
    fill_rect(img, 18, 43, 28, 3, WD)
    hline(img, 18, 45, 35, O)
    hline(img, 18, 45, 45, O)
    vline(img, 17, 36, 45, O)
    vline(img, 46, 36, 45, O)
    # Face + waist + feet (LPC-like planes, no noise).
    fill_rect(img, 20, 16, 24, 5, ML)
    hline(img, 22, 40, 16, MH)
    fill_rect(img, 20, 21, 24, 6, MM)
    fill_rect(img, 24, 27, 16, 9, MD)
    fill_rect(img, 18, 32, 28, 4, MM)
    # Horn steps left, heel block right.
    fill_rect(img, 10, 16, 10, 4, ML)
    fill_rect(img, 8, 18, 12, 4, MM)
    fill_rect(img, 12, 22, 8, 3, MD)
    fill_rect(img, 44, 16, 10, 8, MM)
    fill_rect(img, 44, 16, 10, 3, ML)
    hline(img, 8, 53, 15, O)
    hline(img, 8, 19, 25, O)
    hline(img, 18, 45, 35, O)
    vline(img, 7, 18, 24, O)
    vline(img, 54, 16, 23, O)
    save_png(img, OUT / "anvil.png")


def forge_96x80() -> None:
    img = new_canvas(96, 80)
    fill_rect(img, 12, 18, 72, 54, SM)
    fill_rect(img, 12, 18, 72, 8, SL)
    fill_rect(img, 12, 60, 72, 12, SD)
    # Arch opening
    fill_rect(img, 30, 32, 36, 30, O)
    fill_rect(img, 32, 34, 32, 26, ED)
    fill_rect(img, 36, 38, 24, 18, EM)
    fill_rect(img, 42, 42, 12, 10, EL)
    # Arch stones
    hline(img, 28, 67, 30, SL)
    fill_rect(img, 28, 32, 4, 30, SM)
    fill_rect(img, 64, 32, 4, 30, SM)
    # Outline
    hline(img, 12, 83, 17, O)
    hline(img, 12, 83, 71, O)
    vline(img, 11, 18, 71, O)
    vline(img, 84, 18, 71, O)
    save_png(img, OUT / "forge.png")


def workshop_320x180() -> None:
    """First-person workshop blocking matching Demo A composition, cluster-first."""
    img = new_canvas(320, 180)
    fill_rect(img, 0, 0, 320, 112, SD)
    fill_rect(img, 0, 0, 320, 18, WD)
    # Posts / beams (read as timber, not a UI chrome bar).
    fill_rect(img, 0, 16, 12, 96, WM)
    fill_rect(img, 308, 16, 12, 96, WM)
    fill_rect(img, 0, 16, 320, 6, WD)
    fill_rect(img, 0, 112, 320, 44, SM)
    fill_rect(img, 0, 112, 320, 4, SL)
    fill_rect(img, 24, 120, 40, 10, SD)
    fill_rect(img, 88, 128, 52, 8, SD)
    fill_rect(img, 200, 118, 48, 12, SD)
    fill_rect(img, 0, 156, 320, 24, WD)
    fill_rect(img, 0, 152, 320, 6, WM)
    fill_rect(img, 0, 152, 320, 2, WL)
    # Window + horseshoes
    fill_rect(img, 18, 34, 30, 32, O)
    fill_rect(img, 20, 36, 26, 28, ND)
    fill_rect(img, 22, 38, 10, 24, N)
    fill_rect(img, 34, 38, 10, 24, N)
    vline(img, 32, 36, 63, O)
    hline(img, 20, 45, 50, O)
    for i in range(3):
        fill_rect(img, 56, 36 + i * 12, 12, 8, MM)
        fill_rect(img, 58, 38 + i * 12, 8, 4, SD)
    # Forge: stepped arch so it reads as a hearth, not a monitor.
    fill_rect(img, 118, 38, 88, 72, SL)
    fill_rect(img, 124, 44, 76, 62, SM)
    fill_rect(img, 124, 44, 76, 8, SL)
    fill_rect(img, 148, 54, 28, 4, SD)
    fill_rect(img, 140, 58, 44, 6, SD)
    fill_rect(img, 136, 64, 52, 36, O)
    fill_rect(img, 140, 68, 44, 30, ED)
    fill_rect(img, 148, 74, 28, 20, EM)
    fill_rect(img, 156, 80, 12, 10, EL)
    # Anvil with horn
    fill_rect(img, 128, 108, 14, 6, ML)
    fill_rect(img, 142, 104, 40, 8, ML)
    hline(img, 146, 176, 104, MH)
    fill_rect(img, 148, 112, 28, 10, MD)
    fill_rect(img, 144, 122, 36, 8, MM)
    fill_rect(img, 152, 130, 20, 10, WM)
    # Barrel / bellows
    fill_rect(img, 44, 116, 32, 36, WM)
    fill_rect(img, 46, 118, 28, 8, N)
    fill_rect(img, 44, 116, 32, 4, WL)
    fill_rect(img, 48, 128, 24, 3, WD)
    fill_rect(img, 218, 102, 46, 36, WRAP)
    fill_rect(img, 226, 92, 28, 14, WM)
    fill_rect(img, 226, 92, 28, 4, WL)
    fill_rect(img, 238, 86, 6, 10, WD)
    # Glove + hammer on bench
    fill_rect(img, 36, 158, 40, 18, LEATHER)
    fill_rect(img, 40, 160, 32, 6, WL)
    fill_rect(img, 188, 146, 18, 16, MM)
    fill_rect(img, 190, 146, 14, 4, MH)
    fill_rect(img, 206, 152, 44, 7, WM)
    fill_rect(img, 206, 152, 44, 2, WL)
    fill_rect(img, 236, 152, 10, 7, WRAP)
    save_png(img, OUT / "workshop.png")


def street_320x180() -> None:
    img = new_canvas(320, 180)
    fill_rect(img, 0, 0, 320, 88, N)
    fill_rect(img, 0, 72, 320, 28, ND)
    fill_rect(img, 0, 100, 320, 80, SM)
    fill_rect(img, 0, 100, 320, 6, SL)
    fill_rect(img, 40, 108, 36, 10, SD)
    fill_rect(img, 120, 116, 50, 8, SD)
    fill_rect(img, 220, 110, 40, 10, SD)
    # Shop: stone ground floor, plaster+timber above, slate roof.
    fill_rect(img, 20, 40, 148, 64, SL)
    fill_rect(img, 20, 84, 148, 28, SM)
    fill_rect(img, 16, 28, 156, 16, rgba("night"))
    fill_rect(img, 24, 32, 140, 10, ND)
    fill_rect(img, 24, 40, 8, 72, WD)
    fill_rect(img, 88, 40, 8, 72, WD)
    fill_rect(img, 156, 40, 8, 72, WD)
    fill_rect(img, 20, 68, 148, 6, WD)
    fill_rect(img, 36, 48, 22, 16, ND)
    fill_rect(img, 112, 48, 22, 16, ND)
    fill_rect(img, 40, 86, 26, 26, WD)
    fill_rect(img, 42, 88, 22, 22, WM)
    fill_rect(img, 96, 86, 44, 26, SD)
    fill_rect(img, 104, 92, 28, 16, ED)
    fill_rect(img, 112, 96, 12, 8, EL)
    fill_rect(img, 72, 54, 24, 14, WD)
    fill_rect(img, 78, 58, 12, 6, ML)
    fill_rect(img, 176, 108, 22, 24, WM)
    fill_rect(img, 176, 108, 22, 4, WL)
    fill_rect(img, 202, 112, 18, 20, WM)
    fill_rect(img, 228, 116, 14, 16, MM)
    save_png(img, OUT / "street.png")


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    hammer_48()
    anvil_64x48()
    forge_96x80()
    workshop_320x180()
    street_320x180()
    print(f"wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
