use <V-slot.scad>
use <fillet.scad>

$fn = 25;
vert = 50; // height of your kossel printed corner. default 50;

xbx_l = 77;
xbx_w = 55; 
bracket_h = 20;
bracket_w = 5.25;

zip_h = 4;
zip_w = 2;

vslot_beam_w = 20;
vslot_beam_half = vslot_beam_w/2;

nozzle = .4;
thin_wall = nozzle*2;

v_slot_pos = xbx_w-vert+zip_w*2+vslot_beam_half;

ep = .05; //epsilon extra for removing visual artifacts
er = .1; //extra radius (if your printer prints holes too small)

m5_cap = 8.5;
m5_cap_r = m5_cap/2+er;
m5_cap_d = 5;

m5_major = 5;
m5_rad = m5_major/2+er;

//if you want to add a tab to hold the glass - i used a hex shaped piece of glass. 
gls_tab = true;
gls_tab_only = true;
gls_tab_retract = true;

gls_thk = 5;
extra_w = 5;
tab_r = gls_thk*3/2;
tab_w = vslot_beam_w+extra_w-tab_r;

tab_retract_offset = gls_tab_retract ? 30 : 0;

tab_mnt = 30;

m3_major = 3; // for the Retract Bolt hole
m3_rad = m3_major/2;


//example height of printer bed. the vertex bracket is 50mm tall. the xbox PSU is 55mm tall the glass bed will need to be raised to accomidate this extra height. 

//vslot beam
%translate([xbx_w-vert+zip_w*2,bracket_w,-1])cube([vslot_beam_w,vslot_beam_w,bracket_h+2]);

if(!gls_tab_only){
//vslot beam
%translate([xbx_w-vert+zip_w*2+30,bracket_w,-1])cube([vslot_beam_w,vslot_beam_w,bracket_h+2]);

// xbox example location (slice that is thickness of bracket)
%translate([2,-xbx_l,-1])cube([xbx_w,xbx_l,bracket_h+2]);
}

difference(){
union(){
	if(!gls_tab_only){
	cube([ xbx_w + zip_w*2, bracket_w, bracket_h]);
	translate([v_slot_pos,bracket_w,0])v_slot(bracket_h,0,0);
	} else {
		cube([ tab_mnt, bracket_w, bracket_h]);
	translate([v_slot_pos,bracket_w,0])v_slot(bracket_h,0,0);
	}
}

translate([0,0,0])rotate([0,0,0])fil_linear_i(bracket_h,bracket_w);

if(!gls_tab_only){
//upper Ziptie hole. 
translate([nozzle*2,-ep,(bracket_h-zip_h)-1])
cube([zip_w+ep,bracket_w+2*ep,zip_h]);

//lower ziptie hole. 
translate([xbx_w+zip_w-nozzle*2,-ep,(bracket_h-zip_h)-1])
cube([zip_w+ep,bracket_w+2*ep,zip_h]);

//zip path
translate([zip_w,bracket_w-1.25,(bracket_h-zip_h)-1])cube([xbx_w,zip_w-1,zip_h]);

translate([0,0,-bracket_h+6]){
//upper Ziptie hole. 
translate([nozzle*2,-ep,(bracket_h-zip_h)-1])
cube([zip_w+ep,bracket_w+2*ep,zip_h]);

//lower ziptie hole. 
translate([xbx_w+zip_w-nozzle*2,-ep,(bracket_h-zip_h)-1])
cube([zip_w+ep,bracket_w+2*ep,zip_h]);

//zip path
translate([zip_w,bracket_w-1.25,(bracket_h-zip_h)-1])cube([xbx_w,zip_w-1,zip_h]);
}
}

//Bolt m5
translate([v_slot_pos,-ep,bracket_h/2])rotate([270,0,0])cylinder(r =  m5_rad, h = bracket_w*2 );
//Bolt Cap
translate([v_slot_pos,-.5,bracket_h/2])rotate([270,0,0])cylinder(r =  m5_cap_r, h = 5.5 );
}



// add glass tab holder.

if(gls_tab){
	difference(){
	union(){
		if(gls_tab_retract){
		translate([-gls_thk*2,bracket_w,0])cube([gls_thk*3,tab_w,bracket_h]);
		translate([-gls_thk*2,-tab_mnt+bracket_w,0])cube([gls_thk,tab_mnt,bracket_h]);
		translate([-gls_thk*2-4,+bracket_w+bracket_h/2-tab_retract_offset,bracket_h/2])rotate([0,90,0])cylinder(r1=4,r2 = bracket_h/2,h=4);
		}
		
		translate([-gls_thk*2,bracket_w,0])cube([gls_thk*3,tab_w,bracket_h]);
		translate([-.5,tab_w+gls_thk,0])scale([1.27,1,1])cylinder(r=tab_r,h=bracket_h, $fn = 50);
		translate([xbx_w-vert+zip_w*2,bracket_w+10,0])rotate([0,0,-90])v_slot(bracket_h,0,0);
		translate([0,bracket_w,0])cube([xbx_w-vert+zip_w*2,tab_w,bracket_h]);
		
	}
		if(gls_tab_retract){
		translate([-gls_thk*2-5,+bracket_w+bracket_h/2-tab_retract_offset,bracket_h/2])rotate([0,90,0])cylinder(r=m3_rad,h=8);
		}
		translate([-gls_thk,bracket_w-tab_retract_offset,0])rotate([0,-90,0])fil_linear_i(gls_thk,bracket_h/2);
		translate([-gls_thk*2,bracket_w-tab_retract_offset,bracket_h])rotate([0,90,0])fil_linear_i(gls_thk,bracket_h/2);
		translate([-gls_thk,bracket_w-ep,-ep])cube([gls_thk,vslot_beam_w,bracket_h+2*ep]);
	}
}
