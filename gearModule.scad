/* the original one was posted by by Entropic
 * on Jan 30, 2015; 5:25pm,  on OpenSCAD official forum
 *
 * License? by official author:
 * "Also I thought that someone might benefit from this if they aren't able to make a gear themselves."
 *
 */

numberOfTeeth = 20;
widthOfTeeth = 4;
heightOfTeeth = 5;
thicknessOfGear = 5;
radiusOfHoleForShaft = 4.242640687;  //If shaft is square, find the square of one side,
sidesOfShaft = 4;                    //multiply by two and then square root that to get radius
//diameter = ((teethNo x 1.7 x teethWidth)/pi)+ 2teethHeight

module tooth(width, thickness, height){
  scale([width/5,thickness/5,height/10]){
    difference(){
      translate([-2.5,0,0])
      cube([5,5,10]);
      translate([5+1.25-2.5,0-1,0])
      rotate([0,-14.0362434,0])
        cube([5,5+2,12]);
      translate([0-1.25-2.5,0+5+1,0])
      rotate([0,-14.0362434,180])
        cube([5,5+2,12]);
    }
  }
}
module gear(toothNo, toothWidth, toothHeight, thickness,holeRadius,holeSides){
  radius = (toothWidth*1.7*toothNo)/3.141592653589793238/2;
  rotate([-90,0,0])
  difference(){
    union(){
      for(i=[0:toothNo]){
        rotate([0,(360/toothNo)*i,0])
        translate([0,0,radius-0.5])
          tooth(toothWidth,thickness,toothHeight);
      }
      translate([0,thickness,0])
      rotate([90,0,0])
        cylinder(r=radius, h=thickness);
    }
  translate([0,thickness+1,0])
  rotate([90,0,0])
    cylinder(r=holeRadius,h=thickness+2,$fn=holeSides);
  }
}

module gearInside(toothNo, toothWidth, toothHeight, thickness,holeRadius,holeSides){
  radius = (toothWidth*1.7*toothNo)/3.141592653589793238/2;
  rotate([-90,0,0])
//  difference(){
    union(){
      for(i=[0:toothNo]){
        rotate([0,(360/toothNo)*i,0])
        translate([0,0,radius-0.5])
            mirror([0,0,1])
                translate([0,0,-toothHeight]) 
                    tooth(toothWidth,thickness,toothHeight);
      }
    }
//  translate([0,thickness+1,0])
//  rotate([90,0,0])
//    cylinder(r=holeRadius,h=thickness+2,$fn=holeSides);
//  }
}


//gear(numberOfTeeth,widthOfTeeth,heightOfTeeth,thicknessOfGear,radiusOfHoleForShaft,sidesOfShaft);

gearInside(numberOfTeeth,widthOfTeeth,heightOfTeeth,thicknessOfGear,radiusOfHoleForShaft,sidesOfShaft);

// tooth(toothWidth,thickness,toothHeight);

tooth(widthOfTeeth,thicknessOfGear,heightOfTeeth);

numberOfTeeth = 20;
widthOfTeeth = 4;
heightOfTeeth = 5;
thicknessOfGear = 5;
radiusOfHoleForShaft = 4.242640687;  //If shaft is square, find the square of one side,
sidesOfShaft = 4;                    //multiply by two and then square root that to get radius
//diameter = ((teethNo x 1.7 x teethWidth)/pi)+ 2teethHeight

module tooth(width, thickness, height){
  scale([width/5,thickness/5,height/10]){
    difference(){
      translate([-2.5,0,0])
      cube([5,5,10]);
      translate([5+1.25-2.5,0-1,0])
      rotate([0,-14.0362434,0])
        cube([5,5+2,12]);
      translate([0-1.25-2.5,0+5+1,0])
      rotate([0,-14.0362434,180])
        cube([5,5+2,12]);
    }
  }
}
module gear(toothNo, toothWidth, toothHeight, thickness,holeRadius,holeSides){
  radius = (toothWidth*1.7*toothNo)/3.141592653589793238/2;
  rotate([-90,0,0])
  difference(){
    union(){
      for(i=[0:toothNo]){
        rotate([0,(360/toothNo)*i,0])
        translate([0,0,radius-0.5])
          tooth(toothWidth,thickness,toothHeight);
      }
      translate([0,thickness,0])
      rotate([90,0,0])
        cylinder(r=radius, h=thickness);
    }
  translate([0,thickness+1,0])
  rotate([90,0,0])
    cylinder(r=holeRadius,h=thickness+2,$fn=holeSides);
  }
}

gear(numberOfTeeth,widthOfTeeth,heightOfTeeth,thicknessOfGear,radiusOfHoleForShaft,sidesOfShaft);
