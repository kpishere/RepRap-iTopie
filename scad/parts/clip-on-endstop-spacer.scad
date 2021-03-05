$fn=50;

r2=8;
r1=4;
gap=7;

ht=30;

difference() {
    cylinder(ht,r=r2);
    cylinder(ht,r=r1);
    translate([-gap/2,0,0]) cube([gap,r2,ht]);
}