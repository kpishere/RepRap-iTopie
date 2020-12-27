$fn=50;

// Box
wd=180;
dp=215;
ht=56.5;
wall_th=2;

// Spacer grid
spacer_wd=wd-wall_th*2;
spacer_dp=120;
spacer_ht=4.5;
spacer_md=30;
spacer_nx=4;
spacer_ny=6;

// Box holes
fuse_rad=6.5;
switch_rad=6;

// Mega 2560 mount points [x,y] (lower left == 0,0, thousands of inch) 
in2mm = 25.4/1000;
mega_y=193.3;
mega_x=28.4;
mega_r1=1;
mega_r2=3;
megausb_y1=147.4;
megausb_z1=8.4;
megausb_x1=28.4;
usb_y=12.3;
usb_z=11.3;

mega_pos = [
    [550,100],
    [2600,300],
    [3800,100],
    [3550,2000],
    [2600,1400],
    [600,2000],
];

// Power supply space
pwr_y1=19;
pwr_y2=130;

bos = [
// Mount bosses [x,y,ro,ri,ht]
    [29   ,6.5,5,1,spacer_ht],
    [153.1,6.5,5,1,spacer_ht],
    [30   ,124,12,1,spacer_ht],
// Case stabalizers and cover mounts
    [wd-3,3,3,1,ht-2*wall_th],
    [wd-3,dp-3,3,1,ht-2*wall_th],
    [3,dp-3,3,1,ht-2*wall_th],
    [3,pwr_y2+3,3,1,ht-2*wall_th],
    [wd-3,pwr_y2+3,3,1,ht-2*wall_th]
];

// Wall returns [x,y,r,wx,wy,ht]
retrn= [
    [wall_th   ,pwr_y2+wall_th,180,5,wall_th,ht-2*wall_th],
    [wd-wall_th,pwr_y2,0,5,wall_th,ht-2*wall_th],
];

// Case holes [x,y,z,xr,zr,h,r]
hole= [
    // fuse hole
    [12,wall_th,11.3,90,0,wall_th*2,fuse_rad],
    // power switch hole
    [12,wall_th,35.5,90,0,wall_th*2,switch_rad]
];

// Case knock-outs [x,y,z,xr,yr,h,r1,r2]
kout= [
    // RHS of box
    [wd-wall_th,195,ht-16,0,90,wall_th,9,10],
    [wd-wall_th,195,ht-16-24,0,90,wall_th,9,10],
    // Top
    [16,dp-16,ht-wall_th,0,0,wall_th,11,12],
    // Back
    [110,dp,ht-16-24,90,0,wall_th,9,10],    
    [110,dp,ht-16,90,0,wall_th,9,10],    
    [160,dp,ht-16-24,90,0,wall_th,9,10],    
    [160,dp,ht-16,90,0,wall_th,9,10]    
];

// Case holes square [x,y,z,tx,ty,tz]
hole_sq= [
    // power supply hole
    [wd-wall_th,pwr_y1,0,wall_th,pwr_y2-pwr_y1,ht-spacer_ht-wall_th],
    // USB plug hole
    [0,megausb_y1,ht-megausb_z1-usb_z,wall_th,usb_y,usb_z]
];

// Oblong hole, r1=rad of ends, d=dist of streight between, h=thickness
module oblong(r1,d,h) {
    union() {
        cylinder(h,r=r1);
        translate([d,0,0]) cylinder(h,r=r1);
        translate([0,-r1,0]) cube([d,2*r1,h]);
    }
}

// Knockout, th=thickness, r1=inner rad, r2=outer rad
module knockout(th,r1,r2) {
    difference() {            
        cylinder(th,r=r2);
        cylinder(th,r=r1);
        translate([-r2,-th/2,0]) cube([r2*2,th,th]);
        rotate([0,0,90]) translate([-r2,-th/2,0]) cube([r2*2,th,th]);
    };
}

// Fan, s=fan nominal size, h=thickness, k=spokes, hl=mount hole size
module fan(s,h,k=3,hl=3.6/2) {
    union() {
        // Air hole
        difference() {            
            cylinder(h,r=s/2);
            cylinder(h,r=s*0.95/4);
            // Supports
            for(r=[0:360/k:360]) {
                rotate([0,0,r]) translate([0,-h/2,0]) cube([s/2,h,h]);
            }
        };    
        // Mount holes
        translate([s/2-s*.1,s/2-s*.1,0]) cylinder(h,r=hl);
        translate([-(s/2-s*.1),-(s/2-s*.1),0]) cylinder(h,r=hl);
        translate([+(s/2-s*.1),-(s/2-s*.1),0]) cylinder(h,r=hl);
        translate([-(s/2-s*.1),+(s/2-s*.1),0]) cylinder(h,r=hl);
    }
}

union() {
    difference() {
        cube([wd,dp,ht]);
        translate([wall_th,wall_th,0])
            cube([wd-2*wall_th,dp-2*wall_th,ht-wall_th]);
        // Case round holes
        for(i=[0:len(hole)-1]) {
            translate([hole[i][0],hole[i][1],hole[i][2]])
            rotate([hole[i][3],0,hole[i][4]])
            cylinder(hole[i][5],r=hole[i][6]);
        }
        // Case knock-outs
        for(i=[0:len(kout)-1]) {
            translate([kout[i][0],kout[i][1],kout[i][2]])
            rotate([kout[i][3],kout[i][4],0])
            knockout(kout[i][5],kout[i][6],kout[i][7]);
        }
        // case square hole
        for(i=[0:len(hole_sq)-1]) {
            translate([hole_sq[i][0],hole_sq[i][1],hole_sq[i][2]])
            cube([hole_sq[i][3],hole_sq[i][4],hole_sq[i][5]]);
        }
        // Case vents
        for(i=[204:-4:140]) {
            translate([wall_th,i,6.4]) rotate([0,-90,0]) oblong(1,24,wall_th);
        }
        // Power cord hole
        translate([wd,11.5,13]) rotate([0,-90,0]) oblong(5.5,2,wall_th);
        // Fan hole
        translate([wd,158,ht/2]) rotate([0,-90,0]) fan(40,wall_th);        
    }
    // Stiffness grid
    difference() {
        translate([wall_th,wall_th,ht-wall_th-spacer_ht]) cube([spacer_wd,spacer_dp,spacer_ht]);
        for(x=[wall_th:spacer_md:spacer_md*spacer_nx]) {
            for(y=[wall_th:spacer_md:spacer_md*spacer_ny]) {
                translate([y,x,ht-wall_th-spacer_ht]) cube([spacer_md-wall_th,spacer_md-wall_th,spacer_ht]);
            }
        }
    }
    // Mega mount points
    for(i=[0:len(mega_pos)-1]) {
        translate([mega_x+mega_pos[i][0]*in2mm,mega_y-mega_pos[i][1]*in2mm,ht-wall_th-spacer_ht]) 
        difference() {
            cylinder(spacer_ht,r=mega_r2);
            cylinder(spacer_ht,r=mega_r1);
        }
    }
    // Mega USB guide
    #translate([0,megausb_y1-wall_th,ht-(usb_z+megausb_z1+wall_th)]) 
        difference() {
            cube([megausb_x1,usb_y+2*wall_th,usb_z+megausb_z1+wall_th]);
            translate([0,wall_th,usb_z+wall_th*2]) 
                cube([megausb_x1,usb_y,megausb_z1-wall_th]);
            translate([0,wall_th,wall_th]) 
                cube([megausb_x1,usb_y,usb_z]);
    }
    // mount points
    for(i=[0:len(bos)-1]) {
        translate([bos[i][0],bos[i][1],ht-wall_th])
        rotate([0,180,0]) 
        difference() {
            cylinder(bos[i][4],r=bos[i][2]);
            cylinder(bos[i][4],r=bos[i][3]);
        }
    }
    // wall returns
    for(i=[0:len(retrn)-1]) {
        translate([retrn[i][0],retrn[i][1],ht-wall_th])
        rotate([0,180,retrn[i][2]]) 
        cube([retrn[i][3],retrn[i][4],retrn[i][5]]);
    }
}

