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
        gear2(4);
        translate([-10,-12,0]) cube([20,12,5]); // cut in half
        rotate([0,0,-30]) translate([-10,-12,0]) cube([20,12,5]); // cut top couple teeth
    }
    // structure between gears:
    hull() {
        cylinder( d=15.1, h=4 );
        translate([0,l,0]) cylinder( d=15.1, h=4 );
    }
    // second gear, rotated to fit properly into first one's teeth
    
    translate([0,l,0]) mirror([0,1,0]) intersection()
    {
        rotate([0,0,360/14/2]) gear2(4);
        translate([-10,-12-2,0]) cube([20,12,5]); // cut in half
        rotate([0,0,-35]) translate([-10,-12,0]) cube([20,12,5]); // cut top couple teeth
    }
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


// main body
difference()
{
    union()
    {
        bottom(l=8);
        translate([0,0,14]) mirror([0,0,1]) bottom(l=8);
        
        translate([0,0,4])
            spool2(r1=7.5,r2=6,a=0.8,b=1.5,c=0.7,length=8);
        translate([0,0,7])
            spool2(r1=7.5,r2=6,a=0.7,b=1.5,c=0.8,length=8);
    }
    hull()  // hole in the middle
    {
        translate([0,0,-1]) cylinder( d=8,h=20 );
        translate([0,8,-1]) cylinder( d=8,h=20 );
    }
}


// Hillberry wire lower support and control wire support
translate( [-7.5-3,0,4-1] ) difference()
{
    intersection()
    {
        union()
        {
            translate([1,0,-2]) cube([3,8,6+2+4]); // start with a cube
            translate([-2,3,-2]) cube([3,2,4+8]); // add a second for control wire
        }
        // cut the outer edges: (to be printable w/o supports)
        translate([3,4,3-0.4+1.5])                          
            rotate([0,45,0])
                cube( [8,8,8], center=true );  // spawn a centered cube
    }
    //rotate([-90,0,0]) cylinder( d=5,h=10, $fn=6 );
    
    // main Hillberry wires
    translate([3,0,3-0.5])                          // 5. move to a track
        rotate([-90,0,0])                           // 4. place flat
            rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                translate([0,0,-1])                 // 2. little lower, it will cut hole through
                    cylinder( d=3,h=10, $fn=6 );    // 1. cylinder, vertical
    translate([3,0,3-0.5+3])                          // 5. move to a track
        rotate([-90,0,0])                           // 4. place flat
            rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                translate([0,0,-1])                 // 2. little lower, it will cut hole through
                    cylinder( d=3,h=10, $fn=6 );    // 1. cylinder, vertical
    // control wire hole
    translate([1,0,4])
        scale([1.3,3,1.5])
        rotate([-90,0,0])                           // 4. place flat
                translate([0,0,-1])                 // 2. little lower, it will cut hole through
                    
                    // half a cylinder
                    intersection() {
                        rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                            cylinder( d=3,h=10, $fn=6 );    // 1. cylinder, vertical
                        translate([-1.5,-1.5,0]) cube([1.5,3,3] );
                    }
}

// Hillberry wire upper support and flex-back mount
translate([7.5,-8.5,0]) difference()
{
    intersection()
    {
        cube([5.5,25.5,14]);
        translate([1,12,7])
            rotate([0,45,0]) cube([11,30,11],center=true);
    }
        // main Hillberry wires
    translate([0,0,3-0.5+3])                          // 5. move to a track
        rotate([-90,0,0])                           // 4. place flat
            rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                translate([0,0,-1])                 // 2. little lower, it will cut hole through
                    cylinder( d=3,h=27, $fn=6 );    // 1. cylinder, vertical
    translate([0,0,3-0.5+3+3])                          // 5. move to a track
        rotate([-90,0,0])                           // 4. place flat
            rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                translate([0,0,-1])                 // 2. little lower, it will cut hole through
                    cylinder( d=3,h=27, $fn=6 );    // 1. cylinder, vertical
    hull() {
    translate([3.5,0,3-0.5+3])                          // 5. move to a track
        rotate([-90,0,0])                           // 4. place flat
            rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                translate([0,0,-1])                 // 2. little lower, it will cut hole through
                    cylinder( d=3,h=27, $fn=6 );    // 1. cylinder, vertical
    translate([3.5,0,3-0.5+3+3])                          // 5. move to a track
        rotate([-90,0,0])                           // 4. place flat
            rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                translate([0,0,-1])                 // 2. little lower, it will cut hole through
                    cylinder( d=3,h=27, $fn=6 );    // 1. cylinder, vertical
    }
    
    translate([3.5,12-2-1.5,7-3])
        cube([4,3.5,6]);
    translate([3.5,12+1,7-3])
        cube([4,3.5,6]);
    translate([0,12+2+2,7])
        rotate([-90,0,0]) scale([1,1.3,1]) rotate([0,0,30]) cylinder( d=9,h=20,$fn=6);
    translate([0,12+2+2-17,7])
        rotate([-90,0,0]) rotate([0,0,30]) cylinder( d=10,h=10,$fn=6);

}
// for the flex back - little triangle to support sliding it in
translate([7.5,-8.5,0])
{
    intersection() {
    translate([2,10.3,7-3])
        scale([1.6,1,1]) rotate([0,0,45]) cube([3,3,6]);  // "triangle" - full cube at 45 degrees
    translate([2,10.3,7-3]) 
        cube([3,5,6]);  // slice it in half to form a triangle (slope)
    }
}
//translate([50,0,0])
//part1();



