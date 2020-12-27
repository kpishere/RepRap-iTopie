include <../config.scad>
include <../shapes.scad>
include <Round-Anything/polyround.scad>

// motor pivot point mount 1
motor_piv1=37.5;
motor_piv2=pully_offset2-motor_mount_ctr_spc/2;
motor_piv_dia=3.6;
motor_piv_boss_dia=motor_piv_dia+8;

// motor mount 2
motor_mnt_dia21=2*(motor_mount_ctr_spc-motor_piv_dia/2);
motor_mnt_dia22=motor_mnt_dia21+motor_piv_dia*2;
motor_mnt21=motor_piv1;
motor_mnt22=motor_piv2+motor_mount_ctr_spc;
motor_mnt2_th1=270-8;
motor_mnt2_th2=motor_mnt2_th1+8;

// motor mount 3
motor_mnt_dia31=2*(sqrt(2)*motor_mount_ctr_spc-motor_piv_dia/2);
motor_mnt_dia32=motor_mnt_dia31+motor_piv_dia*2;
motor_mnt31=1+motor_piv1-(motor_mnt_dia31+motor_piv_dia)/2/sqrt(2);
motor_mnt32=2.2+motor_piv2+(motor_mnt_dia31+motor_piv_dia)/2/sqrt(2);
motor_mnt3_th1=270+45-8;
motor_mnt3_th2=motor_mnt3_th1+10;

// motor axis offset
motor_axis_dia1=2*(sqrt(2)*motor_mount_ctr_spc/2-(motor_boss_dia+1)/2);
motor_axis_dia2=motor_axis_dia1+(motor_boss_dia+1)*2;
motor_axis_ang1=315-8;
motor_axis_ang2=motor_axis_ang1+8;

// wall geometry
platePoints = [
    [0,0,0], //1
    [xbar_offset,0,0], //2
    [xbar_offset,end_motor_width,0],//3
    [motor_mount_ctr_spc,end_motor_width,5],//4
    [motor_mount_ctr_spc,end_motor_width-motor_mount_ctr_spc/2,0],//5 - curve edge
    [motor_mount_ctr_spc+3,end_motor_width-20,0],//6
    [motor_mount_ctr_spc+2.4,end_motor_width-30,0],//6.1
    [motor_mount_ctr_spc-motor_piv2,end_motor_width-35.5,0],//7
    [9+motor_piv2,end_motor_width-13.8-8.1-17+7.6,0],//8
    [0,end_motor_width-31.3,0],//9
];

// end idler wall assembly
module end_motor_wall(thickness, pos, hole_clear=false) {
    translate(pos)
    rotate([0,90,0]) 
    linear_extrude(height = thickness,  convexity = 1 )
    difference() {
        union() {
            translate([0,-end_motor_width,0]) {
                shell2d(-4) {
                    polygon(
                        polyRound(platePoints,30)
                    );
                    translate([motor_piv2,7]) gridpattern(memberW = 2, sqW = 8, iter = 15, r = 1);                    
                }
            }                        
            // motor mount 1 pivot
            translate([motor_piv2,-motor_piv1]) {
                bushing(motor_piv_dia,motor_piv_boss_dia);
            }
            // motor mount boss 2 
            translate([motor_mnt22,-motor_mnt21-2]) {
                bushing(0,motor_piv_boss_dia+2);
            }            
            // motor mount boss 3 
            translate([motor_mnt32,-motor_mnt31-2]) {
                bushing(0,motor_piv_boss_dia);
            }            
        }
        // clearance for motor axis and mounts
        translate([motor_piv2,-motor_piv1]) {
            // motor axis
            slot_curved(motor_axis_dia1,motor_axis_dia2,motor_axis_ang1,motor_axis_ang2);
            // motor mount 2 slot
            slot_curved(motor_mnt_dia21,motor_mnt_dia22,motor_mnt2_th1,motor_mnt2_th2);
            // motor mount 3 slot
            slot_curved(motor_mnt_dia31,motor_mnt_dia32,motor_mnt3_th1,motor_mnt3_th2);
        }
        // clearence for bushing mount holes
        if(hole_clear) 
            translate([xbar_offset-zscrew_boss_dia+6,2-end_motor_width]) 
            square([zscrew_boss_dia,2+zscrew_boss_height/2]);
    }
}


// End Idler - x-axis bar along y-axis, origin right-hand centre of lower x-bar
module end_motor() {
    // X-axis bars
    difference() {
        rotate([90,0,0])
        union() {
            translate([0,0,xbar_offset])
            linear_extrude(height = end_motor_width-end_idler_width+1,  convexity = 1 )
                sleeve(rod_dia,end_boss_dia);
            linear_extrude(height = end_motor_width-(end_motor_width-end_idler_width+1.1),  convexity = 1 )
                bushing(0,end_boss_dia);
            translate([0,0,31.3])
            linear_extrude(height = end_motor_width-31.3,  convexity = 1 ) 
                translate([0,xbar_offset]) sleeve(rod_dia,end_boss_dia);        
        }
        translate([-rod_dia,-end_motor_width-1,-11]) cube([end_boss_dia,end_motor_width+2,5]);       
        // chamfer
        translate([0,-end_motor_width-.5,0]) 
            rotate([-90,0,0])
                cylinder(1,d1=rod_dia+2,d2=rod_dia);
        translate([0,-end_motor_width-.5,xbar_offset]) 
            rotate([-90,0,0])
                cylinder(1,d1=rod_dia+2,d2=rod_dia);
        
        // inside clearence for z-bar
        translate([-13.9,-end_motor_width+zboss_dia/2+zscrew_zbar_offset, -6]) 
                linear_extrude(height = xbar_offset-.5,  convexity = 1 )
                    rotate([0,0,135])
                        sleeve(1,lmuu_dia);        

        // inside clearence for z-screw mount holes
        translate([-13.9,-end_motor_width+zboss_dia/2,-6])
        linear_extrude(height = zscrew_boss_height,  convexity = 1 ) {             
            // Bushing holes
            rotate([0,0,45]) {
                translate([zscrew_bushing_mount_hole_offset,0,0]) circle(d=m3_drill4tap_dia);
                translate([-zscrew_bushing_mount_hole_offset,0,0]) circle(d=m3_drill4tap_dia);
                translate([0,zscrew_bushing_mount_hole_offset,0]) circle(d=m3_drill4tap_dia);
                translate([0,-zscrew_bushing_mount_hole_offset,0]) circle(d=m3_drill4tap_dia);
            }
        }
        
        // inside clearence for motor mount holes and slots        
        translate([end_boss_dia/2-end_boss_dia,0,xbar_offset])
            rotate([0,90,0]) 
            linear_extrude(height = end_boss_dia,  convexity = 1 )
            // motor mount 
            translate([motor_piv2,-motor_piv1]) {
                // clearance for motor axis
                slot_curved(motor_axis_dia1,motor_axis_dia2,motor_axis_ang1,motor_axis_ang2);
                // pivot 1
                bushing(0,motor_piv_dia);
                // slot 2
                slot_curved(motor_mnt_dia21,motor_mnt_dia22,motor_mnt2_th1,motor_mnt2_th2);
                // slot 3
                slot_curved(motor_mnt_dia31,motor_mnt_dia32,motor_mnt3_th1,motor_mnt3_th2);
            }
        
        // clearence for x-axis motor tensioning screw
        translate([0,-motor_piv1+motor_mnt_dia31/2-11.3,xbar_offset-motor_piv2-motor_mnt_dia31/2+11.3])
            rotate([135,0]) {
                linear_extrude(height = 25,  convexity = 1 )              
                    bushing(0,m3_drill4tap_dia);
                translate([0,0,15])
                linear_extrude(height = 10,  convexity = 1 )              
                    bushing(0,m3_drill4tap_dia+4);
            }
    }

    // Z-screw bushing
    translate([-13.9,-end_motor_width+zboss_dia/2,-6])
    difference() {
        linear_extrude(height = zscrew_boss_height,  convexity = 1 ) {             
            //rotate(180)
            difference() {
                bushing(zscrew_dia, zscrew_boss_dia);
                // side hole clearence
                translate([0,19,0]) bushing(zscrew_dia, zscrew_boss_dia);
                // Inside clerence
                translate([zscrew_boss_dia/2-2,-zscrew_boss_dia/2,0]) square([2,zscrew_boss_dia]);
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
    
    
    // side walls
    end_motor_wall(wall_thickness,[end_boss_dia/2-wall_thickness,0,xbar_offset]);    
    difference() {
        end_motor_wall(wall_thickness,[-end_boss_dia/2,0,xbar_offset],hole_clear=true);
        // inside clearence for z-bar
        translate([-13.9,-end_motor_width+zboss_dia/2+zscrew_zbar_offset, -6]) 
                linear_extrude(height = xbar_offset-.5,  convexity = 1 )
                    rotate([0,0,45])
                        sleeve(1,lmuu_dia);
    }

    // Z-bar bushing
    translate([-13.9,-end_motor_width+zboss_dia/2+zscrew_zbar_offset, -6]) 
    union() {
        difference() {
            linear_extrude(height = xbar_offset,  convexity = 1 ) {
                 rotate([0,0,135]) 
                    sleeve(lmuu_dia, zboss_dia);
            }
            // chamfer
            cylinder(1,d1=lmuu_dia+2,d2=lmuu_dia);
        }
        // top lip
        translate([0,0,xbar_offset-.5])
        linear_extrude(height = .5,  convexity = 1 )
            rotate([0,0,135])
                sleeve(lmuu_dia-.5,lmuu_dia+.1);
    }

}
//end_motor();
