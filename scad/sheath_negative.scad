/* Provides two modules for generating a negative space/cutout suitable for making a keyboard case where the "body" of the Void Switch is unnecessary:

        * void_sheath_negative(): Generates a negative space version of the sheath for standard Void Switch placement in a top plate.
        * void_sheath_stab_negative(): Generates the negative space/cutouts for a stabilizer (used *in conjunction* with void_sheath_negative()).

*/

use <utils.scad>

$fn = 12;

// Example usage (uncomment below to see what these modules generate)

//magnet_diameter = 4;
//magnet_wall_thickness = 0.5;
//body_height = 10; // Will be output to the console when rendering/previewing void_switch.scad with something like: ECHO: "NOTE: BODY_HEIGHT: 10.4"
//stem_diameter = 5.35; // Copy from void_switch.scad (5.35 == Standard for 4x2mm magnets)
//sheath_length = 0.2; // Copy from void_switch.scad
//sheath_tolerance = 0.15; // Ditto
//stem_tolerance = 0.11; // Ditto
//sheath_clip_width = 1.5; // Ditto
//void_sheath_negative(magnet_diameter, magnet_wall_thickness, body_height, stem_diameter, sheath_length, sheath_tolerance, stem_tolerance, sheath_clip_width);
//void_sheath_stab_negative(height=body_height, x_extra=1, y_extra=2, corner_radius=1, stabilizer_positions=[12,-12]);

// Negative/cutout for the sheath to snap into (has something to do with stem diameter)
module void_sheath_negative(magnet_diameter, magnet_wall_thickness, body_height, stem_diameter, sheath_length, sheath_tolerance, stem_tolerance, sheath_clip_width) {
    sheath_wall_thickness = 1.2; // FYI: Needs to match your switch params (people are unlikely to change this though)
    top_thickness = 0.5; // Needs to match COVER_THICKNESS in void_switch.scad (NOTE: unlikely anyone will change this which is why this is hard-coded)
    clip_height = 0.5; // How much the clips stick out from the side of the sheath
    clip_tolerance = 0.25; // How much extra room each clip gets (between them and the wall)
    sheath_width = stem_diameter+sheath_wall_thickness*2;
    sheath_height = stem_diameter+sheath_wall_thickness*2;
    center_adjust = (sheath_height/2-sheath_wall_thickness*1.5)*1.45+stem_tolerance*1.5;
    // NOTE: center_adjust matches how high off the floor the Cherry cross (+) is in stem.scad.  This allows us to accurately position the sheath so that the stem sits dead center.
    droop_extra = 0.2;
    rotate([0,0,45])
        translate([-(sheath_height+sheath_tolerance*2)/2+center_adjust,0,0])
            difference() {
                cube([
                    sheath_height+sheath_tolerance*2,
                    sheath_width+sheath_tolerance*2,
                    body_height+0.1], center=true); // Goes all the way through hence +0.1
                translate([sheath_height/2,0,0])
                    cube([
                        top_thickness,
                        sheath_clip_width-sheath_tolerance*2,
                        body_height*2], center=true);
            }
    // Makes room for the sheath when it wraps around the outside of the magnet
    translate([
      -stem_diameter/2-(magnet_diameter-magnet_wall_thickness*3)/2.6+stem_tolerance,
      -stem_diameter/2-(magnet_diameter-magnet_wall_thickness*3)/2.6+stem_tolerance,
      0]) {
        difference() {
            rotate([0,0,22.5]) cylinder(
              d=magnet_diameter+magnet_wall_thickness*3+sheath_tolerance*2, // For magnet + sheath holding it
              h=body_height+0.1,
              center=true, $fn=16);
            translate([-magnet_diameter/1.3,-magnet_diameter/1.3,0]) rotate([0,0,45])
                cube([magnet_diameter,magnet_diameter,body_height*2], center=true);
        }
    }
}

// Negatives/cutouts (and space underneath) for stabilizers (holes that go on either side of the sheath in the correct positions)
// NOTE: If full_hollow=true will hollow out the area needed by the stabilizer wire/bar if the cutout in your case design doesn't already have this space cleared out
module void_sheath_stab_negative(height=12, x_extra=0, y_extra=0, x_shift=0, y_shift=0, tolerance=0.1, plate_thickness=1.5, corner_radius=0.5, stabilizer_positions=[], fn=16, full_hollow=false) {
    switch_width = 15.6;
    switch_length = 14; // Slightly shorter because we're making an acurate profile (see below)
    stab_width = 8;
    stab_length = 12.3;
    // Generate the stabs
    mirror([1,0,0]) for (stab_pos=stabilizer_positions) {
        translate([stab_pos,0,0]) union() {
            translate(v = [0, -0.62, 0]) {
                cube([6.65, 12.3, height+0.01], center=true);
                translate(v = [0, -6.35, 0]) {
                    cube([3, 2, height+0.01], center=true);
                }
            }
        }
    }
    // Generate the cutout that goes between stabs (only need one--doesn't need to loop)
    if (full_hollow) {
        // Clear out space for the wire/bar
        translate([x_shift,(-stab_width/2-y_extra)+y_shift,plate_thickness])
            squarish_rpoly(
                xy=[switch_width+x_extra+stab_width*2+corner_radius/2, stab_width/2+y_extra],
                h=height+0.01, r=corner_radius, center=true, $fn=fn);
        translate([stabilizer_positions[0]+x_shift,y_shift,plate_thickness])
            squarish_rpoly(
                xy=[x_extra+stab_width, switch_width+y_extra],
                h=height+0.01, r=corner_radius, center=true, $fn=fn);
        translate([-stabilizer_positions[0]+x_shift,y_shift,plate_thickness])
            squarish_rpoly(
                xy=[x_extra+stab_width, switch_width+y_extra],
                h=height+0.01, r=corner_radius, center=true, $fn=fn);
    }
}