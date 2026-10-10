"""Draw the glowshroom textures as 16x16 pixel art (no dependencies).

The textures are produced by this script, which was written with AI assistance;
see LICENSE. Run: python3 tools/make_textures.py
"""

import struct
import zlib
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "textures"
T = (0, 0, 0, 0)  # transparent


def png(path: Path, pixels: list[list[tuple[int, int, int, int]]]) -> None:
    h, w = len(pixels), len(pixels[0])
    raw = b"".join(b"\x00" + b"".join(struct.pack("BBBB", *px) for px in row) for row in pixels)

    def chunk(kind: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data) & 0xFFFFFFFF)

    path.write_bytes(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
                     + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b""))


PALETTE = {
    ".": T,
    "c": (64, 224, 208, 255),   # cap, glowing cyan
    "C": (150, 255, 240, 255),  # cap highlight
    "d": (24, 140, 150, 255),   # cap shadow
    "s": (220, 255, 250, 255),  # spots
    "g": (120, 200, 190, 255),  # gills
    "w": (214, 222, 200, 255),  # stem
    "W": (170, 180, 160, 255),  # stem shadow
}

GLOWSHROOM = [
    "................",
    "................",
    ".....CCcc.......",
    "...CCcscccc.....",
    "..CccccccsCc....",
    "..cscccccccc....",
    ".dccccsccccd....",
    ".dddggggggdd....",
    "......wW.....Cc.",
    "......wW...Ccscc",
    "......wW..dcccsd",
    ".....wwW..ddggdd",
    ".....wWW....wW..",
    ".....wWW....wW..",
    "....wwWWW..wwWW.",
    "................",
]

LAMP_PALETTE = {
    "f": (40, 52, 58, 255),     # frame
    "F": (70, 86, 92, 255),     # frame highlight
    "b": (20, 90, 96, 255),     # dark glass
    "c": (64, 224, 208, 255),
    "C": (170, 255, 245, 255),
    "s": (235, 255, 252, 255),
}

LAMP = [
    "FFFFFFFFFFFFFFFf",
    "Fbbbbbbbbbbbbbbf",
    "Fbbccbbbbbbccbbf",
    "FbcCCcbbbbcsCcbf",
    "FbcCsCcbbcCCCcbf",
    "FbbcCcbbbbcCcbbf",
    "Fbbbbbbccbbbbbbf",
    "FbbbbbcCCcbbbbbf",
    "FbbbbcCsCCcbbbbf",
    "FbbbbbcCCcbbbbbf",
    "Fbbccbbccbbbccbf",
    "FbcCCcbbbbbcCCbf",
    "FbcCsCbbbbcCsCcf",
    "FbbcCcbbbbbcCcbf",
    "Fbbbbbbbbbbbbbbf",
    "ffffffffffffffff",
]


def render(rows: list[str], palette: dict) -> list[list[tuple[int, int, int, int]]]:
    return [[palette[ch] for ch in row] for row in rows]


if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    png(OUT / "glowshroom_glowshroom.png", render(GLOWSHROOM, PALETTE))
    png(OUT / "glowshroom_lamp.png", render(LAMP, LAMP_PALETTE))
    print("wrote", *sorted(p.name for p in OUT.glob("*.png")))
