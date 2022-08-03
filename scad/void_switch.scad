// 3D printable magnetic separation key switch suitable for use via reed switches or hall effect sensors

// AUTHOR: Riskable <riskable@youknowwhat.com>
// VERSION: 1.3 (Changelog is at the bottom)
// LICENSE: TBD. Do not sell Void Switches (yet!) but feel free to make your own for personal use.
// LICENSING NOTE: If you want to sell keyboards/switches using this design just let me know and we'll work something out! I'll help you make awesome stuff!

use <body.scad>
use <stem.scad>
use <sheath.scad>
use <stabilizer.scad>
use <cherry_void.scad>
use <utils.scad>

/* [Main Parameters] */

// Uncomment this to see the precise location of the hall effect sensor in relation to the center of the switch:
//translate([-3.25,-3.25,0]) // Center of sensor is 3.25mm (45° angle) from center of switch
//    color("green") cylinder(d=1, h=100, center=true);
// NOTE: The magnet isn't perfectly aligned with the sensor on purpose: It's to cram everything into a slightly tigher space :)

// TODO: Make the body stem-specific like the sheath so that we can get accurate center positions for the sheath.

/*
  NOTES:
    * EXPERIMENT!  Try all sorts of different configurations to find what you like and share your results!
    * The body, sheath, and stem should be printed with 0.16mm layer height (including first layer) with a 0.4mm nozzle.  No need to go smaller.  Experiment!  See what works best with your printer!  FYI: The perfect layer height is actually dependent on your STEM_TOLERANCE setting...  It's just that with defaults 0.16mm is best.
    * So far the best results (smoothest switches) have come from printing the body, sheath, and stem in PETG.  However, PLA seems to work fine as well as Nylon (I tested Taulman Bridge).  If you want a *really quiet* switch print the stem in PCTPE or print just the top part (that holds the magnet) in something like TPU (as in, do a "color change" to TPU past the tallest point of the stem's main cylinder).
    * Lubricate your stems with something like Super Lube (any dielectric grease would be fine though) for the best experience.  YOU SHOULD NOT NEED TO SAND ANYTHING (unless your printer's tolerances are off).  NOTE: Sanding doesn't seem to make the switch "scratchy" (which surprised me).  You'd *think* it would but it doesn't...  Not with PETG anyway.
    * Printing everything in clear PETG is highly recommended if you plan to have an LED underneath!
    * You can calculate the theoretical force of the your switch using this calculator: https://www.kjmagnetics.com/calculator.asp (use MAGNET_WALL_THICKNESS + MAGNET_VOID as the "distance").
    * For convenience purposes this .scad will output it's best guess as to the force of your switch in the console but it only "knows" about the most common magnet strengths/sizes (e.g. N35_4x2).  See the supported constants at the bottom of utils.scad.
    * THERE ARE A LOT OF PARAMETERS BUT THEY ARE WORTH UNDERSTANDING!  Turns out that there's a lot things that are worthy of being specific about in order to generate *your* perfect key switch.
    * IF YOU INTEND TO USE REED SWITCHES READ THIS: Reed switches seem to activate/connect when a 3x1.5mm magnet (flat side) gets within ~5mm of (one side of) the reed switch.  This script will echo() the resting distance of the BOTTOM SIDE of the magnet indicating how far away it is from the TOP of the keyboard plate.  So if your key plate is 1.25mm thick and your SHEATH_LENGTH is 1.8 the magnet will be resting 3.15mm beneath the underside of your keyboard plate (4.4mm below the top of the switch--ignoring COVER_THICKNESS).  Doing the math...  That means if you want your switch to actuate at 2mm travel you want the metal lead sticking out one side of your reed switch to be ~9.4mm below the top of your keyboard plate (directly beneath where the magnet sits in the stem).
    * There are ways to put the reed switch closer!  It's just harder to figure out: You have to position the metal lead (of one side of) the reed switch so that the magnetic flux hits it at the point you want.  I've found that if you place the reed switch centered directly under the walls of the switch body (in alignment with the walls) that seems to work out to a ~2mm actuation in a switch with a 1.8mm SHEATH_LENGTH.
    2.4mm sheath means magnet is 5mm away from plate in resting position
    1.8mm sheath means magnet is 4.4mm away
    0mm sheath means magnet is 2.6mm away
*/

// IMPORTANT VARIABLES (customize to your liking):

// The amount of space interposed between the magnets. Controls how strong the switch will be; The higher the value the less force will be required to press the switch. Look at the console output to see the calculated switch strength (e.g. "NOTE: ESTIMATED STRENGTH/FORCE: ~56g"). Highly dependent on the strength and thickness of your magnets.
MAGNET_VOID = 0.6; // [0.1:0.1:3]
/* MAGNET_VOID NOTES:
    * The higher the MAGNET_VOID the lower the (initial) force to move (press) the switch.
    * You're just going to have to experiment with a few different values here to see what you like.
*/
// 2-4mm of travel is traditional for mechanical key switches
TOTAL_TRAVEL = 4; // [1:0.1:20]
// How much extra space (up/down) will be used to contain the stem (does not impact TOTAL_TRAVEL).  Longer == less wobble BUT the switch will be taller.  Doesn't really impact the feel of the switch otherwise.
SHEATH_LENGTH = 0.3; // [0:0.1:2]
// Wiggle room inside the sheath for the stem. If your stem doesn't effortlessly slide inside the sheath you need to increase the tolerance or check your printing layer height isn't messing with it.
STEM_TOLERANCE = 0.13; // [0.01:0.01:0.3]
//   ^ IMPORTANT!  If the stem doesn't effortlessly slide in and out of the sheath or has far too much back-corner/front-corner wobble double-check that your printing layer height isn't messing with the tolerances: With STEM_WALL_THICKNESS=1.2 the bottom layer of the sheath where it touches the stem is precisely 1.68mm tall.  Your layer height can impact this value considerably which is why a 0.28mm layer height is recommended (for FDM) as this results in that layer being precisely 1.68mm above the bed.
// NOTE: Also remember that YOU CAN ALWAYS SAND THE STEM IF IT'S TOO TIGHT.  As long as you get up to like 600 grit (or higher) your switch should still be nice and smooth (eventually--after some normal use).
// NOTE: You can visualize STEM_TOLERANCE by uncommenting the "visualize" RENDER bits at the top of this file.
// Diameter of the magnet that sits on top of the switch body
BODY_MAGNET_DIAMETER = 4; // [3:1:5]
// Thickness of the top magnet (use calipers to measure it!). NOTE: Cheap "4x2mm" N35 magnets are usually 4x1.7 or 4x1.8mm.  MEASURE YOUR MAGNETS WITH CALIPERS TO CHECK!
BODY_MAGNET_HEIGHT = 1.7; // [1:0.1:3]
// NOTE: CHINESE SELLERS LIE! ~1.7mm is the norm for "4x2mm" N35 magnets... Bastards

// Only used when calculating the strength of your switch (it gets spit out to the OpenSCAD console... "NOTE: ESTIMATED STRENGTH/FORCE: ~56g")
MAGNET_STRENGTH = "N35"; // [N35, N42, N45, N52]
// NOTE: The magnet strength calculation assumes you're using two magnets of the same size (and uses the "BODY" magnet values).

// STEM MAGNET PARAMETERS
STEM_MAGNET_DIAMETER = BODY_MAGNET_DIAMETER; // NOTE: Your STEM_DIAMETER needs to be wide enough to fit the magnet
STEM_MAGNET_HEIGHT = BODY_MAGNET_HEIGHT; // The switch body/stem will be automatically adjusted to fit this value

/* [Advanced Stuff] */

// Controls how thick the - part of the Cherry stem cross (+) will be.  Increase this if your keycaps are too loose.  Use a negative value if your keycaps are too tight.
STEM_CROSS_X_EXTRA = 0.0; // [-0.3:0.05:0.3]
// Controls how thick the | part of the Cherry stem cross (+) will be.  Increase this if your keycaps are too loose.  Use a negative value if your keycaps are too tight.
STEM_CROSS_Y_EXTRA = 0.0; // [-0.3:0.05:0.3]
// Wiggle room (from a magnet height perspective, not from a diameter perspective)
MAGNET_TOLERANCE = 0.1;
// How much room (diameter-wise) the magnet gets inside the stem.  Negative tolerance by default to hold the magnet tight (really press it in there). PLA and PETG should flex a bit and hold it strongly. For resin you'll probably want to set this to 0 and put some resin in the hole before inserting the magnet to hold it nice and strong.
STEM_MAGNET_DIAMETER_TOLERANCE = -0.1;
// TIP FOR RESIN PRINTERS: Set STEM_MAGNET_DIAMETER_TOLERANCE to 0 or 0.05 to avoid cracking and and squirt some resin in there before inserting the magnet for a strong hold.
// How much plastic goes around the magnets (not usually important; you can make this smaller if you use a nozzle smaller than 0.4mm to increase your switch's maximum theoretical strength)
MAGNET_WALL_THICKNESS = 0.5;
// NOTE: MAGNET_WALL_THICKNESS is constrained by the STEM_DIAMETER.  So if it's not getting thicker on the sides you'll need to increase STEM_DIAMETER to give it more room.
// Length of the switch_body() (See related: COVER_OVERHANG below)
BODY_LENGTH = 14.2;
// Width of the switch_body() (Seriously: Look at COVER_OVERHANG!)
BODY_WIDTH = 14.2;
// Technically the body doesn't need to be the same height as the sheath and stem are long.  If this is set to anything other than 0 the body will be of the height specified.  Otherwise its height will be calculated based on the length of the sheath.  AT LEAST 6 IS RECOMMENDED (so the clips will work).
BODY_HEIGHT = 0;
// The corner radius around the edges of the switch body
BODY_CORNER_RADIUS = 0.5;
// How thick the walls (just the sides) of the switch will be (in general)
WALL_THICKNESS = 1.35;
// How much the lip sticks out above the top of the switch body.
SHEATH_LIP_HEIGHT = 0.8; // [0.5:0.1:1.5]
// NOTE: If you make SHEATH_LIP_HEIGHT shorter you may want to increase SHEATH_LIP_OVERHANG a bit to prevent it from squishing its way through the top of the body (which can happen if you're pressing really hard trying to snap it into the top plate).

// LESS IMPORTANT VARIABLES (maybe leave these alone)
// How thick the top of the key switch body will be (directly under the keycap).  Doesn't need much.  Set to 0 for flush mount (not usually a good idea but you do you).
COVER_THICKNESS = 0.5; // [0:0.1:1.5]
// How much the top_cover() will overhang the switch_body() so it doesn't fall through the top of the keyboard/plate. Set to 0 for flush mount.
COVER_OVERHANG = 0.6; // [0:0.1:1.5]
// Controls the Z position of the magnet in the switch body and the sheath. Don't mess with this unless you know what you're doing.
BODY_MAGNET_COVER_THICKNESS = 0.0; // [-1.5:0.1:1.5]
// NOTE: THIN MAGNETS MAY NEED ADJUSTMENT TO BODY_MAGNET_COVER_THICKNESS
// Makes up for a little bit of drooping in the magnet holder since it's a bridge printing over air. Leave this setting alone unless you find that the "seat" that prevents the magnet from falling through isn't printing correctly.
MAGNET_BRIDGE_DROOP = 0.2;
// How thick bridges will be (e.g. the little lines that go under the clips in the body). They're supposed to be thin enough to "give way" (a bit) when you snap the switch into the top plate.
CLIP_BRIDGE_THICKNESS = 0.3;
// So we can calculate where to place the snap clips on the sides. For normal plates use 1.5mm.  For plates made out of a PCB use 1.6mm (usually).
SWITCH_PLATE_THICKNESS = 1.5;
// How much wiggle room the switch body gets inside the hole on your keyboard's top plate/cover. Leave this alone unless your switches are too tight or too loose when snapping them into the plate.
SWITCH_PLATE_TOLERANCE = 0.2;
// How big the stem's cylinder will be (probably don't want to change this unless you're using 3mm or 5mm magnets).
STEM_DIAMETER = 5.35;
// NOTE: If you increase WALL_THICKNESS and/or MAGNET_WALL_THICKNESS (say, to make a switch printable with a THICC nozzle) you'll likely need to increase STEM_DIAMETER as well.
// "cherry_cross" is presently the only supported stem type (more stem options in the future, probably)
STEM_TYPE = "cherry_cross"; // [cherry_cross]
// How tall the + will be (or whatever goes into the underside of the keycap). Nearly all keycaps have 4mm stems but some low profile are shorter (e.g. 3mm).
STEM_TOP_HEIGHT = 3.5; // [2:0.1:4]
// TIP: If making a low-profile keycap you migth want to reduce STEM_TOP_HEIGHT a bit to save some vertical space.  Example: Low-profile Cherry MX style keycaps have ~3mm of room inside (I think) so you can set this to 3 if using keycaps like that.
// In switch_body() it divides, BODY_WIDTH/BODY_TAPER to figure out how much smaller the bottom should be in relation to the top.  If you set this too large you can end up with walls that are too thin.  Also know that you don't *need* any taper at all... It just makes it easier to insert the switch into it's respective hole in your keyboard/switch plate.  Set it to 1 to disable tapering of the switch_body() (and just push it harder!).
BODY_TAPER = 1.1;
// How thick the walls of the sheath will be (the part the stem slides inside of)
SHEATH_WALL_THICKNESS = 1.2; // Doesn't need to be quite as thick/strong as the switch's body
// How much wiggle room the sheath gets as it slides into the body
SHEATH_TOLERANCE = 0.15;
// Wiggle room for the magnet where it gets inserted into the sheath (default: 0.1 for strong hold). NOTE: If you have problems with the sheath breaking when you insert the magnet just make this big (e.g. 0.25) and just use some glue.
SHEATH_MAGNET_DIAMETER_TOLERANCE = 0.1;
// TIP FOR RESIN PRINTERS: Resin tends to be brittle so to prevent cracking when inserting the magnet you may want to set SHEATH_MAGNET_DIAMETER_TOLERANCE to something like 0.1 and squirt some resin on the magnet after insertion to hold it in place.
// The wall thickness for the magnet in the sheath
SHEATH_MAGNET_WALL_THICKNESS = MAGNET_WALL_THICKNESS;
// How much the sheath lip sticks out on top of the switch body
SHEATH_LIP_OVERHANG = 1;
// Controls the "spread" of the notches >< on the (inside) sides of the sheath (they're rotated this many degrees so they get farther apart as the stem progresses down the length of the sheath; this is to ensure the least amount of friction when returning to keyup).  IF YOU INCREASE TRAVEL SIGNIFICANTLY YOU MAY WANT TO ADJUST THIS but otherwise probably leave it alone.
SHEATH_NOTCH_ANGLE = 1;
// NOTE: Set SHEATH_NOTCH_ANGLE to 0 to have perfectly straight notches >< (not recommended).  If you do this you'll need to be more careful with your STEM_TOLERANCE setting.
// How thick the little wall at the end of the sheath will be.  By default there's no wall/end stop which means that the stem can be easily removed but will also smack into whatever's underneath the switch when you press it (e.g. the sensor or LED on the PCB or the case covering those things).  If you set this to something like 0.8 you'll get a wall of sorts that prevents the stem from coming out (like, ever haha) and will also prevent it from hitting anything below the switch.  It makes it so you can press pretty hard on keycaps (to insert them) without having to worry that your brute strength will break your LEDs/sensors.  NOTE: This feature requires some flex in the plastic body of the sheath in order for the stem to snap into its channel so resin users be forewarned.
SHEATH_END_STOP_THICKNESS = 0.0; // [0.0:0.1:1.2]
// NOTE: If your keyboard has something underneath the switch at the correct TOTAL_TRAVEL distance you don't need the end stopper and can set SHEATH_END_STOP_THICKNESS to 0.  If you *do* want a stopper a value of 0.5 is usually good for a 0.4mm nozzle.
// These SHEATH_CLIP_* parameters control the little clips on the sheath that let it snap-fit into the body (probably leave these alone unless you're working with something other than PLA/PETG that's either much softer or much more brittle)...
// Controls the thickness of the clips on the side of the sheath (i.e. how much they stick out)
SHEATH_CLIP_HEIGHT = 0.5;
// Controls how long the clips on the side of the sheath will be (should only ever need to be adjusted if you make sigificant changes to SHEATH_WALL_THICKNESS)
SHEATH_CLIP_LENGTH = 0.85;
// Controls how tall (Z; when printing) the little clips on the side of the sheath will be
SHEATH_CLIP_WIDTH = 2;
// Controls the width of the notch for the sheath in the body and its matching cutout/channel on the underside of the sheath
SHEATH_BOTTOM_CLIP_WIDTH = 1.5;

// OpenSCAD's rendering resolution (64 worked well for me but feel free to go higher if you're patient--unlike me)
$fn = 64;

/* [What to Render] */

// Choose what to render. Options are: "body", "sheath", "stem", "body+sheath" (for resin/high res printers), "%body" (for transparent body), "visualize_keyup", "visualize_keydown", "switch_plate". Example to visualize the switch sitting in your keyboard: ["%body", "visualize_keyup", "switch_plate"];
RENDER = ["body", "sheath", "stem"];
//RENDER = ["sheath_double_sided", ""];
// You can combine the body and sheath into a single unit if you have a resin printer since the resolution is tight enough that you don't need to worry about the orientation of the layer lines:
//RENDER = ["body+sheath", "stem"];
// NOTE: SET SHEATH_LIP_HEIGHT TO 0 IF YOU USE "body+sheath"!

// If you want to turn some other model into something that a Void Switch stem can slide in/out of you can use the stem_void option:
//RENDER = ["stem_void"];

// If you want to visualize the switch as it would be installed just uncomment the one you want:
//RENDER = ["%body", "visualize_keyup", "switch_plate"]; // NOTE: Great for checking tolerances!
//RENDER = ["%body", "visualize_keydown", "switch_plate"];
//RENDER = ["visualize_keyup"];
//RENDER = ["visualize_keydown"];
//RENDER = ["%body", "visualize_keyup"];
//RENDER = ["%body", "visualize_keydown"];
//RENDER = ["visualize_keydown", "visualize_keyup"];
//RENDER = ["%body", "visualize_keyup", "visualize_reed_switch"];

/* [Hidden] */
// END CUSTOMIZER OPTIONS

// STABILIZER STUFF (might move it here in the future)
// Make this kinda big since 3D printers are usually bad with small circles
STABILIZER_WIRE_TOLERANCE = 0.4;
// 1.1 == 18awg; 1.6 == 16awg (measured)
STABILIZER_WIRE_DIAMETER = 1.1+STABILIZER_WIRE_TOLERANCE;
// Slightly different from the regular stem since it can't be at a 45° angle
STABILIZER_STEM = false;

// EXPERIMENTAL OPTIONS
// This one will make it so that the magnet gets placed into the body first before snapping the sheath on top of it to hold it in place.  It's slightly harder to assemble this way but if you're using some stranger sheath configurations it can be a better way of doing things (glue is recommended):
SHEATH_HOLDS_MAGNET = true;

// Try to calculate the strength of the switch in grams and output that to the console
display_magnet_strength(BODY_MAGNET_DIAMETER, BODY_MAGNET_HEIGHT, MAGNET_VOID, strength=MAGNET_STRENGTH);

// These variables are used below for placement of things:
sheath_height = STEM_DIAMETER+SHEATH_WALL_THICKNESS*2;
sheath_width = STEM_DIAMETER+SHEATH_WALL_THICKNESS*2;
// Render the selected items
for (item=RENDER) {
    if (item=="body") {
        switch_body(
            BODY_LENGTH, BODY_WIDTH, TOTAL_TRAVEL,
            taper=BODY_TAPER,
            wall_thickness=WALL_THICKNESS,
            sheath_wall_thickness=SHEATH_WALL_THICKNESS,
            sheath_length=SHEATH_LENGTH,
            cover_overhang=COVER_OVERHANG,
            cover_thickness=COVER_THICKNESS,
            plate_thickness=SWITCH_PLATE_THICKNESS,
            plate_tolerance=SWITCH_PLATE_TOLERANCE,
            stem_diameter=STEM_DIAMETER,
            sheath_tolerance=SHEATH_TOLERANCE,
            lip_height=SHEATH_LIP_HEIGHT,
            top_magnet_height=BODY_MAGNET_HEIGHT,
            top_magnet_diameter=BODY_MAGNET_DIAMETER,
            top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
            magnet_height=STEM_MAGNET_HEIGHT,
            magnet_wall_thickness=MAGNET_WALL_THICKNESS,
            magnet_tolerance=MAGNET_TOLERANCE,
            magnet_void=MAGNET_VOID,
            sheath_end_stop_thickness=SHEATH_END_STOP_THICKNESS,
            corner_radius=BODY_CORNER_RADIUS,
            droop_extra=MAGNET_BRIDGE_DROOP,
            stem_tolerance=STEM_TOLERANCE,
            sheath_clip_width=SHEATH_BOTTOM_CLIP_WIDTH,
            bridge_thickness=CLIP_BRIDGE_THICKNESS,
            sheath_snug_magnet=SHEATH_HOLDS_MAGNET,
            height=BODY_HEIGHT);
    } else if (item=="body+sheath") {
        switch_body(
            BODY_LENGTH, BODY_WIDTH, TOTAL_TRAVEL,
            taper=BODY_TAPER,
            wall_thickness=WALL_THICKNESS,
            sheath_wall_thickness=SHEATH_WALL_THICKNESS,
            sheath_length=SHEATH_LENGTH,
            cover_overhang=COVER_OVERHANG,
            cover_thickness=COVER_THICKNESS,
            plate_thickness=SWITCH_PLATE_THICKNESS,
            plate_tolerance=SWITCH_PLATE_TOLERANCE,
            stem_diameter=STEM_DIAMETER,
            sheath_tolerance=-SHEATH_TOLERANCE,
            lip_height=SHEATH_LIP_HEIGHT,
            top_magnet_height=BODY_MAGNET_HEIGHT,
            top_magnet_diameter=BODY_MAGNET_DIAMETER,
            top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
            magnet_height=STEM_MAGNET_HEIGHT,
            magnet_wall_thickness=MAGNET_WALL_THICKNESS,
            magnet_tolerance=MAGNET_TOLERANCE,
            magnet_void=MAGNET_VOID,
            sheath_end_stop_thickness=SHEATH_END_STOP_THICKNESS,
            corner_radius=BODY_CORNER_RADIUS,
            droop_extra=0,
            stem_tolerance=STEM_TOLERANCE,
            sheath_clip_width=0,
            bridge_thickness=CLIP_BRIDGE_THICKNESS,
            sheath_snug_magnet=SHEATH_HOLDS_MAGNET,
            sheath_inside_body=true,
            height=BODY_HEIGHT);
        sheath_overall_length = (
            (SHEATH_LENGTH
            +TOTAL_TRAVEL
            -BODY_MAGNET_COVER_THICKNESS
            +STEM_MAGNET_HEIGHT
            +MAGNET_WALL_THICKNESS*2
            +MAGNET_TOLERANCE
            +MAGNET_VOID)/2
            +BODY_MAGNET_HEIGHT/2);
        translate([
          sheath_height/2-SHEATH_WALL_THICKNESS*1.5+STEM_TOLERANCE,
          sheath_height/2-SHEATH_WALL_THICKNESS*1.5+STEM_TOLERANCE,
          sheath_overall_length])
            rotate([90,0,-45]) // Line it up
                sheath_cherry_cross(SHEATH_LENGTH, STEM_DIAMETER, TOTAL_TRAVEL, 0,
                    stem_tolerance=STEM_TOLERANCE,
                    sheath_tolerance=0.15,
                    wall_thickness=SHEATH_WALL_THICKNESS,
                    lip_height=SHEATH_LIP_HEIGHT,
                    lip_overhang=SHEATH_LIP_OVERHANG,
                    top_magnet_height=BODY_MAGNET_HEIGHT,
                    top_magnet_diameter=BODY_MAGNET_DIAMETER,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=SHEATH_MAGNET_DIAMETER_TOLERANCE,
                    end_stop_thickness=SHEATH_END_STOP_THICKNESS,
                    magnet_void=MAGNET_VOID,
                    notch_angle=SHEATH_NOTCH_ANGLE,
                    snug_magnet=true,
                    inside_body=true);
    } else if (item=="%body") {
        %switch_body( // Sometimes it's nice to have the body transparent when visualizing things
            BODY_LENGTH, BODY_WIDTH, TOTAL_TRAVEL,
            taper=BODY_TAPER,
            wall_thickness=WALL_THICKNESS,
            sheath_wall_thickness=SHEATH_WALL_THICKNESS,
            sheath_length=SHEATH_LENGTH,
            cover_overhang=COVER_OVERHANG,
            cover_thickness=COVER_THICKNESS,
            plate_thickness=SWITCH_PLATE_THICKNESS,
            plate_tolerance=SWITCH_PLATE_TOLERANCE,
            stem_diameter=STEM_DIAMETER,
            sheath_tolerance=SHEATH_TOLERANCE,
            lip_height=SHEATH_LIP_HEIGHT,
            top_magnet_height=BODY_MAGNET_HEIGHT,
            top_magnet_diameter=BODY_MAGNET_DIAMETER,
            top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
            magnet_height=STEM_MAGNET_HEIGHT,
            magnet_wall_thickness=MAGNET_WALL_THICKNESS,
            magnet_tolerance=MAGNET_TOLERANCE,
            magnet_void=MAGNET_VOID,
            sheath_end_stop_thickness=SHEATH_END_STOP_THICKNESS,
            corner_radius=BODY_CORNER_RADIUS,
            droop_extra=MAGNET_BRIDGE_DROOP,
            stem_tolerance=STEM_TOLERANCE,
            sheath_clip_width=SHEATH_BOTTOM_CLIP_WIDTH,
            bridge_thickness=CLIP_BRIDGE_THICKNESS,
            sheath_snug_magnet=SHEATH_HOLDS_MAGNET,
            height=BODY_HEIGHT);
    } else if (item=="sheath") {
        translate([BODY_LENGTH/1.05,0,0]) // Move it over to the side (but keep it tight so we can print more at a time!)
            rotate([0,0,0]) // Line it up
                sheath_cherry_cross(SHEATH_LENGTH, STEM_DIAMETER, TOTAL_TRAVEL, COVER_THICKNESS,
                    stem_tolerance=STEM_TOLERANCE,
                    sheath_tolerance=SHEATH_TOLERANCE,
                    wall_thickness=SHEATH_WALL_THICKNESS,
                    lip_height=SHEATH_LIP_HEIGHT,
                    lip_overhang=SHEATH_LIP_OVERHANG,
                    top_magnet_height=BODY_MAGNET_HEIGHT,
                    top_magnet_diameter=BODY_MAGNET_DIAMETER,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=SHEATH_MAGNET_DIAMETER_TOLERANCE,
                    magnet_wall_thickness=SHEATH_MAGNET_WALL_THICKNESS,
                    end_stop_thickness=SHEATH_END_STOP_THICKNESS,
                    magnet_void=MAGNET_VOID,
                    snap_pip_height=SHEATH_CLIP_HEIGHT,
                    snap_pip_length=SHEATH_CLIP_LENGTH,
                    snap_pip_width=SHEATH_CLIP_WIDTH,
                    notch_angle=SHEATH_NOTCH_ANGLE,
                    bottom_clip_width=SHEATH_BOTTOM_CLIP_WIDTH,
                    snug_magnet=SHEATH_HOLDS_MAGNET);
    } else if (item=="sheath_double_sided") {
        translate([BODY_LENGTH/1.05,0,(SHEATH_LENGTH+TOTAL_TRAVEL-BODY_MAGNET_COVER_THICKNESS+
             STEM_MAGNET_HEIGHT+MAGNET_WALL_THICKNESS*2+MAGNET_TOLERANCE+MAGNET_VOID+COVER_THICKNESS)/2+BODY_MAGNET_HEIGHT/2])
            rotate([90,0,0]) // Line it up
                sheath_cherry_cross_double_sided(SHEATH_LENGTH, STEM_DIAMETER, TOTAL_TRAVEL, COVER_THICKNESS,
                    stem_tolerance=STEM_TOLERANCE,
                    sheath_tolerance=SHEATH_TOLERANCE,
                    wall_thickness=SHEATH_WALL_THICKNESS,
                    lip_height=SHEATH_LIP_HEIGHT,
                    lip_overhang=SHEATH_LIP_OVERHANG,
                    top_magnet_height=BODY_MAGNET_HEIGHT,
                    top_magnet_diameter=BODY_MAGNET_DIAMETER,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=SHEATH_MAGNET_DIAMETER_TOLERANCE,
                    end_stop_thickness=SHEATH_END_STOP_THICKNESS,
                    magnet_void=MAGNET_VOID,
                    snap_pip_height=SHEATH_CLIP_HEIGHT,
                    snap_pip_length=SHEATH_CLIP_LENGTH,
                    snap_pip_width=SHEATH_CLIP_WIDTH,
                    notch_angle=SHEATH_NOTCH_ANGLE,
                    bottom_clip_width=SHEATH_BOTTOM_CLIP_WIDTH,
                    snug_magnet=SHEATH_HOLDS_MAGNET);
    } else if (item=="stem") {
        translate([-BODY_LENGTH/1.25,-TOTAL_TRAVEL/1.15,0]) // STEM
            rotate([0,0,0]) // Line it up so we can bring it closer
                stem_cherry_cross(TOTAL_TRAVEL, STEM_DIAMETER, SHEATH_LENGTH, WALL_THICKNESS, COVER_THICKNESS,
                    magnet_wall_thickness=MAGNET_WALL_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=STEM_MAGNET_DIAMETER_TOLERANCE,
                    lip_height=SHEATH_LIP_HEIGHT,
                    body_magnet_height=BODY_MAGNET_HEIGHT,
                    cross_height=STEM_TOP_HEIGHT,
                    magnet_void=MAGNET_VOID,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    flat_cross=STABILIZER_STEM,
                    cross_x_extra=STEM_CROSS_X_EXTRA,
                    cross_y_extra=STEM_CROSS_Y_EXTRA);
    } else if (item=="stem_double_sided") {
        translate([-BODY_LENGTH/1.25,-TOTAL_TRAVEL/1.15,TOTAL_TRAVEL+COVER_THICKNESS+SHEATH_LIP_HEIGHT+SHEATH_LENGTH+STEM_MAGNET_HEIGHT+MAGNET_WALL_THICKNESS*2+MAGNET_TOLERANCE+MAGNET_VOID+BODY_MAGNET_HEIGHT]) // STEM
            rotate([-90,0,0]) // Line it up so we can bring it closer
                stem_cherry_cross_double_magnet(TOTAL_TRAVEL, STEM_DIAMETER, SHEATH_LENGTH, WALL_THICKNESS, COVER_THICKNESS,
                    magnet_wall_thickness=MAGNET_WALL_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=STEM_MAGNET_DIAMETER_TOLERANCE,
                    lip_height=SHEATH_LIP_HEIGHT,
                    body_magnet_height=BODY_MAGNET_HEIGHT,
                    cross_height=STEM_TOP_HEIGHT,
                    magnet_void=MAGNET_VOID,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    flat_cross=STABILIZER_STEM,
                    cross_x_extra=STEM_CROSS_X_EXTRA,
                    cross_y_extra=STEM_CROSS_Y_EXTRA);
    } else if (item=="stem_void") {
        // Generating a stem negative (for use in other models for boolean/cutout stuff)
            stem_cherry_cross(TOTAL_TRAVEL, STEM_DIAMETER, SHEATH_LENGTH, WALL_THICKNESS, COVER_THICKNESS,
                magnet_wall_thickness=MAGNET_WALL_THICKNESS,
                magnet_height=STEM_MAGNET_HEIGHT,
                magnet_diameter=STEM_MAGNET_DIAMETER,
                magnet_tolerance=MAGNET_TOLERANCE,
                magnet_diameter_tolerance=STEM_MAGNET_DIAMETER_TOLERANCE,
                lip_height=SHEATH_LIP_HEIGHT,
                body_magnet_height=BODY_MAGNET_HEIGHT,
                cross_height=STEM_TOP_HEIGHT,
                magnet_void=MAGNET_VOID,
                extra_tolerance=STEM_TOLERANCE,
                top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                flat_cross=STABILIZER_STEM,
                cross_x_extra=STEM_CROSS_X_EXTRA,
                cross_y_extra=STEM_CROSS_Y_EXTRA);
    } else if (item=="visualize_keyup") {
        rotate([0,0,-90]) translate([
            -sheath_height/2+SHEATH_WALL_THICKNESS*1.5-STEM_TOLERANCE,
            sheath_height/2-SHEATH_WALL_THICKNESS*1.5+STEM_TOLERANCE,
            (SHEATH_LENGTH+TOTAL_TRAVEL-BODY_MAGNET_COVER_THICKNESS+
             STEM_MAGNET_HEIGHT+MAGNET_WALL_THICKNESS*2+MAGNET_TOLERANCE+MAGNET_VOID+COVER_THICKNESS)/2-SHEATH_LIP_HEIGHT+BODY_MAGNET_HEIGHT/2-0.01
          ])
            rotate([90,0,45])
                sheath_cherry_cross(SHEATH_LENGTH, STEM_DIAMETER, TOTAL_TRAVEL, COVER_THICKNESS,
                    stem_tolerance=STEM_TOLERANCE,
                    sheath_tolerance=SHEATH_TOLERANCE,
                    wall_thickness=SHEATH_WALL_THICKNESS,
                    lip_height=SHEATH_LIP_HEIGHT,
                    lip_overhang=SHEATH_LIP_OVERHANG,
                    top_magnet_height=BODY_MAGNET_HEIGHT,
                    top_magnet_diameter=BODY_MAGNET_DIAMETER,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=SHEATH_MAGNET_DIAMETER_TOLERANCE,
                    end_stop_thickness=SHEATH_END_STOP_THICKNESS,
                    magnet_void=MAGNET_VOID,
                    snap_pip_height=SHEATH_CLIP_HEIGHT,
                    snap_pip_length=SHEATH_CLIP_LENGTH,
                    snap_pip_width=SHEATH_CLIP_WIDTH,
                    notch_angle=SHEATH_NOTCH_ANGLE,
                    bottom_clip_width=SHEATH_BOTTOM_CLIP_WIDTH,
                    snug_magnet=SHEATH_HOLDS_MAGNET);
        rotate([0,0,-90]) translate([
            -0.95,0.95,
            -SHEATH_LIP_HEIGHT-TOTAL_TRAVEL-MAGNET_WALL_THICKNESS+MAGNET_TOLERANCE/2
          ])
            rotate([90,0,45]) color([0,1,0,1]) // Keyup (green)
                stem_cherry_cross(TOTAL_TRAVEL, STEM_DIAMETER, SHEATH_LENGTH,
                    WALL_THICKNESS, COVER_THICKNESS,
                    magnet_wall_thickness=MAGNET_WALL_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=STEM_MAGNET_DIAMETER_TOLERANCE,
                    lip_height=SHEATH_LIP_HEIGHT,
                    body_magnet_height=BODY_MAGNET_HEIGHT,
                    cross_height=STEM_TOP_HEIGHT,
                    magnet_void=MAGNET_VOID,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    flat_cross=STABILIZER_STEM,
                    cross_x_extra=STEM_CROSS_X_EXTRA,
                    cross_y_extra=STEM_CROSS_Y_EXTRA);
    } else if (item=="visualize_keydown") {
        rotate([0,0,-90]) translate([
            -2.2, 2.2,
            (SHEATH_LENGTH+TOTAL_TRAVEL-BODY_MAGNET_COVER_THICKNESS+
             STEM_MAGNET_HEIGHT+MAGNET_WALL_THICKNESS*2+MAGNET_TOLERANCE+MAGNET_VOID+COVER_THICKNESS)/2-SHEATH_LIP_HEIGHT+BODY_MAGNET_HEIGHT/2
            ])
            rotate([90,0,45])
                sheath_cherry_cross(SHEATH_LENGTH, STEM_DIAMETER, TOTAL_TRAVEL, COVER_THICKNESS,
                    stem_tolerance=STEM_TOLERANCE,
                    sheath_tolerance=SHEATH_TOLERANCE,
                    wall_thickness=SHEATH_WALL_THICKNESS,
                    lip_height=SHEATH_LIP_HEIGHT,
                    lip_overhang=SHEATH_LIP_OVERHANG,
                    top_magnet_height=BODY_MAGNET_HEIGHT,
                    top_magnet_diameter=BODY_MAGNET_DIAMETER,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=SHEATH_MAGNET_DIAMETER_TOLERANCE,
                    end_stop_thickness=SHEATH_END_STOP_THICKNESS,
                    magnet_void=MAGNET_VOID,
                    snap_pip_height=SHEATH_CLIP_HEIGHT,
                    snap_pip_length=SHEATH_CLIP_LENGTH,
                    snap_pip_width=SHEATH_CLIP_WIDTH,
                    notch_angle=SHEATH_NOTCH_ANGLE,
                    bottom_clip_width=SHEATH_BOTTOM_CLIP_WIDTH,
                    snug_magnet=SHEATH_HOLDS_MAGNET);
        rotate([0,0,-90]) translate([
            -0.95,0.95,
            -SHEATH_LIP_HEIGHT])
            rotate([90,0,45]) color([1,0,0,1]) // Keydown (red)
                stem_cherry_cross(TOTAL_TRAVEL, STEM_DIAMETER, SHEATH_LENGTH,
                    WALL_THICKNESS, COVER_THICKNESS,
                    magnet_wall_thickness=MAGNET_WALL_THICKNESS,
                    magnet_height=STEM_MAGNET_HEIGHT,
                    magnet_diameter=STEM_MAGNET_DIAMETER,
                    magnet_tolerance=MAGNET_TOLERANCE,
                    magnet_diameter_tolerance=STEM_MAGNET_DIAMETER_TOLERANCE,
                    lip_height=SHEATH_LIP_HEIGHT,
                    body_magnet_height=BODY_MAGNET_HEIGHT,
                    cross_height=STEM_TOP_HEIGHT,
                    magnet_void=MAGNET_VOID,
                    top_magnet_cover_thickness=BODY_MAGNET_COVER_THICKNESS,
                    flat_cross=STABILIZER_STEM,
                    cross_x_extra=STEM_CROSS_X_EXTRA,
                    cross_y_extra=STEM_CROSS_Y_EXTRA);
    } else if (item=="switch_plate") { // Make a pretend switch plate
        color([0.7,0.7,0.7,0.1]) translate([0,0,SWITCH_PLATE_THICKNESS/2+COVER_THICKNESS])
            difference() {
                squarish_rpoly(
                    xy=[BODY_LENGTH*2, BODY_WIDTH*2],
                    h=SWITCH_PLATE_THICKNESS,
                    r=1, center=true);
                translate([0,0,SWITCH_PLATE_THICKNESS/2+COVER_THICKNESS-1.101])
                    rotate([0,0,90])
                        cherry_switch_void(height=2, plate_thickness=SWITCH_PLATE_THICKNESS);
            }
            translate([-11,10,SWITCH_PLATE_THICKNESS*2-1.25]) linear_extrude(height=1, center=true)
                text("Switch Plate", size=3);
            rotate([0,180,0]) translate([-11,10,-1]) linear_extrude(height=1, center=true)
                text("Switch Plate", size=3);
    } else if (item=="visualize_reed_switch") { // Make a pretend switch plate
        color([0.5,0.6,0.5,0.8]) translate([-BODY_LENGTH/2+WALL_THICKNESS/1.25,0,1.25+TOTAL_TRAVEL+SHEATH_LENGTH+COVER_THICKNESS+STEM_MAGNET_HEIGHT+MAGNET_TOLERANCE+MAGNET_WALL_THICKNESS*2]) {
            rotate([90,0,0]) cylinder(d=1.25, h=5, center=true);
            cube([1,BODY_WIDTH,0.4], center=true);
        }
    }
}

/* CHANGELOG:
    1.0:
        * Initial release.
    1.1:
        * Renamed STEM_TOP_LENGTH to STEM_TOP_HEIGHT since that better reflects what it controls and made the default 3.5 to match real-world Cherry cross stems.  Also renamed the cross_length argument in stem_cherry_cross() to cross_height.
        * stem.scad: The CHERRY_STEM_HEIGHT constant was renamed to CHERRY_CROSS_HEIGHT to better reflect what it's for.  It was also changed from 4.5 to 3.5 because that's the height of a standard Cherry cross (+) stem (the 4.5 was just a typo).
        * stem.scad: cherry_cross() had its length argument renamed to height to better reflect what it controls.
        * void_switch.scad: You can now control the body's corner radius via the BODY_CORNER_RADIUS parameter.
        * stabilizer.scad: Changed the wire_retention_arm() module to generate a completely different wire clip thing.  The new one is much skinnier than the old one and also more adjustable via some new parameters.  More importantly: IT NOW WORKS WITH LOW-PROFILE SWITCHES!  Yay!
        * stabilizer.scad: Renamed stabilizer_riskey_cross() to stabilizer_body_cherry_cross() to better reflect what it generates.
        * stabilizer.scad: Renamed riskey_stabilizer_stem_cherry_cross() to stabilizer_slider_cherry_cross() to better reflect what it generates.
        * stabilizer.scad: You can now specify the height of the cross (+) just like you can in void_switch.scad.
        * stabilizer.scad: You can now optionally add another (2x1mm) magnet to the stabilizer stem to further reduce the chance of unwanted noise in your stabilizer.  Right now this is hard-coded but I'll make it parametric in the future.
        * stabilizer.scad: Removed old/unused cruft.
    1.2:
        * void_switch.scad: SHEATH_LIP_HEIGHT is now 0.8 instead of 1 by default (just to shorten things a smidge--1 is kinda overkill).
        * stabilizer.scad: The text indicating the total travel now shows up correctly on the mirrored stabilizer body (the left side).
        * stabilizer.scad: The wire_retention_arm() has had the little wire cutout moved down slightly so that it (the wire) gets a bit less wiggle room (it really was too much before this change).
        * stabilizer.scad: Added STABILIZER_WIRE_CLIP_TOLERANCE so that you can have a different amount of tolerance in the clip than in the stabilizer's stem (the clip needs slightly more than the stem does).
        * stabilizer.scad: Fixed an issue where stabilizer stems were getting generated slightly too short when total travel was less than 4.
    1.3:
        * SHEATH_LIP_HEIGHT has been changed from a default of 1.0 to 0.8 (it doesn't need to be that thick).
        * Added "stem_void" feature which uses the stem.scad's negative space feature (same as used by the sheath.scad) to create a model that can be used in boolean operations to make a hole (in other models) that the stem can slide in/out of.
        * Changed how the negative space feature of the stem gets generated slightly so that it doesn't cut out more than it needs to (so the new "stem_void" feature makes more sense).
        * The negative space cutout of the stem now includes a center mark for easy alignment and there's also a commented-out bit of code that adds an alignment marker if you're doing something interesting and want to make sure everything lines up like it's supposed to.
        * stabilizer.scad: Changed the design of the wire clip so that it takes up much less space and can now work with low-profile Void Switches.
*/