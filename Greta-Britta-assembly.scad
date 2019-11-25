include<Greta-Britta.scad>;

module screwHole(h=10,m=3,hat=2){
  cylinder(h=h,d=m,$fn=30);
  cylinder(h=1,d=m*2-1,$fn=30);
  translate([0,0,0.99])cylinder(h=hat,d1=m*2-1,d2=m,$fn=30);
}

// screwHole();

// translate([0,0,2.6])
// %flatTop();

difference(){
  translate([0,0,2.5])flatBottom();

  translate([-space*3.3,space*3.3,0])screwHole();
  translate([space*3.1,space*3.1,0])screwHole();
  translate([0,space*3.3,0])screwHole();

  translate([-space*2.87,-space*3,0])screwHole();
  translate([0,-space*3.2,0])screwHole();
  translate([space*3.1,-space*2.2,0])screwHole();

}