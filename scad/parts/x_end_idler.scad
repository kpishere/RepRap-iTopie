include <../config.scad>
include <../shapes.scad>
include <Round-Anything/polyround.scad>

// wall geometry
platePoints = [
    [0,0,0],
    [xbar_offset,0,0],
    [xbar_offset,end_idler_width,0],
    [0,end_idler_width,0]
];

// end idler wall assembly
module end_idler_wall(thickness, pos, hole_clear=false) {
    translate(pos)
    rotate([0,-90,0]) 
    difference() {
        linear_extrude(height = thickness,  convexity = 1 )
            difference() {
                union() {
                    translate([0,-end_idler_width,0]) {
                        shell2d(-4) {
                            polygon(
                                polyRound(platePoints,30)
                            );
                            translate([pully_offset2-5,7]) gridpattern();
                        }
                    }
                    // x-axis pully
                    translate([xbar_offset-pully_offset2,-pully_offset1]) 
                        bushing(pully_dia,pully_boss);            
                }
                if(hole_clear) translate([0,-2*zscrew_zbar_offset]) 
                    square([zscrew_boss_dia-10,2+zscrew_boss_height/2]);
            };        
    }
}

// End Idler - x-axis bar along y-axis, origin right-hand centre of lower x-bar
module end_idler() {
    // X-axis bars
    difference() {
        rotate([90,0,0])
        linear_extrude(height = end_idler_width,  convexity = 1 ) {
            sleeve(rod_dia,end_boss_dia);
            translate([0,xbar_offset,0]) sleeve(rod_dia,end_boss_dia);
        }
        translate([-rod_dia,-end_idler_width-1,-11]) cube([end_boss_dia,end_idler_width+2,5]);       
        // chamfer
        translate([0,-end_idler_width-.5,0]) 
            rotate([-90,0,0])
                cylinder(1,d1=rod_dia+2,d2=rod_dia);
        translate([0,-end_idler_width-.5,xbar_offset]) 
            rotate([-90,0,0])
                cylinder(1,d1=rod_dia+2,d2=rod_dia);
        
        // inside clearence for z-bar
        translate([13.9,-zboss_dia/2, -6]) 
                linear_extrude(height = end_idler_width-.5,  convexity = 1 )
                    rotate([0,0,-135])
                        sleeve(1,lmuu_dia);        
        
        // inside clearence for z-screw mount holes
        translate([13.9,-zboss_dia/2-zscrew_zbar_offset,-6])
        linear_extrude(height = zscrew_boss_height,  convexity = 1 ) {             
            // Bushing holes
            rotate([0,0,45]) {
                translate([zscrew_bushing_mount_hole_offset,0,0]) circle(d=m3_drill4tap_dia);
                translate([-zscrew_bushing_mount_hole_offset,0,0]) circle(d=m3_drill4tap_dia);
                translate([0,zscrew_bushing_mount_hole_offset,0]) circle(d=m3_drill4tap_dia);
                translate([0,-zscrew_bushing_mount_hole_offset,0]) circle(d=m3_drill4tap_dia);
            }
        }
    }

    // Z-screw bushing
    translate([13.9,-zboss_dia/2-zscrew_zbar_offset,-6])
    difference() {
        linear_extrude(height = zscrew_boss_height,  convexity = 1 ) {             
            difference() {
                bushing(zscrew_dia, zscrew_boss_dia);
                // side hole clearence
                translate([0,19,0]) bushing(zscrew_dia, zscrew_boss_dia);
                // Inside clerence
                translate([-zscrew_boss_dia/2,-zscrew_boss_dia/2,0]) square([2,zscrew_boss_dia]);
                // Bushing holes
                rotate([0,0,45]) {
                    translate([zscrew_bushing_mount_hole_offset,0,0]) circle(d=m3_drill4tap_dia);
                    translate([-zscrew_bushing_mount_hole_offset,0,0]) circle(d=m3_drill4tap_dia);
                    translate([0,zscrew_bushing_mount_hole_offset,0]) circle(d=m3_drill4tap_dia);
                    translate([0,-zscrew_bushing_mount_hole_offset,0]) circle(d=m3_drill4tap_dia);
                }
            }
        }
        // chamfer
        translate([0,0,-.5]) cylinder(1,d1=zscrew_dia+2,d2=zscrew_dia);
    }
    
    // mesh sidewalls
    end_idler_wall(wall_thickness,[-end_boss_dia/2+wall_thickness,0,0]);
    difference() {
        end_idler_wall(wall_thickness,[end_boss_dia/2,0,0], hole_clear=true);
        // inside clearence for z-bar
        translate([13.9,-zboss_dia/2, -6]) 
                linear_extrude(height = end_idler_width-.5,  convexity = 1 )
                    rotate([0,0,-135])
                        sleeve(1,lmuu_dia);
    }
    
    // Z-bar bushing
    translate([13.9,-zboss_dia/2, -6]) 
    union() {
        difference() {
            linear_extrude(height = xbar_offset,  convexity = 1 ) {
                 rotate([0,0,-135]) 
                    sleeve(lmuu_dia, zboss_dia);
            }
            // chamfer
            cylinder(1,d1=lmuu_dia+2,d2=lmuu_dia);
        }
        // top lip
        translate([0,0,xbar_offset-.5])
        linear_extrude(height = .5,  convexity = 1 )
            rotate([0,0,-135])
                sleeve(lmuu_dia-.5,lmuu_dia+.1);
    }
}
//end_idler();
