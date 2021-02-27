$fn=50;

ir=30;
ht=10;
or=ir+ht/2;
pt=18;
deg=490;

difference() {
    // Snap-on guide
    union() {
        rotate([90,0,0]) cube([30,6,60]);
        translate([7,-30,35])
            rotate([90,-25,90]) for ( z = [1:deg]) {
                rotate(z) 
                    translate([ir,0,z*pt/deg]) 
                        rotate([90,0,0])
                            if(z==1 || z==deg) {
                                cylinder(1,r=(or-ir));
                            } else {
                                sphere(r=(or-ir), center=false);
                            }
        }
        translate([0,-3,-10]) cube([30,3,10]);
        translate([0,-7,-20]) cube([30,7,10]);

        translate([0,-60,-10]) cube([30,3,10]);
        translate([0,-60,-20]) cube([30,7,10]);
    }

    // motor
    translate([22-15/2,-30,-(22+9.5)]) 
        rotate([0,0,45]) {
        // motor body size - inner
        linear_extrude(22) {
            intersection() {
                circle(r=25);
                square([42,42], center=true);
            }
        }
        // motor body back end
        translate([0,0,22]) linear_extrude(9.5) {
            intersection() {
                circle(r=53/2);
                square([42,42], center=true);
            }
        }
    }
}