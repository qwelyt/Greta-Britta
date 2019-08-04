showCut=false;
showSwitchCut=true;
keyboardPlacement=[-32,-60,42];
keyboardRotation=[336,12,7];
showSwitch=false;
showKeyCap=false;
showSpaceBox=false;
space=19.04;

/*[case]*/
showUpperCase=true;
showBottomCase=false;
caseThickness=3;
caseZDiff=caseThickness/2;
fillerWidth=caseThickness/2;
leftFillerPlacement=[space*0.5-(fillerWidth*0.5),0,0];
rightFillerPlacement=[-space*0.5+(fillerWidth*0.5),0,0];

/*[Thumb placement]*/
thumbXSpace=0.4;
thumbYSpace=4.5;
thumbZSpace=1.8;
thumbRX=20;
thumbRY=-20;
thumbRZ=-20;
thumbX=space*thumbXSpace;
thumbY=space*thumbYSpace;
thumbZ=space*thumbZSpace;


/*[Cherry MX settings]*/
cherryCutOutSize=13.9954;
cherrySize=14.58;


/*[ Printer settings ]*/
showPrintBox=false;
printerSize=[140,140,140];


// ---- Columns ----
module col1(addZ=0,rotation=[0,15,0]){
	translate([space*0,space*1.25,22.5+addZ])rotate(rotation)children();
}
module col1B(addZ=0){
  col1(-22.5+addZ,rotation=[0,0,0])children();
}


module col2(addZ=0,rotation=[0,12,-1]){
	translate([space*0.96,space*0.75,14.7+addZ])rotate(rotation)children();
}


module col3(addZ=0){
	translate([space*1.82,space*0,-3.7+addZ])rotate([0,9,-2])children();
}


module col4(addZ=0){
	translate([space*2.933,space*0.6,1.5+addZ])rotate([0,6,-3.2])children();
}

module col5(addZ=0){
	translate([space*4.063,space*1.53,10+addZ])rotate([0,3,-4.6])children();
}

module col6(addZ=0){
	translate([space*5.11,space*1.43,9.5+addZ])rotate([0,0,-5.9])children();
}

// ---- Key related "libs" ----
module cherrySwitch(){
	// Awesome Cherry MX model created by gcb
	// Lib: Cherry MX switch - reference
	// Download here: https://www.thingiverse.com/thing:421524
	//  p=cherrySize/2+0.53;
	translate([0,0,13])
		import("switch_mx.stl");
}

module cherryCap(x=0,y=0,z=0, capSize=1, homing=false){
	// Awesome caps created by rsheldiii
	// Lib: KeyV2: Parametric Mechanical Keycap Library
	// Download here: https://www.thingiverse.com/thing:2783650

	if(capSize == 1){
		translate([x-0.819,y-0.8,z+3.5]){
      if(homing){
        rotate([0,0,180])import("keycap-dsa-1.0-row3-homing-cherry.stl");
      } else {
        import("keycap-dsa-1.0-row3-cherry.stl");
      }
    }
	} else if(capSize==1.25){
		translate([x-0.819,y-0.8,z+3.5])
			import("keycap-dsa-1.25-row3-cherry.stl");
	}

}

// ---- Various ----
module screwIn(ro=5,ri=2,h=5){
  difference(){
    cylinder(r=ro,h=h,$fn=30,center=true);
    cylinder(r=ri,h=h+1,$fn=30,center=true);
    translate([0,0,-((h/2))])cylinder(r1=3,r2=2,h=1,$fn=30,center=true);
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

// ---- Keyboard basics ----
module mxSwitchCut(x=0,y=0,z=0){
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

module Key(x=0,y=0,z=0,cap=1,homing=false){
  union(){
    if(showSwitch){
      cherrySwitch();
    }
    if(showSwitchCut){
      mxSwitchCut(x,y,z);
    }
    if(showKeyCap){
			cherryCap(0.82,0.8,3, cap,homing);
		}
    if(showSpaceBox){
			#translate([0,0,7])cube([space*cap,space,space/1.5],center=true);
		}
    if(showCut){
			translate([0,0,7])cube([space*cap,space*1.065,space/1.5],center=true);
		}
  }
}

module KeyPlate(w=space,l=space*1.089,h=caseThickness,center=true){
	cube([w,l,h],center=center);
//  KeyPlate2(w,l,h);
}

module KeyPlate2(w=space,l=space*1.089,h=caseThickness,center=true){
  minkowski(){
    cube([w-1,l-1,h-1],center=center);
    sphere(d=1,$fn=20);
  }
}

// ---- Keyboard ----

module fingerSwitchPlacement(){
  col1()arc(12,4,space*5.1)Key();
  {
    col2()arc(12,2,space*5.1)Key();
    col2()arc(12,1,space*5.1,2)Key(homing=true);
    col2()arc(12,1,space*5.1,3)Key();
  }
  col3()arc(12,5,space*5.1)Key();
  col4()arc(12,5,space*5.1)Key();
  col5()arc(12,5,space*5.1)Key();
  col6(){
    arc(12,1,space*5.1)Key();
    translate([space*0.125,0,0])arc(12,4,space*5.1,1)Key(cap=1.25);
  }
}

module thumbSwitchPlacement(){

  translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])Key();
//  translate([-space*1.15,-space*0.11,space*0.06])rotate([-30,10,0])arc(40,1,space*1.8,0)rotate([0,0,-90])Key();
  translate([0,space,0])rotate([-30,0,90])arc(40,2,space*1.8)rotate([0,0,-90])Key();
}

module switchPlacement(){
  fingerSwitchPlacement();
  
  translate([thumbX,thumbY,thumbZ])
  rotate([thumbRX,thumbRY,thumbRZ])
  thumbSwitchPlacement();
}

module fingerKeyPlates(){
  col1(-caseZDiff)arc(12,4,space*5.1)KeyPlate();
  col2(-caseZDiff)arc(12,4,space*5.1)KeyPlate();
  col3(-caseZDiff)arc(12,5,space*5.1)KeyPlate();
  col4(-caseZDiff)arc(12,5,space*5.1)KeyPlate();
  col5(-caseZDiff)arc(12,5,space*5.1)KeyPlate();
  col6(-caseZDiff){
    arc(12,1,space*5.1)KeyPlate();
    translate([space*0.125,0,0])arc(12,4,space*5.1,1)KeyPlate();
  }
}
module fingerPlateFillers(){
  for(i=[0:3]){ // Col1-col2
    hull(){
      col1(-caseZDiff)arc(12,1,space*5.1,i)translate(leftFillerPlacement)KeyPlate(w=fillerWidth);
      col2(-caseZDiff)arc(12,1,space*5.1,i)translate(rightFillerPlacement)translate([-fillerWidth,0,0])KeyPlate(w=fillerWidth);
    }
  }
  
  {
    for(i=[0:3]){ // Col2-Col3
      hull(){
        col2(-caseZDiff)arc(12,1,space*5.1,i)translate(leftFillerPlacement)KeyPlate(w=fillerWidth);
        
        col3(-caseZDiff)
        arc(12,1,space*5.1,i)
        translate(rightFillerPlacement)
        translate([-fillerWidth*1.2,0,0])
        KeyPlate(w=fillerWidth);
      }
     
    }
    col3(-caseZDiff)
    arc(12,4,space*5.1)
    translate(rightFillerPlacement)
    translate([-fillerWidth*1,0,0])
    KeyPlate(w=fillerWidth);
    
    hull(){
      col2(-caseZDiff)
      arc(12,1,space*5.1,3)
      translate(leftFillerPlacement)
      KeyPlate(w=fillerWidth);
      
      col3(-caseZDiff)
      arc(12,1,space*5.1,4)
      translate(rightFillerPlacement)
      translate([-fillerWidth*1,0,0])
      KeyPlate(w=fillerWidth);
    }
  }
  { // Col3-Col4
    for(i=[0:2]){
      hull(){
        col3(-caseZDiff)arc(12,1,space*5.1,i)translate(leftFillerPlacement)translate([fillerWidth,0,0])KeyPlate(w=fillerWidth);
        col4(-caseZDiff)arc(12,1,space*5.1,i)translate(rightFillerPlacement)KeyPlate(w=fillerWidth);
      }
    }
    
    hull(){
        col3(-caseZDiff)arc(12,1,space*5.1,3)translate(leftFillerPlacement)translate([fillerWidth,0,0])KeyPlate(w=fillerWidth);
        col4(-caseZDiff)arc(12,1,space*5.1,2)translate(rightFillerPlacement)KeyPlate(w=fillerWidth);
      }
    
    for(i=[3:4]){
      hull(){
        col3(-caseZDiff)arc(12,1,space*5.1,4)translate(leftFillerPlacement)KeyPlate(w=fillerWidth);
        col4(-caseZDiff)arc(12,1,space*5.1,i)translate(rightFillerPlacement)translate([-fillerWidth,0,0])KeyPlate(w=fillerWidth);
      }
    }
  }
  { // Col4-Col5
    for(i=[0:2]){
      hull(){
        col4(-caseZDiff)arc(12,1,space*5.1,i)translate(leftFillerPlacement)translate([fillerWidth,0,0])KeyPlate(w=fillerWidth);
        col5(-caseZDiff)arc(12,1,space*5.1,i)translate(rightFillerPlacement)KeyPlate(w=fillerWidth);
      }
    }
    for(i=[3:4]){
      hull(){
        col4(-caseZDiff)arc(12,1,space*5.1,i)translate(leftFillerPlacement)KeyPlate(w=fillerWidth);
        col5(-caseZDiff)arc(12,1,space*5.1,i)translate(rightFillerPlacement)translate([-fillerWidth,0,0])KeyPlate(w=fillerWidth);
      }
    }
  }
  // Col5-Col6
    for(i=[0:4]){
      hull(){
        col5(-caseZDiff)arc(12,1,space*5.1,i)translate(leftFillerPlacement)KeyPlate(w=fillerWidth);
        col6(-caseZDiff)arc(12,1,space*5.1,i)translate(rightFillerPlacement)translate([fillerWidth,0,0])KeyPlate(w=fillerWidth);
      }
    }
}

module fingerWalls_right(){
  for(i=[0:0]){
    hull(){
      col1(-caseZDiff)arc(12,1,space*5.1,i)translate(rightFillerPlacement)translate([0,0,-space*0.7])KeyPlate(w=fillerWidth,h=space*1.4);
      col1(-caseZDiff)arc(12,1,space*5.1,i+1)translate(rightFillerPlacement)translate([0,0,-space*0.7])KeyPlate(w=fillerWidth,h=space*1.4);
    }
  }
  hull(){
    col1(-caseZDiff)arc(12,1,space*5.1,1)translate(rightFillerPlacement)translate([0,0,-space*0.7])KeyPlate(w=fillerWidth,h=space*1.4);
    
    col1(-caseZDiff)arc(12,1,space*5.1,2)translate(rightFillerPlacement)translate([0,-space*0.505,-space*0.7])KeyPlate(w=fillerWidth,l=fillerWidth,h=space*1.4);
  }
  
  hull(){
    
    col1(-caseZDiff)arc(12,1,space*5.1,2)translate(rightFillerPlacement)translate([0,-space*0.505,-space*0.7])KeyPlate(w=fillerWidth,l=fillerWidth,h=space*1.4);
    col1(-caseZDiff)arc(12,1,space*5.1,2)translate(rightFillerPlacement)translate([0,space*0.505,0])KeyPlate(w=fillerWidth,l=fillerWidth);
   
    translate([thumbX,thumbY,thumbZ])rotate([thumbRX,thumbRY,thumbRZ])translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(leftFillerPlacement)translate([0,-space*0.49,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
  }
  
  module l(off,h=space*3){
    hull(){
      col1(-caseZDiff)arc(12,1,space*5.1,off)translate(rightFillerPlacement)translate([0,space*0.5,-space*1.37])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    
      col1(-caseZDiff)arc(12,1,space*5.1,off)translate(rightFillerPlacement)translate([fillerWidth*3,space*0.5,-h])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    }
  }
  
  module r(off,h=space*3){
    hull(){
      col1(-caseZDiff)arc(12,1,space*5.1,off)translate(rightFillerPlacement)translate([0,-space*0.5,-space*1.37])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    
      col1(-caseZDiff)arc(12,1,space*5.1,off)translate(rightFillerPlacement)translate([fillerWidth*3,-space*0.5,-h])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    }
  }
 
  hull(){
    col1(-caseZDiff)arc(12,1,space*5.1,0)translate(rightFillerPlacement)translate([0,-space*0.5,-space*1.36])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    
    
  
    col1(-caseZDiff,rotation=[0,0,-25])arc(12,1,space*5.1)translate(rightFillerPlacement)translate([-space*0.5,-space*0.524,-space*3.2917])rotate([21,0,0])KeyPlate(l=fillerWidth,h=space*0.1,w=fillerWidth);
    
    l(0,space*3.37);
  }
  
  hull(){
    l(0,space*3.37);
    r(1,space*3);
  }
  
  hull(){
    l(1);
    r(1);
  }
  hull(){
    l(1);
    r(2);
  }
  hull(){
//    l(2);
    r(2);
  }
}
module fingerWalls_front(){
  { // col 1
      
      module f(){
        union()hull(){
          col1(-caseZDiff)arc(12,1,space*5.1)translate([space*0.0499,-space*0.9122,-space*1.0544])rotate([3.8,-5,-35])KeyPlate(l=fillerWidth,h=space*0.1,w=space*1.25);
          difference(){
            col1(-caseZDiff)arc(12,1,space*5.1)translate(rightFillerPlacement)translate([fillerWidth*0.498,-space*0.543,-space*1.15])sphere(r=fillerWidth,$fn=30);
            col1(-caseZDiff)arc(12,1,space*5.1)translate(rightFillerPlacement)translate([fillerWidth*0.498,-space*0.54,-space*1.15])translate([fillerWidth*0.2,fillerWidth*0.1,0])rotate([0,0,10])cube(fillerWidth*2,center=true);
          }
        }
      }
      module g(){
        union()hull(){
          col1(-caseZDiff)arc(12,1,space*5.1)translate(rightFillerPlacement)translate([0,-space*0.5052,-space*1.39605])rotate([0,0,0])KeyPlate(l=fillerWidth,h=fillerWidth*0.1,w=fillerWidth);
          
          col1(-caseZDiff)arc(12,1,space*5.1)translate(leftFillerPlacement)translate([fillerWidth*1.6,-space*1.2715,-space*1.2651])rotate([20,-0,-25])KeyPlate(l=fillerWidth*0.9,h=fillerWidth*0.1,w=fillerWidth*0.1);
        }
      }
      hull(){
        col1(-caseZDiff)arc(12,1,space*5.1)translate([0,-space*0.505,space*0.02883])KeyPlate(l=fillerWidth,h=space*0.1,w=space);
        
        col1(-caseZDiff)arc(12,1,space*5.1)translate([fillerWidth*0.18,-space*0.79115,-space*0.20327])rotate([0,-6,-25])KeyPlate(l=fillerWidth,h=space*0.1,w=space);
      }
      
      hull(){
        col1(-caseZDiff)arc(12,1,space*5.1)translate([fillerWidth*0.18,-space*0.79115,-space*0.20327])rotate([0,-6,-25])KeyPlate(l=fillerWidth,h=space*0.1,w=space);
        
        col1(-caseZDiff)arc(12,1,space*5.1)translate(rightFillerPlacement)translate([0,-space*0.505,caseZDiff*0.365])KeyPlate(l=fillerWidth,h=space*0.1,w=fillerWidth);
        
        f();
      }
      
      hull(){
        f();
        g();
      }
      
      hull(){
        g();
        
        col1(-caseZDiff,rotation=[0,0,-25])arc(12,1,space*5.1)translate(rightFillerPlacement)translate([-space*0.5,-space*0.524,-space*3.2917])rotate([21,0,0])KeyPlate(l=fillerWidth,h=space*0.1,w=fillerWidth);
        
        col1(-caseZDiff,rotation=[0,0,-25])arc(12,1,space*5.1)translate(rightFillerPlacement)translate([space*0.4879,-space*0.52404,-space*3.2917])rotate([21,0,0])KeyPlate(l=fillerWidth,h=space*0.1,w=fillerWidth);
        

      }
      
   
    }  
    
  { // col 2
    hull(){
      col2(-caseZDiff)arc(12,1,space*5.1)translate([-fillerWidth*0.5,-space*0.5053,space*0.0288])KeyPlate(l=fillerWidth,h=space*0.1,w=space+fillerWidth);
    
      col2(-caseZDiff)arc(12,1,space*5.1)translate([-fillerWidth*0.27,-space*1.0057,-space*0.796])rotate([1.4,-3,-25])KeyPlate(l=fillerWidth,h=space*0.1,w=space+fillerWidth);
    }
    
    col2(-caseZDiff)arc(12,1,space*5.1)translate([-fillerWidth*0.17,-space*1.0054,-space*(0.796+0.14)])rotate([1.4,-3,-25])KeyPlate(l=fillerWidth,h=space*0.28,w=space+fillerWidth);
    
    hull(){
      union(){hull(){
        col2(-caseZDiff)arc(12,1,space*5.1)translate(leftFillerPlacement)translate([fillerWidth*0.17,-space*1.1936,-space*1.125])rotate([22.3,-2,-4])KeyPlate(l=fillerWidth,h=space*0.2,w=fillerWidth*0.1);
    
        col2(-caseZDiff)arc(12,1,space*5.1)translate(rightFillerPlacement)rotate([22.3,-2,-25])translate([fillerWidth*3.354,-space*1.08525,-space*0.8434])KeyPlate(l=fillerWidth,h=space*0.2,w=fillerWidth*0.1);
      }}
    
      col2(-caseZDiff)arc(12,1,space*5.1)
      rotate([24,-3,-25])
      translate([-fillerWidth*0.50,-space*1.341867,-space*2.6])
      rotate([1,-7,10])
      KeyPlate(l=fillerWidth,h=space*0.1,w=space+fillerWidth*2);
    }
    
  }


  { // col 3
    col3(-caseZDiff)arc(12,1,space*5.1)translate([-fillerWidth*0.1,-space*0.505,-space*0.15])KeyPlate(l=fillerWidth,h=space*0.2,w=space+fillerWidth*2.2);
    
    col3(-caseZDiff)arc(12,1,space*5.1)rotate([22,0,0])translate([-fillerWidth*0.1,-space*0.55901,-space*0.12786])KeyPlate(l=fillerWidth,h=space*0.2,w=space+fillerWidth*2.2);
    
    col3(-caseZDiff)arc(12,1,space*5.1)rotate([26,0,0])translate([-fillerWidth*0.1,-space*0.57342,-space*1.0602])KeyPlate(l=fillerWidth,h=space*1.75,w=space+fillerWidth*2.2);    
  }
  
  
  module c4ll(){
      col4(-caseZDiff)arc(12,1,space*5.1,1)translate(leftFillerPlacement)translate([space,-space*1.2,-space*1.1])rotate([0,-20,10])KeyPlate(l=fillerWidth,h=space*0.1,w=fillerWidth);
  }
  { // Col4
    
    
    hull(){
      col4(-caseZDiff)arc(12,1,space*5.1)translate([fillerWidth*0.5,-space*0.5053,space*0.0288])KeyPlate(l=fillerWidth,h=space*0.1,w=space+fillerWidth);
      
      col4(-caseZDiff)arc(12,1,space*5.1)translate([fillerWidth*0.238,-space*0.9302,-space*0.4121])rotate([1.1,3,25])KeyPlate(l=fillerWidth,h=space*0.1,w=space+fillerWidth);
    }
    
    col4(-caseZDiff)arc(12,1,space*5.1)translate([fillerWidth*0.1473,-space*0.930555,-space*0.5479])rotate([1.1,2.7,25])KeyPlate(l=fillerWidth,h=space*0.28,w=space+fillerWidth);
    
    hull(){
      col4(-caseZDiff)arc(12,1,space*5.1)translate(rightFillerPlacement)translate([-fillerWidth*0.2,-space*1.1205,-space*0.741])rotate([21.9,3.5,1])KeyPlate(l=fillerWidth,h=space*0.2,w=fillerWidth*0.1);
      col4(-caseZDiff)arc(12,1,space*5.1)translate(leftFillerPlacement)translate([fillerWidth*0.13580065,-space*0.6752,-space*0.79168])rotate([21.9,2.7,25])KeyPlate(l=fillerWidth,h=space*0.2,w=fillerWidth*0.1);
      
      col4(-caseZDiff)arc(12,1,space*5.1)translate([-fillerWidth*0.324,-space*0.3253,-space*2])rotate([27,-20,10])KeyPlate(l=fillerWidth,h=space*0.1,w=space+fillerWidth*2);
    }
    
    
    
    hull(){
      col4(-caseZDiff)arc(12,1,space*5.1)translate(leftFillerPlacement)translate([0,-space*0.3375,-space*1.6])rotate([20,-20,16])KeyPlate(l=fillerWidth,h=space*0.1,w=fillerWidth);
      
      col4(-caseZDiff)arc(12,1,space*5.1)translate([space*0.499,-space*0.7036,-space*0.552])rotate([1.1,2.7,25])KeyPlate(l=fillerWidth,h=space*0.324,w=fillerWidth);
      
      c4ll();
    }
    
    hull(){
      col4(-caseZDiff*0.5)arc(12,1,space*5.1,0)translate(leftFillerPlacement)translate([fillerWidth,-space*0.505,])KeyPlate(h=fillerWidth,w=fillerWidth,l=fillerWidth);
      
      col4(-caseZDiff)arc(12,1,space*5.1)translate([space*0.499,-space*0.7036,-space*0.552])rotate([1.1,2.7,25])KeyPlate(l=fillerWidth,h=space*0.324,w=fillerWidth);
      
      c4ll();
    }
    
    hull(){
      col4(-caseZDiff*0.5)arc(12,1,space*5.1,0)translate(leftFillerPlacement)translate([fillerWidth,-space*0.505,])KeyPlate(h=fillerWidth,w=fillerWidth,l=fillerWidth);
      col5(-caseZDiff*0.5)arc(12,1,space*5.1,0)translate(rightFillerPlacement)translate([0,-space*0.505,])KeyPlate(h=fillerWidth,w=fillerWidth,l=fillerWidth);
      
      c4ll();
    }
    
    
    
  }
  
  hull(){
    col5(-caseZDiff)arc(12,1,space*5.1)translate([0,-space*0.5,-space*0.02])KeyPlate(l=fillerWidth);
    
    c4ll();
    
    col6(-caseZDiff)arc(12,1,space*5.1)translate(leftFillerPlacement)translate([0,-space*0.505,-space*0.02])KeyPlate(l=fillerWidth,w=fillerWidth);
    
//    col6(-caseZDiff)arc(12,1,space*5.1)translate([0,-space*0.505,-space*0.7])KeyPlate(l=fillerWidth,h=space*1.4);
    col6(-caseZDiff)arc(12,1,space*5.1)translate(leftFillerPlacement)translate([0,-space*0.505,-space*1.4])KeyPlate(l=fillerWidth,w=fillerWidth);
  }
  
}
module fingerWalls_left(xPadding){

  
  function differ(off) = off == 1 
                        ? -caseZDiff*(0.6-(off/10)) 
                        : -caseZDiff*(0.7-(off/10))
                        ;
  module l(off, h, tilt){
    hull(){
      col6(differ(off))arc(12,1,space*5.1,off)translate(leftFillerPlacement)translate([xPadding,-space*0.514,0])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
      
      col6(-caseZDiff*0.5)arc(12,1,space*5.1,off)translate(leftFillerPlacement)translate([xPadding+tilt,-space*0.514,-h])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    }
  }

  module r(off, h, tilt){
    hull(){
      col6(differ(off))arc(12,1,space*5.1,off)translate(leftFillerPlacement)translate([xPadding,space*0.514,0])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
      
      col6(-caseZDiff*0.5)arc(12,1,space*5.1,off)translate(leftFillerPlacement)translate([xPadding+tilt,space*0.514,-h])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    }
  }
  
  
  col6(-caseZDiff)arc(12,1,space*5.1,0)translate(leftFillerPlacement)translate([0,0,-space*0.585])KeyPlate(w=fillerWidth,h=space*1.32);
  
  hull(){
    col6(-caseZDiff)arc(12,1,space*5.1,0)translate(leftFillerPlacement)translate([0,space*0.5,-space*0.37125])KeyPlate(w=fillerWidth,h=space*0.9,l=fillerWidth);
    
    l(1, space*0.75, xPadding*1.25);
  }
  
  hull(){
    l(1, space*0.75, xPadding*1.25);
    r(1, space*0.45, xPadding*1.35);
  }
  hull(){
    l(2, space*0.45, xPadding*1.45);
    r(2, space*0.45, xPadding*1.7);
  }
  hull(){
    l(3, space*0.45, xPadding*1.7);
    r(3, space*0.62, xPadding*1.9);
  }
  l(4, space*0.7, xPadding*1.9);
  
  hull(){
    r(1, space*0.45, xPadding*1.35);
    l(2, space*0.45, xPadding*1.45);
  }
  hull(){
    r(2, space*0.45, xPadding*1.7);
    l(3, space*0.45, xPadding*1.7);
  }
  
  hull(){
    r(3, space*0.62, xPadding*1.9);
    l(4, space*0.7, xPadding*1.9);
  }
  
  

  
  hull(){
    l(4, space*0.7, xPadding*1.9);

    col6(-caseZDiff)arc(12,1,space*5.1,4)translate(leftFillerPlacement)translate([xPadding,space*0.505,0])KeyPlate(w=fillerWidth,l=fillerWidth,h=fillerWidth);
    
    
    col6(-caseZDiff)arc(12,1,space*5.1,4)translate(leftFillerPlacement)translate([xPadding,space*0.15,-space])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
    
  }  
}

module fingerWalls_back(xPadding){
  { // col6
    module c6bu(){
      hull(){
        col6(-caseZDiff)arc(12,1,space*5.1,4)translate(leftFillerPlacement)translate([xPadding,space*0.505,-space*0.2])KeyPlate(w=fillerWidth,l=fillerWidth,h=fillerWidth);
      
        col6(-caseZDiff)arc(12,1,space*5.1,4)translate(rightFillerPlacement)translate([0,space*0.505,-space*0.21])KeyPlate(w=fillerWidth,l=fillerWidth,h=fillerWidth);
      }
    }
    
    hull(){
      col6(-caseZDiff)arc(12,1,space*5.1,4)translate(leftFillerPlacement)translate([xPadding,space*0.505,0])KeyPlate(w=fillerWidth,l=fillerWidth,h=fillerWidth);    
      
      col6(-caseZDiff)arc(12,1,space*5.1,4)translate(rightFillerPlacement)translate([0,space*0.505,0])KeyPlate(w=fillerWidth,l=fillerWidth,h=fillerWidth);
      
      c6bu();
    }
    
    hull(){
      c6bu();
      
      col6(-caseZDiff)arc(12,1,space*5.1,4)translate(leftFillerPlacement)translate([xPadding,space*0.15,-space])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);
      
      col6(-caseZDiff)arc(12,1,space*5.1,4)translate(rightFillerPlacement)translate([0,space*0.1,-space*1.1])KeyPlate(w=fillerWidth,h=fillerWidth,l=fillerWidth);  
    }
  }
  
}

module fingerWalls(){
  
  xPadding=space*0.125;
  fingerWalls_right();
//  fingerWalls_front();
  fingerWalls_left(xPadding);
//  fingerWalls_back(xPadding);
}

module thumbKeyPlates(){
  translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate([0,0,-caseZDiff])KeyPlate();
  translate([0,space,0])rotate([-30,0,90])arc(40,2,space*1.8)rotate([0,0,-90])translate([0,0,-caseZDiff])KeyPlate();
}

module thumbPlateFillers(){
  hull(){
    translate([0,space,0])rotate([-30,0,90])arc(40,1,space*1.8)rotate([0,0,-90])translate([0,0,-caseZDiff])translate(rightFillerPlacement)KeyPlate(w=fillerWidth);
    
    translate([0,space,0])rotate([-30,0,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate([0,0,-caseZDiff])translate(leftFillerPlacement)KeyPlate(w=fillerWidth);
   }
   
   
   hull(){
     translate([0,0,space*0.105])
     rotate([-30,12,90])
     arc(40,1,space*1.8,1)
     rotate([0,0,-90])
     translate([0,0,-caseZDiff])
     translate([0,+space*0.5-(fillerWidth*0.5),0])
     KeyPlate(l=fillerWidth);
     
     translate([0,space,0])
     rotate([-30,0,90])
     arc(40,1,space*1.8,1)
     rotate([0,0,-90])
     translate([0,0,-caseZDiff])
     translate([0,-space*0.5+(fillerWidth*0.5),0])
     KeyPlate(l=fillerWidth);
   }
}

module thumbWalls(){
  module leftPoint(){
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([space*0.65,-space*1.505,-space*1])rotate([0,20,0])KeyPlate(w=fillerWidth*1,l=fillerWidth);
  }
  
  module bottomPoint(){
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,-space*0.505,-space*1.7])KeyPlate(w=fillerWidth,l=fillerWidth);
  }
  
  hull(){
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(leftFillerPlacement)translate([0,-space*0.505,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,-space*0.505,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    leftPoint();
  }
  
  hull(){
    leftPoint();
    
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,-space*0.505,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    bottomPoint();
  }
  
  hull(){
    leftPoint();
    bottomPoint();
  
    translate([-space*0.63,0,-space*1])leftPoint();
  }
  
  
  hull(){
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,-space*0.505,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,space*0.505,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,-space*0.505,-space*1.7])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([-fillerWidth*3,space*0.505,-space*1.4])KeyPlate(w=fillerWidth,l=fillerWidth);
  }
  hull(){
    
    translate([0,0,space*0.105])rotate([-30,12,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([-fillerWidth*3,space*0.505,-space*1.4])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    
    translate([0,space,0])rotate([-30,0,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,-space*0.505,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    translate([0,space,0])rotate([-30,0,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([0,space*0.505,-caseZDiff])KeyPlate(w=fillerWidth,l=fillerWidth);
    
    
    translate([0,space,0])rotate([-30,0,90])arc(40,1,space*1.8,1)rotate([0,0,-90])translate(rightFillerPlacement)translate([-fillerWidth*4,space*0.505,-space*1.4])KeyPlate(w=fillerWidth,l=fillerWidth);
  }
  
}

module thumbToFinger(){
  
  hull(){
    translate([thumbX,thumbY,thumbZ])
    rotate([thumbRX,thumbRY,thumbRZ])
    translate([0,space,0])
    rotate([-30,0,90])
    arc(40,1,space*1.8)
    rotate([0,0,-90])
    translate([0,-space*0.5+(fillerWidth*0.5),-caseZDiff])
    KeyPlate(l=fillerWidth);
    
    translate([thumbX,thumbY,thumbZ])
    rotate([thumbRX,thumbRY,thumbRZ])
    translate([0,space,0])
    rotate([-30,0,90])
    arc(40,1,space*1.8)
    rotate([0,20,-90])
    translate([-space*0.6,-space*0.5,-caseZDiff*3])
    KeyPlate(l=fillerWidth,w=space*0.4);
    
    
    col1(-caseZDiff)arc(12,1,space*5.1,3)
    translate([0,space*0.5,0])
    KeyPlate(l=fillerWidth);
  }
  
  hull(){
    translate([thumbX,thumbY,thumbZ])
    rotate([thumbRX,thumbRY,thumbRZ])
    translate([0,0,space*0.105])
    rotate([-30,12,90])
    arc(40,1,space*1.8,1)
    rotate([0,0,-90])
    translate([0,space*0.1,-caseZDiff])
    translate(leftFillerPlacement)
    KeyPlate(w=fillerWidth,l=space*1.1);
    
    col1(-caseZDiff)arc(12,1,space*5.1,3)
    translate(rightFillerPlacement)
    KeyPlate(w=fillerWidth);
  }

}

module fingerCase(){
  fingerKeyPlates();
  fingerPlateFillers();
  fingerWalls();
}
module thumbCase(){
  thumbKeyPlates();
  thumbPlateFillers();
  thumbWalls();
}

module upperCase(){
  fingerCase();
    
  translate([thumbX,thumbY,thumbZ])
  rotate([thumbRX,thumbRY,thumbRZ])
  thumbCase();
  
  thumbToFinger();

}


module case(){
  if(showUpperCase){
    upperCase();
  }

  
  
}

module keyboard(){
  if(showCut){
    difference(){
      case();
      switchPlacement();
    }
  } else {
    case();
    switchPlacement();
  }
}

// ---- Build ----
if(showPrintBox){
  #translate([0,0,printerSize[2]/2])cube(printerSize,center=true);
}


if(showCut){
  difference(){
    translate(keyboardPlacement)
    rotate(keyboardRotation){
      keyboard();
    }
    translate([0,0,-5])cube([printerSize[0],printerSize[1],10],center=true);
  }
} else {
  translate(keyboardPlacement)
  rotate(keyboardRotation)
  keyboard();
  
  %translate([0,0,-5])cube([printerSize[0],printerSize[1],10],center=true);
}

module bottomCase(){
  linear_extrude(convexity=10,height=caseThickness)
  translate([keyboardPlacement[0],keyboardPlacement[1],0])
  rotate([0,0,keyboardRotation[2]])
  projection()
  upperCase();
}

if(showBottomCase){

  translate([-0,0,0])scale([1,1,1])bottomCase();
}




//KeyPlate2();
//translate([space*1.1,0,0])KeyPlate();
//translate([0,space*1.1,0])KeyPlate();
//translate([space*1.1,space*1.1,0])KeyPlate();