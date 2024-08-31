// Sheath-related modules

use <utils.scad>
use <stem.scad>

// Future support for other stem types:
//module sheath(stem_type="cherry_cross", extra_tolerance=0) {
//    if (stem_type == "cherry_cross") {
//        sheath_cherry_cross(extra_tolerance=extra_tolerance);
//    } else if (stem_type == "cherry_cylinder") {
//        sheath_cherry_cylinder(extra_tolerance=extra_tolerance);
//    }
//}

// Constants
CHERRY_CYLINDER_DIAMETER = 5.47; // Represents the keycap's stem (female side of the +)
CHERRY_STEM_HEIGHT = 4.5; // How far the underside of the keycap extends into the stem()
CHERRY_CROSS_LENGTH = 4; // Length of the - and the | in the +

// This fits into the switch body--what the stem slides in and out of
module sheath_cherry_cross(length, stem_diameter, travel, cover_thickness,
    stem_tolerance=0.2, sheath_tolerance=0.2, wall_thickness=1.4, lip_height=1, lip_overhang=1, top_magnet_height=2, top_magnet_diameter=4, top_magnet_cover_thickness=-0.5, magnet_height=2, magnet_diameter=4, magnet_wall_thickness=0.5, magnet_tolerance=0, magnet_diameter_tolerance=0, end_stop_thickness=0.8, magnet_void=0, snap_pip_height=0.4, snap_pip_length=1.5, snap_pip_width=1.5, notch_angle=1, bottom_clip_width=1.5, snug_magnet=true, inside_body=false, mark_tolerance=true) {
    sheath_width = stem_diameter+wall_thickness*2; // Side-to-side wall_thickness doesn't need to be as strong
    sheath_height = stem_diameter+wall_thickness*2; // Need wall_thickness to be full height above/below
    total_travel = travel+top_magnet_height;
    stopper_height = CHERRY_CYLINDER_DIAMETER/2.25; // Height of the wall at the end (should be high enough to stop the stem when inserting a keycap but short enough that you can still slide it in (to the point where it clicks/snaps into place)
    sheath_overall_length = (
        cover_thickness+length+total_travel-top_magnet_cover_thickness
        +magnet_height+magnet_wall_thickness*2+magnet_tolerance
        +magnet_void); // NOTE: Doesn't include the lip_height on purpose
    // Uncomment these to debug the length/height if you've made changes and things aren't lining up or aren't the right length;
//    echo(sheath_width=sheath_width);
//    echo(sheath_overall_length=sheath_overall_length);
//    echo(sheath_height=sheath_height);
    difference() {
        translate([0,0,sheath_height/2]) {
            union() {
                translate([0,lip_height,0])
                    cube([ // Main body of the sheath
                        sheath_width,
                        sheath_overall_length,
                        sheath_height], center=true);
            // NOTE: The +0.01 below just ensures that slicers see the lip+sheath as a single object instead of two:
                translate([0,-sheath_overall_length/2+lip_height/2+0.01,0])
                    difference() {
                        squarish_rpoly( // The lip that sticks out the top
                            xy=[sheath_width+lip_overhang*2, lip_height],
                            h=sheath_height+lip_overhang*2, r=lip_height/3, center=true);
                        // Cut off the corners so they can't catch keycaps inside edges
                        translate([sheath_height,0,sheath_height/1.35])
                            rotate([0,45,0])
                                cube([
                                    sheath_height,
                                    lip_height*2,
                                    sheath_height], center=true);
                        translate([-sheath_height,0,sheath_height/1.35])
                            rotate([0,-45,0])
                                cube([
                                    sheath_height,
                                    lip_height*2,
                                    sheath_height], center=true);
                    }
                translate([ // Generate the ring around the magnet (that holds it in place)
                  0,
                  -sheath_overall_length/2+top_magnet_height/2+magnet_wall_thickness*1.5+length/2+0.001,
                    -sheath_height/2+(top_magnet_diameter+magnet_wall_thickness*3)/2+stem_diameter
                ])
                    rotate([90,0,0])
                        difference() {
                            cylinder(d=top_magnet_diameter+magnet_wall_thickness*3, h=top_magnet_height+magnet_wall_thickness*3+length, center=true);
                        }
            }
        }
        // Ensure the bottom is flat (really just for the lip):
        translate([0,0,-250])
            cube([500, 500, 500], center=true);
        // Use the stem's void space/negative cutout feature (extra_tolerance) to carve out a space for itself:
        stem_cutout_floor = CHERRY_CYLINDER_DIAMETER/2-wall_thickness/1.05+stem_tolerance/3;
        translate([
            0,
            -(sheath_overall_length)/2+top_magnet_height+lip_height-top_magnet_cover_thickness+length,
        // NOTE: We use CHERRY_CYLINDER_DIAMTER/2 because that's what stem.scad uses to flatten the underside of the stem (the two have to match)
            stem_cutout_floor
        ]) {
                stem_cherry_cross(total_travel,
                    stem_diameter, length, wall_thickness, cover_thickness,
                    magnet_height=magnet_height, magnet_diameter=magnet_diameter,
                    magnet_tolerance=magnet_tolerance,
                    magnet_wall_thickness=magnet_wall_thickness,
                    lip_height=lip_height, extra_tolerance=stem_tolerance,
                    notch_angle=notch_angle);
           }
        // Cut a little extra up top in the event that the stem's void space feature doesn't cover everything
        if (!inside_body) {
            // Add the cutout on the bottom for snap fit in the body
            translate([
                0, // The little hole
                -sheath_overall_length/2+(cover_thickness+sheath_tolerance)/2+lip_height,
                cover_thickness/2-0.01])
                    cube([bottom_clip_width, cover_thickness+sheath_tolerance, cover_thickness*2], center=true);
            translate([
                0, // The longer one
                cover_thickness*2+sheath_tolerance,
                wall_thickness/2-0.01])
                    cube([bottom_clip_width,sheath_overall_length-sheath_tolerance-lip_height*2, wall_thickness*2], center=true);
        }
        // The sheath doesn't actually need to be higher than the > < (notches) part so we remove the excess material to make it less likely that a squished magnet (pushing the sides of its holder outwards) will result in stiction
        translate([
          0,
          lip_height+length+top_magnet_height,
          sheath_height/2+stem_cutout_floor+stem_diameter-stem_diameter/8])
      // NOTE: Stem uses `stem_diameter-stem_diameter/3.25+extra_tolerance/2` to determine the height of the notches and the notches themselves are stem_diameter/2
            difference() {
                cube([sheath_width*2,sheath_overall_length,sheath_height], center=true);
                translate([0,0,-sheath_height/1.5])
                    cube([stem_diameter+sheath_tolerance-0.01,sheath_overall_length*2,sheath_height], center=true);
            }
        // Add a cylindrical cutout along the center to ensure the layer lines get extruded paralell to the motion of the stem (no infill)
        translate([0,0,stem_diameter/2+wall_thickness/2])
            scale([0.9,1,0.85]) rotate([90,0,0])
                cylinder(d=stem_diameter, h=sheath_overall_length*2, center=true);
        // Carve out a space for the magnet
        translate([
          0,
          -sheath_overall_length/2+(top_magnet_height+magnet_tolerance)/2-top_magnet_cover_thickness+lip_height+length-magnet_tolerance+0.01,
          top_magnet_diameter/2+stem_diameter+magnet_wall_thickness*1.5
          ]) {
            rotate([90,0,0])
                cylinder(d=top_magnet_diameter+magnet_diameter_tolerance, h=top_magnet_height+magnet_tolerance, center=true);
        // Visualize the magnet
            %translate([0,-magnet_tolerance,0]) rotate([90,0,0])
                cylinder(d=top_magnet_diameter, h=top_magnet_height, center=true);
        }
        // Cut a hole in the top of the magnet area so the magnet can be inserted sideways (as opposed to awkwardly-press-fit from below like the old way)
        translate([
          0,
          -sheath_overall_length/2+(top_magnet_height+magnet_tolerance)/2-top_magnet_cover_thickness+lip_height+length-magnet_tolerance+0.01,
          top_magnet_diameter+stem_diameter+magnet_wall_thickness*1.5
          ]) {
            cube([top_magnet_diameter-magnet_tolerance,top_magnet_height+magnet_tolerance,top_magnet_diameter+magnet_diameter_tolerance], center=true);
        }
        // Flatten the circular part of the sheath so that we can squeeze the magnet in there with a tool and have it sit flush with the edge (no need to squeeze it *past* the edge in order to get a full fit)
        translate([
          0,
          -sheath_overall_length/2+(top_magnet_height+magnet_tolerance)/2-top_magnet_cover_thickness+lip_height+length-magnet_tolerance+0.01,
          top_magnet_diameter/2+stem_diameter+magnet_wall_thickness*1.5+top_magnet_diameter
          ]) {
            cube([top_magnet_diameter*2,top_magnet_height*4+magnet_tolerance,top_magnet_diameter+magnet_diameter_tolerance], center=true);
        }
        if (!snug_magnet) {
        // This removes the material that goes around the magnet in the sheath in case you want to try that other way of holding the magnet in (see similar comment in body.scad).
            translate([0,
              -sheath_overall_length/2+top_magnet_height/2+lip_height,
            top_magnet_diameter*2.4
            ])
                rotate([0,0,0])
                    cube([
                        top_magnet_diameter*1.375,
                        top_magnet_height+0.05,
                        top_magnet_diameter], center=true);
        }
        if (mark_tolerance) {
            // Mark the stem tolerance on the side
            tolerance_text = len(str(stem_tolerance)) > 1 ? str(stem_tolerance) : str(stem_tolerance, ".0");
            translate([sheath_width/2-0.2,-2.25,stem_diameter/2.75])
                rotate([90,0,90]) linear_extrude(1)
                    text(tolerance_text, size=2.5, font="Ubuntu:style=Bold");
        }
    }
    if (!inside_body) {
        pip_rotation = 20;
        translate([ // Right side pip (bottom)
            sheath_width/2,
            -sheath_overall_length/2+lip_height+sheath_tolerance+snap_pip_length/2+cover_thickness,
            snap_pip_width/2])
                rotate([0,0,pip_rotation])
                    cube([snap_pip_height, snap_pip_length, snap_pip_width], center=true);
        translate([ // Right side pip (top)
            sheath_width/2,
            -sheath_overall_length/2+lip_height+sheath_tolerance+snap_pip_length/2+cover_thickness,
            sheath_height-snap_pip_width/2])
                rotate([0,0,pip_rotation])
                    cube([snap_pip_height, snap_pip_length, snap_pip_width], center=true);
        translate([ // Left side pip (bottom)
            -sheath_width/2,
            -sheath_overall_length/2+lip_height+sheath_tolerance+snap_pip_length/2+cover_thickness,
            snap_pip_width/2])
                rotate([0,0,-pip_rotation])
                    cube([snap_pip_height, snap_pip_length, snap_pip_width], center=true);
        translate([ // Left side pip (top)
            -sheath_width/2,
            -sheath_overall_length/2+lip_height+sheath_tolerance+snap_pip_length/2+cover_thickness,
            sheath_height-snap_pip_width/2])
                rotate([0,0,-pip_rotation])
                    cube([snap_pip_height, snap_pip_length, snap_pip_width], center=true);
    }
    // Add a little stopper at the end that's low enough to get the stem through but also high enough to prevent it from falling out the bottom when the switch is upright (with no PCB underneath)
    if (stopper_height) {
        translate([0,end_stop_thickness/2+sheath_overall_length/2+lip_height,stopper_height/2])
            cube([
                sheath_width,
                end_stop_thickness,
                stopper_height], center=true);
    }
}

module sheath_cherry_cross_double_sided(length, stem_diameter, travel, cover_thickness,
    stem_tolerance=0.2, sheath_tolerance=0.2, wall_thickness=1.4, lip_height=1, lip_overhang=1, top_magnet_height=2, top_magnet_diameter=4, top_magnet_cover_thickness=-0.5, magnet_height=2, magnet_diameter=4, magnet_wall_thickness=0.5, magnet_tolerance=0, magnet_diameter_tolerance=0, end_stop_thickness=0.8, magnet_void=0, snap_pip_height=0.4, snap_pip_length=1.5, snap_pip_width=1.5, notch_angle=1, bottom_clip_width=1.5, snug_magnet=true, inside_body=false, mark_tolerance=true) {
    sheath_width = stem_diameter+wall_thickness*2; // Side-to-side wall_thickness doesn't need to be as strong
    sheath_height = stem_diameter+wall_thickness*2; // Need wall_thickness to be full height above/below
    total_travel = travel+top_magnet_height;
    sheath_overall_length = (
        cover_thickness+length+total_travel-top_magnet_cover_thickness
        +magnet_height+magnet_wall_thickness*2+magnet_tolerance
        +magnet_void); // NOTE: Doesn't include the lip_height on purpose
    // Use the normal sheath_cherry_cross() module, mirror it, then cut out the unnecessary middle section
    difference() {
        union() {
            difference() {
                sheath_cherry_cross(length, stem_diameter, travel, cover_thickness, stem_tolerance=stem_tolerance, sheath_tolerance=sheath_tolerance, wall_thickness=wall_thickness, lip_height=lip_height, lip_overhang=lip_overhang, top_magnet_height=top_magnet_height, top_magnet_diameter=top_magnet_diameter, top_magnet_cover_thickness=top_magnet_cover_thickness, magnet_height=magnet_height, magnet_diameter=magnet_diameter, magnet_wall_thickness=magnet_wall_thickness, magnet_tolerance=magnet_tolerance, magnet_diameter_tolerance=magnet_diameter_tolerance, end_stop_thickness=end_stop_thickness, magnet_void=magnet_void, snap_pip_height=snap_pip_height, snap_pip_length=snap_pip_length, snap_pip_width=snap_pip_width, notch_angle=notch_angle, bottom_clip_width=bottom_clip_width, snug_magnet=snug_magnet, inside_body=inside_body, mark_tolerance=false);
                translate([0,lip_height,0])
                    cube([total_travel+length,sheath_overall_length,sheath_width], center=true);
            }
            translate([0,0,sheath_height]) mirror([0,0,1])
                difference() {
                    sheath_cherry_cross(length, stem_diameter, travel, cover_thickness,
            stem_tolerance=stem_tolerance, sheath_tolerance=sheath_tolerance, wall_thickness=wall_thickness, lip_height=lip_height, lip_overhang=lip_overhang, top_magnet_height=top_magnet_height, top_magnet_diameter=top_magnet_diameter, top_magnet_cover_thickness=top_magnet_cover_thickness, magnet_height=magnet_height, magnet_diameter=magnet_diameter, magnet_wall_thickness=magnet_wall_thickness, magnet_tolerance=magnet_tolerance, magnet_diameter_tolerance=magnet_diameter_tolerance, end_stop_thickness=end_stop_thickness, magnet_void=magnet_void, snap_pip_height=snap_pip_height, snap_pip_length=snap_pip_length, snap_pip_width=snap_pip_width, notch_angle=notch_angle, bottom_clip_width=bottom_clip_width, snug_magnet=snug_magnet, inside_body=inside_body, mark_tolerance=false);
                    translate([0,lip_height,0])
                        cube([total_travel+length,sheath_overall_length,sheath_width], center=true);
                }
        }
        // Mark the stem tolerance on the side
        tolerance_text = len(str(stem_tolerance)) > 1 ? str(stem_tolerance) : str(stem_tolerance, ".0");
        translate([sheath_width/2-0.2,-2.25,stem_diameter/2])
            rotate([90,0,90]) linear_extrude(1)
                text(tolerance_text, size=2.5, font="Ubuntu:style=Bold");
    }
}


