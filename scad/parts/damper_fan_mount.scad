//
$fn=50;

// fan hole
r1=19;
// outer edges
xy=44;
rxy=2.5;
extra=2;
// thickness
th=1;
th_off=th-0.2;

rp1=20;
rp2=22;

ro=45.25/2;
rs=3.5/2;

// gasket
gth=1.4;
gr=ro-1.7;

difference() {
    linear_extrude(th) {
    difference() {
        // outer body
        minkowski() {
            square([xy-2*rxy,xy-2*rxy]);
            circle(r=rxy);
        }
        // Fan hole
        translate([xy/2-rxy,xy/2-rxy]) circle(r=r1);
        // mount hole
        translate([xy/2-rxy+ro*sqrt(2)/2,xy/2-rxy+ro*sqrt(2)/2]) circle(r=rs);
        translate([xy/2-rxy-ro*sqrt(2)/2,xy/2-rxy+ro*sqrt(2)/2]) circle(r=rs);
        translate([xy/2-rxy-ro*sqrt(2)/2,xy/2-rxy-ro*sqrt(2)/2]) circle(r=rs);
        translate([xy/2-rxy+ro*sqrt(2)/2,xy/2-rxy-ro*sqrt(2)/2]) circle(r=rs);
    }
    }
    // gasket
    translate([xy/2-rxy,xy/2-rxy]) difference() {
        cylinder(th_off,r=(gr+gth));
        cylinder(th_off,r=gr);
    }
}
