module pins(numPins){
  space=2.54;
  translate([0,-(space*numPins)/2])
  union(){
    for (i=[0:numPins-1]) {
      translate([0,i*space,0]){
        difference(){
          cube([2,space,8],center=true);
          translate([0,0,2])cube([1,1,8],center=true);
        }
        translate([0,0,-5.5])cube([0.1,0.5,3],center=true);
      } 
    }
  }
}

pins(12);