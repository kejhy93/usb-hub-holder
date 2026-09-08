// ============================================================================
//  Parametric desk stand for a flat USB hub  (right-angle / "dogleg" USB-C cable)
// ============================================================================
//
//  A small solid block that holds a thin, flat USB hub upright on your desk so
//  the USB-C socket on its BOTTOM end stays plugged in and usable. Designed for
//  a right-angle USB-C cable: the plug drops into a cavity under the hub and the
//  cable turns and leaves through either side (or straight down).
//
//  There are lots of near-identical "flat stick" USB hubs with slightly
//  different sizes, so everything is parametric - measure yours and type the
//  numbers into the parameters below (OpenSCAD Customizer, or edit the file).
//
//  ---------------------------------------------------------------------------
//  WHAT TO MEASURE  (calipers; take the largest reading, incl. any moulding
//  seam or lip around the socket)
//  ---------------------------------------------------------------------------
//
//   SIDE view                        FRONT view
//                                     ___________________
//        ___                         |   ___________     |
//       |   |  hub (stands            |  |    hub    |    |
//       |   |  vertically, USB-C      |  |___________|    |
//       |   |  socket pointing        |  |         |  |=  |=  cable exits
//       |___|  DOWN)                  |  |  front  |  |   |   the side
//      __| |__   plug_body_*          |  |  slot   |  |   |
//     |plug   |  (right-angle         |  |         |  |   |
//     |_______|   USB-C plug)         |__|         |___|
//        | |___  cable turns          |____|_______|____|
//                                      block sits flat on the desk
//         (the front slot runs the full height, straight through - no roof)
//
//  ---------------------------------------------------------------------------
//  PRINTING
//  ---------------------------------------------------------------------------
//    * Orientation: as modelled — flat on the bed, hub slot facing up.
//    * Supports: NONE. The block sits flat (no feet), the plug cavity is open
//      top and bottom, the front access slot runs straight through top to
//      bottom (no roof), and the cable channel roof is a 45-deg gable. There
//      is no horizontal internal face anywhere.
//    * Material: PLA/PETG both fine. ~15-20% infill; the mass helps it not tip.
//    * If the hub is a tight or loose fit, adjust `hub_clearance` (see notes
//      there) and reprint — no other change needed.
//
//  ---------------------------------------------------------------------------
//  License: CC-BY 4.0  —  attribution appreciated, commercial use allowed.
//  ============================================================================


/* [Hub - measure the USB hub you want to hold] */

// Hub WIDTH: the long side of the rectangular end (mm)
hub_width = 59;         // [10:0.5:120]
// Hub THICKNESS: the short side of the rectangular end (mm)
hub_thickness = 11;     // [3:0.5:30]
// Hub LENGTH: tip to tip. Not critical - only used for the on-screen preview
hub_length = 110;       // [20:200]


/* [Right-angle USB-C cable plug] */

// Plug body WIDTH - across the hub's wide axis, i.e. parallel to hub_width (mm)
plug_body_width = 21;        // [6:0.5:40]
// Plug body THICKNESS - across the hub's thin axis, parallel to hub_thickness (mm)
plug_body_thickness = 10;    // [4:0.5:20]
// Plug body HEIGHT - how far the plug + strain relief hangs below the hub (mm)
plug_body_height = 16;       // [6:40]
// Cable DIAMETER - the bare cable just past the plug (mm)
cable_diameter = 6;          // [2:0.5:12]
// Height of the side channel the turned cable escapes through (mm). Taller =
// easier to get a finger in from the side to pull the plug out.
cable_channel_height = 13;    // [4:30]
// FRONT access slot: opens the whole front of the plug cavity (full height,
// straight through) so you can grab the plug to unplug it. Width in mm across
// the hub; 0 = no slot. Because it runs top-to-bottom it has no roof, so it
// needs no support.
front_slot_width = 22;       // [0:40]


/* [Holder body] */

// Overall WIDTH of the block (mm). Wider = more stable side to side.
block_width = 80;            // [30:200]
// Overall DEPTH of the block, front to back (mm). Deeper = harder to tip
// forward/back - increase this if a tall hub feels wobbly.
block_depth = 32;            // [16:80]
// How far the hub sinks into the block (mm). More = firmer grip, taller print.
pocket_depth = 9;            // [4:40]


/* [Fit and finish] */

// Total clearance added to the hub slot, split over both sides (mm).
// FDM printers shrink slots, so some is always needed. Start ~0.4; if the hub
// won't go in, go to 0.6-0.8; if it rattles, drop to 0.2-0.3.
hub_clearance = 0.4;         // [0:0.05:1.5]
// Total clearance around the plug body cavity (mm). Keep this loose - the hub
// socket should be what grips the plug, not the holder. 2 mm is a good start;
// raise it if the plug is still hard to pull out.
plug_clearance = 2.0;        // [0:0.1:4]
// Extra width added to the side cable channel beyond the plug (mm, total). More
// room for a finger / for the cable to move.
channel_extra_width = 4;     // [0:0.5:15]
// Lead-in chamfer around the mouth of the hub slot (mm)
mouth_chamfer = 1.2;         // [0:0.1:4]
// Retention bump on each side of the slot so the hub doesn't rattle (mm of
// interference per side). 0 = none. Raise for a light "click"; lower it back
// to 0 if you then can't seat the hub.
retention_nub = 0;           // [0:0.05:1]


/* [Quality] */

// Curve resolution (higher = smoother nubs/preview, slower)
fn = 48;                     // [16:8:120]


/* [Hidden] */

$fn = fn;
eps = 0.02;                  // tiny overlap to keep booleans clean

// ---- derived slot / cavity sizes -------------------------------------------
slot_w = hub_width     + hub_clearance;     // hub slot opening (X)
slot_d = hub_thickness + hub_clearance;     // hub slot opening (Y)

cav_w  = plug_body_width     + plug_clearance;   // plug cavity, across width (X)
cav_d  = plug_body_thickness + plug_clearance;   // plug cavity, front-to-back (Y)

// ---- heights (Z, 0 = desk surface; block sits flat) ----------------------
total_h   = plug_body_height + pocket_depth;  // overall height
cav_top_z = plug_body_height;                 // where the plug cavity meets the slot

// side cable channel: at least as tall as the cable, capped so a ledge remains
channel_h = min(max(cable_channel_height, cable_diameter + 1), cav_top_z - 2);
// side channel depth (Y): the plug cavity plus finger room
channel_d = cav_d + channel_extra_width;

// front access slot width, capped so the hub keeps front wall + ledge each side
front_slot_w = (front_slot_width > 0) ? min(front_slot_width, slot_w - 16) : 0;

// ---- positions (Y, 0 = front face, block_depth = back face) --------------
cav_y0    = (block_depth - cav_d) / 2;      // plug cavity, centred in the depth
cav_y1    = cav_y0 + cav_d;
ch_y0     = (block_depth - channel_d) / 2;  // side channel, same centre, wider
ch_y1     = ch_y0 + channel_d;
slot_cy   = block_depth / 2;                // hub slot sits above the cavity
slot_y0   = slot_cy - slot_d / 2;
slot_y1   = slot_cy + slot_d / 2;

// ---- sanity checks --------------------------------------------------------
assert(block_width  >= slot_w + 6,
       "block_width is too small for this hub - increase block_width");
assert(block_depth  >= channel_d + 6,
       "block_depth is too small for the cable channel - increase block_depth or reduce channel_extra_width");
assert(block_depth  >= slot_d + 4,
       "block_depth is too small for the hub slot - increase block_depth");
assert(cav_d >= cable_diameter,
       "plug_body_thickness is too small for the cable - the cable channel would pinch it");

echo(str("Holder outer size  : ", block_width, " x ", block_depth,
         " x ", total_h, " mm (W x D x H)"));
echo(str("Hub slot opening   : ", slot_w, " x ", slot_d, " mm"));
echo(str("Hub sticks up ~    : ", hub_length - pocket_depth, " mm above the slot"));


// ============================================================================
//  Geometry
// ============================================================================

// Solid block that everything is cut from. Sits flat on the desk - no feet, so
// there is no overhang underneath to support.
module block_body() {
    translate([-block_width/2, 0, 0])
        cube([block_width, block_depth, total_h]);
}

// The slot the hub drops into, plus a chamfered lead-in at the top.
module hub_slot() {
    translate([-slot_w/2, slot_y0, cav_top_z])
        cube([slot_w, slot_d, pocket_depth + eps]);

    if (mouth_chamfer > 0)
        translate([0, slot_cy, total_h - mouth_chamfer])
            linear_extrude(height = mouth_chamfer + eps)
                offset(delta = mouth_chamfer)
                    square([slot_w, slot_d], center = true);
}

// Cavity for the right-angle plug. Everything here is open to the bed and/or
// the hub slot, so there is nothing to support. The plug ends up reachable
// from the front and from both sides, which is what makes it easy to unplug.
//   * a straight-down pocket directly under the hub (also open through the base)
//   * a wide side channel, no floor, 45-deg gabled roof, exits both sides
//   * a full-height front access slot (see front_access_slot)
module plug_cavity() {
    // straight-down pocket - open through the bottom of the block
    translate([-cav_w/2, cav_y0, -eps])
        cube([cav_w, cav_d, plug_body_height + eps]);

    // side cable channel, no floor, 45-deg gabled roof (near-point ridge)
    z1 = channel_h;
    ch = min(channel_d/2 - 0.3, channel_h - 1.5);   // 45-deg chamfer on top edges
    translate([-block_width/2 - eps, 0, 0])
        rotate([0, 90, 0])
            linear_extrude(height = block_width + 2*eps)
                polygon([
                    [ eps,       ch_y0],
                    [ eps,       ch_y1],
                    [-(z1 - ch), ch_y1],
                    [-z1,        ch_y1 - ch],
                    [-z1,        ch_y0 + ch],
                    [-(z1 - ch), ch_y0],
                ]);

    front_access_slot();
}

// Opens the FRONT of the plug cavity so you can grab the plug to pull it out.
// It just removes the front WALL of the pocket over `front_slot_w`, for the
// FULL height of the block. Open at the front, the top and the bottom, so it
// has no roof and no floor - nothing to support. It takes a bite out of the
// middle of the hub slot's front lip; the lip each side still holds the (much
// wider) hub, and the back wall ties the two sides together.
module front_access_slot() {
    if (front_slot_w > 0)
        translate([-front_slot_w/2, -eps, -eps])
            cube([front_slot_w, cav_y0 + 1, total_h + 2*eps]);
}

// Optional cones that pinch the hub lightly so it does not rattle. The
// underside is ~45 deg, so they print without support.
module retention_nubs() {
    if (retention_nub > 0)
        for (sx = [-1, 1])
            translate([sx * (slot_w/2 + 1.5), slot_cy, cav_top_z + pocket_depth/2])
                rotate([0, -sx * 90, 0])
                    cylinder(h = retention_nub + 1.5, r1 = 2, r2 = 0);
}

module holder() {
    union() {
        difference() {
            block_body();
            hub_slot();
            plug_cavity();
        }
        retention_nubs();
    }
}

// ---- preview / render -----------------------------------------------------
// A parent file can set NO_AUTO_RENDER=true to include this without drawing.
if (is_undef(NO_AUTO_RENDER)) holder();
