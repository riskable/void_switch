// Modules related to the switch's stem

use <utils.scad>

// CONSTANTS
SENSOR_OFFSET = [3.25,3.25]; // How far away the hall effect sensor (or reed switch) is in relation to the center of the switch (any 45° angle)

// Cherry constants (not all used; many are here "just in case")
CHERRY_SWITCH_LENGTH = 15.6;
CHERRY_SWITCH_WIDTH = 15.6;
CHERRY_CYLINDER_DIAMETER = 5.47; // Represents the keycap's stem (female side of the +)
CHERRY_CROSS_HEIGHT = 3.5; // How far the underside of the keycap extends into the stem()
// NOTE: These CHERRY_CROSS_THICKNESS_* values are from the official spec
CHERRY_CROSS_THICKNESS_X = 1.31; // Width of the - in the + (Measured: 1.26-1.31)
CHERRY_CROSS_THICKNESS_Y = 1.09; // Width of the | in the + (Measured: 1.09-1.1)
CHERRY_CROSS_LENGTH = 4; // Length of the - and the | in the +
CHERRY_CENTER_HOLE_DIAMETER = 3.9878; // Size of the mounting hole on the PCB
// Key switches typically have two pins...  Cherry pins have very specific positions based on where the center hole/mounting pin is:
CHERRY_PIN_1_X_DISTANCE = -3.81; // Distance to the left of the center hole
CHERRY_PIN_1_Y_DISTANCE = 2.54; // Distance up from the center hole
CHERRY_PIN_2_X_DISTANCE = 2.54; // Distance to the right of the center hole
CHERRY_PIN_2_Y_DISTANCE = 5.08; // Distance up from the center hole
// If there's an LED (we don't use this info but it's good to have):
CHERRY_LED_PIN_1_X_DISTANCE = -5.08;
CHERRY_LED_PIN_1_Y_DISTANCE = -2.54;
CHERRY_LED_PIN_2_X_DISTANCE = -5.08;
CHERRY_LED_PIN_2_Y_DISTANCE = 2.54;

// FUTURE: Support for different stem types
//module stem(stem_type="cherry_cross") {
//    if (stem_type == "cherry_cross") {
//        stem_cherry_cross();
//    }
//}

// TODO: See if we *actually need* the wall_thickness passed in to this module because it's probably just "useful small value"...

// Generates a cross (+) style Cherry MX stem:
// NOTE: notch_angle only applies when using extra_tolerance (void space feature)
module stem_cherry_cross(travel, diameter, sheath_length, wall_thickness, cover_thickness, magnet_height=2, magnet_diameter=4, magnet_tolerance=0, magnet_diameter_tolerance=0.1, magnet_wall_thickness=0.5, lip_height=1, magnet_void=0.2, body_magnet_height=2, extra_tolerance=0, cross_height=CHERRY_CROSS_HEIGHT, top_magnet_cover_thickness=-0.5, notch_angle=1, flat_cross=false, cross_x_extra=0, cross_y_extra=0) {
    total_travel = travel+sheath_length+cover_thickness+lip_height;
    // Magnet's (edge) distance from the center of the switch (MUST BE UNCHANGING!):
    magnet_distance = sqrt((SENSOR_OFFSET[0]*SENSOR_OFFSET[0])+(SENSOR_OFFSET[1]*SENSOR_OFFSET[1]));
    // NOTE: I completely forget how I figured out that the square root of all that made for the perfect magnet_distance LOL 🤷
    stem_length = total_travel+magnet_height+magnet_wall_thickness*2+magnet_tolerance+magnet_void-top_magnet_cover_thickness+body_magnet_height;
    flat_back_tolerance = extra_tolerance/4; // The flat side opposes a 45° angle which means it'll get too much wiggle room if we just use the normal tolerance value.
    adjusted_magnet_diameter = magnet_diameter + magnet_diameter_tolerance; // Negative tolerance by default so the magnet gets held tight (cram it in there!)
    sheath_width = diameter+wall_thickness*2;
    // TIP FOR RESIN PRINTERS: To avoid cracking set magnet_diameter_tolerance to 0 and squirt some resin in there before inserting the magnet.
    // NOTE: Because we add a bit extra to the end of the connector there's +1mm in a few places
    taper_length = 0.5; // Goes at the end of the stem to work around 3D printing "corner bulge" that can result in stems getting stuck down
    translate([0,stem_length/2,0]) {
        difference() {
            translate([
              0,
              stem_length/2,
              CHERRY_CROSS_LENGTH/3+extra_tolerance]) rotate([90,0,0]) difference() {
                union() {
                    translate([0,0,stem_length])
                        if (flat_cross) {
                            cherry_cross(cross_height, y_adjust=cross_y_extra, x_adjust=cross_x_extra);
                        } else {
                            rotate([0,0,45])
                                cherry_cross(cross_height, y_adjust=cross_y_extra, x_adjust=cross_x_extra);
                // Uncomment this when you want to see the center point of the stem:
//                            %rotate([0,0,45])
//                                cylinder(d=0.25, h=stem_length*2, center=true);
                        }
            // Add a cylinder that will represent the TOTAL_TRAVEL of the switch
                    difference() {
                        union() {
                            cylinder(
                                d=diameter,
                                h=stem_length-taper_length);
                            translate([0,0,stem_length-taper_length])
                                cylinder(
                                    d1=diameter,
                                    d2=diameter-taper_length,
                                    h=taper_length);
                            if (extra_tolerance) {
            // If we're doing a cutout we need the center of the stem to stick out the front a bit:
                                translate([0,0,stem_length/4])
                                    cylinder(
                                        d=diameter+extra_tolerance*1.333, // *1.33 because that's what seems to match the other tolerances (haha)
                                        h=stem_length+lip_height*2);
            // Angled top so that it can print without supports
                                translate([
                                  0,
                                  diameter/3+extra_tolerance,
                                  stem_length/2+lip_height*2])
                                    rotate([0,0,45])
                                        cube([
                                            diameter/2+extra_tolerance,
                                            diameter/2+extra_tolerance,
                                            stem_length*1.5], center=true);
                            }
                        }
            // This hole through the stem serves two purposes: 1) It prevents cattywompus infill from messing up light shining through and 2) Lets the light shine through directly (if only a little bit; much will pass through the stem like a light pipe anyway)
                        if (!extra_tolerance) { // No pointless cylinder when making a cutout
                            if (!flat_cross) {
                                cylinder(
                                    d=CHERRY_CROSS_LENGTH/2,
                                    h=total_travel*10,
                                    center=true);
                            }
            // This hole makes sure we can push the magnet out if we insert it the wrong way:
                            translate([
                                0,
                                0,
                                (magnet_height+magnet_tolerance)/2+magnet_wall_thickness]) {
            // NOTE: The magnet needs to be in the same spot no matter the diameter of the stem!
                                    cube([
                                        CHERRY_CROSS_LENGTH/3.2,
                                        diameter*4,
                                        magnet_height+magnet_tolerance], center=true);
                            }
            // Add a cutout along the bottom to reduce the amount of surface area that can rub against the flat part of the sheath (friction reduction)
                            translate([0,-diameter/3,total_travel/2+magnet_height/2])
                            // This one further reduces the surface area--further down the shaft
                                rotate([0,0,45]) cube([
                                    diameter/2.5,
                                    diameter/2.5,
                                    total_travel+magnet_height+magnet_tolerance], center=true);
            // Taper the end a smidge to reduce the likelihood of first-layer squish causing an issue
                            translate([0,-diameter*1.5,0]) rotate([45,0,0])
                                cube([diameter*2,diameter*2,diameter*2], center=true);
                            // This taper also makes inserting the stem easier
                        }
                    }
                }
            }
            // Flatten the bottom of the stem so it doesn't start printing in mid-air
            translate([0,0,-CHERRY_CYLINDER_DIAMETER/2+flat_back_tolerance])
            // NOTE: Using flat_back_tolerance because the amount of wiggle room on the 45° angle is too much on its own
                cube([500,500,CHERRY_CYLINDER_DIAMETER], center=true);
        }
        // Add the magnet holder at the end
        difference() {
            union() {
                if (!extra_tolerance) { // Normal magnet holder:
                    translate([
                        0, // NOTE that we take the magnet_void into account in the magnet holder here:
                        -(magnet_height+magnet_tolerance+magnet_wall_thickness*2)/2+stem_length/2-magnet_void/2,
                        CHERRY_CROSS_LENGTH/3+magnet_distance-magnet_diameter/4
                    ]) {
                        difference() {
                            squarish_rpoly(
                                xy=[
                                    diameter,
                                    magnet_height+magnet_tolerance+magnet_wall_thickness*2+magnet_void
                                ],
                                h=magnet_diameter*1.25+magnet_wall_thickness*2,
                                r=0.5, center=true);
                            // Match the cutout running along the main cylinder:
                            translate([0,0,-magnet_distance+magnet_diameter/2.75]) rotate([90,0,0])
                                cylinder(
                                    d=CHERRY_CROSS_LENGTH/2,
                                    h=total_travel*2,
                                    center=true);
                        }
                    }
                } else { // Negative/void space version of magnet holder (for cutouts):
                    // Generate a center mark so it's easy to line up when using the negative space cutout feature with things other than void_switch.scad
                    translate([0,-CHERRY_CROSS_LENGTH/2,CHERRY_CROSS_LENGTH/3+extra_tolerance])
                        rotate([90,0,0])
                            cylinder(d=0.1, h=stem_length*2.5, center=true);
                    difference() {
                        translate([0,0,CHERRY_CROSS_LENGTH])
                            difference() {
                                cube([
                                    diameter+extra_tolerance*1.33,
                                    stem_length,
                                    CHERRY_CYLINDER_DIAMETER/2+diameter], center=true);
                                translate([
                                  0,
                                  -stem_length/2+magnet_wall_thickness/2,
                                  magnet_diameter/2+magnet_wall_thickness-0.075])
                                    difference() {
                                        cube([
                                          sheath_width-magnet_wall_thickness*2,
                                          magnet_wall_thickness,
                                          magnet_wall_thickness*2.5], center=true);
                                        translate([
                                          0,
                                          magnet_wall_thickness*1.5,
                                          -magnet_wall_thickness*1.75])
//                                          rotate([45,0,0])
                                            cube([
                                              sheath_width-magnet_wall_thickness*2,
                                              magnet_wall_thickness*4,
                                              magnet_wall_thickness*4], center=true);
                                    }
                            }
// Add the side notches (that prevent binding at the corner opposite the bottom of the sheath):
                        translate([
                          diameter/(1.5/(1+notch_angle/38))+extra_tolerance*1.65,
                          0,
                          diameter-diameter/3.25+extra_tolerance/2])
    // This slightly-rotated bit is so the notch cutout gets slightly wider at the end (to reduce the chance of the stem getting stuck):
                            rotate([0,45,-notch_angle]) cube([
                                diameter/2,
                                stem_length+1,
                                diameter/2], center=true);
                        translate([
                          -diameter/(1.5/(1+notch_angle/38))-extra_tolerance*1.65,
                          0,
                          diameter-diameter/3.25+extra_tolerance/2])
    // This slightly-rotated bit is so the notch cutout gets slightly wider at the end (to reduce the chance of the stem getting stuck):
                            rotate([0,-45,notch_angle]) cube([
                                diameter/2,
                                stem_length+1,
                                diameter/2], center=true);
                    }
                }
            }
            if (!extra_tolerance) {
            // Cutout for the magnet (NOTE: No tolerance for the diameter so it gets squeezed in tight):
                translate([
                    0,
                    -(magnet_height+magnet_tolerance)/2-magnet_wall_thickness+stem_length/2,
                    CHERRY_CROSS_LENGTH/2.25+magnet_distance
                ]) {
                        rotate([90,0,0])
                            cylinder(d=adjusted_magnet_diameter, h=magnet_height+magnet_tolerance, center=true);
                    cube([adjusted_magnet_diameter-magnet_tolerance,magnet_height+magnet_tolerance,magnet_diameter], center=true);
                    // Cut a slot for the bits in the sheath that hold the magnet in place (not sure why I need the -0.075...)
                    translate([0,-magnet_height/2-(magnet_wall_thickness+magnet_void)/2-magnet_tolerance/2,magnet_diameter/2.65])
                        difference() {
                            cube([
                              magnet_diameter+magnet_wall_thickness*2.85,
                              magnet_wall_thickness+magnet_void+0.01,
                              magnet_diameter], center=true);
    // This cube gives the magnet a little bar that prevents it from falling out (forwards)
                            translate([0,magnet_wall_thickness+magnet_tolerance,(magnet_wall_thickness*4.75)/2-magnet_wall_thickness]) 
                              cube([
                                magnet_diameter+magnet_wall_thickness*2.85,
                                magnet_wall_thickness*10,
                                magnet_wall_thickness*4.75], center=true);
                        }
                // No reason for the top end of the stem to stick out very far, this cuts it off a bit:
                translate([0,(-magnet_height-magnet_void)/2-magnet_height/2-magnet_wall_thickness-0.1,magnet_height]) cube([
                  magnet_diameter+magnet_wall_thickness*2.85,
                  magnet_height+magnet_void,
                  magnet_diameter], center=true);
                }
                // This is so you can push the magnet out if you have the wrong pole facing down:
                translate([
                  0,
                  (magnet_height+magnet_tolerance)/2+stem_length/2-magnet_wall_thickness-magnet_height-magnet_tolerance,
                  0])
                    cube([
                        CHERRY_CROSS_LENGTH/3.2,
                        magnet_height+magnet_tolerance,
                        diameter*4], center=true);
                // Side channel (slides into the sheath's notches/cutouts)
                translate([diameter/1.475,0,diameter-diameter/3.25])
                    rotate([0,45,0]) cube([
                        diameter/2,
                        stem_length+1,
                        diameter/2], center=true);
                translate([-diameter/1.475,0,diameter-diameter/3.25])
                    rotate([0,-45,0]) cube([
                        diameter/2,
                        stem_length+1,
                        diameter/2], center=true);
                // Remove a bit of material before and after the part that actually touches the sides of the sheath so as to minimize surface contact area:
                touching_part_width = 0.5;
                touching_part_depth = 0.15;
                translate([
                  -diameter/1.475+touching_part_depth,
                  stem_length/2-(magnet_height+magnet_wall_thickness*2+magnet_void+magnet_tolerance)/2-magnet_wall_thickness-touching_part_width,
                  diameter-diameter/3.25])
                    rotate([0,-45,0]) cube([
                        diameter/2,
                        (magnet_height+magnet_wall_thickness*2+magnet_void+magnet_tolerance),
                        diameter/2], center=true);
                translate([
                  diameter/1.475-touching_part_depth,
                  stem_length/2-(magnet_height+magnet_wall_thickness*2+magnet_void+magnet_tolerance)/2-magnet_wall_thickness-touching_part_width,
                  diameter-diameter/3.25])
                    rotate([0,-45,0]) cube([
                        diameter/2,
                        (magnet_height+magnet_wall_thickness*2+magnet_void+magnet_tolerance),
                        diameter/2], center=true);
                // Visualize the magnet
                %translate([
                  0,
                  -(magnet_height+magnet_tolerance)/2-magnet_wall_thickness+stem_length/2,
                  CHERRY_CROSS_LENGTH/2.25+magnet_distance
                  ])
                    rotate([90,0,0])
                        cylinder(d=magnet_diameter, h=magnet_height, center=true);
            }
        }
    }
    // Visualize the magnet
//    %translate([
//      0,
//      10,
////      -(magnet_height+magnet_tolerance)/2-magnet_wall_thickness+stem_length/2,
////                  magnet_diameter/2+diameter/4+magnet_distance
////      magnet_diameter/2.8
//      CHERRY_CROSS_LENGTH/3,
//      ])
//        rotate([90,0,0])
//            translate([
//                0,
//                0,
//                0])
//                cylinder(d=magnet_diameter, h=magnet_height, center=true);
}

module stem_cherry_cross_double_magnet(travel, diameter, sheath_length, wall_thickness, cover_thickness, magnet_height=2, magnet_diameter=4, magnet_tolerance=0, magnet_diameter_tolerance=-0.1, magnet_wall_thickness=0.5, lip_height=1, magnet_void=0.2, body_magnet_height=2, extra_tolerance=0, cross_length=CHERRY_CROSS_LENGTH, top_magnet_cover_thickness=-0.5, notch_angle=1, flat_cross=false) {
    // Just use the regular stem_cherry_cross() and mirror it to make the other side hold another magnet
    stem_cherry_cross(travel, diameter, sheath_length, wall_thickness, cover_thickness, magnet_height=magnet_height, magnet_diameter=magnet_diameter, magnet_tolerance=magnet_tolerance, magnet_diameter_tolerance=magnet_diameter_tolerance, magnet_wall_thickness=magnet_wall_thickness, lip_height=lip_height, magnet_void=magnet_void, body_magnet_height=body_magnet_height, extra_tolerance=extra_tolerance, cross_length=cross_length, top_magnet_cover_thickness=top_magnet_cover_thickness, notch_angle=notch_angle, flat_cross=flat_cross);
    translate([0,0,diameter/2]) mirror([0,0,1])
        stem_cherry_cross(travel, diameter, sheath_length, wall_thickness, cover_thickness, magnet_height=magnet_height, magnet_diameter=magnet_diameter, magnet_tolerance=magnet_tolerance, magnet_diameter_tolerance=magnet_diameter_tolerance, magnet_wall_thickness=magnet_wall_thickness, lip_height=lip_height, magnet_void=magnet_void, body_magnet_height=body_magnet_height, extra_tolerance=extra_tolerance, cross_length=cross_length, top_magnet_cover_thickness=top_magnet_cover_thickness, notch_angle=notch_angle, flat_cross=flat_cross);
}

// Experimental stuff; ignore
module stem_cherry_cross_split(travel, diameter, sheath_length, wall_thickness, cover_thickness, magnet_height=1.5, magnet_diameter=3, magnet_tolerance=0, magnet_wall_thickness=0.5, lip_height=1, magnet_void=0.2, extra_tolerance=0) {
    total_travel = travel+sheath_length+cover_thickness+lip_height;
    magnet_distance = 2.9; // Magnet's (edge) distance from the center of the switch (MUST BE UNCHANGING!)
    // NOTE: Assuming you have something like an sk6812mini (3.7mm wide) in the center, a 3mm (diameter) magnet will need to be at least 1.85mm (3.7/2) away from the center for there to be room for a hall effect sensor (though you probably want at least a mm or two more than that).
    stem_length = total_travel+magnet_height+magnet_wall_thickness*2+magnet_tolerance + 0.5;
    // NOTE: THE +0.35 ABOVE IS TEMPORARY UNTIL WE START FACTORING THE TOP MAGNET IN!
    // NOTE: Because we add a bit extra to the end of the connector there's +1mm in a few places
    translate([0,stem_length/2,0]) {
        difference() {
            translate([0,stem_length/2,CHERRY_CROSS_LENGTH/3]) rotate([90,0,0]) difference() {
                union() {
                    translate([0,0,stem_length])
                        rotate([0,0,45])
                            cherry_cross();
            // Add a cylinder that will represent the TOTAL_TRAVEL of the switch
                    difference() {
                        union() {
                            cylinder(
                                d=diameter,
                                h=stem_length);
            // Give the top a 45° angle so we don't have any bridging when printing
                            translate([0,diameter/2.85,stem_length/2])
                                rotate([0,0,45])
                                    cube([
                                        diameter/2+extra_tolerance*2,
                                        diameter/2+extra_tolerance*2,
                                        stem_length], center=true);
                            if (extra_tolerance) {
            // If we're doing a cutout we need the center of the stem to stick out the front a bit:
                                translate([0,0,lip_height*2])
                                    cylinder(
                                        d=diameter+extra_tolerance*2, // *2 because diameter (not radius)
                                        h=stem_length+lip_height*2);
                                translate([0,diameter/3+extra_tolerance,stem_length/2+lip_height*2])
                                    rotate([0,0,45])
                                        cube([
                                            diameter/2+extra_tolerance,
                                            diameter/2+extra_tolerance,
                                            stem_length*1.5], center=true);
                            }
                        }
            // This hole through the stem serves two purposes: 1) It prevents cattywompus infill from messing up light shining through and 2) Lets the light shine through directly (if only a little bit; much will pass through the stem like a light pipe anyway)
                        if (!extra_tolerance) { // No pointless cylinder when making a cutout
                            cylinder(
                                d=CHERRY_CROSS_LENGTH/2,
                                h=total_travel*4,
                                center=true);
            // Add a little cutout for the magnet in the stem (in case the diameter is really big):
                            translate([
                                0,
                                0,
                                (magnet_height+magnet_tolerance+magnet_wall_thickness/2)/2+magnet_wall_thickness*1.75]) {
            // NOTE: The magnet needs to be in the same spot no matter the diameter of the stem!
            // This makes sure we can push the magnet out if we insert it the wrong way:
                                    cube([
                                        CHERRY_CROSS_LENGTH/3.2,
                                        diameter*4,
                                        magnet_height+magnet_tolerance+magnet_wall_thickness*2.2], center=true);
                            }
            // Make a hole in the end that will act as a clip to hold the magnet holder in place
                            translate([
                                0,
                                0,
                                (magnet_height+magnet_tolerance+magnet_wall_thickness/2)/2]) {
            // This makes sure we can push the magnet out if we insert it the wrong way:
                                    cube([
                                        CHERRY_CROSS_LENGTH/3.2-magnet_wall_thickness,
                                        diameter*4,
                                        magnet_height+magnet_tolerance+magnet_wall_thickness*2.2], center=true);
                            }
            // Add a cutout along the bottom to reduce the amount of surface area that can rub against the flat part of the sheath (friction reduction)
                            translate([0,-diameter/5,0])
                            // This one can't be wider than the Cherry cross stem part
                                cube([
                                    CHERRY_CROSS_LENGTH/3.2,
                                    diameter/2.5,
                                    total_travel*4], center=true);
                            translate([0,-diameter/3,total_travel/2+magnet_height/2])
                            // This one further reduces the surface area--further down the shaft
                                rotate([0,0,45]) cube([
                                    diameter/2.5,
                                    diameter/2.5,
                                    total_travel+magnet_height+magnet_tolerance], center=true);
            // Taper the end a smidge to reduce the likelihood of first-layer squish causing an issue
                            translate([0,-diameter*1.5,0]) rotate([45,0,0])
                                cube([diameter*2,diameter*2,diameter*2], center=true);
                            // This taper also makes inserting the stem easier
                        }
                    }
                }
            }
            // Flatten the bottom of the stem so it doesn't start printing in mid-air
            translate([0,0,-CHERRY_CYLINDER_DIAMETER/2-extra_tolerance])
                cube([500,500,CHERRY_CYLINDER_DIAMETER], center=true);
        }
    }
    // Generate the magnet holder that attaches to the stem
    translate([0,total_travel*2,(magnet_height+magnet_tolerance+magnet_wall_thickness*2)/2]) {
        rotate([90,0,0]) difference() {
            squarish_rpoly(
                xy=[diameter, magnet_height+magnet_tolerance+magnet_wall_thickness*2],
                h=magnet_diameter+magnet_wall_thickness+magnet_distance/2,
                r=0.5, center=true);
            translate([0,0,magnet_diameter*1.5-magnet_tolerance]) rotate([0,45,0]) cube([
                magnet_diameter*2,
                magnet_diameter*2,
                magnet_diameter*2], center=true);
            translate([0,-magnet_wall_thickness+magnet_void,-magnet_diameter/2]) cube([
                magnet_diameter,
                magnet_height+magnet_tolerance,
                magnet_diameter], center=true);
        // Side channel (slides into the sheath's notches/cutouts)
            translate([diameter/2,0,diameter/2.6])
                rotate([0,45,0]) cube([
                    diameter/4,
                    stem_length+1,
                    diameter/4], center=true);
            translate([-diameter/2,0,diameter/2.6])
                rotate([0,45,0]) cube([
                    diameter/4,
                    stem_length+1,
                    diameter/4], center=true);
        }
        translate([0,-diameter/4,0])
            cube([
                CHERRY_CROSS_LENGTH/3-0.2,
                diameter/1.7,
                magnet_height+magnet_tolerance+magnet_wall_thickness*2], center=true);
        translate([0,-diameter/1.4,0])
            cylinder(
                d=CHERRY_CROSS_LENGTH/2-0.2,
                h=magnet_height+magnet_tolerance+magnet_wall_thickness*2, center=true);
        
    }
}

// This makes the + bit that slides *in* to a Cherry MX style keycap:
module cherry_cross(height=CHERRY_CROSS_HEIGHT, y_adjust=0, x_adjust=0) {
    linear_extrude(height=height) {
        square([CHERRY_CROSS_THICKNESS_X+x_adjust, CHERRY_CROSS_LENGTH], center=true);
        square([CHERRY_CROSS_LENGTH, CHERRY_CROSS_THICKNESS_Y+y_adjust], center=true);
    }
}
