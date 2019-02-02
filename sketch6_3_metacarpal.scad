
use <gearModule.scad>

module gear2(thick=5,flip=false) // height 15
{
    translate([0,0,0])
    intersection()
    {
        //thick = 5;
        translate([0,0,thick])
            gear(toothNo=14, toothWidth=2,
                 toothHeight=3, thickness=thick,
                 holeRadius=0,holeSides=4);

        union()
        {
            r1=11.5;
            r2 = 8.5;
            
            if(flip) {
            cylinder( r1=r2,r2=r1,h=thick/4);
            translate([0,0,thick/4]) cylinder( r1=r1,r2=r1,h=3*thick/4);
            //translate([0,0,3*thick/4]) cylinder( r1=r1,r2=r2,h=thick/4);
            }
            else
            {
            //cylinder( r1=r2,r2=r1,h=thick/4);
            translate([0,0,0]) cylinder( r1=r1,r2=r1,h=3*thick/4);
            translate([0,0,3*thick/4]) cylinder( r1=r1,r2=r2,h=thick/4);
            }
        }
    }
}

module spool(a=1,r1=8.5,r2=7.5,maintrackextra=0) {
    
    
    //middle
    hull() {
        translate( [0,0,0] )
            cylinder( r1=r1, r2=r2, h=a );
        translate( [0,10,0] )
            cylinder( r1=r1, r2=r2, h=a );
    }
    
    hull() {
        translate( [0,0,a] )
            cylinder( r1=r2, r2=r2, h=a+maintrackextra );
        translate( [0,10,a] )
            cylinder( r1=r2, r2=r2, h=a+maintrackextra );
    }
    hull() {
        translate( [0,0,2*a+maintrackextra] )
            cylinder( r1=r2, r2=r1, h=a );
        translate( [0,10,2*a+maintrackextra] )
            cylinder( r1=r2, r2=r1, h=a );
    }
}

module bottom(l=8)
{
    // 3/4 of a gear
    intersection()
    {
        rotate([0,0,360/14/2]) gear2(4);
        translate([-10,-12-2,0]) cube([20,12,5]); // cut in half
        rotate([0,0,-15]) translate([-10,-12,0]) cube([20,12,5]); // cut top couple teeth
    }
    // structure between gears:
    hull() {
        cylinder( d=15.1, h=4 );
        translate([0,l,0]) cylinder( d=15.1, h=4 );
    }
    // second gear, rotated to fit properly into first one's teeth
    
//    translate([0,l,0]) mirror([0,1,0]) intersection()
//    {
//        rotate([0,0,360/14/2]) gear2(4);
//        translate([-10,-12-2,0]) cube([20,12,5]); // cut in half
//        rotate([0,0,-15]) translate([-10,-12,0]) cube([20,12,5]); // cut top couple teeth
//    }
}

module spool2(r1=8.5,r2=7.5,a=1,b=1,c=1,length=8) {
    
    
    //middle
    hull() {
        translate( [0,0,0] )
            cylinder( r1=r1, r2=r2, h=a );
        translate( [0,length,0] )
            cylinder( r1=r1, r2=r2, h=a );
    }
    
    hull() {
        translate( [0,0,a] )
            cylinder( r1=r2, r2=r2, h=b );
        translate( [0,length,a] )
            cylinder( r1=r2, r2=r2, h=b );
    }
    hull() {
        translate( [0,0,a+b] )
            cylinder( r1=r2, r2=r1, h=c );
        translate( [0,length,a+b] )
            cylinder( r1=r2, r2=r1, h=c );
    }
}


/*    tunnels are shorter !!!! */
module part1(full=true) {
    // main body
//    difference()
    {
        union()
        {
            bottom(l=0);
            translate([0,0,14]) mirror([0,0,1]) bottom(l=0);
            
            translate([0,0,4])
                spool2(r1=7.5,r2=6,a=0.8,b=1.5,c=0.7,length=0);
            translate([0,0,7])
                spool2(r1=7.5,r2=6,a=0.7,b=1.5,c=0.8,length=0);
        }

    }

}


module servo_spool()
{
    // assumptions for control wire displacement = 50mm
    // diameter for full motor rotation should be 16mm
    // 180 degrees (1/2) rotation should be around d=32mm
    //translate([0,-30,0])
    difference()
    {
        union() // spool
        {
            translate([0,0,-1]) cylinder( d1=26, d2=22,h=3 );
        translate([0,0,2]) cylinder( d=22,h=3 );
        translate([0,0,5]) cylinder( d1=22,d2=26, h=2 );
        translate([0,0,7]) cylinder( d1=26,d2=26, h=2 );
        }
    }
}


// SERVO
translate([15,60,20])
    rotate([0,180,0])
        translate( [0,-30,0] )
        {
            servo_spool();
            translate([-6,-6,14]) cube( [12,23,21] );
            translate([-6,-6-4,16]) cube( [12,10,1.2] );
            translate([-6,-6+23,16]) cube( [12,4,1.2] );
        }


part1();



// springs - 1
translate([-13,1,0])
{
    difference() 
    {
        cube( [6,4,10] );
        translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
        //translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
        translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
        translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
    }
}

// springs - 2
mirror([1,0,0])
translate([-13,1,0])
{
    difference() 
    {
        cube( [6,4,10] );
        translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
        //translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
        translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
        translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
    }
}

offset = 3;

rotate([0,0,180])
{
    // mount for the press-plate:
    translate([10-3,-37-offset,-7])
            difference()
            {
            translate( [0,-8,0] ) cube( [3,25+2*8+offset,9.5] );
            translate([1.1,-4,4.5]) 
                rotate([0,90,0])
                        translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
            translate([1.1,25+4,4.5]) 
                rotate([0,90,0])
                        translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
            }
    
    // second wall, opposite to the servo:
    // screw holes because why not
    translate([-10,-37-offset,-7])
            difference()
            {
            translate( [0,-8,0] ) cube( [3,25+2*8+offset,9.5] );
            translate([1.1,-4,4.5]) 
                rotate([0,90,0])
                        translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
            translate([1.1,25+4,4.5]) 
                rotate([0,90,0])
                        translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
            }
    // back wall, with mounts for the Hillberry wires
    translate([-10,-37-3-8-1,-7])
        cube([20,3,9.5]);
            
// front support for the gear:
//intersection()
{
//translate([-10,0,-7])
//        cube( [20,12,8] );
translate([0,0,-7])
    cylinder( d1=13, d2=15, h=7 );
}
     

// after the half-spool supports for spring-mounts and control-wire-mount:
translate([-10,-4,-7])
        cube( [20,4,11] );
//translate([-7,-4,0])
//        cube( [14,4,17]);


translate([-8,-4,20]) rotate([0,90,0])
{
    difference() 
    {
        translate([0,0,1]) cube( [6,4,14] );
        translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
        translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
        translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
    }
}


}

