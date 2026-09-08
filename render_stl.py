#!/usr/bin/env python3
"""Offline STL -> PNG previews using trimesh + matplotlib (no GL needed).

Usage: render_stl.py OUTPREFIX file1.stl[:R,G,B] [file2.stl[:R,G,B] ...]
"""
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import trimesh

out_prefix = sys.argv[1]
specs = sys.argv[2:]

DEFAULT_COLS = [(0.30, 0.55, 0.85), (0.90, 0.55, 0.20), (0.25, 0.75, 0.35)]

all_tris, all_cols = [], []
lo = np.array([np.inf] * 3)
hi = np.array([-np.inf] * 3)
light = np.array([0.4, -0.7, 0.65]); light /= np.linalg.norm(light)

for i, spec in enumerate(specs):
    if ":" in spec:
        path, col = spec.split(":")
        base_col = np.array([float(x) for x in col.split(",")])
    else:
        path = spec
        base_col = np.array(DEFAULT_COLS[i % len(DEFAULT_COLS)])
    mesh = trimesh.load(path, force="mesh")
    tris = mesh.triangles
    n = mesh.face_normals
    shade = np.clip(np.abs(n @ light), 0, 1) * 0.65 + 0.35
    cols = np.clip(shade[:, None] * base_col[None, :], 0, 1)
    all_tris.append(tris)
    all_cols.append(cols)
    lo = np.minimum(lo, tris.reshape(-1, 3).min(axis=0))
    hi = np.maximum(hi, tris.reshape(-1, 3).max(axis=0))

tris = np.concatenate(all_tris)
cols = np.concatenate(all_cols)
ctr = (lo + hi) / 2
rad = (hi - lo).max() / 2 * 1.05

views = {"iso": (22, -58), "front": (6, -90), "side": (10, -2), "top": (78, -90)}

for name, (elev, azim) in views.items():
    fig = plt.figure(figsize=(6, 6), dpi=130)
    ax = fig.add_subplot(111, projection="3d")
    pc = Poly3DCollection(tris, facecolors=cols, edgecolors=(0, 0, 0, 0.12), linewidths=0.15)
    pc.set_zsort("max")
    ax.add_collection3d(pc)
    ax.set_xlim(ctr[0] - rad, ctr[0] + rad)
    ax.set_ylim(ctr[1] - rad, ctr[1] + rad)
    ax.set_zlim(ctr[2] - rad, ctr[2] + rad)
    ax.set_box_aspect((1, 1, 1))
    ax.view_init(elev=elev, azim=azim)
    ax.set_xlabel("X"); ax.set_ylabel("Y"); ax.set_zlabel("Z (up)")
    ax.set_title(f"{out_prefix}  [{name}]")
    fig.tight_layout()
    fn = f"{out_prefix}_{name}.png"
    fig.savefig(fn)
    plt.close(fig)
    print("wrote", fn)
