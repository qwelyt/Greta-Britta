cherryCutOutSize=13.9954;
cherrySize=14.58;
space=19.04;
caseThickness=3;
caseZDiff=caseThickness/2;
lowerCaseDistance=caseThickness*12;
xStart=0.0;
yStart=0;
zStart=54;
upperCasePart="All"; // ["All", "Fingers", "Thumb"]
showCut=false;
showPrintBox=false;
showUpperCase=true;
showWalls=true;
showFillers=true;
showLowerCase=true;
showKeys=true;
showKey=true;
showCap=true;
showCutBox=true;
spaceBox=false;
showFingers=true;
showThumb=false;

module col1(addZ=0){
	translate([space*0,space*1.25,22.5+addZ])rotate([0,15,0])children();
}
module col1B(addZ=0){
  col1(-22.5+addZ)rotate([0,-15,0])children();
}

module col2(addZ=0){
	translate([space*0.96,space*0.75,14.7+addZ])rotate([0,12,-1])children();
}
module col2B(addZ=0){
  col2(-14.7+addZ)rotate([0,-12,0])children();
}

module col3(addZ=0){
	translate([space*1.82,space*0,-3.7+addZ])rotate([0,9,-2])children();
}
module col3B(addZ=0){
  col3(3.7+addZ)rotate([0,-9,0])children();
}

module col4(addZ=0){
	translate([space*2.933,space*0.6,1.5+addZ])rotate([0,6,-3.2])children();
}
module col4B(addZ=0){
  col4(-1.5+addZ)rotate([0,-6,0])children();
}


module col5(addZ=0){
	translate([space*4.063,space*1.53,10+addZ])rotate([0,3,-4.6])children();
}
module col5B(addZ=0){
  col5(-10+addZ)rotate([0,-3,0])children();
}

module col6(addZ=0){
	translate([space*5.11,space*1.43,9.5+addZ])rotate([0,0,-5.9])children();
}
module col6B(addZ=0){
  col6(-9.5+addZ)rotate([0,0,0])children();
}


module cherryKey(){
	// Awesome Cherry MX model created by gcb
	// Lib: Cherry MX switch - reference
	// Download here: https://www.thingiverse.com/thing:421524
	//  p=cherrySize/2+0.53;
	translate([0,0,13])
		import("switch_mx.stl");
}

module cherryCap(x=0,y=0,z=0, capSize=1){
	// Awesome caps created by rsheldiii
	// Lib: KeyV2: Parametric Mechanical Keycap Library
	// Download here: https://www.thingiverse.com/thing:2783650

	if(capSize == 1){
		translate([x-0.819,y-0.8,z+3.5])
			import("keycap-dsa-1.0-row3-cherry.stl");
	} else if(capSize==1.25){
		translate([x-0.819,y-0.8,z+3.5])
			import("keycap-dsa-1.25-row3-cherry.stl");
	}

}


module D(cap=1.25){
	C(0,0,0,cap);
}
module C(x=0,y=0,z=0,cap=1){
	union(){
		if(showKey){
			cherryKey();
		}
		if(showCutBox){
			d=14.05;
			p=14.58/2+0.3;
			translate([x,y,z]){
				translate([0,0,-4]){
					cube([d,d,10], center=true);
          
         
					translate([0,-(p-0.6),1.8]) rotate([-10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
					translate([0,-(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);
          
          translate([0,(p-0.6),1.8]) rotate([10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
					translate([0,(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);
				}
			}
		}
		if(showCap){
			cherryCap(0.82,0.8,3, cap);
		}
		if(spaceBox){
			#translate([0,0,7])cube([space*cap,space,space/1.5],center=true);
		}
	}
}
module P(w=space,l=space*1.089,h=caseThickness,center=true){
	cube([w,l,h],center=center);
}

module R(r=1.503,h=space,center=true,fn=50){
	rotate([90,0,0])cylinder(r=r,h=h,center=center,$fn=fn);
}
module RR(r=1.503,fn=50){
	sphere(r=r,$fn=fn);
}

module mountPoint(x=12,y=12){
  difference(){
    cube([x,y,caseThickness],center=true);
    cylinder(r=3,h=caseThickness+2,$fn=30,center=true);
    rotate([0,0,15])cylinder(r=5,h=2,$fn=6);
  }
}

module arcPlacement(radius, angle){
	x = radius - radius*cos(angle);
	y = radius * sin(angle);
	translate([x,y,0]){
		rotate([0,0,-angle])children();
	}
}

module arc(angle, keys, spacing, offset=0){
	off=angle*offset;
	r = angle*(keys-1)+off;
	union(){
		rotate([0,-90,0]){
			for(a = [off:angle:r]){
				arcPlacement(spacing, a) rotate([0,90,0])children();
			}
		}
	}
}

module thumb(){
	// Space
	rotate([0,0,-90])D();
	// Alt
	translate([0,space*1,-space*0.3])rotate([-30,0,0])D();
	// Layers
	translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0]){
		C();
		translate([space,0,0])C();
	}
}

module keys(){
  if(showFingers){
    col1()arc(12,4,space*5.1)C();
    col2()arc(12,4,space*5.1)C();
    col3()arc(12,5,space*5.1)C();
    col4()arc(12,5,space*5.1)C();
    col5()arc(12,5,space*5.1)C();
    col6(){
      arc(12,1,space*5.1)C();
      translate([space/8,0,0])arc(12,4,space*5.1,1)D();
    }
  }
	if(showThumb){
		translate([space*1.2,space*5,space*2.7])rotate([10,0,40])thumb();
	}
}

module upperFingerCase(){
  union(){
    // Keymounts
    col1(-caseZDiff)arc(12,4,space*5.1)P();
    col2(-caseZDiff)arc(12,4,space*5.1)P();
    col3(-caseZDiff)arc(12,5,space*5.1)P();
    col4(-caseZDiff)arc(12,5,space*5.1)P();
    col5(-caseZDiff)arc(12,5,space*5.1)P();
    col6(-caseZDiff){
      arc(12,2,space*5.1)P(w=space*1.05);
      translate([space/8,0,0])arc(12,4,space*5.1,1)P(w=space*1.35);
    }
    
    // fill
    if(showFillers){
        {// 1-2
          for(x = [0:3]){
            hull(){
              col1(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.492,0,0])P(w=0.3);

              col2(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.507,0,0])P(w=0.3);
            }
          }
        }
        { // 2-3
          for(x = [0:3]){
            hull(){
              col2(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.47,0,0])P(w=1);
              col3(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.549,0,0])P(w=1);
            }
          }
          col3(-caseZDiff)arc(12,5,space*5.1,0)translate([-space*0.5,0,0])P(w=1);    
        }
        { // 3-4
          for(x = [0:4]){
            hull(){
              col3(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.5,0,0])P(w=0.3);
              col4(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.5,0,0])P(w=0.3);
            }
          }
          for(x = [0:1]){
            hull(){
              col3(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.52,0,0])P(w=1);
              col4(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.48,0,0])P(w=1);
            }
          }

          hull(){
            col3(-caseZDiff)arc(12,1,space*5.1,2)translate([space*0.52,0,0])P(w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,1)translate([-space*0.48,0,0])P(w=1);
          }

          hull(){
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.48,0,0])P(w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,0,0])P(w=1);
          }
        }
        { // 4-5
          for(x=[0:4]){
            hull(){
              col4(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.5,0,0])P(w=0.3);
              col5(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.5,0,0])P(w=0.3);
            }
          }
          for(x=[0:1]){
            hull(){
              col4(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.52,0,0])P(w=1);
              col5(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.48,0,0])P(w=1);
            }
          }
          for(x=[0:1]){
            hull(){
              col4(-caseZDiff)arc(12,1,space*5.1,x+1)translate([space*0.52,0,0])P(w=1);
              col5(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.48,0,0])P(w=1);
            }
          }

          for(x=[3:4]){
            hull(){
              col4(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.48,0,0])P(w=1);
              col5(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.52,0,0])P(w=1);
            }
          }
        }
        { //5-6
          for(x = [0:4]){
            hull(){
              col5(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.47,0,0])P(w=1);
              col6(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.549,0,0])P(w=1);
            }
          }
        }
      
    }
    // Walls
    if(showWalls){
        { // Col 1
          for(x=[0:3]){ // Side
            hull(){
          col1(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.5,0,0])P(w=caseThickness);
            col1(-caseZDiff)arc(12,1,space*5.1,x)translate([-space*0.5,0,-space])P(w=caseThickness,l=space*1.3);
            }
          }
          
          hull(){ // Front
            col1(-caseZDiff)arc(12,1,space*5.1,0)translate([-caseThickness/4,-space*0.52,0])P(l=caseThickness,w=space+caseThickness/2);
            col1(-caseZDiff)arc(12,1,space*5.1,0)translate([-caseThickness/4,-space*0.572,-space])P(l=caseThickness,w=space+caseThickness/2);
          }
          
          { // back
            
          }
        }
        { // col 1-2
          hull(){ // Front
            col1(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.474,-space*0.52,0])P(l=caseThickness,w=1);
            col1(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.474,-space*0.572,-space])P(l=caseThickness,w=1);
            col2(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.49,-space*0.52,0])P(l=caseThickness,w=1);
            col2(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.49,-space*0.572,-space])P(l=caseThickness,w=1);
          }
        }
        { // col 2
          hull(){ // front
            col2(-caseZDiff)arc(12,1,space*5.1,0)translate([-caseThickness*0.05,-space*0.52,0])P(l=caseThickness,w=space+caseThickness*0.1);
            col2(-caseZDiff)arc(12,1,space*5.1,0)translate([-caseThickness*0.05,-space*0.572,-space])P(l=caseThickness,w=space+caseThickness*0.1);
          }
          
        }  
        { // col 2-3
          hull() { // Front
            col2(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.474,-space*0.52,0])P(l=caseThickness,w=1);
            col2(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.474,-space*0.572,-space])P(l=caseThickness,w=1);
            col3(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.5494,-space*0.35,0])P(l=caseThickness,w=1);
            col3(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.5494,-space*0.35,-space])P(l=caseThickness,w=1);
          }
        }
        { // col 3
          hull(){ // Front
            col3(-caseZDiff)arc(12,1,space*5.1,0)translate([-caseThickness*0.092,-space*0.47,0])P(l=caseThickness,w=space+caseThickness*0.77);
            col3(-caseZDiff)arc(12,1,space*5.1,0)translate([-caseThickness*0.092,-space*0.35,-space])P(l=caseThickness,w=space+caseThickness*0.77);
          }
          hull(){ // Back
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([-caseThickness*0.092,space*0.466,0])P(l=caseThickness,w=space*1.024);
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([-caseThickness*0.092,space*0.65,-space])P(l=caseThickness,w=space*1.024);
          }
        }
        { //col 3-4
          hull() { // Front
            col3(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.52,-space*0.35,0])P(l=caseThickness,w=1);
            col3(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.52,-space*0.35,-space])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.48155,-space*0.47,0])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.48155,-space*0.47,-space])P(l=caseThickness,w=1);
          }
          
          hull(){ // Back
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.48,space*0.47,0])P(l=caseThickness,w=1);
          col3(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.48,space*0.65,-space])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.520,space*0.465,0])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,space*0.8,-space])P(l=caseThickness,w=caseThickness);
          }
        }
        { // col 4
          hull(){ // front
            col4(-caseZDiff)arc(12,1,space*5.1,0)translate([caseThickness*0.125,-space*0.47,0])P(l=caseThickness,w=space+caseThickness*0.35);
            col4(-caseZDiff)arc(12,1,space*5.1,0)translate([caseThickness*0.125,-space*0.47,-space])P(l=caseThickness,w=space+caseThickness*0.35);
          }
          
          hull(){ //back
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.48,space*0.465,0])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.520,space*0.465,0])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.3,space*0.8,-space])P(l=caseThickness,w=caseThickness);
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,space*0.8,-space])P(l=caseThickness,w=caseThickness);
          }
        }
        { // col 4-5
          hull(){ // front
           col4(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.521,-space*0.47,0])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.521,-space*0.47,-space])P(l=caseThickness,w=1);
            col5(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.48155,-space*0.47,0])P(l=caseThickness,w=1);
            col5(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.48155,-space*0.47,-space])P(l=caseThickness,w=1);
          }
          
          hull(){ // back
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.48,space*0.465,0])P(l=caseThickness,w=1);
            col4(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.3,space*0.8,-space])P(l=caseThickness,w=caseThickness);
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,space*0.48,-space*0.15])P(l=caseThickness,w=1);
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,space*0.102,-space])P(l=caseThickness,w=1);
          }
        }
        { // col 5
          { // col 5
          hull(){ // front
            col5(-caseZDiff)arc(12,1,space*5.1,0)translate([caseThickness*0.125,-space*0.47,0])P(l=caseThickness,w=space+caseThickness*0.35);
            col5(-caseZDiff)arc(12,1,space*5.1,0)translate([caseThickness*0.125,-space*0.47,-space])P(l=caseThickness,w=space+caseThickness*0.35);
          }
          
          hull(){ // back, top part
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([caseThickness*0.41,space*0.466,0])P(l=caseThickness,w=space+caseThickness*1.4);
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.39,space*0.567,-space*0.15])P(l=caseThickness,w=1);
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,space*0.48,-space*0.15])P(l=caseThickness,w=1);
          }
          
          hull(){ // back
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.39,space*0.568,-space*0.15])P(l=caseThickness,w=1);
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,space*0.48,-space*0.15])P(l=caseThickness,w=1);
            
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.375,space*0.156,-space*1.003])P(l=caseThickness,w=0.1);
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.52,space*0.102,-space])P(l=caseThickness,w=1);
          }
          
        }
          
        }
        { // col 5-6
          hull(){ // Front
           col5(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.521,-space*0.47,0])P(l=caseThickness,w=1);
            col5(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.521,-space*0.47,-space])P(l=caseThickness,w=1);
            col6(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.48155,-space*0.47,0])P(l=caseThickness,w=1);
            col6(-caseZDiff)arc(12,1,space*5.1,0)translate([-space*0.48155,-space*0.47,-space])P(l=caseThickness,w=1);
          }
          
          
          
        }
        { // col 6
          hull(){ // Front
            col6(-caseZDiff)arc(12,1,space*5.1,0)translate([caseThickness*0.125,-space*0.47,0])P(l=caseThickness,w=space+caseThickness*0.35);
            col6(-caseZDiff)arc(12,1,space*5.1,0)translate([caseThickness*0.125,-space*0.47,-space])P(l=caseThickness,w=space+caseThickness*0.35);
          }
          hull(){ // Side
            col6(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.4685,-space*0.004,0])P(w=caseThickness);
            col6(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.4685,-space*0.004,-space])P(w=caseThickness);
          }
         
          hull(){ // 1uSide - 1.25uSide
           col6(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.4685,space*0.4617,0])P(w=caseThickness,l=caseThickness);
            col6(-caseZDiff)arc(12,1,space*5.1,1)translate([space*0.722,-space*0.47,0])P(w=caseThickness,l=caseThickness);
            col6(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.4684,space*0.4617,-space])P(w=caseThickness,l=caseThickness);
            col6(-caseZDiff)arc(12,1,space*5.1,1)translate([space*0.8,-space*0.57,-space])P(w=caseThickness,l=caseThickness);
          }
          
          for(x=[1:3]){ // side
            hull(){
              col6(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.722,0,0])P(w=caseThickness);
              col6(-caseZDiff)arc(12,1,space*5.1,x)translate([space*0.8,0,-space])P(w=caseThickness,l=space*1.3);
            }
          }
          
          hull(){ // side, last section
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.722,0,0])P(w=caseThickness);
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.8,-space*0.13,-space])P(w=caseThickness,l=space*1.05);
          }
        
          hull(){ // back, top part
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([caseThickness*0.41,space*0.466,0])P(l=caseThickness,w=space+caseThickness*3);
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([caseThickness*0.41,space*0.57123,-space*0.15])P(l=caseThickness,w=space+caseThickness*3);
          }
          hull(){ // Back
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([caseThickness*0.41,space*0.57123,-space*0.15])P(l=caseThickness,w=space+caseThickness*3);
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.8525,space*0.32,-space*1.053])P(l=caseThickness,w=1,h=1);
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.7,space*0.16,-space])P(l=caseThickness,w=1);
          }
          
         
          hull(){ // Back-side filler
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.8525,space*0.32,-space*1])P(l=caseThickness,w=1,h=caseThickness);
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.774,space*0.518,1])P(l=1,w=1,h=1);
            col6(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.774,space*0.623,-caseThickness*0.62])P(l=1,w=1,h=1);
          }
        }
      
        { // Mountpoints
          { // Fingers <-> Thumb
            col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-caseThickness,space*0.53,-space*0.7])rotate([96,0,0])mountPoint();
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([-caseThickness*5,space*0.52+caseThickness*0.4,-space*0.7])rotate([100,0,0])mountPoint();
          }
          { // Upper <-> Lower
            col1(-caseZDiff)arc(12,1,space*5.1,0)translate([-caseThickness,-5,-space*0.95])mountPoint();
            col3(-caseZDiff)arc(12,1,space*5.1,0)translate([0,0,-space*0.95])mountPoint();
            col5(-caseZDiff)arc(12,1,space*5.1,0)translate([space*0.5,-2,-space*0.95])mountPoint();
            
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([0,5,-space*0.95])mountPoint();
            col5(-caseZDiff)arc(12,1,space*5.1,4)translate([space*0.5,-3,-space*0.95])mountPoint();
          }
        }
    }
  }
}


module upperThumbCase(){
  union(){
    // Thumb
    translate([space*1.2,space*5,space*2.7-caseThickness/2])rotate([10,0,40]){
      rotate([0,0,-90])P();// Space

      translate([0,space*1,-space*0.3])rotate([-30,0,0])P();// Alt

      translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0]){// Layers
        P();
        translate([space,0,0])P();
      }
    }
    // fill
    if(showFillers){
      { //Thumb
        translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40]){

          { // Space-Alt
            hull(){
              rotate([0,0,-90])translate([-space*0.472,0,0])P(w=1); // space
              translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([0,-space*0.518,0])P(l=1); // Alt
            }
          }
          { // Space - Space, fill gap
            hull(){ 
              rotate([0,0,-90])translate([-space*0.1,-space*0.5182,0])P(l=1,w=space*0.7); // space
              rotate([0,0,-90])translate([-space*0.1,-space*0.485,-caseZDiff*4])P(l=1,w=space*0.4); // space
            }
          }

          { // Alt-Layers
            hull(){
              translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([0,space*0.518,0])P(l=1); // Alt
              translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([0,-space*0.518,0])P(l=1); // Layer
            }        
          }

          { // Alt-Layers
            hull(){
              translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([0,space*0.518,0])P(l=1); // Alt
              translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space,-space*0.518,0])P(l=1); // Layers
            }       
          }

          { // Space - layer
            hull(){
              translate([space*0.518,space*0.473,0])P(l=1,w=1); // space
              translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space,-space*0.518,0])P(l=1); // Layers
            }
          }
          { // Space - alt
            hull(){
              translate([space*0.518,space*0.473,0])P(l=1,w=1); // space
              translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([space*0.9,space*0.518,0])P(l=1,w=space*0.8); // Alt
            }
          }
          { // Alt - Layers
            hull(){
              translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([space*0.9,space*0.518,0])P(l=1,w=space*0.8); // Alt
              translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space,-space*0.518,0])P(l=1); // Layers
            }
          }
        }
      }
      { // Cols - Thumb
        { // col1 - Thumb
          hull(){
            col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-space*0.5,space*0.52,0])P(w=caseThickness,l=1);
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([-space*0.518,-space*0.518,0])P(w=1,l=1); // Alt
            translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([-space*0.518,space*0.518,0])P(w=1,l=1); // Alt
          }
          hull(){
            col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-space*0.5,space*0.52,0])P(w=caseThickness,l=1);
          col1(-caseZDiff)arc(12,1,space*5.1,3)translate([space*0.5,space*0.52,0])P(w=caseThickness,l=1);
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([-space*0.518,-space*0.518,0])P(w=1,l=1); // Alt
          }

          col1(-caseZDiff)arc(12,1,space*5.1,3)translate([space*0.5,space*0.345,0])P(w=space*0.1,l=space*0.5);

          hull(){ // col1 - space
            col1(-caseZDiff)arc(12,1,space*5.1,3)translate([space*0.57,space*0.345,0])P(w=1,l=space*0.5);
            translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])rotate([0,0,-90])translate([space*0.35,-space*0.52,0])P(w=space*0.35,l=1); // space
          }
          { // Space - Col1
            hull(){
              translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])rotate([0,0,-90])translate([space*0.52,-space*0.52,0])P(w=1,l=1); // space
              col1(-caseZDiff)arc(12,1,space*5.1,3)translate([space*0.48,space*0.6,0])P(w=0.3,l=1,h=0.3);
            col1(-caseZDiff)arc(12,1,space*5.1,3)translate([space*0.5315,space*0.0721,4.43])P(w=1,l=1,h=0.3);
            }
          }
          
        }
        { // col2 - Thumb
          hull(){
            col2(-caseZDiff)arc(12,1,space*5.1,3)translate([0,space*0.569,0])P(l=1);
            translate([space*1.2,space*5,space*2.7-caseThickness/2])rotate([10,0,40])rotate([0,0,-90])translate([space*0.52,0,0])P(w=1); // space
          }
        }
        { // col3 - Thumb
          hull(){ //Space
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.5,space*0.63,-0.5])P(l=caseThickness,w=caseThickness);
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.5,space*0.8,-space])P(l=caseThickness,w=caseThickness);
            translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])rotate([0,0,-90])translate([space*0.52,space*0.465,0])P(w=1,l=caseThickness); // Space
          }
          hull(){ // Space - alt/layers, upper
            translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])rotate([0,0,-90])translate([space*0.52,space*0.465,0])P(w=1,l=caseThickness); // Space    
            translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])rotate([0,0,-90])translate([-space*0.473,space*0.465,0])P(w=1,l=caseThickness); // Space
            translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([space*1.2212,space*0.518,0])P(w=caseThickness,l=1); // Alt
          }
          hull(){ // Space - layers, lower
            col3(-caseZDiff)arc(12,1,space*5.1,4)translate([-space*0.5,space*0.65,-space])P(l=caseThickness,w=caseThickness);
            translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])rotate([0,0,-90])translate([space*0.52,space*0.465,0])P(w=1,l=caseThickness); // Space    
            

          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space*1.7,-space*0.3,-space])P(l=space*1.09,w=caseThickness);
          }
        }
        
        hull(){// layers, inner, top
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])rotate([0,0,-90])translate([space*0.52,space*0.465,0])P(w=1,l=caseThickness); // Space
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space*1.7,-space*0.8187,-space])P(l=1,w=caseThickness); // layer
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([space*1.2212,space*0.518,0])P(w=caseThickness,l=1); // Alt
        }
        hull(){ // // layers, inner, small dip mid
         translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space*1.42,0,0])P(l=space*1.09,w=caseThickness);
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space*1.7,-space*0.8187,-space])P(l=1,w=caseThickness); // layer
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([space*1.2212,space*0.518,0])P(w=caseThickness,l=1); // Alt
        }
        hull(){ // layers, inner, bottom
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space*1.42,0,0])P(l=space*1.09,w=caseThickness);
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([space*1.7,-space*0.3,-space])P(l=space*1.09,w=caseThickness);
        }
        
        
        hull(){ // layers-col1, outer, upper
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([-space*0.4212,-space*0.518,0])P(l=1,w=caseThickness); // layers
          col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-space*0.5,space*0.52,0])P(w=caseThickness,l=1);
          col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-space*0.5,space*0.624,-space])P(w=caseThickness,l=1);
        }
        hull(){ // layers-col1, outer, lower
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([-space*0.4212,-space*0.518,0])P(l=1,w=caseThickness); // layers
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([-space*0.4212,space*0.518,0])P(l=1,w=caseThickness); // layers
          col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-space*0.5,space*0.624,-space])P(w=caseThickness,l=1);

        }
        hull(){ // layers-col1-alt, outer, upper. small gap
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([-space*0.2,space*1.75,-space*1.05])rotate([-60,0,0])translate([-space*0.4212,-space*0.518,0])P(l=1,w=caseThickness); // layers
          translate([space*1.2,space*5,space*2.7-caseZDiff])rotate([10,0,40])translate([0,space*1,-space*0.3])rotate([-30,0,0])translate([-space*0.465,space*0.518,0])P(w=caseThickness,l=1); // Alt
          col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-space*0.5,space*0.52,0])P(w=caseThickness,l=1);
        }
      }
    }
    
    { // Mountpoints
      { // Fingers <-> Thumb
        col1(-caseZDiff)arc(12,1,space*5.1,3)translate([-caseThickness,space*0.52+caseThickness*1.33,-space*0.7])rotate([-84,0,0])mountPoint();
        col3(-caseZDiff)arc(12,1,space*5.1,4)translate([-caseThickness*5,space*0.52+caseThickness*1.5,-space*0.67])rotate([-80,0,0])mountPoint();
      }
    }
  }
}


module upperCase(){
  union(){
    if(showFingers){
      upperFingerCase();
    }

    if(showThumb){
      upperThumbCase();
    }
  }
}

module lowerCase(){
  module c1Wall(x,y){
    hull(){
      col1B(-lowerCaseDistance)translate([-space*0.422,space*x,0])P(w=caseThickness);
      rotate([-24,1.3,-0.55])col1(-caseZDiff)arc(12,1,space*5.1,y)translate([-space*0.5,0,-space])P(w=caseThickness,l=space*1.3);
    }
  }
  col1B(-lowerCaseDistance){
    for(x=[0:4]){
      translate([0,space*x,0])P(w=space*1);
    }
  }

  for(x=[0:3])c1Wall(x,x);
    c1Wall(4,3);

  
	col2B(-lowerCaseDistance){
    for(x=[0:4])translate([0,space*x,0])P(w=space*1.1);
  }
	col3B(-lowerCaseDistance){
    for(x=[0:5])translate([0,space*x,0])P(w=space*1.0);
  }
  col4B(-lowerCaseDistance){
    for(x=[0:5])translate([0,space*x,0])P(w=space*1.5);
  }
	col5B(-lowerCaseDistance){
    for(x=[0:4])translate([0,space*x,0])P(w=space*1.0);
    translate([0,space*4.4,0])P(w=space*1.0);
  }
	col6B(-lowerCaseDistance){
		P(w=space*1.15);
		translate([space/8,0,0])translate([0,space,0])for(x=[0:3])translate([-space*0.1,space*x,0])P(w=space*1.55);
    translate([space/8,0,0])translate([0,space,0])translate([-space*0.1,space*3.4,0])P(w=space*1.55);
	}
  
  // Walls
//  col1B(-lowerCaseDistance){
//    hull(){
//      translate([-space*0.5,-space*0.545,space])cube(caseThickness);
//      translate([-space*0.5,-space*0.545,0])cube(caseThickness);
//      
//      translate([space*0.25,-space*0.545,space])cube(caseThickness);
//      translate([space*0.25,-space*0.545,0])cube(caseThickness);
//    }
//    
//    hull(){
//      translate([-space*0.5,-space*0.545,space])cube(caseThickness);
//      translate([-space*0.5,-space*0.545,0])cube(caseThickness);
//      
//      translate([-space*0.5,space*4.387,space])cube(caseThickness);
//      translate([-space*0.5,space*4.387,0])cube(caseThickness);
//    }
//  }
}


if(showPrintBox){
  #cube([140,140,140]);
}

module keeb(){
  translate([17,18.8,42])
  rotate([-24,1.3,0]){
  //translate([20,15,50])
  //rotate([-24,11,0]){
    
    if(showCut){
      if ( upperCasePart == "All" ){
        difference(){
          union(){upperCase();}
          keys();
        } 
      } else if(upperCasePart == "Fingers" ){
        difference(){
          union(){upperFingerCase();}
          upperThumbCase();
          keys();
        }
      } else if (upperCasePart == "Thumb" ){
        difference(){
          union(){ upperThumbCase();}
          upperFingerCase();
          keys();
        }
      }
    } else {  
      if(showKeys){
        keys();
      }

      if ( upperCasePart == "All" ){
          union(){upperCase();}

      } else if(upperCasePart == "Fingers" ){
          union(){upperFingerCase();}
      } else if (upperCasePart == "Thumb" ){
          union(){ upperThumbCase();}
      }
    }
    
    if(showLowerCase){
      rotate([24,-1.3,0])lowerCase();
    }
    

  }
}
keeb();
//translate([-space*3,0,0])mirror([1,0,0])keeb();
//difference(){
//  union(){
//    for(x= [0:2]){ 
//      for(y=[0:2]){
//        translate([space*x,space*y,0]){
//          P();
//        }
//      }
//    }
//  }
//  for(x= [0:2]){ 
//    for(y=[0:2]){
//      translate([space*x,space*y,0]){
//          translate([0,0,1])C();
//      }
//    }
//  }
//}
//C();

//difference(){
//mountPoint();
//translate([0,0,0])cylinder(r=4,h=2,$fn=6);
//}
