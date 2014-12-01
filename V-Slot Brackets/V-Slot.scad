//start
module  v_slot(l = 1, w = 15, mnt_d = 3) 
{ 
big_w = 8.3; // big side on the trapizoid
small_w = 4.5; // small side on the trapizoid
thk = 1.9; // thickness of the trapizoid

a = big_w/2;
b = small_w/2;
c = thk;
d = 0;

	linear_extrude(height=l, center=false) {
	polygon(points = [ [-a,d],[a,d],[b,c],[-b,c]],paths = [[0,1,2,3]]);
	}
	translate([-w/2,-mnt_d,0])
	cube([w,mnt_d,l]);
}

v_slot(20);
