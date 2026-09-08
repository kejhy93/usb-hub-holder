#!/bin/bash
# Render OpenSCAD PNG previews (headless via flatpak + x11).
set -e
FP="flatpak run --socket=x11 --share=ipc --device=all --env=DISPLAY=:0 org.openscad.OpenSCAD"
CS=Tomorrow
SZ=1100,850
Q="-viewall -viewall"

$FP --colorscheme=$CS --imgsize=$SZ --view=scales --projection=p \
    --camera=0,0,0,62,0,25,0 --viewall -o shot_iso.png     preview_scene.scad
$FP --colorscheme=$CS --imgsize=$SZ --projection=o \
    --camera=0,0,0,90,0,0,0 --viewall  -o shot_front.png   preview_scene.scad
$FP --colorscheme=$CS --imgsize=$SZ --projection=o \
    --camera=0,0,0,90,0,90,0 --viewall -o shot_side.png    preview_scene.scad
$FP --colorscheme=$CS --imgsize=$SZ --projection=p \
    --camera=0,0,0,62,0,25,0 --viewall -o shot_section.png preview_scene.scad -D 'SECTION=true'
echo done
