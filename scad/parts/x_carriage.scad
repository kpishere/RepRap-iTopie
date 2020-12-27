
$fn=50;

// Carriage 
carriage_x=56;
carriage_y=68;
carriage_rad=4;
carriage_thick=12;

// mount holes
mnt_m4=2;
thru_m4=4.1/2;
mnt_x_spacing=15;
mnt_y_spacing=54;
mnt_len=2;

// strap path
strap_y=20;
strap_thick=1.6;
strap_wide=3;
strap_rad=5;
strap_xpos1=5;
strap_xpos2=19;

// Bearing slots
bushing_offset=4;
bushing_rad=15/2;
bushing_len=25;
bushing_stop_rad=11/2;
bushing_stop_offset=1.5;

// Belt path
belt_top_offset=42.3;
belt_ctr_offset=2;
inside_rad=3;
tail_len=10.1;
belt_ret_y=6;
belt_ret_offset=25.8;

belt_single_thick=1.35;
belt_mesh_thick=1.8;
belt_height=7;

mid_rad=inside_rad+belt_single_thick;
outer_rad=inside_rad+belt_mesh_thick;

module belt_path2D() {
    difference() {
        circle(mid_rad);
        circle(inside_rad);
        square([2*mid_rad,mid_rad]);
        translate([-mid_rad,-mid_rad])
            square([2*mid_rad,mid_rad]);
    };
    translate([-2*mid_rad+belt_single_thick,-(belt_mesh_thick-belt_single_thick)])
        #difference() {
            circle(mid_rad);
            circle(inside_rad);
            square([2*mid_rad,mid_rad]);
            translate([-mid_rad,-mid_rad])
                square([mid_rad,2*mid_rad]);
        };
    translate([0,inside_rad])
        square([tail_len,belt_mesh_thick]);
    translate([-(inside_rad+belt_single_thick),-(belt_mesh_thick-belt_single_thick)])
        square([belt_single_thick, belt_mesh_thick-belt_single_thick]);
    translate([-2*(mid_rad-belt_single_thick/2),0])
        difference() {
            circle(outer_rad);
            circle(outer_rad-belt_single_thick);
            square([2*outer_rad,outer_rad]);
            translate([0,-outer_rad])
                square([outer_rad,2*outer_rad]);
        }
    translate([-2*(mid_rad-belt_single_thick/2),outer_rad-belt_single_thick])
        square([2*(mid_rad-belt_single_thick/2),belt_single_thick]);
    difference() {
        translate([tail_len,0]) square([outer_rad,2*outer_rad]);
        translate([tail_len,-belt_mesh_thick/2-.1]) circle(carriage_rad);
        translate([tail_len,2*carriage_rad+belt_mesh_thick/2-.1]) circle(carriage_rad);
    }
}

module strap_path_part() {
    difference() {
        square([carriage_thick,strap_y/2]);
        translate([strap_rad+strap_thick,strap_y/2-strap_rad-strap_thick]) circle(strap_rad);
        translate([strap_rad+strap_thick,-strap_thick]) square([strap_y/2,strap_y/2]);
        translate([strap_thick,-strap_rad-strap_thick]) square([strap_y/2,strap_y/2]);
    }
}

module strap_path() {
    linear_extrude(strap_wide) {
        strap_path_part();
        mirror([0,1,0]) strap_path_part();
    }
}

// carriage block 3d
difference() {
    // block material
    union() {
        linear_extrude(carriage_thick) {
            // block
            translate([carriage_rad,carriage_rad])
            minkowski() {
                square([carriage_x-2*carriage_rad,carriage_y-2*carriage_rad]);
                circle(carriage_rad);
            }
            // bosses top/bottom
            translate([carriage_x/2,0]) circle(carriage_rad);
            translate([carriage_x/2,carriage_y]) circle(carriage_rad);
        }
        // mount nubs
        translate([0,0,-mnt_len])
        linear_extrude(mnt_len)
        #for(x=[carriage_x/2-mnt_x_spacing:mnt_x_spacing:carriage_x/2+mnt_x_spacing]) {
            translate([x,carriage_y/2-mnt_y_spacing/2]) circle(mnt_m4);
            translate([x,carriage_y/2+mnt_y_spacing/2]) circle(mnt_m4);
        }
    }    
    // mount holes
    linear_extrude(carriage_thick) {
        translate([carriage_x/2,0]) circle(thru_m4);
        translate([carriage_x/2,carriage_y]) circle(thru_m4);
    }
    // belt path
    translate([3*inside_rad+belt_single_thick+belt_mesh_thick + carriage_x/2 + belt_ctr_offset ,belt_top_offset-outer_rad,carriage_thick-belt_height-.1]) {
        linear_extrude(belt_height+.2) belt_path2D();
        translate([-2*(3*inside_rad+belt_single_thick+belt_mesh_thick + belt_ctr_offset ),0,0])
            mirror([1,0,0]) linear_extrude(belt_height+.2) belt_path2D();

    }
    //belt return
    translate([0,belt_ret_offset,carriage_thick-belt_height-.1])
    linear_extrude(belt_height+.2) 
    #union() {
        square([carriage_x+inside_rad,belt_ret_y]);
        difference() {
            translate([carriage_x-inside_rad,-inside_rad]) 
                square([carriage_x+inside_rad,2*inside_rad+belt_ret_y]);
            translate([carriage_x-inside_rad,-inside_rad]) circle(inside_rad);
            translate([carriage_x-inside_rad,belt_ret_y+inside_rad]) circle(inside_rad);
        }
        difference() {
            translate([0,-inside_rad]) square([inside_rad,2*inside_rad+belt_ret_y]);
            translate([inside_rad,-inside_rad]) circle(inside_rad);
            translate([inside_rad,belt_ret_y+inside_rad]) circle(inside_rad);
        }
    }
    // strap holes
    rotate([0,-90,0]) 
        union() {
            // lower
            translate([0,bushing_offset+bushing_rad,-strap_wide-strap_xpos1]) strap_path();
            translate([0,bushing_offset+bushing_rad,-strap_wide-strap_xpos2]) strap_path();
            translate([0,bushing_offset+bushing_rad,-carriage_x+strap_xpos1]) strap_path();
            translate([0,bushing_offset+bushing_rad,-carriage_x+strap_xpos2]) strap_path();
            // upper
            translate([0,carriage_y-bushing_offset-bushing_rad,-strap_wide-strap_xpos1]) strap_path();
            translate([0,carriage_y-bushing_offset-bushing_rad,-strap_wide-strap_xpos2]) strap_path();
            translate([0,carriage_y-bushing_offset-bushing_rad,-carriage_x+strap_xpos1]) strap_path();
            translate([0,carriage_y-bushing_offset-bushing_rad,-carriage_x+strap_xpos2]) strap_path();
        }
    // bushing paths
    translate([0,0,carriage_thick]) 
    rotate([0,90,0])         
        union() {
            translate([0,bushing_offset+bushing_rad,0]) linear_extrude(carriage_x) circle(bushing_stop_rad);
            translate([0,carriage_y-bushing_offset-bushing_rad,0]) linear_extrude(carriage_x) circle(bushing_stop_rad);
            
            translate([0,bushing_offset+bushing_rad,bushing_stop_offset]) linear_extrude(bushing_len) circle(bushing_rad);
            translate([0,bushing_offset+bushing_rad,carriage_x-bushing_len-bushing_stop_offset]) linear_extrude(bushing_len) circle(bushing_rad);

            translate([0,carriage_y-bushing_offset-bushing_rad,bushing_stop_offset]) linear_extrude(bushing_len) circle(bushing_rad);
            translate([0,carriage_y-bushing_offset-bushing_rad,carriage_x-bushing_len-bushing_stop_offset]) linear_extrude(bushing_len) circle(bushing_rad);
        }        
}


//linear_extrude(belt_height) belt_path2D();