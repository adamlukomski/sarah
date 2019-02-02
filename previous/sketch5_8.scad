/* diff from sketch5_5:

    gear teeth too long at 4, reduced to 3.5
    
    
    still TODO: flex-back mounts
    
    

*/

use <gearModule.scad>

module gear2(thick=5,flip=false) // height 15
{
    translate([0,0,0])
    intersection()
    {
        //thick = 5;
        translate([0,0,thick])
            gear(toothNo=14, toothWidth=2,
                 toothHeight=3.5, thickness=thick,
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

module part1(full=true)
{
    
    translate( [0,0,0] ) {
        // lower
        /*translate([0,0,-5]) hull()
        {
            cylinder( d1=10, d2=15, h=5 );
            translate( [0,10,0] ) cylinder( d1=20, d2=15, h=5 );
        }*/
        
        
        
        union(){
            spool(1.7,7.5,7.5);
            intersection()
            {
                translate([-10,-12,0])
                cube([20,12,5]);
                gear2(5);
            }
            }
            translate([0,10,0]) rotate([0,0,360/14/2]) {
            intersection() {
            translate([-10,0,0])
                cube([20,12,5]);
            gear2(5);
            }
        }
        
        translate( [0,0,7+5] ) {
                spool(1.7,7.5,7.5);
                union(){
                intersection()
                {
                    translate([-10,-12,0])
                    cube([20,12,5]);
                    gear2(5,true);
                }
                }
                translate([0,10,0]) rotate([0,0,360/14/2]) {
                intersection() {
                translate([-10,0,0])
                    cube([20,12,5]);
                gear2(5,true);
                }
            }
        }
        
        
    
    
    // inner spools    
        translate( [0,0,5]) {
        //upper
        /*translate([0,0,6]) hull()
        {
            cylinder( d1=15, d2=10, h=5 );
            translate( [0,10,0] ) cylinder( d1=15, d2=20, h=5 );
        }*/
        
        spool(a=1,r1=8.5,r2=7.3,maintrackextra=0.5);
        translate( [0,0,3+0.5] ) spool(a=1,r1=8.5,r2=7.3,maintrackextra=0.5);
        }
    }
   
    if( full )
    {
        // back, simple (no flex-back)
        translate([7,-8-1,0])
        difference()
        {
            cube([3,26+2,17]);
            translate([3,-1,8.5]) rotate([-90,90,0]) cylinder(d=9.5,h=70,$fn=6);
        }
        translate([7,-8-1,0])
            cube( [3,2,16] );
        translate([7,16+1,0])
            cube( [3,2,16] );
        
        // for flex-back v0.1
        
        translate([10,3,0])
        {
        difference() 
        {
            cube( [6,4,17] );
        translate([0,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
            translate([7,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
            translate([7,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
        }
        }
    
        
        // front, for holding wires
        difference() {
        translate([-11,3,0])
            cube( [5,4,17] );
        translate([-8.5,15,6.8])
            rotate([90,90,0]) cylinder(d=3,h=20,$fn=6);
        translate([-8.5,15,10.2])
            rotate([90,90,0]) cylinder(d=3,h=20,$fn=6);
        }
    
        // front, for bending wire (control signal)
        translate([-16,3,0])
        {
        difference() 
        {
            cube( [6,4,17] );
            translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
            translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
            translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
        }
        }
    }    
}


module mount1()
{
    translate([8.5,0,0]) rotate( [0,-90,0] ) intersection()
    {
        translate([0,-5,0]) part1();    
        translate([-15,-2,-5]) cube([30,30,30]);
    }
    //translate([-15,-18,0]) cube([5,20,3]);
    //translate([12,-18,0]) cube([5,20,3]);
    //translate([-15,-18,0]) cube([30,5,3]);
}

module mount3() // shorter mount1
{
    translate([8.5,0,0]) rotate( [0,-90,0] ) intersection()
    {
        translate([0,-9,0]) part1();    
        translate([-15,0,-5]) cube([30,30,30]);
    }
    //translate([-15,-18,0]) cube([5,20,3]);
    //translate([12,-18,0]) cube([5,20,3]);
    //translate([-15,-18,0]) cube([30,5,3]);
}

module mount2()
{
    translate([8.5,0,0]) rotate( [0,-90,0] ) intersection()
    {
        translate([0,-3,0]) part1(full=false);    
        translate([-15,-32.1,-5]) cube([30,30,30]);
    }
    //translate([-15,-18,0]) cube([5,20,3]);
    //translate([12,-18,0]) cube([5,20,3]);
    //translate([-15,-18,0]) cube([30,5,3]);
}




//linear_extrude(height = 5, center = true, convexity = 10, twist = 30)
//translate([0,8,0]) projection() rotate([90,0,0]) part1();
//part1();
//translate([0,28,0]) part1();


difference()
{
    part1();
    hull()
    {
        translate([0,0,-1]) cylinder( r=5, h=20 );
        translate([0,10,-1]) cylinder( r=5, h=20 );
    }
}

//part1();

// goes to sketch5_9:
//rotate([0,180,0])
//{
//    mount3();
//    rotate([0,90,0]) translate([0,-5,0]) mount2();
//    difference()
//    {
//        translate([-7.5,-7.5,-8]) cube([15,8,15]);
//        translate([-1,0,10]) rotate([153,43,0]) cylinder(d=4,h=20,$fn=6);
//        translate([1,0,10]) rotate([153,-43,0]) cylinder(d=4,h=20,$fn=6);
//        translate([-1,0,-10]) rotate([-153+180,-43,0]) cylinder(d=4,h=20,$fn=6);
//        translate([1,0,-10]) rotate([-153+180,43,0]) cylinder(d=4,h=20,$fn=6);
//    }
//}
//
//        translate([-13,1,-7])
//        {
//        difference() 
//        {
//            cube( [6,4,10] );
//            translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
//            //translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
//            translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
//            translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
//        }
//        }
//
//        mirror([1,0,0])
//        translate([-13,1,-7])
//        {
//        difference() 
//        {
//            cube( [6,4,10] );
//            translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
//            //translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
//            translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
//            translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
//        }
//        }
//
//
//        //  (control signal)
//         translate([-8,-8,14]) rotate([0,90,0])
//        {
//        difference() 
//        {
//            translate([0,0,1]) cube( [6,4,14] );
//            translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
//            translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
//            translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
//        }
//        }
//        
//        // flex-back
//        //  (control signal)
//         translate([8,-8,-14]) rotate([0,-90,0])
//        {
//        difference() 
//        {
//            translate([0,0,1]) cube( [7,4,14] );
//            translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
//            translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
//            translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
//        }
//        }





// wire: 1.5mm
/*translate([0,19,9.5])
    rotate([0,90,0])
        cylinder( d=1.5,h=10, center=true,$fn=36);
*/
        
        