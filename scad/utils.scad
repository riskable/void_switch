// Keycap utility modules and functions

// NOTE: If your rpoly or squarish_rpoly ends up flat you probably just need to reduce the corner radius.

// MODULES

// Riskable's polygon: Kind of like a combo roundedCube()+cylinder() except you can also offset one of the diameters
module rpoly(d=0, h=0, d1=0, d2=0, r=1, edges=4, d2_offset=[0,0], center=true, $fn=64) {
    // Because we use a cylinder diameter instead of a cube for the length/width we need to correct for the fact that it will be undersized (fudge factor):
    fudge = 1/cos(180/edges);
    module rpoly_proper(d1, d2, h, r, edges, d2_offset) {
        fudged_d1 = d1 * fudge - r*2.82845; // Corner radius magic fix everything number! 2.82845
        fudged_d2 = d2 * fudge - r*2.82845; // Ditto!
        if (edges > 3) {
            hull() {
                linear_extrude(height=0.0001)
                    offset(r=r) rotate([0,0,45]) circle(d=fudged_d1, $fn=edges);
                translate([d2_offset[0],d2_offset[1],h])
                    linear_extrude(height=0.0001)
                        offset(r=r) rotate([0,0,45]) circle(d=fudged_d2, $fn=edges);
            }
        } else { // Triangles need a little special attention
            hull() {
                linear_extrude(height=0.0001)
                    offset(r=r) rotate([0,0,30]) circle(d=d1, $fn=edges);
                translate([d2_offset[0],d2_offset[1],h])
                    linear_extrude(height=0.0001)
                        offset(r=r) rotate([0,0,30]) circle(d=d2, $fn=edges);
            }
        }
    }
    if (d1) {
        if (center) {
            translate([0,0,-h/2])
                rpoly_proper(d1, d2, h, r, edges, d2_offset);
        } else {
            rpoly_proper(d1, d2, h, r, edges, d2_offset);
        }
    } else {
        fudged_diameter = d * fudge - r*2.82845; // Corner radius magic fix everything number! 2.82845
        if (center) {
            translate([0,0,-h/2])
                rpoly_proper(d, d, h, r, edges, d2_offset);
        } else {
            rpoly_proper(d, d, h, r, edges, d2_offset);
        }
    }
}

module squarish_rpoly(xy=[0,0], h=0, xy1=[0,0], xy2=[0,0], r=1, xy2_offset=[0,0], center=false, $fn=64) {
    module square_rpoly_proper(xy1, xy2, h, r, xy2_offset) {
        // Need to correct for the corner radius since we're using offset() and square()
        corrected_x1 = xy1[0] > r ? xy1[0] - r*2 : r/10;
        corrected_y1 = xy1[1] > r ? xy1[1] - r*2 : r/10;
        corrected_x2 = xy2[0] > r ? xy2[0] - r*2 : r/10;
        corrected_y2 = xy2[1] > r ? xy2[1] - r*2 : r/10;
        if (corrected_x1 <= 0 || corrected_x2 <= 0 || corrected_y1 <= 0 || corrected_y2 <= 0) {
            warning("Corner Radius (x2) is larger than this rpoly! Won't render properly.");
        }
        corrected_xy1 = [corrected_x1, corrected_y1];
        corrected_xy2 = [corrected_x2, corrected_y2];
        hull() {
            linear_extrude(height=0.0001)
                offset(r=r) square(corrected_xy1, center=true);
            translate([xy2_offset[0],xy2_offset[1],h])
                linear_extrude(height=0.0001)
                    offset(r=r) square(corrected_xy2, center=true);
        }
    }
    if (xy1[0]) {
        if (center) {
            translate([0,0,-h/2])
                square_rpoly_proper(xy1, xy2, h, r, xy2_offset);
        } else {
            square_rpoly_proper(xy1, xy2, h, r, xy2_offset);
        }
    } else {
        if (center) {
            translate([0,0,-h/2])
                square_rpoly_proper(xy, xy, h, r, xy2_offset);
        } else {
            square_rpoly_proper(xy, xy, h, r, xy2_offset);
        }
    }
}

module note(text) echo(str("NOTE: ", text));
module warning(text) echo(str("WARNING: ", text));

// This does its best to try to figure out how strong your switch will be from the magnet diameter and its thickness (height) then outputs the result to the console
// NOTE: For a list of supported magnet sizes for this calculation see the N* constants down below.  Also, you can get more accurate values using the calculator at https://www.kjmagnetics.com/calculator.asp (FYI: Your theoretical "distance" value will be MAGNET_WALL_THICKNESS + MAGNET_VOID + MAGNET_TOLERANCE/2)
module display_magnet_strength(diameter, height, distance, strength="N35", magnet_wall_thickness=0.5) {
    start_str = "ESTIMATED STRENGTH/FORCE: ~";
    if (strength == "N35") {
        if (diameter == 4) {
            if (height == 2) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N35_4x2), "g"));
            } else if (height == 1.8) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N35_4x1_8), "g"));
            } else if (height == 1.7) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N35_4x1_7), "g"));
            } else if (height == 1.5) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N35_4x1_5), "g"));
            } else if (height == 1) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N35_4x1), "g"));
            }
        } else if (diameter == 3) {
            if (height == 2) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N35_3x2), "g"));
            } else if (height == 1.5) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N35_3x1_5), "g"));
            }
        }
    } else if (strength == "N42") {
        if (diameter == 4) {
            if (height == 2) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N42_4x2), "g"));
            } else if (height == 1.5) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N42_4x1_5), "g"));
            } else if (height == 1) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N42_4x1), "g"));
            }
        }
    } else if (strength == "N45") {
        if (diameter == 4) {
            if (height == 2) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N45_4x2), "g"));
            } else if (height == 1.5) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N45_4x1_5), "g"));
            } else if (height == 1) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N45_4x1), "g"));
            }
        }
    } else if (strength == "N50") {
        if (diameter == 4) {
            if (height == 2) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N50_4x2), "g"));
            } else if (height == 1.5) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N50_4x1_5), "g"));
            } else if (height == 1) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N50_4x1), "g"));
            }
        }
    } else if (strength == "N52") {
        if (diameter == 4) {
            if (height == 2) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N52_4x2), "g"));
            } else if (height == 1.5) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N52_4x1_5), "g"));
            } else if (height == 1) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N52_4x1), "g"));
            }
        } else if (diameter == 3) {
            if (height == 2) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N52_3x2), "g"));
            } else if (height == 1.5) {
                note(str(start_str, magnet_strength(distance, magnet_wall_thickness=magnet_wall_thickness, zero_strength=N52_3x1_5), "g"));
            }
        }
    } else {
        note("UNKNOWN SWITCH STRENGTH.  See display_magnet_strength() in utils.scad to see what's supported and there's also a note about how to figure it out using an online calculator.");
    }
};

// FUNCTIONS
function is_odd(x) = (x % 2) == 1;
// This function is used to generate curves given a total number of steps, step we're currently calculating, and the amplitude of the curve:
function polygon_slice(step, amplitude, total_steps=10) = (1 - step/total_steps) * amplitude;
function polygon_slice_reverse(step, amplitude, total_steps=10) = (1 - (total_steps-step)/total_steps) * amplitude;
// These constants are for use with the magnet_strength() function
// Values for the most common magnet sizes
// N35 (aka "cheapo"; they come in much more variety than the stronger variants)
N35_4x2 = 290.29888; // grams of force at 0.0
N35_4x1_8 = 258.54744; // 4x1.8mm
N35_4x1_7 = 244.93968; // 4x1.7mm
N35_4x1_5 = 213.18824; // 4x1.5mm
N35_4x1 = 136.0776; // 4x1mm
N35_3x2 = 181.4368; // 3x2mm
N35_3x1_5 = 145.14944; // 3x1.5mm
// N42
N42_4x2 = 344.72992;
N42_4x1_5 = 258.54744;
N42_4x1 = 163.29312;
// N45
N45_4x1 = 176.90088;
N45_4x1_5 = 276.69112;
N45_4x2 = 371.94544;
// N50
N50_4x1 = 195.04456;
N50_4x1_5 = 308.44256;
N50_4x2 = 412.76872;
// N52
N52_4x2 = 426.37648; // grams of force at 0.0
N52_4x1_5 = 322.05; // 4x1.5mm
N52_4x1 = 204.1164; // 4x1mm
N52_3x1_5 = 217.72416;
N52_3x2 = 272.1552;
function magnet_strength(distance, magnet_wall_thickness=0.5, zero_strength=N35_4x2) = round((1/pow(1+distance+magnet_wall_thickness, 2)) * zero_strength);

// EXAMPLES:

// Make a pyramid:
//squarish_rpoly(xy1=[40,40], xy2=[0.1,0.1], h=10, r=0.2, center=true);

// Dodecahedron (12-sided die)
//diameter = 12;
//rpoly(d1=diameter, d2=0.1, h=diameter/2, r=0.01, edges=6, d2_offset=[0,0], center=false, $fn=64);
//translate([0,0,-diameter/2])
//    rpoly(d1=0.1, d2=12, h=diameter/2, r=0.01, edges=6, d2_offset=[0,0], center=false, $fn=64);