# USB Hub Holder

A parametric, print-in-place desk stand that holds a thin, flat USB hub
**upright** on your desk so the **USB-C socket on its bottom end** stays plugged
in and usable.

It's designed around a **right-angle ("dogleg") USB-C cable**: the plug drops
into a cavity under the hub, and the cable turns and leaves through **either
side** or straight down through the base. A **full-height slot in the front**
lets you reach in and pull the plug out without fighting it.

![preview](shot_iso.png)

---

## Features

- **Fits your hub, not mine.** Every dimension is a parameter. "Flat stick"
  USB hubs all differ by a couple of millimetres — measure yours, type in the
  numbers, print.
- **No supports.** Prints flat, hub slot up. The block sits directly on the bed
  (no feet), the plug cavity is open top and bottom, the front slot runs
  straight through, and the only roof in the model is a 45° gable. There is no
  horizontal internal face anywhere.
- **Easy to unplug.** The plug is held only by the hub's own socket — the
  holder gives it clearance on all sides and opens the whole front.
- **No hardware.** No glue, no screws, no magnets. Just the print.

Default size: **80 × 32 × 25 mm** block; a 110 mm hub stands ~100 mm proud.

---

## How it works

```
  SIDE view                         FRONT view
                                     ___________________
       ___                          |   ___________     |
      |   |  hub stands             |  |    hub    |    |
      |   |  vertically,            |  |___________|    |
      |   |  USB-C socket           |  |         |  |== cable exits
      |___|  pointing DOWN          |  |  front  |  |   the side (or
     __| |__   right-angle          |  |  slot   |  |   down, or the
    |plug   |  USB-C plug           |  |         |  |   other side)
    |_______|                       |__|         |___|
       | |___  cable turns          |____|_______|____|
                                     block sits flat on the desk
```

- The hub drops into a slot in the top; it rests on two internal ledges and is
  held front-to-back by the slot walls.
- The plug hangs into a cavity below. That cavity is open through the base, and
  a channel carries the turned cable out through both side faces.
- The front slot removes the middle of the front wall over the plug, full
  height, so you can grab the plug. The block stays rigid: the sides are solid
  and the back wall ties them together.

---

## Fitting your hub

Open `hub_holder.scad` in [OpenSCAD](https://openscad.org/). Use
**Window → Customizer**, or edit the values at the top of the file.

### 1. Measure the hub

Calipers, take the **largest** reading — include any moulding seam or the lip
around the socket.

| Parameter       | What to measure                          |
|-----------------|------------------------------------------|
| `hub_width`     | long side of the rectangular end         |
| `hub_thickness` | short side of the rectangular end        |
| `hub_length`    | tip to tip (on-screen preview only)      |

### 2. Measure the right-angle plug on your cable

| Parameter             | What to measure                                      |
|-----------------------|-----------------------------------------------------|
| `plug_body_width`     | plug body, across the hub's **wide** axis            |
| `plug_body_thickness` | plug body, across the hub's **thin** axis            |
| `plug_body_height`    | how far the plug + strain relief hangs below the hub |
| `cable_diameter`      | the bare cable just past the plug                    |

### 3. Render (F6), export STL (F7), print.

The console prints the resulting outer size, slot opening, and how far the hub
will stick up.

---

## All parameters

### Hub

| Parameter       | Default | Notes                          |
|-----------------|--------:|--------------------------------|
| `hub_width`     |    59   | long side of the end           |
| `hub_thickness` |    11   | short side of the end          |
| `hub_length`    |   110   | preview only, not critical     |

### Right-angle USB-C cable plug

| Parameter              | Default | Notes                                             |
|------------------------|--------:|---------------------------------------------------|
| `plug_body_width`      |    21   | across the hub's wide axis                         |
| `plug_body_thickness`  |    10   | across the hub's thin axis                         |
| `plug_body_height`     |    16   | drop below the hub                                 |
| `cable_diameter`       |     6   | bare cable                                         |
| `cable_channel_height` |    13   | side channel height — taller = easier finger access|
| `front_slot_width`     |    22   | front access slot width; `0` closes the front      |

### Holder body

| Parameter      | Default | Notes                                          |
|----------------|--------:|------------------------------------------------|
| `block_width`  |    80   | wider = more stable side to side               |
| `block_depth`  |    32   | deeper = harder to tip forward/back            |
| `pocket_depth` |     9   | how far the hub sinks in; more = firmer grip   |

### Fit and finish

| Parameter             | Default | Notes                                                   |
|-----------------------|--------:|---------------------------------------------------------|
| `hub_clearance`       |   0.4   | total slack in the hub slot (both sides). See below.     |
| `plug_clearance`      |   2.0   | slack around the plug — keep loose so only the socket grips it |
| `channel_extra_width` |     4   | extra width in the side cable channel                    |
| `mouth_chamfer`       |   1.2   | lead-in around the top of the hub slot                   |
| `retention_nub`       |     0   | tiny bumps that pinch the hub so it doesn't rattle       |

### Quality

| Parameter | Default | Notes                    |
|-----------|--------:|--------------------------|
| `fn`      |    48   | curve resolution         |

---

## Printing

| | |
|---|---|
| **Orientation** | as modelled — flat on the bed, hub slot facing up |
| **Supports**    | none (see *Features*) |
| **Material**    | PLA or PETG |
| **Infill**      | ~15–20 % — the mass is what keeps it from tipping |
| **Layer height**| anything; 0.2 mm is fine |

---

## Troubleshooting

**The hub doesn't fit / rattles.** Change only `hub_clearance` and reprint. FDM
printers shrink slots, so some slack is always needed.

- won't go in → raise it (`0.6`, then `0.8`)
- rattles → lower it (`0.3`, then `0.2`), or add a little `retention_nub`

**A tall hub feels tippy.** Increase `block_depth` (front-to-back is the weak
direction) and/or `pocket_depth` for a firmer grip.

**The plug is hard to pull out.** The holder shouldn't grip the plug at all —
only the hub's socket should. Raise `plug_clearance` (`2.5`, then `3`). You can
also widen `front_slot_width` and `cable_channel_height` for more finger room.

**A parameter combination doesn't make sense.** The script `assert()`s with a
plain-language message telling you which value to change.

---

## Repository

| File                 | Purpose                                              |
|----------------------|------------------------------------------------------|
| `hub_holder.scad`    | the model — the only file you need                   |
| `hub_holder.stl`     | ready-to-slice mesh at the default parameters        |
| `hub_holder.3mf`     | same, project format                                 |
| `preview_scene.scad` | coloured holder + mock hub + mock plug, for renders  |
| `shots.sh`           | renders the preview PNGs (Linux, flatpak OpenSCAD)   |
| `render_stl.py`      | no-GPU STL→PNG fallback previewer (trimesh + matplotlib) |

### Rendering previews

```sh
# STL only (headless):
flatpak run org.openscad.OpenSCAD -o hub_holder.stl hub_holder.scad

# PNG previews:
./shots.sh
```

---

## Contributing / remixing

Issues and PRs welcome — especially fit numbers for specific hub models.
Remixes are encouraged; a link back is appreciated.

## License

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) — use it, sell prints
of it, remix it; just credit the source.
