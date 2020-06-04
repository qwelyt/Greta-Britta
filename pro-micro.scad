pinLocation = 0; // [0, 1,2,3,4]
module holes(){
    for (i=[0:11]) {
        translate([0, (2.54*i), 0])
        cylinder(d=1, h=10, center=true, $fn=30);
    }
}


module pins(numPins){
  space=2.54;
  translate([0,-(space*numPins)/2])
  union(){
    for (i=[0:numPins-1]) {
      translate([0,i*space,0]){
        translate([0,0,2])cube([0.5,0.5,11],center=true);
        minkowski(){
          cube(1.5,center=true);
          sphere(0.25);
        }
        if(i < numPins-1){
          translate([0,1,0])cube(1.3,center=true);
        }
      } 
    }
  }
}

difference(){
    cube([18, 33, 1.5],center=true);
    // translate([18/2-1.5,33/2-3,0])holes();
    translate([18/2-1.5,-33/2+1,0])holes();
    translate([-18/2+1.5,-33/2+1,0])holes();
    // translate([-18/2+1.5,33/2-3,0])holes();
}

if(pinLocation==1){
  translate([18/2-1.5,-0.2,1.8])pins(12);
  translate([-18/2+1.5,-0.2,1.8])pins(12);
} else if(pinLocation==2){
  translate([18/2-1.5,-0.2,-1.8])pins(12);
  translate([-18/2+1.5,-0.2,-1.8])pins(12);
} else if(pinLocation==3){
  translate([18/2-1.5,-0.2,1.8])rotate([0,180,0])pins(12);
  translate([-18/2+1.5,-0.2,1.8])rotate([0,180,0])pins(12);
} else if(pinLocation==4){
  translate([18/2-1.5,-0.2,-1.8])rotate([0,180,0])pins(12);
  translate([-18/2+1.5,-0.2,-1.8])rotate([0,180,0])pins(12);
} else if(pinLocation==0){}

translate([0,33/2,1.5])cube([7, 6, 2], center=true);
translate([0,33/4,1.5])cube([11,3,1.5],center=true);
translate([0,-33/9,1])cube([11,11,1.5],center=true);
translate([0,-33/2.7,1])cube([11,3,1.5],center=true);
