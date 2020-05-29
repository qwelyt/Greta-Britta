module holes(){
    for (i=[0:11]) {
        translate([0, -i-(1.6*i), 0])
        cylinder(d=1, h=10, center=true, $fn=30);
    }
}
difference(){
    cube([18, 33, 1.5],center=true);
    translate([18/2-1.5,33/2-3,0])holes();
    translate([-18/2+1.5,33/2-3,0])holes();
    
}

translate([0,33/2,1.5])cube([7, 6, 2], center=true);
translate([0,33/4,1.5])cube([11,3,1.5],center=true);
translate([0,-33/9,1])cube([11,11,1.5],center=true);
translate([0,-33/2.7,1])cube([11,3,1.5],center=true);
