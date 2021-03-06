showCut=false;
showSwitchCut=true;
keyboardPlacement=[-20.5,-50,70];
keyboardRotation=[336,30,7];
showSwitch=false;
showKeyCap=false;
showSpaceBox=false;
space=19.04;
plateSpace12Deg=space*5.023;


/*[case]*/
showUpperCase=true;
showBottomCase=false;
skirt="SHORT"; //["NONE", "LONG", "SHORT"]
caseThickness=3;
caseZDiff=caseThickness/2;
fillerWidth=caseThickness/2;
leftFillerPlacement=[space*0.5-(fillerWidth*0.5),0,0];
rightFillerPlacement=[-space*0.5+(fillerWidth*0.5),0,0];
frontFillerPlacement=[0,-space*0.505,0];
backFillerPlacement=[0,space*0.505,0];

/*[Thumb placement]*/
thumbXSpace=0.6;
thumbYSpace=-0.100;
thumbZSpace=-0.726;
thumbRX=-75;
thumbRY=20;
thumbRZ=60;
thumbX=space*thumbXSpace;
thumbY=space*thumbYSpace;
thumbZ=space*thumbZSpace;
thumbPlacement = [thumbX,thumbY,thumbZ];
thumbRotation = [thumbRX,thumbRY,thumbRZ];


/*[Cherry MX settings]*/
cherryCutOutSize=13.9954;
cherrySize=14.58;


/*[ Printer settings ]*/
showPrintBox=false;
printerSize=[140,140,140];

// mX: h=mX-1, d= X*(1+((1/3)*2))
function mNutH(m) = m-1;
function mNutD(m) = m*(1+((1/3)*2));

// ---- Columns ----
module col1(addZ=0,rotation=[0,15,0]){
  translate([space*0,space*0.5,0+addZ])rotate([6,0,0])
  children();
}

module col2(addZ=0,rotation=[0,12,-1]){
  translate([space*1,space*0.25,0+addZ])rotate([3,0,0])
  children();
}

module col3(addZ=0){
  translate([space*2,space*0,0+addZ])rotate([0,0,0])
  children();

}

module col4(addZ=0){
  translate([space*3,space*0.25,0+addZ])rotate([3,0,0])
  children();
}

module col5(addZ=0){
  translate([space*4,space*0.5,0+addZ])rotate([6,0,0])
  children();
}

module col6(addZ=0){
  translate([space*5,space*0.5,0+addZ])rotate([6,0,0])
  children();
}

// ---- Key related "libs" ----
module cherrySwitch(){
	// Awesome Cherry MX model created by gcb
	// Lib: Cherry MX switch - reference
	// Download here: https://www.thingiverse.com/thing:421524
	//  p=cherrySize/2+0.53;
	translate([0,0,13.32])
		import("switch_mx.stl");
}

module cherryCap(x=0,y=0,z=0, capSize=1, homing=false,rotateCap=false){
	// Awesome caps created by rsheldiii
	// Lib: KeyV2: Parametric Mechanical Keycap Library
	// Download here: https://www.thingiverse.com/thing:2783650

  capRotation = rotateCap ? 90 : 0;

	if(capSize == 1){
		translate([x-0.819,y-0.8,z+3.5])rotate([0,0,capRotation]){
      if(homing){
        rotate([0,0,180])import("keycap-dsa-1.0-row3-homing-cherry.stl");
      } else {
        import("keycap-dsa-1.0-row3-cherry.stl");
      }
    }
	} else if(capSize==1.25){

		translate([x-0.819,y-0.8,z+3.5])
    rotate([0,0,capRotation])
			import("keycap-dsa-1.25-row3-cherry.stl");
	}

}

module proMicro(pins=true){
  rotate([0,0,180]){
    if(pins){
      import("pro-micro_wpins.stl");
    } else {
      import("pro-micro.stl");
    }
  }
}

module pmHolder_base(){
  rotate([0,0,180])import("pro-micro-holder_base.stl");
}
module pmHolder_lid(){
  rotate([0,0,180])import("pro-micro-holder_lid.stl");
}
module pitch(){
  import("pitch.stl");
}

// ---- Various ----
module screwIn(ro=5,ri=2,h=5){
  difference(){
    cube([ro*2,ro*2,h], center=true);
    cylinder(r=ri,h=h+1,$fn=30,center=true);
    translate([0,0,-((h/2))])cylinder(r1=3,r2=2,h=1,$fn=30,center=true);
  }
}
module screwInWithMount(h=8,d=12,ri=3){
  difference(){
    union(){
      cylinder(d=d,h=h,$fn=30,center=true);
      translate([d/4,0,0])cube([d/2,d-0.055,h],center=true);
    }
    cylinder(d=ri,h=h+1,$fn=30,center=true);
    translate([0,0,-((h/2))])cylinder(d1=ri+(ri),d2=ri,h=1,$fn=30,center=true);
    translate([0,0,h-ri*1.66])cylinder(h=mNutH(ri),d=mNutD(ri),center=true);
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
module mxSwitchCut(x=0,y=0,z=0,rotateCap=false){
  capRotation = rotateCap ? 90 : 0;
  d=14.05;
  p=14.58/2+0.3;
  translate([x,y,z]){
    translate([0,0,-3.7])
    rotate([0,0,capRotation]){
      difference(){
        cube([d,d,10], center=true);
        translate([d*0.5,0,0])cube([1,4,12],center=true);
        translate([-d*0.5,0,0])cube([1,4,12],center=true);
      }


      translate([0,-(p-0.6),1.8]) rotate([-10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
      translate([0,-(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);

      translate([0,(p-0.6),1.8]) rotate([10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
      translate([0,(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);
    }
  }
}

module Key(x=0,y=0,z=0,cap=1,homing=false,rotateCap=false){
  union(){
    if(showSwitch){
      cherrySwitch();
    }
    if(showSwitchCut){
      mxSwitchCut(x,y,z);
    }
    if(showKeyCap){
			cherryCap(0.82,0.8,3.32, cap,homing,rotateCap);
		}
    if(showSpaceBox){
      capRotation = rotateCap ? 90 : 0;
      translate([0,0,7])
      rotate([0,0,capRotation])
      #cube([space*cap,space,space*0.7],center=true);
		}
    if(showCut){
      capRotation = rotateCap ? 90 : 0;
			translate([0,0,7])
      rotate([0,0,capRotation])
      cube([space*cap,space*1.065,space/1.5],center=true);
		}
  }
}

module KeyPlate(w=space,l=space*1.089,h=caseThickness,center=true,,rotateCap=false){
  capRotation = rotateCap ? 90 : 0;
  rotate([0,0,capRotation])
	cube([w,l,h],center=center);
}

module legMount(h=space*1,r=1,spaceing=space,fn=30){
  difference(){
    union(){
      translate([0,-spaceing*0.4,0])cube([r*5,r,h*0.5],center=true);
      translate([0,spaceing*0.4,0])cube([r*5,r,h*0.5],center=true);
      translate([0,0,-h*0.25])cube([r*5,spaceing*1.3,r],center=true);
    }

    translate([0,0,h*0.15])rotate([90,0,0])cylinder(r=r*1.1,h=h*1.5,$fn=fn,center=true);
  }

}

module legStart(h=space,fn=30){
  cylinder(r=3,h=h,$fn=fn);
  translate([0,h/2,2])rotate([90,0,0])cylinder(r=1,h=h,$fn=fn);
  translate([0,0,h])cylinder(r=1.3,h=h*0.3,$fn=fn);
}

module leg(h=space,fn=30){
  difference(){
    cylinder(r=3,h=h,$fn=fn);
    translate([0,0,-h*0.01])cylinder(r=1.5,h=h*0.4,$fn=fn);
  }
  translate([0,0,h])cylinder(r=1.3,h=h*0.3,$fn=fn);

}

// ---- Keyboard ----

module fingerSwitchPlacement(){
  col1()arc(12,4,plateSpace12Deg)Key();
  {
    col2()arc(12,2,plateSpace12Deg)Key();
    col2()arc(12,1,plateSpace12Deg,2)Key(homing=true);
    col2()arc(12,1,plateSpace12Deg,3)Key();
  }
  col3()arc(12,5,plateSpace12Deg)Key();
  col4()arc(12,5,plateSpace12Deg)Key();
  col5()arc(12,5,plateSpace12Deg)Key();
  col6(){
    arc(12,1,plateSpace12Deg)Key();
    translate([space*0.125,0,0])arc(12,4,plateSpace12Deg,1)Key(cap=1.25);
  }
}

module thumbSwitchPlacement(){
  col1()
  arc(12,1,plateSpace12Deg,4)
  translate(thumbPlacement)
  rotate(thumbRotation)
  {
    arc(40,2,space*1.9,0)
    rotate([0,0,-90]){
      Key(cap=1.25,rotateCap=true);
    }


    arc(40,1,space*1.9,1)
    rotate([0,0,90])
    arc(40,1,(space*1.9)*1.1,1)
    rotate([0,0,180]){
      Key();
    }
  }

}

module thumbPlacement(){
  col1()
  arc(12,1,plateSpace12Deg,4)
  translate(thumbPlacement)
  rotate(thumbRotation)
  children();
}

module thumbFront(){
  thumbPlacement()
  arc(40,1,space*1.9,1)
  rotate([0,0,90])
  arc(40,1,(space*1.9)*1.1,1)
  translate([0,0,-caseZDiff])
  children();
}

module thumbMid(){
  thumbPlacement()
  arc(40,1,space*1.9,1)
  translate([0,0,-caseZDiff])
  children();
}


module thumbLeft(){
  thumbPlacement()
  arc(40,1,space*1.9,0)
  translate([0,0,-caseZDiff])
  children();
}

module keyPlates(){
  { // Finger
    col1()
    arc(12,4,plateSpace12Deg)
    translate([0,0,-caseZDiff])
    KeyPlate();

    col2()arc(12,4,plateSpace12Deg)translate([0,0,-caseZDiff])KeyPlate();
    col3()arc(12,5,plateSpace12Deg)translate([0,0,-caseZDiff])KeyPlate();
    col4()arc(12,5,plateSpace12Deg)translate([0,0,-caseZDiff])KeyPlate();
    col5()arc(12,5,plateSpace12Deg)translate([0,0,-caseZDiff])KeyPlate();
    col6(){
      arc(12,1,plateSpace12Deg)translate([0,0,-caseZDiff])KeyPlate();
      arc(12,4,plateSpace12Deg,1)translate([0,0,-caseZDiff])KeyPlate(w=space*1.25);
    }
  }

  module fingerBackCol1(){
    col1()
    arc(12,1,plateSpace12Deg,3)
    translate([0,0,-caseZDiff])
    translate(backFillerPlacement)
    children();
  }

  module fingerBackRight(){
    fingerBackCol1()
    translate(rightFillerPlacement)
    KeyPlate(w=fillerWidth,l=fillerWidth);
  }

  module fingerBackCol2(){
    col2()
    arc(12,1,plateSpace12Deg,3)
    translate([0,0,-caseZDiff])
    translate(backFillerPlacement)
    children();
  }

  module fingerBackCol3(){
    col3()
    arc(12,1,plateSpace12Deg,4)
    translate([0,0,-caseZDiff])
    translate(backFillerPlacement)
    children();
  }

  { // Thumb
    {
      { // Plates
        thumbPlacement()
        arc(40,2,space*1.9,0)
        translate([0,0,-caseZDiff])
        rotate([0,0,-90])
        KeyPlate(w=space*1.25,rotateCap=true);


        thumbFront()
        rotate([0,0,180])
        KeyPlate();
      }


      { // Fillers
        hull(){
          thumbLeft()
          translate(backFillerPlacement)
          translate([0,fillerWidth,0])
          KeyPlate(w=space*1.25,l=fillerWidth);

          thumbMid()
          translate(frontFillerPlacement)
          translate([0,-fillerWidth,0])
          KeyPlate(w=space*1.25,l=fillerWidth);
        }

        hull(){
          thumbMid()
          translate(rightFillerPlacement)
          translate([-fillerWidth*2.5,0,0])
          KeyPlate(w=fillerWidth);

          thumbFront()
          translate(frontFillerPlacement)
          translate([0,-fillerWidth,0])
          KeyPlate(l=fillerWidth);
        }
      }
    }
  }

  { // Finger <-> Thumb filler
    hull(){
      col1()
      arc(12,1,plateSpace12Deg,3)
      translate([0,0,-caseZDiff])
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);

      fingerBackRight();


      thumbFront()
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([-fillerWidth,0,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
    hull(){
      fingerBackRight();


      thumbFront()
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([-fillerWidth,0,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbFront()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth,0,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
    hull(){
      fingerBackRight();


      thumbFront()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth,0,0])
      translate([0,-fillerWidth,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbMid()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-fillerWidth,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
    hull(){
      fingerBackRight();


      thumbMid()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-fillerWidth,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbLeft()
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,fillerWidth,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }

     hull(){
      fingerBackRight();


      thumbLeft()
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,fillerWidth,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbLeft()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-0.098,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
    hull(){
      fingerBackCol1()
      translate(leftFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);

      fingerBackCol2()
      translate(rightFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbLeft()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-0.098,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
    hull(){
      fingerBackCol3()
      translate(rightFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);

      fingerBackCol2()
      translate(leftFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbLeft()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-0.098,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);

    }
    hull(){
      fingerBackCol3()
      translate(rightFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbLeft()
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([fillerWidth*1.5,0,0])
      translate([0,-0.098,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);


      thumbLeft()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-0.098,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }

    hull(){
      thumbLeft()
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-0.098,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);

      fingerBackCol2()
      translate(rightFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);

      fingerBackCol2()
      translate(leftFillerPlacement)
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
  }
}

module skirt(){

  module dot(h=fillerWidth){
    cube([fillerWidth, fillerWidth, h],center=true);
  }
  module pin(h=space){
    translate([0,0,-h*0.5])
    dot(h=h);
  }


  module oldrightSide(){

    for(i=[0:1]){
      hull(){
        col1()
        arc(12,1,plateSpace12Deg,i)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        pin();

        col1()
        arc(12,1,plateSpace12Deg,i)
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        pin();
      }
      hull(){
        col1()
        arc(12,1,plateSpace12Deg,i+1)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        pin();

        col1()
        arc(12,1,plateSpace12Deg,i)
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        pin();
      }
    }



    module point(){
      col1()
      arc(12,1,plateSpace12Deg,2)
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([-space*0.5,0,-(space*0.9-fillerWidth*0.5)])
      dot();
    }

    hull(){
      col1()
      arc(12,1,plateSpace12Deg,2)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      pin();

      point();
    }

    hull(){
      point();

      col1()
      arc(12,1,plateSpace12Deg,2)
      translate([0,0,-caseZDiff])
      translate(rightFillerPlacement)
      KeyPlate(w=fillerWidth);
    }

    hull(){
      thumbFront()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      dot(h=caseThickness);

      thumbFront()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      point();
    }

    hull(){
      col1()
      arc(12,1,plateSpace12Deg,3)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      thumbFront()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth,0,0])
      dot(h=caseThickness);

      point();
    }

    hull(){
      thumbFront()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      dot(h=caseThickness);

      thumbFront()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,0,-space*0.7])
      dot(h=caseThickness);

      point();
    }

    hull(){
      thumbFront()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      dot(h=caseThickness);

      thumbFront()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,0,-space*0.7])
      dot(h=caseThickness);

      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      dot(h=caseThickness);

      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,0,-space*0.7])
      dot(h=caseThickness);
    }
    hull(){
      thumbFront()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,0,-space*0.7])
      dot(h=caseThickness);

      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,0,-space*0.7])
      dot(h=caseThickness);

      thumbFront()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([-space*1.2,-space*2,-space*4])
      dot(h=caseThickness);

      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([-space*0.6,-space*2,-space*3])
      dot(h=caseThickness);
    }


    hull(){
      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,0,-space])
      dot(h=caseThickness);

      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,-fillerWidth*1,0])
      dot(h=caseThickness);

      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,0,-space*0.7])

      dot(h=caseThickness);
    }

    hull(){
      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([0,0,-space*0.7])
      dot(h=caseThickness);

      thumbFront()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([-space*0.6,-space*2,-space*3])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,0,-space])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-space*0.5,-space*3.3])
      dot(h=caseThickness);
    }

    hull(){
      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.586,0,0])
      dot(h=caseThickness);


      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,0,-space])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.586,0,0])
      translate([0,0,-space])
      dot(h=caseThickness);
    }

    hull(){
      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,0,-space])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.586,0,0])
      translate([0,0,-space])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(rightFillerPlacement)
      translate([-fillerWidth*2.5,0,0])
      translate([0,-space*0.5,-space*3.3])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.586,0,0])
      translate([0,0,-space*3])
      dot(h=caseThickness);
    }



  }

  module flyingPointFront(){
      col1()
      arc(12,1,plateSpace12Deg,1)
      translate([0,0,-caseZDiff])
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-space*2.4])
      dot(h=caseThickness);
  }
  module frontFlyingPointFront(){
        translate([0,-space,-space*0.4])
        flyingPointFront();
  }

  module leftFrontFlyingLower(){
      col6()
      arc(12,1,plateSpace12Deg)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([space*0.36,0,-space*0.9])
      dot();
  }

  module rightSide(){
    module flyingPoint(){
        arc(12,1,plateSpace12Deg,2)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([-space*1, space, -space])
        dot(h=caseThickness);
    }
    module lowerFlyingPoint(){
        translate([space*0.7,0,-space*1.5])
        flyingPoint();
    }
    module bottomFlyingPoint(){
        translate([space*1.55,space,-space*3.0])
        flyingPoint();
    }
    module rearFlyingPoint(){
        arc(12,1,plateSpace12Deg,3)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([-space*1.22, space, -space])
        dot();
    }
    module thumbFrontFlyingPoint(){
        thumbFront()
        translate(frontFillerPlacement)
        translate(leftFillerPlacement)
        translate([fillerWidth,0,-space*0.5])
        dot(h=caseThickness);
    }

    module longSkirt(){
      module fingerToThumb(){
        hull(){
          col1()
          arc(12,1,plateSpace12Deg,2)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          dot(h=caseThickness);

          thumbFront()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          dot(h=caseThickness);

          thumbFront()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          dot(h=caseThickness);
        }

        #hull(){
          col1()
          arc(12,1,plateSpace12Deg,2)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          dot(h=caseThickness);

          col1()
          arc(12,1,plateSpace12Deg,2)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(backFillerPlacement)
          dot(h=caseThickness);

          thumbFront()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          dot(h=caseThickness);
        }

        #hull(){
          col1()
          arc(12,1,plateSpace12Deg,2)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          dot(h=caseThickness);

          flyingPoint();

          thumbFront()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          dot(h=caseThickness);

        }
        #hull(){
          rearFlyingPoint();

          thumbFront()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          dot(h=caseThickness);

          thumbFront()
          translate(frontFillerPlacement)
          translate(leftFillerPlacement)
          dot(h=caseThickness);
        }
        #hull() {
          rearFlyingPoint();

          thumbFront()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          dot(h=caseThickness);

          flyingPoint();
        }
      }
      module thumbSkirt(){
        #hull() {
          thumbMid()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          translate([fillerWidth*1.5868,0,0])
          dot(h=caseThickness);

          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);

          thumbMid()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          translate([fillerWidth*2.5,0,0])
          translate([0,fillerWidth,0])
          translate([0,0,-space])
          dot(h=caseThickness);

          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([0,0,-space])
          translate([0,fillerWidth,0])
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);
        }

        #hull() {

          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);

          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([0,0,-space])
          translate([0,fillerWidth,0])
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);

          thumbFrontFlyingPoint();

        }
        hull() {
          
          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);

          thumbFront()
          translate(frontFillerPlacement)
          translate(leftFillerPlacement)
          dot(h=caseThickness);


          thumbFrontFlyingPoint();
        }
        hull(){
          thumbFrontFlyingPoint();

          thumbFront()
          translate(frontFillerPlacement)
          translate(leftFillerPlacement)
          dot(h=caseThickness);

          rearFlyingPoint();
        }

        hull(){
          thumbFrontFlyingPoint();

          rearFlyingPoint();

          bottomFlyingPoint();
        }

        hull(){
          bottomFlyingPoint();
          flyingPoint();
          rearFlyingPoint();
        }

        hull(){
          bottomFlyingPoint();
          thumbFrontFlyingPoint();

          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([0,0,-space])
          translate([0,fillerWidth,0])
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);
        }

        hull(){

          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([0,0,-space])
          translate([0,fillerWidth,0])
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);

          thumbMid()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          translate([fillerWidth*2.5,0,0])
          translate([0,fillerWidth,0])
          translate([0,0,-space])
          dot(h=caseThickness);

          
          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([0,0,-space*3])
          translate([0,-fillerWidth*2,0])
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);

          thumbMid()
          translate(backFillerPlacement)
          translate(leftFillerPlacement)
          translate([fillerWidth*2.5,0,0])
          translate([0,fillerWidth,0])
          translate([0,0,-space*3])
          dot(h=caseThickness);
          
        }

        hull(){
          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([0,0,-space])
          translate([0,fillerWidth,0])
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);
          
          thumbMid()
          translate(backFillerPlacement)
          translate(rightFillerPlacement)
          translate([0,0,-space*3])
          translate([0,-fillerWidth*2,0])
          translate([-fillerWidth*2.5,0,0])
          dot(h=caseThickness);

          bottomFlyingPoint();
        }
      }

      module fingerSkirt(){
        hull(){
          col1()
          arc(12,1,plateSpace12Deg,2)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          dot(h=caseThickness);

          flyingPointFront();
          
          flyingPoint();
        }
        hull(){
          col1()
          arc(12,1,plateSpace12Deg,1)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(backFillerPlacement)
          dot(h=caseThickness);

          col1()
          arc(12,1,plateSpace12Deg,1)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          dot(h=caseThickness);

          flyingPointFront();
          
        }
        hull(){
          col1()
          arc(12,1,plateSpace12Deg,0)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(backFillerPlacement)
          dot(h=caseThickness);

          col1()
          arc(12,1,plateSpace12Deg,0)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          dot(h=caseThickness);

          flyingPointFront();
          
        }

        hull(){
          col1()
          arc(12,1,plateSpace12Deg,0)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          dot(h=caseThickness);

          flyingPointFront();

          col1()
          arc(12,1,plateSpace12Deg,0)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          translate([0,0,-space*2])
          dot(h=caseThickness);

        }

        hull(){
          flyingPointFront();
          flyingPoint();
          bottomFlyingPoint();
        }

        hull(){
          flyingPointFront();
          bottomFlyingPoint();

          col1()
          arc(12,1,plateSpace12Deg,0)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          translate([0,0,-space*2])
          dot(h=caseThickness);
        }

        hull(){
          col1()
          arc(12,1,plateSpace12Deg,0)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          translate([0,0,-space*2])
          dot(h=caseThickness);
          
          bottomFlyingPoint();

          col1()
          arc(12,1,plateSpace12Deg,0)
          translate([0,0,-caseZDiff])
          translate(rightFillerPlacement)
          translate(frontFillerPlacement)
          translate([space,space,-space*4])
          dot(h=caseThickness);
        }
      }
      fingerToThumb();
      thumbSkirt();
      fingerSkirt();
    }

    module shortSkirt(){
      hull(){
        col1()
        arc(12,1,plateSpace12Deg,0)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        dot(h=caseThickness);

        col1()
        arc(12,1,plateSpace12Deg,0)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        dot(h=caseThickness);

        flyingPointFront();
        
        translate([0,-space,-space*0.4])flyingPointFront();
      }
      hull(){
        flyingPointFront();

        col1()
        arc(12,1,plateSpace12Deg,1)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        dot(h=caseThickness);

        col1()
        arc(12,1,plateSpace12Deg,1)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        dot(h=caseThickness);
      }
      hull(){
        flyingPointFront();
        flyingPoint();

        col1()
        arc(12,1,plateSpace12Deg,2)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        dot(h=caseThickness);
      }
      hull(){
        col1()
        arc(12,1,plateSpace12Deg,2)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        dot(h=caseThickness);

        thumbFront()
        translate(backFillerPlacement)
        translate(leftFillerPlacement)
        dot(h=caseThickness);

        thumbFront()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        dot(h=caseThickness);
      }
      hull(){
        col1()
        arc(12,1,plateSpace12Deg,2)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        dot(h=caseThickness);

        col1()
        arc(12,1,plateSpace12Deg,2)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        dot(h=caseThickness);

        thumbFront()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        dot(h=caseThickness);
      }

      hull(){
        col1()
        arc(12,1,plateSpace12Deg,2)
        translate([0,0,-caseZDiff])
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        dot(h=caseThickness);

        thumbFront()
        translate(backFillerPlacement)
        translate(leftFillerPlacement)
        dot(h=caseThickness);

        flyingPoint();
      }

      hull() {
        flyingPoint();
        rearFlyingPoint();
        
        thumbFront()
        translate(backFillerPlacement)
        translate(leftFillerPlacement)
        dot(h=caseThickness);
      }
      hull(){
        flyingPoint();
        flyingPointFront();

        lowerFlyingPoint();
      }
      hull(){
        flyingPoint();
        rearFlyingPoint();

        lowerFlyingPoint();
      }
      hull() {
        thumbFrontFlyingPoint();
        
        thumbFront()
        translate(backFillerPlacement)
        translate(leftFillerPlacement)
        dot(h=caseThickness);

        thumbFront()
        translate(frontFillerPlacement)
        translate(leftFillerPlacement)
        dot(h=caseThickness);
      }
      hull() {
        thumbFrontFlyingPoint();

        rearFlyingPoint();

        thumbFront()
        translate(backFillerPlacement)
        translate(leftFillerPlacement)
        dot(h=caseThickness);
      }
      hull(){
        thumbFrontFlyingPoint();
        lowerFlyingPoint();
        rearFlyingPoint();
      }
      hull() {
        thumbFront()
        translate(frontFillerPlacement)
        translate(leftFillerPlacement)
        dot(h=caseThickness);

        thumbMid()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        translate([-fillerWidth*2.5,0,0])
        dot(h=caseThickness);

        thumbFrontFlyingPoint();
      }
      hull() {
        thumbMid()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        translate([-fillerWidth*2.5,0,0])
        dot(h=caseThickness);

        thumbMid()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        translate([0,0,-space])
        translate([0,space*0.3,0])
        translate([-fillerWidth*2.5,0,0])
        dot(h=caseThickness);

        thumbFrontFlyingPoint();
      }
      hull(){
        thumbFrontFlyingPoint();
        lowerFlyingPoint();

        thumbMid()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        translate([0,0,-space])
        translate([0,space*0.3,0])
        translate([-fillerWidth*2.5,0,0])
        dot(h=caseThickness);
      }
      hull() {
        thumbMid()
        translate(backFillerPlacement)
        translate(leftFillerPlacement)
        translate([fillerWidth*1.5868,0,0])
        dot(h=caseThickness);

        thumbMid()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        translate([-fillerWidth*2.5,0,0])
        dot(h=caseThickness);

        thumbMid()
        translate(backFillerPlacement)
        translate(leftFillerPlacement)
        translate([space*0.4,0,0])
        translate([0,space*0.3,0])
        translate([0,0,-space])
        dot(h=caseThickness);

        thumbMid()
        translate(backFillerPlacement)
        translate(rightFillerPlacement)
        translate([0,0,-space])
        translate([0,space*0.3,0])
        translate([-fillerWidth*2.5,0,0])
        dot(h=caseThickness);
      }

 
    }

    if(skirt == "LONG"){
      longSkirt();
    } else if (skirt == "SHORT"){
      shortSkirt();
    }

  }
  module leftSide(){
    module col6WallLine(o,x,y,z,rZ){
      hull(){
        col6()
        arc(12,1,plateSpace12Deg,o)
        translate([0,0,-caseZDiff*0.5])
        translate(leftFillerPlacement)
        translate(frontFillerPlacement)
        translate([space*0.125,0,0])
        dot();

        col6()
        arc(12,1,plateSpace12Deg,o)
        translate([0,0,-caseZDiff*0.5])
        translate(leftFillerPlacement)
        translate(backFillerPlacement)
        translate([space*0.125,0,0])
        dot();

        col6()
        rotate([
          -keyboardRotation[0]
          , -keyboardRotation[1]
          , -keyboardRotation[2]
        ])
        translate([0,space*o,0])
        translate(leftFillerPlacement)
        translate([x,y,z])
        rotate([90,0,rZ])
        pin(h=space*1.125);
      }
    }

    hull(){ // 1u on col6
      col6()
      arc(12,1,plateSpace12Deg)
      translate([0,0,-caseZDiff*0.5])
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      dot();

      col6()
      arc(12,1,plateSpace12Deg)
      translate([0,0,-caseZDiff*0.5])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      dot();

      leftFrontFlyingLower();

      col6()
      arc(12,1,plateSpace12Deg)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([space*0.47,0,-space*0.5])
      dot();
    }
    hull(){ // Filler for 1u <-> 1.25u
      col6()
      arc(12,1,plateSpace12Deg)
      translate([0,0,-caseZDiff*0.5])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      dot();

      col6()
      arc(12,1,plateSpace12Deg,1)
      translate([0,0,-caseZDiff*0.5])
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([space*0.125,0,0])
      dot();

      col6()
      arc(12,1,plateSpace12Deg)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([space*0.47,0,-space*0.5])
      dot();

      col6()
      arc(12,1,plateSpace12Deg,1)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([space*0.504,1,-space*0.41])
      rotate([0,-35,-0])
      dot();
    }

    col6WallLine(1,space*0.199,-space*0.6,-space*1.3,0);
    col6WallLine(2,space*0.199,-space*0.5,-space*1.3,-5);
    col6WallLine(3,space*0.275,-space*0.5,-space*1.32,-10);
    col6WallLine(4,space*0.4599,-space*0.5,-space*1.4,-15);




  }

  module frontSide(){
    module col1RightFlyer(){
      col1()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,-space*0.3,-space])
      dot(h=caseThickness);
    }
    module col3RightFlyer(){
      col3()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,-space*0.2,-space])
      dot(h=caseThickness);
    }
    module col3LeftFlyer(){
      col3()
      arc(12,1,plateSpace12Deg,0)
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,-space*0.3,-space])
      dot(h=caseThickness);
    }
    module col3BottomFlyer(){
      col3()
      arc(12,1,plateSpace12Deg,0)
      translate(leftFillerPlacement)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,space*0.5,-space*2.4])
      dot(h=caseThickness);
    }
    module col5RightFlyer(){
      col5()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,-space*0.7,-space])
      dot(h=caseThickness);
    }

    
    module frontTopArch(){
      hull(){
        col1()
        arc(12,1,plateSpace12Deg,0)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col1()
        arc(12,1,plateSpace12Deg,0)
        translate(leftFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col2()
        arc(12,1,plateSpace12Deg,0)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);
      }
      hull(){
        col2()
        arc(12,1,plateSpace12Deg,0)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col2()
        arc(12,1,plateSpace12Deg,0)
        translate(leftFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col3()
        arc(12,1,plateSpace12Deg,0)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);
      }
      hull(){
        col4()
        arc(12,1,plateSpace12Deg,0)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col4()
        arc(12,1,plateSpace12Deg,0)
        translate(leftFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col3()
        arc(12,1,plateSpace12Deg,0)
        translate(leftFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);
      }
      hull(){
        col5()
        arc(12,1,plateSpace12Deg,0)
        translate(rightFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col5()
        arc(12,1,plateSpace12Deg,0)
        translate(leftFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col4()
        arc(12,1,plateSpace12Deg,0)
        translate(leftFillerPlacement)
        translate(frontFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);
      }
    }

    frontTopArch();

    hull(){
      col1()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      col2()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      
      col1RightFlyer();
    }
    hull(){
      frontFlyingPointFront();
      col1RightFlyer();

      col1()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);
    }
    hull(){
      col1RightFlyer();
      col3BottomFlyer();
      col3RightFlyer();
    }
    hull(){
      col1RightFlyer();
      frontFlyingPointFront();
      col3BottomFlyer();
    }

    hull(){
      col1RightFlyer();
      col3RightFlyer();

      col2()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);
    }

    hull(){
      col3RightFlyer();

      col2()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      col3()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

    }

    hull(){
      col3()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      col3()
      arc(12,1,plateSpace12Deg,0)
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);


      col3RightFlyer();
      col3LeftFlyer();

    }
    hull(){
      col3RightFlyer();
      col3LeftFlyer();
      col3BottomFlyer();
    }
    hull(){
      col3LeftFlyer();

      col3()
      arc(12,1,plateSpace12Deg,0)
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);


      col6()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

    }
    hull(){
      col3LeftFlyer();

      col6()
      arc(12,1,plateSpace12Deg,0)
      translate(rightFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      col6()
      arc(12,1,plateSpace12Deg,0)
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);
    }

    hull(){
      col3LeftFlyer();

      col6()
      arc(12,1,plateSpace12Deg,0)
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      leftFrontFlyingLower();
    }

    hull(){
      col3LeftFlyer();
      col3BottomFlyer();
      leftFrontFlyingLower();
    }

  }

  module backSide(){
    module col6LeftFlyer(){
      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([0,space*0.2,-space*0.4])
      dot();
    }
    module col6LowerPoint(){
      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff])
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,0,-space*1.75])
      dot();

    }
    module col5RightFlyer(){
      col5()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff/2])
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,space*0.2,-space*0.4])
      dot();
    }

    module col3RightFlyer(){
      col3()
      arc(12,1,plateSpace12Deg,4)
      translate(rightFillerPlacement)
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([0,space*0.5,-space*0.3])
      dot(h=caseThickness);
    }

    module thumLeftAnchor(){
      thumbLeft()
      translate(leftFillerPlacement)
      translate(frontFillerPlacement)
      translate([fillerWidth*1.6,0,0])
      translate([0,-0.098,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
    module thumbMidLowerFlyer(){
        thumbMid()
        translate(frontFillerPlacement)
        translate(leftFillerPlacement)
        translate([space*0.9,0,0])
        translate([0,0,-space*1.1])
        dot(h=caseThickness);
    }
    module backTopArch(){
      hull(){
        col3()
        arc(12,1,plateSpace12Deg,4)
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col3()
        arc(12,1,plateSpace12Deg,4)
        translate(leftFillerPlacement)
        translate(backFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col4()
        arc(12,1,plateSpace12Deg,4)
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);
      }
      hull(){
        col4()
        arc(12,1,plateSpace12Deg,4)
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col4()
        arc(12,1,plateSpace12Deg,4)
        translate(leftFillerPlacement)
        translate(backFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);

        col5()
        arc(12,1,plateSpace12Deg,4)
        translate(rightFillerPlacement)
        translate(backFillerPlacement)
        translate([0,0,-caseZDiff])
        dot(h=caseThickness);
      }
    }
    backTopArch();

    hull(){
      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff/2])
      translate([space*0.125,0,0])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      dot();

      col6LeftFlyer();

      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([space*0.96,-space*0.3,-space*1.1])
      dot();
    }

    hull(){
      col6LeftFlyer();

      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([space*0.96,-space*0.3,-space*1.1])
      dot();

      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([space*0.3,-space*0.1,-space*1.5])
      dot();

    }
    hull(){
      col6LeftFlyer();

      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([space*0.3,-space*0.1,-space*1.5])
      dot();

      col6LowerPoint();
    }
    hull(){
      col6LeftFlyer();
      col6LowerPoint();
      col5RightFlyer();
    }

    hull(){
      col3RightFlyer();
      thumbMidLowerFlyer();
      col5RightFlyer();
    }
    hull(){
      col5RightFlyer();
      thumbMidLowerFlyer();
      col6LowerPoint();
    }

    hull(){
      col6LeftFlyer();

      col6()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff/2])
      translate([space*0.125,0,0])
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      dot();

      col5()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff/2])
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      dot();
    }

    hull(){
      col6LeftFlyer();
      col5RightFlyer();

      col5()
      arc(12,1,plateSpace12Deg,4)
      translate([0,0,-caseZDiff/2])
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      dot();
    }

    hull(){
      col3RightFlyer();

      col5RightFlyer();

      col5()
      arc(12,1,plateSpace12Deg,4)
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);
    }
    hull(){
      col3RightFlyer();

      col3()
      arc(12,1,plateSpace12Deg,4)
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      col4()
      arc(12,1,plateSpace12Deg,4)
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);
    }

    hull(){
      col3RightFlyer();

      col4()
      arc(12,1,plateSpace12Deg,4)
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      col5()
      arc(12,1,plateSpace12Deg,4)
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

    }

    hull(){
      col3()
      arc(12,1,plateSpace12Deg,4)
      translate(rightFillerPlacement)
      translate(backFillerPlacement)
      translate([0,0,-caseZDiff])
      dot(h=caseThickness);

      col3RightFlyer();

      thumLeftAnchor();
    }

    hull(){
      thumLeftAnchor();
      thumbMidLowerFlyer();

      thumbLeft()
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([fillerWidth*1.6,0,0])
      translate([0,fillerWidth,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);
    }
    hull(){
      thumbMidLowerFlyer();

      diff=-caseZDiff*0.38;
      
      thumbLeft()
      translate(leftFillerPlacement)
      translate(backFillerPlacement)
      translate([fillerWidth*1.61,0,0])
      translate([0,fillerWidth,0])
      KeyPlate(w=fillerWidth,l=fillerWidth);

      thumbMid()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.6,0,0])
      translate([0,-fillerWidth,0])
      dot(h=caseThickness);
    }

    hull(){
      thumbMidLowerFlyer();
      thumLeftAnchor();
      col3RightFlyer();
    }

    hull(){
      thumbMid()
      translate(frontFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.6,0,0])
      dot(h=caseThickness);

      thumbMidLowerFlyer();

      thumbMid()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.6,0,0])
      dot(h=caseThickness);
    }
    hull(){
      thumbMidLowerFlyer();

      thumbMid()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([fillerWidth*1.6,0,0])
      dot(h=caseThickness);

      thumbMid()
      translate(backFillerPlacement)
      translate(leftFillerPlacement)
      translate([space*0.4,0,0])
      translate([0,space*0.3,0])
      translate([0,0,-space])
      dot(h=caseThickness);
    }
  }
  rightSide();
  leftSide();
  frontSide();
  backSide();
}


module switchPlacement(){
  fingerSwitchPlacement();
  thumbSwitchPlacement();
}

module upperCaseBuild(){
  if(showUpperCase){
    keyPlates();
    union(){skirt();}
  }
}

module upperCase(showCut=false){
  if(showCut){
    difference(){
      upperCaseBuild();
      switchPlacement();
    }
  } else {
    upperCaseBuild();
    switchPlacement();
  }
}

module bottomMould(h=3){
  module b1(){
    linear_extrude(height=1, scale=[0,0], slices=1, twist=0)
    projection(true)topNoCuts();
  }
  module b2(){
    linear_extrude(height=h, scale=[1,1], slices=1, twist=0)
    projection()b1();
  }
  b2();
}  

module topNoCuts(){
  translate([0,0,-16.1])rotate([0,-13.999,0])
      difference(){
        translate(keyboardPlacement)
        rotate(keyboardRotation)
        upperCaseBuild();

        if(skirt == "SHORT"){
          cutterShortSkirt();
        } else {
          translate([0,0,-5])cube([printerSize[0],printerSize[1],10],center=true);
        }
      }
}

module bottomCase(){
  difference(){
    translate([0,0,-4])bottomMould(7);
    topNoCuts();
    scaleA=1.02;
    scale([scaleA,scaleA])topNoCuts();
    scaleB=scaleA+0.02;
    scale([scaleB,scaleB])topNoCuts();
  }
}

// ---- Build ----
if(showPrintBox){
  #translate([0,0,printerSize[2]/2])cube(printerSize,center=true);
}

module cutterShortSkirt(){
  rotate([0,keyboardRotation[1]*0.46666,0])
  cube([printerSize[0]*1.2,printerSize[1], 32], center=true);
}

module top(showCut=false){
  if(showCut){
    union(){
      difference(){
        translate(keyboardPlacement)
        rotate(keyboardRotation)
        upperCase(showCut);

        if(skirt == "SHORT"){
          cutterShortSkirt();
        } else {
          translate([0,0,-5])cube([printerSize[0],printerSize[1],10],center=true);
        }
      }
    }
  } else {
      translate(keyboardPlacement)
      rotate(keyboardRotation)
      upperCase();


      if(skirt == "SHORT"){
        %cutterShortSkirt();
      } else {
        %translate([0,0,-5])cube([printerSize[0],printerSize[1],10],center=true);
      }
  }
}
module bottom(){
  rotate([0,keyboardRotation[1]*0.46666,0])
  bottomCase();
}

module flatTop(showCut=true){
  rotate([0,-keyboardRotation[1]*0.46666,0])
  translate([-4,0,-15.5])
  top(showCut);
}

module screwPoints(ri=3,holes=false){
  module point(){
    cube([1,1,1],center=true);
  }  
  holeZ=-2.6;
  module hole(){
    translate([0,0,holeZ]){
      cylinder(d=ri,h=8+1,$fn=30,center=true);
      #translate([0,0,-4.5])cylinder(d=ri,h=2.5,$fn=30,center=true);
    }
  }
  // Back right
  translate([-70.5,35,4]){
    rotate([0,0,180])screwInWithMount(ri=ri);
    if(holes){
      hole();
    }
  }
  
  // Back "mid"
  translate([-30,58,4])rotate([0,0,90]){
    screwInWithMount(ri=ri);
    if(holes){
      hole();
    }
    hull(){
      translate([4.5,-5.4752,-3.5])point();
      translate([4.5,-5.4752,3.5])point();

      translate([8.5,-5.4752,-3.5])point();
      translate([7,-5.4752,3.5])point();

      translate([4.5,5.4752,-3.5])point();
      translate([4.5,5.4752,3.5])point();

      translate([8.5,5.4752,-3.5])point();
      translate([6.4,5.4752,3.5])point();
    }
  }

  // Front right
  translate([-51,-55.5,4]){
    rotate([0,0,190])screwInWithMount(ri=ri);
    if(holes){
      hole();
    }

    hull(){
      translate([5.44,0,3.5])point();
      translate([5.44,0,-3.5])point();

      translate([5.44,-7,3.5])point();
      translate([5.44,-7,-3.5])point();
    }

    hull(){
      translate([5.44,-3,3.5])point();
      translate([5.44,-3,-3.5])point();

      translate([5.44,-7,3.5])point();
      translate([5.44,-7,-3.5])point();

      translate([0,-6,3.5])point();
      translate([0,-6,-3.5])point();
    }

    hull(){
      rotate([0,0,190]){
        translate([4.5,-5.4725,-3.5])point();
        translate([7,-5.4725,-3.5])point();

        translate([4,5.4725,-3.5])point();
        translate([7,4.4725,-3.5])point();

        
        translate([5.5,-5.4725,2])point();
        translate([5.5,5.4725,2])point();
      }
    }
  }
  
  // Back left
  translate([54.5,55,4]){
    screwInWithMount(ri=ri);
    if(holes){
      hole();
    }

    hull(){
      translate([5,-5.4725,-3.5])point();
      translate([6.5,-5.4725,-3.5])point();
      translate([4,-5.4725,3.5])point();

      translate([5,5.4,3.5])point();
      translate([5,5.4725,-3.5])point();
      translate([8.9,5.4725,-3.5])point();
    }

    hull(){    
      translate([-5.44,0,3.5])point();
      translate([-5.44,10,3.5])point();

      translate([-5.44,0,-3.5])point();
      translate([-5.44,11,-3.5])point();
    }

    hull(){
      translate([-4.44,4,-3.5])point();
      translate([-4.44,4,3.5])point();

      translate([8.9,5.4725,-3.5])point();
      translate([4,5.4725,3.5])point();

      translate([-4.44,11,-3.5])point();
      translate([-4.44,10,3.5])point();
    }
  }

  // Front left
  translate([57,-37.3,4]){
    screwInWithMount(ri=ri);
    
    if(holes){
      hole();
    }
    
    hull(){
      translate([-5.4,0,-3.5])point();
      translate([-5,-12.5,-3.5])point();
      
      translate([-5.45,0,3.5])point();
      translate([-5,-11.5,3.5])point();
    }

    hull(){
      translate([-5,-4,-3.5])point();
      translate([-5,-4,3.5])point();

      translate([-5,-11.5,3.5])point();
      translate([-5,-12.5,-3.5])point();

      translate([6,-7,-3.5])point();
      translate([3,-6,3.5])point();

      translate([6,-4.5,-3.5])point();
      translate([3,-4,3.5])point();
    }
  }
}

module flatBottom(){
  difference(){
    bottomCase();
    screwPoints(ri=0);
    screwPoints(ri=3, holes=true);
  }
}

difference(){
  // flatTop(showCut);
  flatTop(true);

  translate([-53,-44.4,15])
  rotate([-15,107,-10])
  rotate([0,0,180])
  translate([0,17,1.7])
  cube([8,8,3], center=true);
  
  translate([-60,-10,25])
  rotate([51,0,0]) 
  rotate([0,-28,0]) 
  cylinder(d=8, h=16,$fn=50,center=true);
}
// screwPoints();
// flatBottom();
// screwPoints();
// cylinder(d=3,h=30);
// cherrySwitch();

translate([-53,-44.4,15])rotate([-15,107,-10]){ 
  #proMicro();
  pmHolder_base();
  pmHolder_lid();
}

  translate([-60,-10,25])
  rotate([51,0,0]) 
  rotate([0,-28,0]){
      translate([0,0,2])
      cylinder(d=7.5, h=16,$fn=50,center=true);
      
      translate([0,0,8]){
          difference(){
            cylinder(d=10,h=2,center=true,$fn=6);
              cylinder(d=7,h=4,center=true,$fn=50);
          }
      }
  }

//rotate([0,180,0])proMicro();

//#translate([7.5,1.8,-7])pitch();
