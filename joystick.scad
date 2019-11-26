// Super rough sketch of "Thumb Slide Joystick" COM-09429 by SparkFun
// https://media.digikey.com/pdf/Data%20Sheets/Sparkfun%20PDFs/COM-09426_Web.pdf
$fn=50;

module body() {
  difference(){
    cube([20,20,5],center=true);
    rotate([0,0,45])translate([16,0,0])cube([10,20,7],center=true);
    rotate([0,0,-45])translate([16,0,0])cube([10,20,7],center=true);
    rotate([0,0,45])translate([-16,0,0])cube([10,20,7],center=true);
    rotate([0,0,-45])translate([-16,0,0])cube([10,20,7],center=true);
  }
  translate([0,0,2.5])cylinder(d=20, h=1, center=true);
  translate([0,0,2.7])cylinder(d=16, h=1, center=true);
}

module stick(){
  cylinder(d=3, h=5, center=true);

  translate([0,0,3])
  scale([1,1,0.2])
  sphere(d=13);
}

module mount() {
  difference(){
    minkowski() {
      cube([10,2.7,1],center=true);
      translate([1.5,0,0])cylinder(d=1.5, h=0.1, center=true);
    }
    translate([-2,0,0])cylinder(d=2.7, h=3, center=true);
  }
}

module joystick(){
  body();
  translate([0,0,2.5])stick();

  translate([-9.5,7.8,-1])mount();
  translate([8,8,-1])rotate([0,0,-135])mount();
}
