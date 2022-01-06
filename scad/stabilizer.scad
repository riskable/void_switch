// Void switch stabilizers: Meant to fit inside Cherry MX style stabilizer holes but only for use with Void Switches.
// NOTE: Requires 18 gauge wire bent into the correct length/u-shape.  The wire diameter is parametric though so you *can* use a different-sized wire if you want!

// AUTHOR: Riskable <riskable@youknowwhat.com>
// VERSION: 1.0 (Changelog is at the bottom)
// LICENSE: TBD. Do not sell Void Switch stabilizers (yet!) but feel free to make your own for personal use.
// LICENSING NOTE: If you want to sell keyboards/switches using this design just let me know and we'll work something out! I'll help you make awesome stuff!

/* NOTES:
    * Print all layers at 0.16mm layer height (including first layer) in order to get that perfect thickness on the +.
    * FYI: Bending the wire just right is a huge pain in the ass!  Good luck!
    * Someone PLEASE make a decent wire-bending jig we can all print out that makes good, *tight* bends at the correct distances (e.g. 24mm apart for 2-2.5U keys).
*/

// TODO: Make this take the stem magnet height into account and not just re-use the body magnet height.
// TODO: Make this take the switch's MAGNET_VOID into account instead of relying on the stab wire's wiggle room (at an angle) to make up for it.  Note that this works fine as long as the switch's MAGNET_VOID is less than 0.8mm or so but for larger voids the stabilizer should take that into account.
// TODO: Make this work better with shorter travel distances (e.g. <3mm).

/* [Switch Parameters] */

use <utils.scad>
use <stem.scad>

// These need to match what's in Void Switch.scad
// Total travel of your switches (NOTE: All "Switch" parameters MUST match whatever values you used to generate your switches).
TRAVEL = 4; // [1:0.1:20]
// Copy setting from void_switch.scad
BODY_MAGNET_DIAMETER = 4; // [3:1:5]
// Copy setting from void_switch.scad
BODY_MAGNET_HEIGHT = 1.7; // [1:0.1:3]
// Copy setting from void_switch.scad
MAGNET_WALL_THICKNESS = 0.5;
// Copy setting from void_switch.scad
COVER_THICKNESS = 0.8; // [0:0.1:1.5]
// Copy setting from void_switch.scad
PLATE_THICKNESS = 1.5; // [0:0.1:1.5]
// Copy setting from void_switch.scad
SHEATH_LIP_HEIGHT = 1; // [0.5:0.1:1.5]
// Copy setting from void_switch.scad
SHEATH_LENGTH = 0.3; // [0:0.1:2]
// Copy setting from void_switch.scad
WALL_THICKNESS = 1.35;

/* [Stabilizer Parameters] */
// Wiggle room inside the stabilizer body for its stem (stabs should use a larger value than the switches so you don't have to be so precise with your wire bending).
STEM_TOLERANCE = 0.25; // [0.1:0.1:0.5]
// Controls how much extra room the wire gets in that little hole at the end of the stabilizer stem.
STABILIZER_WIRE_TOLERANCE = 0.2; // [0.1:0.1:0.5]
// The diameter of your steel wire.  NOTE: 18 gauge steel wire came in at 1.12mm when I measured it and 16 gauge came in at 1.6mm.
STABILIZER_WIRE_DIAMETER = 1.12;
// Up/down wiggle room inside the stab body for the magnet
MAGNET_TOLERANCE = 0.2; // [0.05:0.05:0.3]
// Diameter of the stabilizer magnets (NOTE: Doesn't have to be the same as the switch!)
STAB_MAGNET_DIAMETER = 4; // [3:1:5]
// Thickness/height of the stabilizer magnets
STAB_MAGNET_HEIGHT = 1.7; // [1:0.1:3]
// Does the same thing as SHEATH_LIP_OVERHANG in void_switch.scad (how much the lip sticks out on the sides of the stab).
LIP_OVERHANG = 0.65;

// Distance between the magnet and the stabilizer bar/wire (lower value == less pull on the wire). Similar to the MAGNET_VOID in void_switch.scad but not as strong of an impact.  Uses negative values.
STAB_MAGNET_VOID = -0.0; // [-0.3:0.1:0]

/* [Hidden] */
$fn = 64;

SHEATH_OVERALL_LENGTH = TRAVEL+BODY_MAGNET_HEIGHT+MAGNET_WALL_THICKNESS*2+MAGNET_TOLERANCE+PLATE_THICKNESS;

// Constants
STABILIZER_LENGTH = 12.29-0.45; // As per the spec (-0.45 tolerance)
STABILIZER_WIDTH = 6.65-0.3; // Also per the spec
STABILIZER_STEM_DIAMETER = 4.10; // Maybe this could be different some day?
CHERRY_CYLINDER_DIAMETER = 5.47; // Represents the keycap's stem (female side of the +)
CHERRY_STEM_HEIGHT = 4.5; // How far the underside of the keycap extends into the stem()
CHERRY_CROSS_LENGTH = 4; // Length of the - and the | in the +

// The under-the-plate stab:
stabilizer_riskey_cross(SHEATH_LENGTH, STABILIZER_STEM_DIAMETER, TRAVEL, PLATE_THICKNESS,
    stem_tolerance=STEM_TOLERANCE, sheath_tolerance=0.2, wall_thickness=WALL_THICKNESS, lip_height=SHEATH_LIP_HEIGHT, lip_overhang=LIP_OVERHANG, magnet_void=STAB_MAGNET_VOID, body_magnet_height=BODY_MAGNET_HEIGHT, body_magnet_diameter=BODY_MAGNET_DIAMETER, magnet_height=STAB_MAGNET_HEIGHT, magnet_diameter=STAB_MAGNET_DIAMETER, magnet_wall_thickness=MAGNET_WALL_THICKNESS, magnet_tolerance=MAGNET_TOLERANCE, end_stop_thickness=0, wire_diameter=STABILIZER_WIRE_DIAMETER, wire_tolerance=STABILIZER_WIRE_TOLERANCE);
translate([-9,0,0])
mirror([1,0,0]) stabilizer_riskey_cross(SHEATH_LENGTH, STABILIZER_STEM_DIAMETER, TRAVEL, PLATE_THICKNESS,
    stem_tolerance=STEM_TOLERANCE, sheath_tolerance=0.2, wall_thickness=WALL_THICKNESS, lip_height=SHEATH_LIP_HEIGHT, lip_overhang=LIP_OVERHANG, magnet_void=STAB_MAGNET_VOID, body_magnet_height=BODY_MAGNET_HEIGHT, body_magnet_diameter=BODY_MAGNET_DIAMETER, magnet_height=STAB_MAGNET_HEIGHT, magnet_diameter=STAB_MAGNET_DIAMETER, magnet_wall_thickness=MAGNET_WALL_THICKNESS, magnet_tolerance=MAGNET_TOLERANCE, end_stop_thickness=0, wire_diameter=STABILIZER_WIRE_DIAMETER, wire_tolerance=STABILIZER_WIRE_TOLERANCE);
// Stems for the under-the-plate stab:
translate([8,0,0])
    riskey_stabilizer_stem_cherry_cross(TRAVEL, STABILIZER_STEM_DIAMETER, SHEATH_LENGTH, WALL_THICKNESS, PLATE_THICKNESS, cover_thickness=COVER_THICKNESS, wire_diameter=STABILIZER_WIRE_DIAMETER, wire_tolerance=STABILIZER_WIRE_TOLERANCE, magnet_height=STAB_MAGNET_HEIGHT, magnet_diameter=STAB_MAGNET_DIAMETER, magnet_tolerance=MAGNET_TOLERANCE, magnet_wall_thickness=MAGNET_WALL_THICKNESS, lip_height=SHEATH_LIP_HEIGHT, magnet_void=STAB_MAGNET_VOID, extra_tolerance=0);
translate([13,0,0])
    riskey_stabilizer_stem_cherry_cross(TRAVEL, STABILIZER_STEM_DIAMETER, SHEATH_LENGTH, WALL_THICKNESS, PLATE_THICKNESS, cover_thickness=COVER_THICKNESS, wire_diameter=STABILIZER_WIRE_DIAMETER, wire_tolerance=STABILIZER_WIRE_TOLERANCE, magnet_height=STAB_MAGNET_HEIGHT, magnet_diameter=STAB_MAGNET_DIAMETER, magnet_tolerance=MAGNET_TOLERANCE, magnet_wall_thickness=MAGNET_WALL_THICKNESS, lip_height=SHEATH_LIP_HEIGHT, magnet_void=STAB_MAGNET_VOID, extra_tolerance=0);

// NOTE: We use half the stabilizer wire tolerance for the clips because they need to be tighter than everything else
translate([-2,TRAVEL+5,0]) rotate([0,0,0])
    wire_retention_arm(TRAVEL, SHEATH_OVERALL_LENGTH, STABILIZER_WIRE_DIAMETER, STABILIZER_WIRE_TOLERANCE/2);
translate([-11,TRAVEL+5,0]) rotate([0,0,0])
    wire_retention_arm(TRAVEL, SHEATH_OVERALL_LENGTH, STABILIZER_WIRE_DIAMETER, STABILIZER_WIRE_TOLERANCE/2);

backforce_length = 30; // 15mm from the center of the switch on either side
backforce_width = 11; // Needs to fit inside the keycap but not terribly tight--just enough to prevent it from rotating

//backforce_levitation_jig(backforce_length, backforce_width, stem_diameter=CHERRY_CYLINDER_DIAMETER, magnet_diameter=4, magnet_height=2, magnet_tolerance=0, wall_thickness=WALL_THICKNESS);

//levitator(magnet_diameter, magnet_height, magnet_tolerance=0.2, wall_thickness=WALL_THICKNESS, thickness=0.4);

module levitator(magnet_diameter, magnet_height, magnet_tolerance=0.2, wall_thickness=0.9, thickness=1, stem_tolerance=0.15) {
    // NOTE: stem_tolerance is the keycap stem; not the switch stem
    distance = magnet_diameter * 1; // From the center/stem
    height = 2 + wall_thickness; // Just enough to grab the stem
    difference() {
        translate([0,0,height/2]) union() {
            // Main body of the thing
            hull() {
                // NOTE: The square-ish walls around the stem area are just to provide rigidity
                cube([CHERRY_CYLINDER_DIAMETER+wall_thickness*2+stem_tolerance*2,CHERRY_CYLINDER_DIAMETER+wall_thickness*2+stem_tolerance*2,height], center=true);
                translate([distance,distance,0])
                    cylinder(d=magnet_diameter+wall_thickness*2, h=height, center=true);
            }
            // Body of the part that holds the magnet (hollowed out below)
            translate([distance,distance,0])
                cylinder(d=magnet_diameter+wall_thickness*2, h=height, center=true);
        }
        translate([0,0,-5]) cherry_cross(length=10); // Just don't die on it
        translate([0,0,height/2+thickness+wall_thickness/2]) // Stem cutout
            cube([CHERRY_CYLINDER_DIAMETER+stem_tolerance*2,CHERRY_CYLINDER_DIAMETER+stem_tolerance*2,height+wall_thickness], center=true);
        translate([distance,distance,(magnet_height+magnet_tolerance)/2-0.01]) {
            cylinder(d=magnet_diameter, h=magnet_height+magnet_tolerance, center=true);
            // So we can pop the magnet out if necessary:
            cylinder(d=magnet_diameter/1.5, h=100, center=true);
        }
        // Cut off a few bits here and there so it can fit under more keycaps
        translate([distance*2.15,distance*1.25,magnet_diameter/2])
            cube([magnet_diameter, magnet_diameter*2, magnet_diameter*2], center=true);
        translate([distance*1.25,distance*2.15,magnet_diameter/2])
            cube([magnet_diameter*2, magnet_diameter, magnet_diameter*2], center=true);
    }
}

// This is a magnetic levitation backward-force generator that can be placed under any given (long) keycap to cusion the bottom and provide a backwards (upwards) force to ease the burden of bringing a heavy keycap back up.  i.e. it's for spacebars.  NOTE: The *length* is really just the distance between the center of the magnets--not the actual length of the thing.
module backforce_levitation_jig(length, width, stem_diameter=CHERRY_CYLINDER_DIAMETER, magnet_diameter=4, magnet_height=2, magnet_tolerance=0, wall_thickness=1.2) {
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

// Make the thing that holds the wire in place
module wire_retention_arm(travel, length, wire_diameter, wire_tolerance) {
    pin_diameter = 1.875;
    pin_height = 2;
    thickness = 1;
    wire_diameter = wire_diameter + wire_tolerance;
    difference() {
        translate([length/4,0,thickness/2])
            cube([length/1.375, travel*1.5, thickness], center=true);
        // Cut off a bit of the sides so they don't overlap with the top plate
        translate([0,travel*1.1,thickness/2])
            cube([length, travel, thickness*2], center=true);
        translate([0,-travel*1.1,thickness/2])
            cube([length, travel, thickness*2], center=true);
        // Cut out the corners so the wire can get under it
        translate([
          length/4+wire_diameter*1.35,
          travel*1.5-wire_diameter-wire_tolerance,
          0])
            cube([wire_diameter+wire_tolerance, travel*1.5, thickness*4], center=true);
        translate([
          length/4+wire_diameter*1.35,
          -travel*1.5+wire_diameter+wire_tolerance,
          0])
            cube([wire_diameter+wire_tolerance, travel*1.5, thickness*4], center=true);
    }
    // Add the little pegs that stick out
    translate([0,-(pin_diameter/2+pin_diameter)/2,0]) {
        translate([0,0,pin_height/2+thickness])
            cylinder(d=pin_diameter, h=pin_height, center=true, $fn=8);
        translate([0,pin_diameter+pin_diameter/2,pin_height/2+thickness])
            cylinder(d=pin_diameter, h=pin_height, center=true, $fn=8);
    }
}

module back_stabilizer_clips(length, stabilizer_wire_diameter, travel, stem_diameter=4.1, wall_thickness=1.35, magnet_height=1.5, magnet_diameter=3, magnet_wall_thickness=0.5, magnet_tolerance=0, end_stop_thickness=0.8) {
    sheath_width = STABILIZER_WIDTH; // Side-to-side wall_thickness doesn't need to be as strong
    sheath_height = STABILIZER_LENGTH; // Need wall_thickness to be full height above/below
    pin_diameter = 1.875;
    sheath_overall_length = length+travel+magnet_height+magnet_wall_thickness*2+magnet_tolerance+plate_thickness;
    stopper_height = wall_thickness+stem_diameter;
    // The pin
    translate([
      sheath_width/2-pin_diameter/2-wall_thickness/2,
      sheath_height/2-pin_diameter,
      (wall_thickness*1.5)/2+lip_height])
        cylinder(d=pin_diameter, h=wall_thickness*1.5, center=true, $fn=8);
    translate([
      -sheath_width/2+pin_diameter/2+wall_thickness/2,
      sheath_height/2-pin_diameter,
      (wall_thickness*1.5)/2+lip_height])
        cylinder(d=pin_diameter, h=wall_thickness*1.5, center=true, $fn=8);
    // Connecting wall
    translate([0,pin_diameter,0.5])
        cube([sheath_width,pin_diameter*4,lip_height], center=true);
    // Wall that will contain the wire
    translate([0,-pin_diameter+stabilizer_wire_diameter/2,(sheath_overall_length-0.5)/2+lip_height])
        cube([sheath_width,stabilizer_wire_diameter,sheath_overall_length-0.5], center=true);
    // Walls that keeps everything straight and lined up
    translate([
      0,
      pin_diameter/1.5-lip_height,
      (sheath_overall_length-stabilizer_wire_diameter*2)/2+lip_height])
        cube([
            sheath_width,
            lip_height*3,
            sheath_overall_length-stabilizer_wire_diameter*2], center=true);
        // Two sides
    translate([
      sheath_width/2-stabilizer_wire_diameter/2,
      pin_diameter/1.5-lip_height,
      (sheath_overall_length-stabilizer_wire_diameter)/2+lip_height])
        cube([
            stabilizer_wire_diameter,
            lip_height*3,
            sheath_overall_length-stabilizer_wire_diameter], center=true);
    translate([
      -sheath_width/2+stabilizer_wire_diameter/2,
      pin_diameter/1.5-lip_height,
      (sheath_overall_length-stabilizer_wire_diameter)/2+lip_height])
        cube([
            stabilizer_wire_diameter,
            lip_height*3,
            sheath_overall_length-stabilizer_wire_diameter], center=true);
}

// Old unused clip (may come revisit later)
//module stabilizer_clip(stabilizer_wire_diameter, body_length=14, taper=1.1, wall_thickness=1.35) {
//    pin_diameter = 1.875; // Need to match the hole in the switch body
//    translate([0,-(stabilizer_wire_diameter+wall_thickness*1.5)/2+pin_diameter,0]) {
//        difference() {
//            // Make the hollow cylinder that will hold the wire
//            cylinder(d=stabilizer_wire_diameter+wall_thickness*1.5, h=body_length/4);
//            cylinder(d=stabilizer_wire_diameter, h=body_length*4, center=true);
//            // Flatten the bottom
//            translate([0,stabilizer_wire_diameter*1.575,0])
//                cube([
//                    stabilizer_wire_diameter*3,
//                    stabilizer_wire_diameter*2,
//                    body_length*4.5], center=true);
//            // Cut a hole so we can clip in the wire
//            translate([0,stabilizer_wire_diameter,0])
//                cube([
//                    stabilizer_wire_diameter/2.5,
//                    stabilizer_wire_diameter*2,
//                    body_length*4.5], center=true);
//        }
//    }
//    // Generate the octagonal pin that slides into the switch body:
//    translate([
//      -stabilizer_wire_diameter-wall_thickness/2,
//      0,
//      (stabilizer_wire_diameter*1.25)/2.165])
//        rotate([90,0,90])
//            rotate([0,0,22.5])
//                cylinder(
//                    d=pin_diameter,
//                    h=wall_thickness*2, center=true, $fn=8);
//}

// This fits into the switch body--what the stem slides in and out of
module stabilizer_riskey_cross(length, stem_diameter, travel, plate_thickness,
    stem_tolerance=0.2, sheath_tolerance=0.2, wall_thickness=1.35, spring_wall_thickness=0.8, lip_height=1, lip_overhang=1, magnet_void=0.2, body_magnet_height=2, body_magnet_diameter=6, magnet_height=1.5, magnet_diameter=3, magnet_wall_thickness=0.5, magnet_tolerance=0, end_stop_thickness=0.8, wire_diameter=1.12, wire_tolerance=0.4) {
    sheath_width = STABILIZER_WIDTH; // Side-to-side wall_thickness doesn't need to be as strong
    sheath_height = STABILIZER_LENGTH; // Need wall_thickness to be full height above/below
    total_travel = travel;
//    stopper_height = wall_thickness+stem_diameter; // Height of the wall at the end (should be high enough to stop the stem when inserting a keycap but short enough that you can still slide it in (to the point where it clicks/snaps into place)
    stopper_height = 0;
    wire_diameter = wire_diameter + wire_tolerance;
    sheath_overall_length = length+total_travel+magnet_height+magnet_wall_thickness+magnet_tolerance+plate_thickness; // NOTE: Doesn't include the lip_height on purpose
    // These are currently unused (FUTURE):
    tactile_arm_thickness = 0.8;
    tactile_bump_width = 1.35; // Three standard .4mm nozzle extrusion widths
    tactile_bump_height = 0.4;
    center_correction = 0.25; // Cherry stem plate holes are actually not centered under the stabilizer stem holes!  They're slightly to the left and right on each side.  This value corrects for that off-centered-ness.
    pin_diameter = 1.875; // Need to match everything else
    negative_magnet_tolerance = 0.1;
    difference() {
        translate([0,0,sheath_height/2]) {
            union() {
                translate([0,lip_height,0])
                    cube([ // Main body of the sheath
                        sheath_width,
                        sheath_overall_length,
                        sheath_height], center=true);
                translate([0,-sheath_overall_length/2+lip_height/2,0])
                    // The lip (that sticks out the top)
                    squarish_rpoly( // The +0.01 below just makes sure the slicer sees this as one object
                        xy=[sheath_width+lip_overhang*2, lip_height+0.01],
                        h=sheath_height+lip_height*2, r=lip_height/3, center=true);
            }
        }
        // Add a mark indicating which side this is (because it's hard to tell 0.25mm difference with the naked eye)
        translate([-1.5,-sheath_overall_length/2+lip_height/2-0.3,0.75])
            rotate([90,0,0]) linear_extrude(1)
                text("▶", size=3.5, font="Code2000");
        // Ensure the bottom is flat:
        translate([0,0,-250])
            cube([500, 500, 500], center=true);
        // Use the stem's void space/negative cutout feature (extra_tolerance) to carve out a space for itself:
        translate([
            center_correction,
            -(sheath_overall_length)/2+length+lip_height+plate_thickness,
            sheath_height/2
        ])
        // We scale it on the Z a smidge because the angle of the bar makes the stem want to tilt.  A bit of extra Z wiggle room doesn't really hurt anything (unlike X wiggle room which makes the stem too hard to put on without a lot of fiddling).
                scale([1,1,1.1])
                    riskey_stabilizer_stem_cherry_cross(total_travel*3, stem_diameter, length, wall_thickness,
                        plate_thickness, magnet_height=magnet_height, magnet_diameter=magnet_diameter,
                        magnet_tolerance=magnet_tolerance,
                        magnet_wall_thickness=magnet_wall_thickness,
                        lip_height=lip_height, extra_tolerance=stem_tolerance);
        // Add holes through the bottom sides near the magnet so we can attach a wire clip there
        translate([-sheath_height/2,magnet_void,pin_diameter/2+wire_diameter*1.25])
            rotate([90,0,90])
                cylinder(d=pin_diameter, h=sheath_height, center=true);
        translate([
          -sheath_height/2,
          magnet_void+pin_diameter+pin_diameter/2,
          pin_diameter/2+wire_diameter*1.25])
            rotate([90,0,90])
                cylinder(d=pin_diameter, h=sheath_height, center=true);
//        // Add a cutout along the center to ensure the layer gets extruded paralell to the motion of the stem
//        translate([center_correction,0,sheath_height/2+stem_diameter/3])
//            rotate([0,90,90])
//                cylinder(d=stem_diameter, h=sheath_overall_length*2, center=true);
        // Cut out room in the back for the wire to be able to fit
        translate([
            center_correction,
            -wire_diameter,
            sheath_overall_length/1.5]) {
                translate([0,0,0]) hull() {
                    cube([wire_diameter,wire_diameter,sheath_overall_length*2], center=true);
                    translate([0,sheath_overall_length,0])
                        cylinder(d=wire_diameter*2.5, h=sheath_overall_length*2, center=true);
                        
                }
            }
        // Cutout for the magnet that pulls on the stabilizer wire
        translate([
          center_correction,
            magnet_height/2-sheath_overall_length/2+lip_height+magnet_void,
//          -magnet_height/2-sheath_overall_length/2+lip_height+plate_thickness+magnet_void,
          magnet_diameter/2-0.01]) {
            %rotate([90,0,0]) // Visualize the magnet
                cylinder(d=magnet_diameter, h=magnet_height, center=true);
            cube([
                magnet_diameter-negative_magnet_tolerance, // Needs to sit tight
                magnet_height+magnet_tolerance,
                magnet_diameter+magnet_tolerance], center=true);
        }
        if (stopper_height) {
            // Add holes for the pins of the back stabilizer clip (mostly copied from the very end of this module)
            translate([
              -sheath_width/2+pin_diameter/2+wall_thickness/2,
              pin_diameter*2.2,
              pin_diameter/2+wall_thickness])
                rotate([90,0,0])
                    cylinder(d=pin_diameter, h=pin_diameter*1.5, center=true);
            translate([
              sheath_width/2-pin_diameter/2-wall_thickness/2,
              pin_diameter*2.2,
              pin_diameter/2+wall_thickness])
                rotate([90,0,0])
                    cylinder(d=pin_diameter, h=pin_diameter*1.5, center=true);
        }
        // Mark the total travel on the side
        travel_text = len(str(travel)) > 1 ? str(travel) : str(travel, ".0"); // So it looks right
        translate([sheath_width/2-0.2,-2,sheath_height/2-4]) rotate([90,0,90]) linear_extrude(1)
            text(travel_text, size=3, font="Ubuntu:style=Bold");
    }
    // Snap clips
    translate([ // Top left
        -sheath_width/2+(wall_thickness-stem_tolerance)/2,
        0.75-sheath_overall_length/2+lip_height+plate_thickness,
        sheath_height])
            difference() { // Cut off the bottom to make it flat so we can have a thin wall on top
                rotate([-10,0,0]) cube([wall_thickness-stem_tolerance, 1.5, .5], center=true);
                translate([0,0,-0.51]) cube([5, 5, 1], center=true); // Extra 0.01 is just for rendering
            }
    translate([ // Top right
        sheath_width/2-(wall_thickness-stem_tolerance)/2,
        0.75-sheath_overall_length/2+lip_height+plate_thickness,
        sheath_height])
            difference() { // Cut off the bottom to make it flat so we can have a thin wall on top
                rotate([-10,0,0]) cube([wall_thickness-stem_tolerance, 1.5, .5], center=true);
                translate([0,0,-0.51]) cube([5, 5, 1], center=true); // Extra 0.01 is just for rendering
            }
    translate([ // Right side pip (top)
        sheath_width/2-0.05,
        0.75-sheath_overall_length/2+lip_height+plate_thickness,
        sheath_height-1])
            rotate([0,0,10]) cube([.5, 1.5, 1], center=true);
    translate([ // Left side pip (top)
        -sheath_width/2+0.05,
        0.75-sheath_overall_length/2+lip_height+plate_thickness,
        sheath_height-1])
            rotate([0,0,-10]) cube([.5, 1.5, 1], center=true);
    translate([ // Right side pip (bottom)
        sheath_width/2-0.05,
        0.75-sheath_overall_length/2+lip_height+plate_thickness,
        0.5])
            rotate([0,0,10]) cube([.5, 1.5, 1], center=true);
    translate([ // Left side pip (bottom)
        -sheath_width/2+0.05,
        0.75-sheath_overall_length/2+lip_height+plate_thickness,
        0.5])
            rotate([0,0,-10]) cube([.5, 1.5, 1], center=true);
    // This little side edge thing ensures that the side of the stabilizer prints properly with a 0.4mm nozzle
    // (the edge can get a bit thin at the widest point of the stem circular cutout which results in there being an empty space--this little cube ensures it has something to bridge across to)
    translate([
      center_correction+3,
      0.3+sheath_overall_length/2,
      sheath_height/2])
        cube([0.5,1,sheath_height], center=true);
    // Add a little stopper at the end that's low enough to get the stem through but also high enough to prevent it from falling out the bottom when the switch is upright (with no PCB underneath)
    if (stopper_height) {
        difference() {
            translate([0,end_stop_thickness/2+sheath_overall_length/2+lip_height,(sheath_height/2.6+stopper_height)/2]) // -.85 because of the lowered cross on the stem
                cube([
                    sheath_width,
                    end_stop_thickness,
                    sheath_height/2.6+stopper_height], center=true);
//            // Add holes for the pins of the back stabilizer clip
//            translate([
//              -sheath_width/2+pin_diameter/2+wall_thickness/2,
//              -pin_diameter/2,
//              pin_diameter/2+wall_thickness])
//                rotate([90,0,0])
//                    cylinder(d=pin_diameter, h=sheath_height*2, center=true);
//            translate([
//              sheath_width/2-pin_diameter/2-wall_thickness/2,
//              -pin_diameter/2,
//              pin_diameter/2+wall_thickness])
//                rotate([90,0,0])
//                    cylinder(d=pin_diameter, h=sheath_height*2, center=true);
        }
    }
}

// Generates a cross (+) style Cherry MX stem/slider (lowered by 0.85mm to print flat):
module riskey_stabilizer_stem_cherry_cross(travel, diameter, sheath_length, wall_thickness, plate_thickness, cover_thickness=0.8, wire_diameter=1.12, wire_tolerance=0.4, magnet_height=1.5, magnet_diameter=3, magnet_tolerance=0, magnet_wall_thickness=0.5, lip_height=1, magnet_void=0.2, extra_tolerance=0) {
    total_travel = travel+sheath_length+plate_thickness+cover_thickness+lip_height+magnet_void+magnet_height;
    echo(total_travel=total_travel);
    // NOTE: Assuming you have something like an sk6812mini (3.7mm wide) in the center, a 3mm (diameter) magnet will need to be at least 1.85mm (3.7/2) away from the center for there to be room for a hall effect sensor (though you probably want at least a mm or two more than that).
    stem_length = total_travel+wire_diameter+wire_tolerance+wall_thickness/2;
//    stem_length = total_travel/1.25;
    echo(stem_length=stem_length);
    wire_diameter = wire_diameter + wire_tolerance;
    flat_back_tolerance = extra_tolerance/2; // The flat side opposes a 45° angle which means it'll get too much wiggle room if we just use the normal tolerance value.
    pin_diameter = 1.875; // Needs to match everything else
    // NOTE: Because we add a bit extra to the end of the connector there's +1mm in a few places
    translate([0,stem_length/2,0]) {
        difference() {
            translate([0,stem_length/2,CHERRY_CROSS_LENGTH/3]) rotate([90,0,0]) difference() {
                union() {
                    translate([0,-0.788,stem_length])
                        rotate([0,0,0])
                            cherry_cross();
            // Add a cylinder that will represent the TOTAL_TRAVEL of the switch
                    difference() {
                        union() {
                            cylinder(
                                d=diameter,
                                h=stem_length);
                            if (extra_tolerance) {
            // If we're doing a cutout we need the center of the stem to stick out the front a bit:
                                translate([0,0,lip_height*2])
                                    cylinder(
                                        d=diameter+extra_tolerance*2, // *2 because diameter (not radius)
                                        h=stem_length+lip_height*2);
            // Angled top so that it can print without supports
                                translate([0,diameter/3+extra_tolerance,stem_length/2+lip_height*2])
                                    rotate([0,0,45])
                                        cube([
                                            diameter/2+extra_tolerance,
                                            diameter/2+extra_tolerance,
                                            stem_length*1.5], center=true);
                            }
                        }
                        if (!extra_tolerance) {
                            translate([0,-diameter/3,total_travel/2+magnet_height/2])
                            // This one further reduces the surface area--further down the shaft
                                rotate([0,0,45]) cube([
                                    diameter/2.5,
                                    diameter/2.5,
                                    total_travel+magnet_height+magnet_tolerance], center=true);
            // Taper the end a smidge to reduce the likelihood of first-layer squish causing an issue
                            translate([0,-diameter*1.5,0]) rotate([45,0,0])
                                cube([diameter*2,diameter*2,diameter*2], center=true);
                            // NOTE: This taper also makes inserting the stem easier
                        }
                    }
                }
            }
            if (!extra_tolerance) {
                // Hole for the stabilizer wire
                translate([
                    0,
                    stem_length/2-wire_diameter/2-wall_thickness/3,
                    0]) {
            // TODO: Figure out the math on how wide it needs to be based on total_travel (so it gets enough of an angle)
                        translate([0,-wire_diameter/1.5,0]) rotate([-15,0,0])
                        // This hull() below makes the hole a bit wider so the bent wire doesn't have to be so perfect (X and Z tolerance are much more important than the Y here)
                            hull() {
                                translate([wire_diameter/4,0,0])
                                    cylinder(
                                        d=wire_diameter*1.35,
                                        h=total_travel*2, center=true);
                                translate([-wire_diameter/4,0,0])
                                    cylinder(
                                        d=wire_diameter*1.35,
                                        h=total_travel*2, center=true);
                            }
                }
            }
            // Flatten the bottom of the stem so it doesn't start printing in mid-air
            translate([0,0,-CHERRY_CYLINDER_DIAMETER/2-flat_back_tolerance])
            // NOTE: Using flat_back_tolerance because the amount of wiggle room on the 45° angle is too much on its own
                cube([500,500,CHERRY_CYLINDER_DIAMETER], center=true);
        }
    }
}

// Generates a jig for bending steel wire into the correct shape for stabilizers
module bending_jig(length, width=8, hole_size=2, wall_thickness=2, tolerance=0.3) {
    // Outside part
    difference() {
        squarish_rpoly(
            xy=[length+hole_size*4, width+hole_size*3.5],
            h=hole_size+wall_thickness, r=hole_size/4, center=true);
        squarish_rpoly(
            xy=[length, width],
            h=hole_size+wall_thickness*2, r=hole_size/4, center=true);
        // Cutout on the inside (long side)
        hull() {
            translate([length/2,width/2,0])
                sphere(d=hole_size);
            translate([-length/2,width/2,0])
                sphere(d=hole_size);
        }
        // Cutout on the inside (short sides)
        hull() {
            translate([length/2,width/2,0])
                sphere(d=hole_size);
            translate([length/2,-width,0])
                sphere(d=hole_size);
        }
        hull() {
            translate([-length/2,width/2,0])
                sphere(d=hole_size);
            translate([-length/2,-width,0])
                sphere(d=hole_size);
        }
        // Remove half so it's just an L
        translate([0,-hole_size,0])
            squarish_rpoly(
                xy=[length, width+wall_thickness*2],
                h=hole_size+wall_thickness*2, r=hole_size/4, center=true);
    }
    // Inside part
    translate([0,-hole_size-tolerance*2,0]) {
        difference() {
            squarish_rpoly(
                xy=[length-tolerance*2, width+wall_thickness*2],
                h=hole_size+wall_thickness, r=hole_size/4, center=true);
            // Short sides
            hull() {
                translate([length/2-tolerance,width,0])
                    sphere(d=hole_size);
                translate([length/2-tolerance,-width,0])
                    sphere(d=hole_size);
            }
            hull() {
                translate([-length/2+tolerance,width,0])
                    sphere(d=hole_size);
                translate([-length/2+tolerance,-width,0])
                    sphere(d=hole_size);
            }
            // Long side
            hull() {
                translate([length/2,width-hole_size,0])
                    sphere(d=hole_size);
                translate([-length/2,width-hole_size,0])
                    sphere(d=hole_size);
            }
            // Add some descriptive text about how big this bender is
            size = 8;
            translate([-size/1.25,-size/2,hole_size-0.5]) linear_extrude(1)
                text(str(length), size=size, font="Ubuntu");
        }
    }
}
