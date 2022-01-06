// Riskable's Cherry MX void/cutout module for making keyboard (top) plates and key switch testers

$fn = 32;

use <utils.scad> // Because it's nice to have rounded corners on these sorts of things

// AUTHOR: Riskable <riskable@youknowwhat.com>
// VERSION: 1.1 (Changelog is at the bottom)
// LICENSE: Creative Commons - Attribution - Non-Commercial (if you want to use it in a commercial setting/product just ask!)

// NOTES
/*
    * Feel free to use this .scad in your own projects to add proper Cherry MX-styled switch cutouts to keyboards, perhipherals, testers, or whatever you like.
    * You can just copy cherry_switch_void() into your own code if you like--it's entirely self-contained and reasonably small.  Just make sure to credit it, "// This module was written by Riskable:" or something like that =)
    * Actual Cherry MX Measurements:
        * Length/Width outside dimentions: 15.5mm x 13.95mm
        * Length/Width under the overhang (no "under" on one side though): 13.95mm x 13.95mm
        * In essence, it only overhangs on two sides and the basic cherry "hole" would be 14x14mm
*/

/* Creates the shape of a (proper) Cherry MX switch hole.
    height: The thickness, really.  Doesn't impact PLATE_THICKNESS
    x_extra: Extra (void) space on the X axis (e.g. to save some plastic). Doesn't change the top plate.
    y_extra: Extra (void) space on the Y axis.  Same thing as X.
    tolerance: Extra room on all sides (0.1 default should be good for most printers)
    plate_thickness: How thick the top plate will be. Typical Cherry MX plates are about 1.5mm thick.
*/
module cherry_switch_void(height=12, x_extra=0, y_extra=0, tolerance=0.1, plate_thickness=1.5, corner_radius=0.5) { // Cherry MX body is supposed to be 11.6mm
    switch_width = 15.6;
    switch_length = 14; // Slightly shorter because we're making an acurate profile (see below)
    center_space = 3.5; // Space between the cutouts on the sides of the switch
    sides_width = (5+center_space); // Taken from the Cherry MX developer PDF
    // Make the basic switch shape:
    cube(
        [switch_length+tolerance, switch_length+tolerance, height],
        center=true);
    // Profile for the sides:
    translate([0,sides_width/2,0])
        cube([switch_width-tolerance, center_space+tolerance, height], center=true);
    translate([0,-sides_width/2,0])
        cube([switch_width-tolerance, center_space+tolerance, height], center=true);
    // Fill out the rest with a solid cube so that there's a top plate + empty space beneath
    translate([0,0,plate_thickness])
        squarish_rpoly(
            xy=[switch_width+x_extra, switch_width+y_extra],
            h=height, r=corner_radius, center=true);
}

/*
CHANGELOG:
    1.2: Now using utils.scad with squarish_rpoly() instead of roundedCube since it's better (it's faster *and* I wrote it myself =).
    1.1: Now using roundedCube so the interior edges aren't so sharp.
    1.0: Initial release
*/