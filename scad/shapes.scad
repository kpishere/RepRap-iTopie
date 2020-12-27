// iTopie RepRap - Shapes modules
//
// @version 1.1.0
// @license GPLv3
// @docs    http://reprap.org/wiki/ITopie  
// @sources https://github.com/lautr3k/RepRap-iTopie 
// @author  Sébastien Mischler <skarab>
// @author  http://www.onlfait.ch
//
module corner(radius = 0) {
    render() difference() {
        square([radius, radius]);
        translate([radius, radius, 0])
            circle(radius);
    }
}

module rounded_square(width, height, radius = 0, corner_radius = [0, 0, 0, 0]) {
    render() difference() {
        square([width, height]);
        if (radius > 0 || corner_radius[3] > 0) {
            corner(radius > 0 ? radius : corner_radius[3]);
        }
        if (radius > 0 || corner_radius[0] > 0) {
            translate([0, height, 0])
                rotate([0, 0, -90])
                    corner(radius > 0 ? radius : corner_radius[0]);
        }
        if (radius > 0 || corner_radius[1] > 0) {
            translate([width, height, 0])
                rotate([0, 0, -180])
                    corner(radius > 0 ? radius : corner_radius[1]);
        }
        if (radius > 0 || corner_radius[2] > 0) {
            translate([width, 0, 0])
                rotate([0, 0, -270])
                    corner(radius > 0 ? radius : corner_radius[2]);
        }
    }
}

module y_mount(width, height, corner_radius) {
    render() union() {    
        rounded_square(width, height, corner_radius = [corner_radius[0], corner_radius[1], 0, 0]);
        translate([width, 0, 0])
            corner(corner_radius[2]);
        rotate([0, 180, 0])
            corner(corner_radius[3]);
    }
}


// bushing with slit in side
module sleeve(in_dia, out_dia) {
    difference() {
        circle(d=out_dia);
        circle(d=in_dia);
        translate([-1,-0]) square([2,out_dia],center=false);
    }
}

// complete bushing
module bushing(in_dia, out_dia) {
    difference() {
        circle(d=out_dia);
        circle(d=in_dia);
    }
}

// Slot over radius 
// conditions: d1 < d2, th1 < th2, th2-th1 <= 90deg
module slot_curved(d1,d2,th1,th2) {
    union() {
        difference() {
            circle(d=d2);
            circle(d=d1);
            rotate(th1) square([d2/2,d2/2]);
            rotate(th2) translate([-d2/2,0]) square([d2/2,d2/2]);
            rotate(th2) translate([-d2/2,-d2/2]) square([d2,d2/2]);
        }
        rotate(th1) translate([0,(d1+d2)/4]) circle(d=(d2-d1)/2);
        rotate(th2) translate([0,(d1+d2)/4]) circle(d=(d2-d1)/2);
    }
}

// fill pattern for wall plate
module gridpattern(memberW = 2, sqW = 8, iter = 12, r = 1){
	round2d(0, r)rotate([0, 0, 45])translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2])difference(){
		square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
		for (i = [0:iter - 1], j = [0:iter - 1]){
			translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW])square([sqW, sqW]);
		}
	}
}

