$fn=50;

// carrage mount holes
carriage_y=68;

// Titan areo supplied bracket
areo_y=62;
areo_z=40;

// bracket
th=2;
wd=areo_z;
side=8;
carriage_rad=4;
m4clr=4.1/2;
mt_boss=10;
mt_hole=6;
mt_y_off=20;

union() {
    // Base plate
    difference() {
        union() {
            cube([wd,carriage_y+2*(carriage_rad+th),th*2]);
            // side
            translate([wd,0,0]) cube([side,carriage_y+2*(carriage_rad+th),th*2]);
        }
        translate([0,th,0]) cube([wd+side,carriage_y+2*(carriage_rad),th]);  
        translate([areo_z/2,carriage_rad+th,th]) cylinder(th,r=m4clr);
        translate([areo_z/2,carriage_y+2*(carriage_rad+th)-(carriage_rad+th),th]) 
            cylinder(th,r=m4clr);
        translate([0,((carriage_y+2*(carriage_rad+th))-areo_y)/2,0]) cube([wd,areo_y,th*2]);    
    };
    // Mount hole
    translate([wd,((carriage_y+2*(carriage_rad+th))-areo_y)/2,mt_y_off]) 
        rotate([90,0,0]) {
        difference() {
            union() {
                cylinder(th,r=mt_boss);
                translate([-mt_boss/2,-mt_y_off+th,0]) cube([mt_boss+side/2-1,mt_y_off,th]);
            }
            cylinder(th,r=mt_hole);
        }
        #translate([0,-mt_y_off+2*th,0]) rotate([0,90,0]) cylinder(mt_boss/2+side/2-1,r=th);
    }
}