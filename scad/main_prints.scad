// iTopie RepRap - Main file
//
// @version 1.0
// @license GPLv3
// @docs    http://reprap.org/wiki/ITopie  
// @sources https://github.com/lautr3k/RepRap-iTopie 
// @author  Kevin Peck <skarab>
//
use     <parts/x_end_idler.scad>
use     <parts/x_end_motor.scad>

translate([0,50,0]) end_idler();
translate([0,-90,0]) rotate([0,0,180]) end_motor();