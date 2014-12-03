use <V-slot.scad>
use <fillet.scad>

//--******************--//

//if you want to add a tab to hold the glass - i used a hex shaped piece of glass. 
gls_tab_only = false; // if you don't want the xbox mount set to true
gls_tab_retract = false; // if you want the AutoProbe Retract bolt holder set to true

//--****************-- //


$fn = 25;
vert = 50; // height of your kossel printed corner. default 50;

xbx_l = 77;
xbx_w = 55; 
bracket_h = 18;
bracket_w = 6;

zip_h = 4.5;
zip_w = 2;

vslot_beam_w = 20;
vslot_beam_half = vslot_beam_w/2;

nozzle = .4; // for making thin walls that play nice with your printer. 
thin_wall = nozzle*1;

v_slot_pos = xbx_w-vert+zip_w*2+vslot_beam_half;

ep = .05; //epsilon extra for removing visual artifacts
er = .1; //extra radius (if your printer prints holes too small)

m5_cap = 8.5;
m5_cap_r = m5_cap/2+er;
m5_cap_d = 5;

m5_major = 5;
m5_rad = m5_major/2+er;

gls_thk = 5.65; // this is the thickness of your glass.  
extra_w = 5;

tab_w = vslot_beam_w/2; // length that the tab extends across glass. 

tab_retract_offset = gls_tab_retract ? 30 : 0;

m3_major = 3; // for the Retract Bolt hole
m3_rad = m3_major/2;


//example height of printer bed. the vertex bracket is 50mm tall. the xbox PSU is 55mm tall the glass bed will need to be raised to accomidate this extra height. 

//vslot beam
//%translate([xbx_w-vert+zip_w*2,bracket_w,-1])cube([vslot_beam_w,vslot_beam_w,bracket_h+2]);
 
 
//vslot beam
//%translate([xbx_w-vert+zip_w*2+30,bracket_w,-1])cube([vslot_beam_w,vslot_beam_w,bracket_h+2]);

// xbox example location (slice that is thickness of bracket)
//%translate([2,-xbx_l,-1])cube([xbx_w,xbx_l,bracket_h+2]);


difference(){
union(){
	if(!gls_tab_only){
	cube([ xbx_w + zip_w*2, bracket_w, bracket_h]);
	}else{
		cube([ vslot_beam_w, bracket_w, bracket_h]);
	}
	if(!gls_tab_retract){
	translate([-gls_thk-bracket_w,bracket_w+(vslot_beam_w - tab_w),0])cube([bracket_w,tab_w,bracket_h]);
	} else {
	translate([-gls_thk-bracket_w,bracket_w,0])cube([bracket_w,vslot_beam_w,bracket_h]);
	translate([-bracket_w-gls_thk,bracket_w+bracket_h/2,bracket_h/2])rotate([0,-90,0])cylinder(r1=bracket_h/2, r2 = bracket_h/4,h=3);
	}
translate([0,bracket_w,0])cube([bracket_w,vslot_beam_w,bracket_h]);
translate([-gls_thk-bracket_w,bracket_w+vslot_beam_w,0])cube([v_slot_pos+10+gls_thk+bracket_w,bracket_w,bracket_h]);
translate([v_slot_pos,bracket_w+vslot_beam_w,0])rotate([0,0,180])v_slot(bracket_h,0,0);
translate([v_slot_pos,bracket_w,1+zip_h])v_slot(bracket_h-2*zip_h-2,0,0);
}

if(!gls_tab_only){
//zip tie paths
//upper Ziptie hole. 
translate([nozzle*2-zip_w,-ep,(bracket_h-zip_h)-1])cube([zip_w*2,bracket_w-1,zip_h]);

//lower ziptie hole. 
translate([xbx_w+zip_w-nozzle*2,-ep,(bracket_h-zip_h)-1])cube([zip_w+ep,bracket_w+2*ep,zip_h]);

//zip path
translate([zip_w-bracket_w,bracket_w-zip_w,(bracket_h-zip_h)-1])cube([xbx_w+bracket_w,zip_w-thin_wall,zip_h]);
//#translate([0,bracket_w-zip_w-thin_wall,(bracket_h-zip_h)-1])cube([bracket_w,zip_w,zip_h]);

	translate([0,0,1]){
	//upper Ziptie hole. 
	translate([nozzle*2-zip_w,-ep,0])	cube([zip_w*2,bracket_w-1,zip_h]);
	//rotate([0,0,-50])translate([-zip_w/3,4,0])cube([1,5,zip_h]);

	//lower ziptie hole. 
	translate([xbx_w+zip_w-nozzle*2,-ep,0])	cube([zip_w+ep,bracket_w+2*ep,zip_h]);

	//zip path
	translate([zip_w-bracket_w,bracket_w-zip_w,0])cube([xbx_w+bracket_w,zip_w-thin_wall,zip_h]);
	translate([0,bracket_w-zip_w-thin_wall,0])cube([bracket_w,zip_w,zip_h]);
	}
}

//Bolt m5
translate([v_slot_pos,vslot_beam_w+ep,bracket_h/2])rotate([270,0,0])cylinder(r =  m5_rad, h = bracket_w*2 );
//Bolt Cap
translate([v_slot_pos,vslot_beam_w+bracket_w+.5,bracket_h/2])rotate([270,0,0])cylinder(r =  m5_cap_r, h = 5.5 );


//fillets
translate([0,0,0])fil_linear_i(bracket_h,bracket_w);
translate([v_slot_pos+10,vslot_beam_w+2*bracket_w,0])scale([4,1,1])rotate([0,0,180])fil_linear_i(bracket_h,bracket_w);

if(!gls_tab_retract){
translate([-gls_thk-bracket_w,bracket_w+(vslot_beam_w-tab_w),0])scale([1,5,1])rotate([0,0,0])fil_linear_i(bracket_h,bracket_w);
translate([-gls_thk-bracket_w,vslot_beam_w+2*bracket_w,0])scale([.25,1,1])rotate([0,0,270])fil_linear_i(bracket_h,bracket_w+2);
} else {

//Glass Tab Retract for auto Retract. 
translate([-gls_thk-bracket_w,vslot_beam_w+2*bracket_w,0])rotate([0,0,270])fil_linear_i(bracket_h,bracket_w+2);
translate([-gls_thk,bracket_w,0])rotate([0,-90,0])fil_linear_i(bracket_w,bracket_h/2);
translate([-bracket_w-gls_thk,bracket_w,bracket_h])rotate([0,90,0])fil_linear_i(bracket_w,bracket_h/2);
translate([-bracket_w-gls_thk+2,bracket_w+bracket_h/2,bracket_h/2])rotate([0,-90,0])cylinder(h=bracket_w,r=m3_rad);
}


if(gls_tab_only){
translate([vslot_beam_w,0,0])rotate([0,0,90])fil_linear_i(bracket_h,bracket_w);
translate([vslot_beam_w,bracket_w,0])rotate([0,0,180])fil_linear_i(bracket_h,bracket_w-3);
}

//corners
translate([bracket_w,bracket_w,-ep]) cylinder(r=.5,h=bracket_h+2*ep);
translate([bracket_w,bracket_w+vslot_beam_w,-ep]) cylinder(r=.5,h=bracket_h+2*ep);
}

