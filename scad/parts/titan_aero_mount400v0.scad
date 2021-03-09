$fn=50;

wall_th=2;
corner_rad=4;
mount_xof=6;
mount_wd=38+2*mount_xof;
mount_ht=62-2*corner_rad;
mount_rad=4.5/2;
mount_spc=15;
mount_off=2.5;

// 0 - All
// 1 - Frame
// 2 - Front coweling
// 3 - Part fan
// 4 - Back duct
// 5 - Front duct
part=5;

// Show motor and hot end 1=show, 0=hide
mtr_show=0;

mnt_holes = [
    [0+mount_xof,0],
    [mount_spc+mount_xof,0],
    [2*mount_spc+mount_xof,0],
    [0+mount_xof,54],
    [mount_spc+mount_xof,54],
    [2*mount_spc+mount_xof,54]
];

// Short motor plus fin back
mtr_dpth=32;
mtr_xy=46;
mtr_htsnk_ht=11.2;
mtr_hleoff=15.5;
mtr_rad=12;

dwn_air_gap=5;
side_air_gap=4;
side_air_ht=30;
wire_mnt=8;

// Head coweling
hdcw_xy=80;
hdcw_z1=32.8;
hdcw_y1=7.5;
hdcw_tprad=32;
hdcd_th=1;
fan_ht=8;
fan_xy=40;
thmb_rad=15.4;

// Vent holes for airflow [x,y,z,ry,r,h]
vnt_holes = [
    [0,0,0,0,1,side_air_ht],
    [mtr_xy+wall_th+side_air_gap,0,0,0,1,side_air_ht]
];
// Motor mount holes [x,y,r]
mtr_holes = [
    [0,0,mtr_rad],
    [mtr_hleoff,mtr_hleoff,3.4/2],
    [-mtr_hleoff,-mtr_hleoff,3.4/2],
    [mtr_hleoff,-mtr_hleoff,3.4/2],
    [-mtr_hleoff,mtr_hleoff,3.4/2]
];

// z-probe
mt_boss=12;
mt_hole=6.15;
mt_x1=64.5;
mt_y1=12;
mt_ht=15;
mt_drp=12;
mt_th=1;
mt_clr=0.1;

// Fan body
module fan(wide,height) {
    re=3;
    r1=19;
    ro=45.25/2;
    rs=3.5/2;

    linear_extrude(height) {
        difference() {
            // outer body
            minkowski() {
                square([wide-2*re,wide-2*re]);
                circle(r=re);
            }
            // Fan hole
            translate([wide/2-re,wide/2-re]) circle(r=r1);
            // mount hole
            translate([wide/2-re+ro*sqrt(2)/2,wide/2-re+ro*sqrt(2)/2]) circle(r=rs);
            translate([wide/2-re-ro*sqrt(2)/2,wide/2-re+ro*sqrt(2)/2]) circle(r=rs);
            translate([wide/2-re-ro*sqrt(2)/2,wide/2-re-ro*sqrt(2)/2]) circle(r=rs);
            translate([wide/2-re+ro*sqrt(2)/2,wide/2-re-ro*sqrt(2)/2]) circle(r=rs);
        }
    }
}

if(mtr_show) {
    translate([mount_spc+corner_rad+mount_off,4,-(mtr_dpth+dwn_air_gap+wall_th)]) {    
        rotate([0,0,180]) 
            import("../../stl/Titan-Aero-Nema24.stl");
        // Heatsink
        translate([-28,2,26]) cube([mtr_xy-4,mtr_xy-4,mtr_htsnk_ht]);
        // Hot end tip
        translate([-18,0,-13]) rotate([90,0,0]) cylinder(30,r=4);
        translate([-28,-29,-21]) cube([27,22,16]);
    }
}

// Base mount -- frame
if(part==0 || part==1) {
    translate([-mount_xof,0,0]) {
        linear_extrude(wall_th) {
            difference() {
                translate([-6.3,0]) minkowski() {
                    square([mount_wd,mount_ht]);
                    circle(r=corner_rad);
                };
                for(i=[0:len(mnt_holes)-1]) {
                    translate(mnt_holes[i]) circle(r=mount_rad);
                }
            }
        }
    }
    // Mtr encasement
    translate([-(mount_xof+mount_rad+2*wall_th+side_air_gap),2*wall_th,-(mtr_dpth+wall_th+dwn_air_gap)]) {
        difference() {
            cube([mtr_xy+2*wall_th+2*side_air_gap,mtr_xy-wall_th,mtr_dpth+mtr_htsnk_ht-2*wall_th]);
            // Motor clearence
            translate([side_air_gap+wall_th,wall_th,wall_th]) 
                cube([mtr_xy+side_air_gap,mtr_xy-wall_th,mtr_dpth+3*wall_th]);
            // Airflow clearence 
            translate([wall_th,wall_th,wall_th]) 
                cube([wall_th+side_air_gap,mtr_xy-wall_th,mtr_dpth/3]);
            // Airvents
            translate([wall_th,(mtr_xy-side_air_ht)/2-1,0])
            for(i=[0,len(vnt_holes)-1]) {
                translate([vnt_holes[i][4]+vnt_holes[i][0],0,0]) 
                    cylinder(wall_th,r=vnt_holes[i][4]);
                translate([vnt_holes[i][4]+vnt_holes[i][0],vnt_holes[i][5],0]) 
                    cylinder(wall_th,r=vnt_holes[i][4]);
                translate([vnt_holes[i][0],0,0])
                    cube([2*vnt_holes[i][4],vnt_holes[i][5],wall_th]);
            }
            // mount holes
            translate([2*mtr_hleoff,2*mtr_hleoff-corner_rad*2,0]) {
                for(i=[0:len(mtr_holes)-1]) {
                    translate([mtr_holes[i][0],mtr_holes[i][1],0]) cylinder(wall_th,r=mtr_holes[i][2]);
                }
                // Slot for assembly
               translate([-3,mtr_rad-2,0]) cube([6,mtr_rad,wall_th]); 
            }
            
        }
        // Wire mounts
        translate([mtr_xy+(side_air_gap+wire_mnt),0,6]) 
            difference() {
                cube([wire_mnt,mtr_xy-wall_th,wall_th]);
                for(i=[8:4*wall_th:mtr_xy-8]) {
                    translate([0, i, 0]) 
                    cube([wall_th,1.5*wall_th, wall_th]);
                }
            }
        // Z-probe mount
        translate([mt_x1,wall_th,-mt_y1]) 
            rotate([90,0,0]) {
            // probe mount surface
            translate([0,0,mt_drp]) {
                difference() {
                    union() {
                        cylinder(wall_th*1.5,r=mt_boss);
                    }
                    cylinder(wall_th*1.5,r=mt_hole);
                }
                // curved probe wall
                translate([0,0,-mt_drp]) difference() {
                    cylinder(mt_drp,r=(mt_boss));
                    cylinder(mt_drp,r=(mt_boss-mt_th));
                    translate([-mt_x1+(mtr_xy+2*wall_th+2*side_air_gap),-mt_boss,0]) 
                        cube([2*mt_boss,2*mt_boss,2*mt_ht]);
                }
            }
            // Side cowling
            translate([-mt_x1+(mtr_xy+1*wall_th+2*side_air_gap),-mt_boss,-(2*mt_ht-wall_th)]) {
                union() {
                    difference() {
                        translate([0,0,-mt_ht]) cube([wall_th,2*mt_boss,3*mt_ht]);
                         translate([-2*wall_th+mt_clr,mt_boss-wall_th,-16]) 
                            rotate([90,0,90]) difference() {
                            cylinder(6-mt_clr,r=thmb_rad);
                        }   
                    }
                    difference() {
                        translate([-2*wall_th+mt_clr,mt_boss-wall_th,-16]) 
                            rotate([90,0,90]) difference() {
                            cylinder(3*wall_th-mt_clr,r=thmb_rad);
                            cylinder(3*wall_th-mt_clr,r=thmb_rad-mt_th);
                        }
                        translate([-2*wall_th, -3*wall_th+0.6,-mtr_xy+wall_th-1]) cube([3*wall_th,2*thmb_rad,2*thmb_rad]);
                        translate([-2*wall_th, -thmb_rad,-mtr_xy+wall_th+10]) cube([3*wall_th,thmb_rad,2*thmb_rad]);
                    }
                }            
                // Bottom face cowling
                translate([-4*wall_th,0,2*mt_ht-wall_th]) 
                    cube([5*wall_th,2*thmb_rad,wall_th]);
                translate([-mtr_xy-5*wall_th,0,2*mt_ht-wall_th]) 
                    cube([4*wall_th,2*thmb_rad,wall_th]);
                // Side cowling
                translate([-mtr_xy-5*wall_th,0,2*mt_ht-wall_th]) rotate([0,90,0])
                    cube([12*wall_th,2*thmb_rad,wall_th]);
            }
        }    
    }
}
if(part==0 || part==2) // Front coweling
{
    translate([-mount_xof,0,0]) {
         // Head coweling
        difference() {
            translate([-hdcw_tprad/2+side_air_gap-1.5,hdcw_y1-side_air_gap-.5,-(mtr_dpth+hdcw_z1)]) {
                cube([2*hdcw_tprad,2*hdcw_tprad-5,wall_th]);
                translate([hdcw_tprad+3.5,0,wall_th]) cube([wall_th*7,wall_th,wall_th*2]);
                translate([10,0,wall_th]) cube([wall_th*2,wall_th,wall_th*2]);
            }    
            translate([mount_spc+corner_rad+mount_off+mount_xof,4,-(mtr_dpth+dwn_air_gap+wall_th)]) {
                    rotate([0,0,180]) 
                        import("../../stl/Titan-Aero-Assembly_HotEnd.stl");
                    translate([-mtr_xy,-mtr_xy/2-corner_rad,-27]) {
                        translate([15.2,30,0]) cube([42,40,wall_th*2]);
                        translate([16,54,0]) cylinder(wall_th*2,r=3);
                        translate([60,54,0]) cylinder(wall_th*2,r=3);
                        translate([38,76,0]) cylinder(wall_th*2,r=3);
                        translate([38,31,0]) cylinder(wall_th*2,r=3);
                    }
            }
           #translate([+hdcw_tprad+side_air_gap*2-wall_th,hdcw_y1-side_air_gap+wall_th,-(mtr_dpth+hdcw_z1+0.05)]) 
                cube([side_air_gap+wall_th*2,32,wall_th*1.1]);
           translate([-hdcw_tprad/2+side_air_gap+wall_th*2,hdcw_y1-side_air_gap+wall_th,-(mtr_dpth+hdcw_z1+0.05)]) 
                cube([side_air_gap+wall_th*2,32,wall_th*1.1]);
        }
        // Coweling front
        translate([hdcw_tprad/2+side_air_gap-1.5,hdcw_tprad-side_air_gap-1,-(mtr_dpth+hdcw_z1+fan_ht)]) {
            difference() {
                cylinder(fan_ht,r=hdcw_tprad);
                cylinder(fan_ht,r=hdcw_tprad-hdcd_th);
                translate([-hdcw_tprad,-hdcw_tprad,0]) cube([2*hdcw_tprad,hdcw_tprad,fan_ht]);
            }
            translate([-hdcw_tprad+corner_rad,-20,0]) 
            linear_extrude(fan_ht) {                
                difference() {
                    minkowski() {
                        square([2*hdcw_tprad-2*corner_rad,fan_xy-2*corner_rad]);
                        circle(r=corner_rad);
                    };
                    translate([hdcd_th,hdcd_th])
                    minkowski() {
                        square([2*hdcw_tprad-2*corner_rad-2*hdcd_th,fan_xy-2*corner_rad-2*hdcd_th]);
                        circle(r=corner_rad);
                    };            
                    translate([-corner_rad,fan_xy/2]) square([2*hdcw_tprad,fan_xy]);
                }
            }
            // Fan shroud
                translate([-hdcw_tprad+corner_rad,-20,-wall_th/2]) 
                {
                    
                    difference() {
                        union() {
                            translate([hdcw_tprad-side_air_gap,hdcw_tprad/2+4,0]) 
                            difference() {
                                cylinder(wall_th/2,r=hdcw_tprad);
                                translate([-hdcw_tprad,-hdcw_tprad-fan_xy/2+8,0]) cube([2*hdcw_tprad,(fan_xy)/2,wall_th/2]);
                            }
                            linear_extrude(wall_th/2) {
                                minkowski() {
                                    square([2*hdcw_tprad-2*corner_rad,(fan_xy-2*corner_rad)/2+3]);
                                    circle(r=corner_rad);
                                }
                            }
                        }                        
                        translate([hdcw_tprad-corner_rad,1.1,0]) linear_extrude(wall_th/2) {
                        rotate([0,0,45]) minkowski() {
                            square([32.2,32.2]);
                            circle(r=corner_rad);
                        }
                    }
                }
            }
        }
    }
}
pc_ht1=70;
pc_fw1=5;

dct_bk1_ow=15;
dct_bk1_oh=4;
dct_bk1_th=45;
dct_bk1_ooy=-12;
dct_bk1_ooz=29;
dct_bk1_oox=24;
dct_wl_th=0.5;
dct_bk1_points = [
  [ 0,  0,  0 ],  //0
  [ 0,  30,  0 ],  //1
  [ 10,  30,  0 ],  //2
  [ 10,  0,  0 ],  //3
  [ 0+dct_bk1_oox,  0+dct_bk1_ooy,  dct_bk1_ooz ],  //4
  [ 0+dct_bk1_oox,  dct_bk1_ow*cos(dct_bk1_th)+dct_bk1_ooy,  dct_bk1_ooz+dct_bk1_ow*sin(dct_bk1_th)  ],  //5
  [ dct_bk1_oh+dct_bk1_oox,  dct_bk1_ow*cos(dct_bk1_th)+dct_bk1_ooy,  dct_bk1_ooz+dct_bk1_ow*sin(dct_bk1_th) ],  //6
  [ dct_bk1_oh+dct_bk1_oox,  0+dct_bk1_ooy,  dct_bk1_ooz ]]; //7
dct_bk1_points1 = [
  [ 0+dct_wl_th,  0+dct_wl_th,  0 ],  //0
  [ 0+dct_wl_th,  30-dct_wl_th,  0 ],  //1
  [ 10-dct_wl_th,  30-dct_wl_th,  0 ],  //2
  [ 10-dct_wl_th,  0+dct_wl_th,  0 ],  //3
  [ 0+dct_bk1_oox+dct_wl_th,  0+dct_bk1_ooy+dct_wl_th,  dct_bk1_ooz+dct_wl_th ],  //4
  [ 0+dct_bk1_oox+dct_wl_th,  (dct_bk1_ow-dct_wl_th)*cos(dct_bk1_th)+dct_bk1_ooy,  dct_bk1_ooz+dct_bk1_ow*sin(dct_bk1_th)  ],  //5
  [ dct_bk1_oh+dct_bk1_oox-dct_wl_th,  (dct_bk1_ow-dct_wl_th)*cos(dct_bk1_th)+dct_bk1_ooy,  dct_bk1_ooz+dct_bk1_ow*sin(dct_bk1_th) ],  //6
  [ dct_bk1_oh+dct_bk1_oox-dct_wl_th,  0+dct_bk1_ooy+dct_wl_th,  dct_bk1_ooz+dct_wl_th ]]; //7
 
dct_ft1_ow=8;
dct_ft1_oh=11;
dct_ft1_ooy=1.6;
dct_ft1_ooz=7;
dct_ft1_oox=-15.6;
dct_ft1_points=[[ 0,  0,  0 ],  //0
  [ 0,  30,  0 ],  //1
  [ 10,  30,  0 ],  //2
  [ 10,  0,  0 ],  //3
  [ 0+dct_ft1_ooy, dct_ft1_oox, dct_ft1_ooz ],  //4
  [ 0+dct_ft1_ooy,  dct_ft1_oox, dct_ft1_ooz+dct_ft1_oh ],//5
  [ dct_ft1_ow+dct_ft1_ooy, dct_ft1_oox, dct_ft1_ooz+dct_ft1_oh ], //6
  [ dct_ft1_ow+dct_ft1_ooy, dct_ft1_oox,  dct_ft1_ooz  ]  //7
  ];
dct_ft1_points1=[[ 0+dct_wl_th,  0+dct_wl_th,  0 ],  //0
  [ 0+dct_wl_th,  30-dct_wl_th,  0 ],  //1
  [ 10-dct_wl_th,  30-dct_wl_th,  0 ],  //2
  [ 10-dct_wl_th,  0+dct_wl_th,  0 ],  //3
  [ dct_ft1_ooy+dct_wl_th, dct_ft1_oox-dct_wl_th, dct_ft1_ooz+dct_wl_th ],  //4
  [ dct_ft1_ooy+dct_wl_th,  dct_ft1_oox-dct_wl_th, dct_ft1_ooz+dct_ft1_oh-dct_wl_th ],//5
  [ dct_ft1_ow+dct_ft1_ooy-dct_wl_th, dct_ft1_oox-dct_wl_th, dct_ft1_ooz+dct_ft1_oh-dct_wl_th ], //6
  [ dct_ft1_ow+dct_ft1_ooy-dct_wl_th, dct_ft1_oox-dct_wl_th,  dct_ft1_ooz+dct_wl_th  ]  //7
  ];

dct_faces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left

if(part==0 || part==3) {
    // fan body and position
    translate([-mount_off,pc_ht1,-pc_fw1]) {
    rotate([-90,0,0])
        fan(40,20);
    }
}
if(part==0 || part == 4) {
    // side guide back
    translate([41.9,-7,-30.5]) 
    difference() {
        cube([10,59,30]);
        translate([0.5,0.5,0.5]) cube([9,59.5,29]);
        translate([-0.5,0.5,0.5]) cube([9,9,29]);
        translate([5,55,-0.2]) cylinder(31,r=2);
    }
    // Tip outlet - back
    translate([42.5,3,-30.5]) rotate([90,0,-90]) 
        difference() {
            polyhedron(dct_bk1_points,dct_faces);
            polyhedron(dct_bk1_points1,dct_faces);
        }               
}
if(part==0 || part == 5) {
    // side guide fwd
    translate([-26.2,3,-43]) 
    difference() {
        cube([10,49,30]);
        translate([0.5,0,0.5]) cube([9,49,29]);
        #translate([5,45,-0.2]) cylinder(31,r=2);
    }
    // Tip outlet - front
    translate([-26.2,3,-43]) rotate([90,0,0]) 
        difference() {
            polyhedron(dct_ft1_points,dct_faces);
            polyhedron(dct_ft1_points1,dct_faces);
        }                       
    translate([-8,-25,-60]) 
    rotate([0,45,0])
        for(i=[0:135]) {
           translate([-i/135*7,i/135*10,-i/135*5]) rotate([0,i,0]) 
            difference() {
                cube([15-i/135*7,4+i/135*7,1]);
                translate([.5,.5,0]) cube([15-i/135*7-1,4+i/135*7-1,1]);
            }
        }
}