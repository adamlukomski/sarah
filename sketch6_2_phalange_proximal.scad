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


/*    tunnels are shorter !!!! */
module part1(full=true) {
    // main body
//    difference()
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
//        hull()  // hole in the middle
//        {
//            translate([0,0,-1]) cylinder( d=8,h=20 );
//            translate([0,8,-1]) cylinder( d=8,h=20 );
//        }
    }
    
    if( full )
    {
        // Hillberry wire lower support and control wire support
        translate( [-7.5-3,0,4-1] ) difference()
        {
            intersection()
            {
                union()
                {
                    cube([3,8,6+2]); // start with a cube
                    translate([-2,3,2]) cube([2,2,4]); // add a second for control wire
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
            translate([0,0,4])
                rotate([-90,0,0])                           // 4. place flat
                    rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                        translate([0,0,-1])                 // 2. little lower, it will cut hole through
                            cylinder( d=3,h=10, $fn=6 );    // 1. cylinder, vertical
        }
        
        // Hillberry wire lower support and flex-back mount
        translate([7.5,-8,0]) difference()
        {
            intersection()
            {
                cube([5.5,24,14]);
                translate([1,12,7])
                    rotate([0,45,0]) cube([11,30,11],center=true);
            }
                // main Hillberry wires
            translate([0,0,3-0.5+3])                          // 5. move to a track
                rotate([-90,0,0])                           // 4. place flat
                    rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                        translate([0,0,13])                 // 2. little lower, it will cut hole through
                            cylinder( d=3,h=27, $fn=6 );    // 1. cylinder, vertical
            translate([0,0,3-0.5+3+3])                          // 5. move to a track
                rotate([-90,0,0])                           // 4. place flat
                    rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                        translate([0,0,13])                 // 2. little lower, it will cut hole through
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
            
            translate([3,12-2-3,7-3])
                cube([4,3,6]);
            translate([3,12,7-3])
                cube([4,3,6]);
        }
        
        
    } // if( full )
}

difference()
{
union()
{
    translate([7,-3,7]) rotate( [0,-90,0] ) intersection()
    {
        translate([0,0,0]) part1();    
        translate([-15,0,-5]) cube([30,30,30]);
        
    }
    
    translate([7,-3,7]) rotate( [0,-90,0] )
    // filling, so that spiral-like hole is doable
        translate([7.2,-12,0])
        {
            translate([0,0,3-0.5+3])                          // 5. move to a track
                rotate([-90,0,0])                           // 4. place flat
                    rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                        translate([0,0,13])                 // 2. little lower, it will cut hole through
                            cylinder( d=3,h=6, $fn=6 );    // 1. cylinder, vertical
            translate([0,0,3-0.5+3+3])                          // 5. move to a track
                rotate([-90,0,0])                           // 4. place flat
                    rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                        translate([0,0,13])                 // 2. little lower, it will cut hole through
                            cylinder( d=3,h=6, $fn=6 );    // 1. cylinder, vertical
        }
    translate([7,-3,-7.3]) rotate( [0,-90,0] )
    // filling, so that spiral-like hole is doable
        translate([7.2,-12,0])
        {
            translate([0,0,3-0.5+3])                          // 5. move to a track
                rotate([-90,0,0])                           // 4. place flat
                    rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                        translate([0,0,13])                 // 2. little lower, it will cut hole through
                            cylinder( d=3,h=6, $fn=6 );    // 1. cylinder, vertical
            translate([0,0,3-0.5+3+3])                          // 5. move to a track
                rotate([-90,0,0])                           // 4. place flat
                    rotate([0,0,30])                        // 3. rotate by half an edge, to be vertical
                        translate([0,0,13])                 // 2. little lower, it will cut hole through
                            cylinder( d=3,h=6, $fn=6 );    // 1. cylinder, vertical
        }
    
    
    translate([0,-3,0])
    intersection()
    {
        part1( full=false );
        translate([-10,-12,0]) cube( [20,12,18] );
    }
    
    
}

// spiral-like hole
translate([1.5,5,14.2])
    rotate([90,0,0])
        for( a=[0:0.1:3.14])
            translate([(1-cos(a*360/2/PI))*2.8,-(1-cos(a*360/2/PI))*2.9,a*3])
                cylinder( d=3, h=1, $fn=6 );
mirror([1,0,0])
// spiral-like hole
translate([1.5,5,14.2])
    rotate([90,0,0])
        for( a=[0:0.1:3.14])
            translate([(1-cos(a*360/2/PI))*2.8,-(1-cos(a*360/2/PI))*2.9,a*3])
                cylinder( d=3, h=1, $fn=6 );

// spiral-like hole
translate([1.5,5,0])
mirror([0,0,1])
    rotate([90,0,0])
        for( a=[0:0.1:3.14])
            translate([(1-cos(a*360/2/PI))*2.8,-(1-cos(a*360/2/PI))*2.9,a*3])
                cylinder( d=3, h=1, $fn=6 );
// spiral-like hole
mirror([1,0,0])
translate([1.5,5,0])
mirror([0,0,1])
    rotate([90,0,0])
        for( a=[0:0.1:3.14])
            translate([(1-cos(a*360/2/PI))*2.8,-(1-cos(a*360/2/PI))*2.9,a*3])
                cylinder( d=3, h=1, $fn=6 );
            
}

// springs - 1
translate([-13,5,0.5])
{
    difference() 
    {
        translate([0,-4,0]) cube( [6,8,10] );
        translate([-1,-5,6]) cube( [9,5,5] ); 
        translate([3,-5,6]) rotate([0,0,0]) cube([15,10,5]); // main hole
        //translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
        translate([0,-5,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
        translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
    }
}

// springs - 2
mirror([1,0,0])
translate([-13,5,0.5])
{
    difference() 
    {
        translate([0,-4,0]) cube( [6,8,10] );
        translate([-1,-5,6]) cube( [9,5,5] ); 
        translate([3,-5,6]) rotate([0,0,0]) cube([15,10,5]); // main hole
        //translate([0,-1,16]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // upper trim
        translate([0,-5,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
        translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
    }
}