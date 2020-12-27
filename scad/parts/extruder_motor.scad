$fn = 50;

use <threadlib/threadlib.scad>;

MY_THREAD_TABLE = [
    ["M19-ext", [2.25, 8.3120, 16.9380, [[0, -1.0929], [0, 1.0929], [1.5830, 0.1790], [1.5830, -0.1790]]]],
    ["M19-int", [2.25, -10.2925, 20.2925, [[0, 1.2304], [0, -1.2304], [1.5330, -0.3453], [1.5330, 0.3453]]]]
];

baseplate_thickness=5;
baseplate_xy_len=42;
baseplate_corner_rad=3;

baseplate_mount_rad=2; // m4
baseplate_mount_xy_len=31;
baseplate_center_rad=12;

bushing_internal_len=27;
bushing_wall_thickness=3;
bushing_opening_rad=5;
bushing_access_rad=4;
bushing_chamfer_len=1.5;

insert_len=50;
insert_rad=4;
insert_shaft_len=20;
insert_shaft_rad=2.51;
insert_flex_len=25;
insert_flex_xy=2.6;

thru_m4=4.1/2;

// motor mount & z rod pockets
// 0 = none, 1 = left, 2 = right
module motor_mount_holes(radius) {
    circle(radius);
    translate([baseplate_mount_xy_len, 0, 0])
        circle(radius);
    translate([baseplate_mount_xy_len, baseplate_mount_xy_len, 0])
        circle(radius);
    translate([0, baseplate_mount_xy_len, 0])
        circle(radius);
    translate([baseplate_mount_xy_len/2, baseplate_mount_xy_len/2, 0]) {
        circle(baseplate_center_rad);
    }
}

module adapter() {
    // baseplate
    linear_extrude(baseplate_thickness) {
        difference() {        
            translate([-2*baseplate_mount_rad,-2*baseplate_mount_rad]) {
                minkowski() {
                    square([baseplate_xy_len-baseplate_corner_rad,baseplate_xy_len-baseplate_corner_rad]);
                    circle(baseplate_corner_rad);
                }
            }
            motor_mount_holes(baseplate_mount_rad);
        }
    };
    
    // mount
    difference() {
        union() {
            linear_extrude(baseplate_thickness+bushing_internal_len) {
                translate([-2*baseplate_mount_rad,baseplate_xy_len-2*baseplate_mount_rad]) square([baseplate_xy_len-2*baseplate_mount_rad,baseplate_thickness]);
                translate([baseplate_mount_xy_len/2-baseplate_thickness/2,baseplate_corner_rad+baseplate_mount_rad+2*baseplate_center_rad]) square([baseplate_thickness,baseplate_xy_len/2-baseplate_center_rad]);
            }
            // boss mount left
            translate([-bushing_access_rad,baseplate_xy_len-2*baseplate_mount_rad,baseplate_thickness+bushing_internal_len-baseplate_thickness])
            rotate([0,90,90])
            linear_extrude(baseplate_thickness) circle(baseplate_thickness);
            // boss mount right
            translate([baseplate_mount_xy_len+baseplate_corner_rad,baseplate_xy_len-2*baseplate_mount_rad,baseplate_thickness+bushing_internal_len-baseplate_thickness])
            rotate([0,90,90])
            linear_extrude(baseplate_thickness) circle(baseplate_thickness);
        }
        // mount hole left
        translate([-bushing_access_rad,baseplate_xy_len-2*baseplate_mount_rad,baseplate_thickness+bushing_internal_len-baseplate_thickness])
        rotate([0,90,90])
        linear_extrude(baseplate_thickness) circle(thru_m4);
        // mount hole right
        translate([baseplate_mount_xy_len+baseplate_corner_rad,baseplate_xy_len-2*baseplate_mount_rad,baseplate_thickness+bushing_internal_len-baseplate_thickness])
        rotate([0,90,90])
        linear_extrude(baseplate_thickness) circle(thru_m4);
    }
    // insert
    translate([baseplate_mount_xy_len/2, baseplate_mount_xy_len/2,0])
    difference() {
        cylinder(insert_len,r1=insert_rad, r2=insert_rad);
        // stepper shaft
        translate([0,0,-.1])
        difference() {
            cylinder(insert_shaft_len,r1=insert_shaft_rad, r2=insert_shaft_rad);
            translate([-insert_shaft_rad,insert_shaft_rad-0.5,-0.1])
            cube([2*insert_shaft_rad,2*insert_shaft_rad,insert_shaft_len]);
        }
        // flex cable shaft
        translate([-insert_flex_xy/2,-insert_flex_xy/2,insert_len-insert_flex_len+0.1])
        cube([insert_flex_xy,insert_flex_xy,insert_flex_len]);
    }
    
    // coupler housing
    translate([baseplate_mount_xy_len/2, baseplate_mount_xy_len/2, baseplate_thickness])
        difference() {
            union() {
                cylinder(bushing_internal_len+bushing_wall_thickness-bushing_chamfer_len,r1=baseplate_center_rad+bushing_wall_thickness
                , r2=baseplate_center_rad+bushing_wall_thickness);
                translate([0,0,bushing_internal_len+bushing_wall_thickness-bushing_chamfer_len])
                cylinder(bushing_chamfer_len,r1=baseplate_center_rad+bushing_wall_thickness, r2=baseplate_center_rad+bushing_wall_thickness-bushing_chamfer_len);
            }
            cylinder(bushing_internal_len+bushing_wall_thickness+2
                ,r1=bushing_opening_rad, r2=bushing_opening_rad);   
            translate([0,0,-0.5])
                cylinder(bushing_internal_len+1,r1=baseplate_center_rad, r2=baseplate_center_rad);      
     
            
         // access holes
    translate([-baseplate_mount_xy_len/2,0, 1+bushing_access_rad])
        rotate([0,90,0])
        cylinder(50,r1=bushing_access_rad,r2=bushing_access_rad);
    translate([-baseplate_mount_xy_len/2,0, 24-bushing_access_rad])
        rotate([0,90,0])
        cylinder(50,r1=bushing_access_rad,r2=bushing_access_rad);
       
    }

    // thread extension
    translate([baseplate_mount_xy_len/2, baseplate_mount_xy_len/2, baseplate_thickness+bushing_internal_len+bushing_wall_thickness])
        difference() {
            bolt("M19", turns=5, table=MY_THREAD_TABLE);
            translate([0,0,-5])
            cylinder(30,r1=bushing_opening_rad,r2=bushing_opening_rad);
        }
        
}

module adapter_xsection() {
    difference() {
        adapter();
            translate([baseplate_mount_xy_len/2, baseplate_mount_xy_len/2,0]) 
                cube([100,100,100]);
    }
}

//adapter_xsection();
adapter();
