
// A bed level check

// Fillament height and width (mm)
fh=0.2;
fw=0.4;

// Size of centre circle
circle_turns=18;

// Bounding size for square spiral
bound_x=232-2*fw;
bound_y=232-2*fw;

// Number of loops in outer spiral
square_turns=5;


cylinder(fh,r=fw*circle_turns/2);
for(i=[1:square_turns]) {
    translate([bound_x/2*i/square_turns-bound_x/2*1/square_turns,0,0]) rotate([0,0,90]) cube([bound_x/2*i/square_turns,fw,fh]);
    translate([bound_x/2*i/square_turns-bound_x/2*1/square_turns,bound_x/2*i/square_turns,0]) rotate([0,0,180]) cube([2*bound_x/2*i/square_turns-bound_x/2*1/square_turns,fw,fh]);
    translate([-bound_x/2*i/square_turns,bound_x/2*i/square_turns,0]) rotate([0,0,270]) cube([2*bound_x/2*i/square_turns,fw,fh]);
    translate([-bound_x/2*i/square_turns,-bound_x/2*i/square_turns,0]) rotate([0,0,0]) cube([2*bound_x/2*i/square_turns,fw,fh]);
    translate([bound_x/2*i/square_turns,-bound_x/2*i/square_turns,0]) rotate([0,0,90]) cube([bound_x/2*i/square_turns,fw,fh]);
}