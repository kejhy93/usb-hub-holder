// Assembled visual check: holder + mock hub + mock right-angle plug, coloured.
// Not for printing. Render with shots.sh. Set SECTION=true to cut the near half.

NO_AUTO_RENDER = true;
include <hub_holder.scad>

SECTION = is_undef(SECTION) ? false : SECTION;

hub_bottom_z = total_h - pocket_depth;

module mock_hub() {
    translate([-hub_width/2, slot_cy - hub_thickness/2, hub_bottom_z])
        cube([hub_width, hub_thickness, hub_length]);
}

module mock_plug() {
    body_h = min(plug_body_height, 12);
    zc = hub_bottom_z - body_h + cable_diameter/2 + 1;   // cable centre height
    // straight-down plug body under the hub
    translate([-plug_body_width/2, slot_cy - plug_body_thickness/2, hub_bottom_z - body_h])
        cube([plug_body_width, plug_body_thickness, body_h]);
    // dogleg: cable turns 90 deg and runs out the RIGHT side (left is symmetric)
    hull() {
        translate([0, slot_cy, zc]) rotate([0, 90, 0])
            cylinder(d = cable_diameter, h = eps);
        translate([block_width/2 + 8, slot_cy, zc]) rotate([0, 90, 0])
            cylinder(d = cable_diameter, h = eps);
    }
}

module scene() {
    color([0.72, 0.74, 0.78]) holder();
    color([0.20, 0.50, 0.85]) mock_hub();
    color([0.95, 0.25, 0.75]) mock_plug();
}

if (SECTION)
    difference() { scene(); translate([0, -60, -60]) cube([60, 160, 260]); }
else
    scene();
