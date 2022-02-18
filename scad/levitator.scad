// THE LEVITATOR - Goes under the keycap to provide a cusion of magnetic levitation

// AUTHOR: Riskable <riskable@youknowwhat.com>
// VERSION: 1.0 (Changelog is at the bottom)

/* NOTES:

    * The default configuration works with 4x1 through 4x2mm magnets (anything shorter than 2mm will end up stuck in there just fine--don't worry about it).
    * The default configuration will "eat" 0.4mm of your stem's cross height.  So keycaps won't be able to go all the way down (if you didn't print that part of the stem slightly longer to make up for it).  In testing, losing 0.4mm of height on the cross part of the stem makes absolutely no difference whatsoever.  The keycap still stays on just fine.  I wouldn't worry about it =)

*/

$fn = 64;

use <utils.scad>

// Configurables
LEVITATOR_THICKNESS = 0.4; // How thick the floor will be/how much of the cross part of the stem (+) gets eaten by THE LEVITATOR
WALL_THICKNESS = 0.8; // How thick around the edges you want it to be (0.8 is fine and fits under most keycaps)
STEM_TOLERANCE = 0.15; // How tight the cross-shaped cutout will be
MAGNET_TOLERANCE = 0.2; // Only used with MAGNET_HEIGHT (because we have some bridging)
MAGNET_DIAMETER = 4;
MAGNET_HEIGHT = 2;
MAGNET_DISTANCE = 3.75; // Distance from the center of the stem where the magnet goes

// Constants
CHERRY_CYLINDER_DIAMETER = 5.47; // Represents the keycap's stem (female side of the +)
CHERRY_CROSS_LENGTH = 4; // Length of the - and the | in the +
// We make the cross slightly thinner than normal to keep a tight fit:
CHERRY_CROSS_THICKNESS_X = 1.1; // Width of the - and in the + (Reality: 1.31)
CHERRY_CROSS_THICKNESS_Y = 1.1; // Width of the | in the + (Reality: 1.09)

levitator(MAGNET_DIAMETER, MAGNET_HEIGHT, magnet_distance=MAGNET_DISTANCE, magnet_tolerance=MAGNET_TOLERANCE, wall_thickness=WALL_THICKNESS, thickness=LEVITATOR_THICKNESS, stem_tolerance=STEM_TOLERANCE);
//levitator_double_sided(MAGNET_DIAMETER, MAGNET_HEIGHT, magnet_distance=MAGNET_DISTANCE, magnet_tolerance=MAGNET_TOLERANCE, wall_thickness=WALL_THICKNESS, thickness=LEVITATOR_THICKNESS, stem_tolerance=STEM_TOLERANCE);

// TODO: Finish making this as well as making a matching void space version for top plates:
// This is for the special situations with long ass/heavy spacebars: 
BACKFORCE_LENGTH = 30; // 15mm from the center of the switch on either side
BACKFORCE_WIDTH = 11; // Needs to fit inside/under the keycap but not terribly tight--just enough to prevent it from rotating
//uplifting_jigaroo(BACKFORCE_LENGTH, BACKFORCE_WIDTH, stem_diameter=CHERRY_CYLINDER_DIAMETER, magnet_diameter=4, magnet_height=2, magnet_tolerance=0, wall_thickness=1.2);

module levitator(magnet_diameter, magnet_height, magnet_distance=3.75, magnet_tolerance=MAGNET_TOLERANCE, wall_thickness=0.9, thickness=1, stem_tolerance=0.15) {
    // NOTE: stem_tolerance is the keycap stem; not the switch stem
    height = 2 + wall_thickness; // Just enough to grab the stem
    difference() {
        translate([0,0,height/2]) union() {
            // Main body of the thing
            hull() {
                // NOTE: The square-ish walls around the stem area are just to provide rigidity
                cube([
                    CHERRY_CYLINDER_DIAMETER+wall_thickness*2+stem_tolerance*2,
                    CHERRY_CYLINDER_DIAMETER+wall_thickness*2+stem_tolerance*2,
                    height], center=true);
                translate([magnet_distance,magnet_distance,0])
                    cylinder(d=magnet_diameter+wall_thickness*2, h=height, center=true);
            }
            // Body of the part that holds the magnet (hollowed out below)
            translate([magnet_distance,magnet_distance,0])
                cylinder(d=magnet_diameter+wall_thickness*2, h=height, center=true);
        }
        translate([0,0,-5]) cherry_cross(length=10); // Just don't die on it
        translate([0,0,height/2+thickness+wall_thickness/2]) // Stem cutout
            cube([
                CHERRY_CYLINDER_DIAMETER+stem_tolerance*2,
                CHERRY_CYLINDER_DIAMETER+stem_tolerance*2,
                height+wall_thickness], center=true);
        translate([magnet_distance,magnet_distance,(magnet_height+magnet_tolerance)/2-0.01]) {
            cylinder(d=magnet_diameter, h=magnet_height+magnet_tolerance, center=true);
            // So we can pop the magnet out if we screw up which pole is facing down:
//            rotate([0,0,45])
//                cube([magnet_diameter/3,magnet_diameter/3,100], center=true);
        }
        // Make an angled hole in the top that stops the magnet from coming out while also letting you push it out if needed to flip it around
        translate([magnet_distance,magnet_distance,wall_thickness/2+(magnet_height+magnet_tolerance)-0.01])
            cylinder(d1=magnet_diameter, d2=magnet_diameter/1.5, h=wall_thickness, center=true);
        // Cut off a few bits here and there so it can fit under more keycaps
//        translate([magnet_distance*2+wall_thickness/1.25,magnet_distance*1.25,magnet_diameter/2])
//            cube([magnet_diameter, magnet_diameter*2, magnet_diameter*2], center=true);
//        translate([magnet_distance*1.25,magnet_distance*2+wall_thickness/1.25,magnet_diameter/2])
//            cube([magnet_diameter*2, magnet_diameter, magnet_diameter*2], center=true);
        translate([magnet_distance*1.5,magnet_distance*1.5,magnet_diameter/1.35])
            rotate([0,-50,45])
                cube([magnet_diameter, magnet_diameter*2, magnet_diameter*2], center=true);
    }
}

module levitator_double_sided(magnet_diameter, magnet_height, magnet_distance=3.75, magnet_tolerance=MAGNET_TOLERANCE, wall_thickness=0.9, thickness=1, stem_tolerance=0.15) {
    // NOTE: stem_tolerance is the keycap stem; not the switch stem
    height = 2 + wall_thickness; // Just enough to grab the stem
    difference() {
        translate([0,0,height/2]) union() {
            // Main body of the thing
            hull() {
                // NOTE: The square-ish walls around the stem area are just to provide rigidity
                cube([
                    CHERRY_CYLINDER_DIAMETER+wall_thickness*2+stem_tolerance*2,
                    CHERRY_CYLINDER_DIAMETER+wall_thickness*2+stem_tolerance*2,
                    height], center=true);
                translate([magnet_distance,magnet_distance,0])
                    cylinder(d=magnet_diameter+wall_thickness*2, h=height, center=true);
                translate([-magnet_distance,-magnet_distance,0])
                    cylinder(d=magnet_diameter+wall_thickness*2, h=height, center=true);
            }
            // Body of the part that holds the magnet (hollowed out below)
            translate([magnet_distance,magnet_distance,0])
                cylinder(d=magnet_diameter+wall_thickness*2, h=height, center=true);
        }
        translate([0,0,-5]) cherry_cross(length=10); // Just don't die on it
        translate([0,0,height/2+thickness+wall_thickness/2]) // Stem cutout
            cube([
                CHERRY_CYLINDER_DIAMETER+stem_tolerance*2,
                CHERRY_CYLINDER_DIAMETER+stem_tolerance*2,
                height+wall_thickness], center=true);
        translate([magnet_distance,magnet_distance,(magnet_height+magnet_tolerance)/2-0.01])
            cylinder(d=magnet_diameter, h=magnet_height+magnet_tolerance, center=true);
        translate([-magnet_distance,-magnet_distance,(magnet_height+magnet_tolerance)/2-0.01])
            cylinder(d=magnet_diameter, h=magnet_height+magnet_tolerance, center=true);
        // Make an angled hole in the top that stops the magnet from coming out while also letting you push it out if needed to flip it around
        translate([magnet_distance,magnet_distance,wall_thickness/2+(magnet_height+magnet_tolerance)-0.01])
            cylinder(d1=magnet_diameter, d2=magnet_diameter/1.5, h=wall_thickness, center=true);
        translate([-magnet_distance,-magnet_distance,wall_thickness/2+(magnet_height+magnet_tolerance)-0.01])
            cylinder(d1=magnet_diameter, d2=magnet_diameter/1.5, h=wall_thickness, center=true);
        // Cut off a few bits here and there so it can fit under more keycaps
        translate([magnet_distance*1.5,magnet_distance*1.5,magnet_diameter/1.35])
            rotate([0,-50,45])
                cube([magnet_diameter, magnet_diameter*2, magnet_diameter*2], center=true);
        translate([-magnet_distance*1.5,-magnet_distance*1.5,magnet_diameter/1.35])
            rotate([0,50,45])
                cube([magnet_diameter, magnet_diameter*2, magnet_diameter*2], center=true);
    }
}

// This is a magnetic levitation backward-force generator that can be placed under any given (long) keycap to cusion the bottom and provide a backwards (upwards) force to ease the burden of bringing a heavy keycap back up.  In other words, it's for (heavy) spacebars.  NOTE: The *length* is really just the distance between the center of the magnets--not the actual length of the thing.
// NOTE: Requires matching magnets (same locations underneath) in the keyboard plate!
module uplifting_jigaroo(length, width, stem_diameter=CHERRY_CYLINDER_DIAMETER, magnet_diameter=4, magnet_height=2, magnet_tolerance=0, wall_thickness=1.2) {
    // NOTE: We make this pretty thick so it's stable--even though that adds extra weight
    difference() {
        cube([
            length+magnet_diameter+magnet_tolerance*2+wall_thickness*2,
            width,
            magnet_height+wall_thickness], center=true);
        cube([stem_diameter,stem_diameter,wall_thickness*8], center=true);
        translate([length/2,0,magnet_height/2-wall_thickness/4])
            cylinder(d=magnet_diameter+magnet_tolerance*2, h=magnet_height+0.01, center=true);
        translate([-length/2,0,magnet_height/2-wall_thickness/4])
            cylinder(d=magnet_diameter+magnet_tolerance*2, h=magnet_height+0.01, center=true);
    }
}

// This makes the + bit that slides *in* to a Cherry MX style keycap:
module cherry_cross(length=CHERRY_CROSS_LENGTH, y_adjust=0, x_adjust=0) {
    linear_extrude(height=length) {
        square([CHERRY_CROSS_THICKNESS_X+x_adjust, CHERRY_CROSS_LENGTH], center=true);
        square([CHERRY_CROSS_LENGTH, CHERRY_CROSS_THICKNESS_Y+y_adjust], center=true);
    }
}
