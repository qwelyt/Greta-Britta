module pins(numPins){
  space=2.6;
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

module proMicro(pins=true){
  translate([0,0,-0])import("pro-micro.stl");
  if(pins){
    translate([7.5,0.5,1.75])pins(12);
    translate([-7.5,0.5,1.75])pins(12);
  }
}
module holder_base(){
  difference(){
    cube([22,37,4.5], center=true);
    cube([18.2,33.2,6], center=true);
    translate([0,17,1.7])cube([8,4,3], center=true);
    translate([0,-17,2])cube([23,2,2.6],center=true);
  }
  translate([0,0,-1.6])cube([10,37,1.3],center=true);
}

module holder_lid(){
  union(){
    translate([0,-2,2.8])cube([10,30,1],center=true);
    translate([0,-17,2])cube([22,2,2.6],center=true);
  }
}

// proMicro();
// holder_base();
holder_lid();

