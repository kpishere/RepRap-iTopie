$fn=50;

bushing_height=20;
bushing_len=13.5;
bushing_outer_rad=13/2;
bushing_hole_rad=5/2;
bushing_bearing_rad=6.4/2;
bushing_step_len=1;
bushing_body_len=bushing_height-bushing_len;

bushing_x_len=44;
bushing_x_offset=8;
bushing_y_len=30;
bushing_y_offset=bushing_y_len/2-bushing_outer_rad-5;

m5_rad=5/2;

difference() {
    union() {
        cylinder(bushing_height-bushing_step_len,r1=bushing_outer_rad,r2=bushing_outer_rad);
        cylinder(bushing_height,r1=bushing_bearing_rad,r2=bushing_bearing_rad);
        translate([0,bushing_y_offset,bushing_body_len/2])
        cube([bushing_x_len,bushing_y_len,bushing_body_len],center=true);
    }
    // shaft hole
    translate([0,0,-.1])
    cylinder(bushing_height+0.2,r1=bushing_hole_rad,r2=bushing_hole_rad); 
    // mount holes
    translate([bushing_x_offset+bushing_outer_rad,0,-.1])
    cylinder(bushing_body_len+0.2,r1=m5_rad,r2=m5_rad); 
    translate([-(bushing_x_offset+bushing_outer_rad),0,-.1])
    cylinder(bushing_body_len+0.2,r1=m5_rad,r2=m5_rad); 
}