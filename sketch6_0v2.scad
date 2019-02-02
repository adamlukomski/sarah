use <gearModule.scad>

module gear2(thick=5,flip=false) // height 15
{
    translate([0,0,0])
    intersection()
    {
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
            }
            else
            {
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

module metacarpal_bottom(l=8)
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

module phalange()
{
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
                            rotate([0,0,30])                // 3. rotate by half an edge, to be vertical
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
}


/*    tunnels are shorter !!!! */
module proximal_part1(full=true) {
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

module proximal()
{
    difference()
    {
    union()
    {
        translate([7,-3,7]) rotate( [0,-90,0] ) intersection()
        {
            translate([0,0,0]) proximal_part1();    
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
            proximal_part1( full=false );
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
            translate([0,-5,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
            translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
        }
    }
}


/*    tunnels are shorter !!!! */
module metacarpal(full=true)
{
    metacarpal_length = 10;
    difference()
    {
        union()
        {
            metacarpal_bottom(l=metacarpal_length);
            translate([0,0,14]) mirror([0,0,1]) metacarpal_bottom(l=metacarpal_length);
            
            translate([0,0,4])
                spool2(r1=7.5,r2=6,a=0.8,b=1.5,c=0.7,length=metacarpal_length);
            translate([0,0,7])
                spool2(r1=7.5,r2=6,a=0.7,b=1.5,c=0.8,length=metacarpal_length);
        }
        translate([0,0,-2]) cylinder( d=4, h=20, $fn=12 ); // 3mm screw
        translate([0,0,12]) cylinder( d=6.5, h=5, $fn=12 ); // screw head

        translate([0,metacarpal_length,-2]) cylinder( d=4, h=20, $fn=12 ); // 3mm screw
        translate([0,metacarpal_length,12]) cylinder( d=6.5, h=5, $fn=12 ); // screw head
    }


    // springs - 1
    translate([-13,1,0])
    {
        difference() 
        {
            cube( [6,4,10] );
            translate([6.5,-1,8]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // main hole
//            translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
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
//            translate([0,-1,0]) rotate([-90,90,0]) cylinder(d=9.5,h=20,$fn=6); // lower trim
            translate([-1,4,7]) rotate([0,90,0]) cylinder(d=4,h=20,$fn=6); // upper trim
        }
    }
    
    rotate([0,0,180])
    {
        // glue side mounts to the main body
        translate([-13,-5,0])
                cube( [8,4,4] );
        translate([5,-5,0])
                cube( [8,4,4] );
        
        // control wire:
        translate([-8,-4-3,20]) rotate([0,90,0])
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
    
    
}


module metacarpal_mount()
{
    metacarpal_length = 10;
    difference()
    {
        
        hull() {
            cylinder( d=15.1, h=3 );
            translate([0,metacarpal_length,0]) cylinder( d=15.1, h=3 );
        }
                        
        translate([0,0,-2]) cylinder( d=4, h=20, $fn=12 ); // 3mm screw
        translate([0,metacarpal_length,-2]) cylinder( d=4, h=20, $fn=12 ); // 3mm screw
    }
   
    
}

module metacarpal_mount_semi()
{
    metacarpal_length = 10;
    difference()
    {
        
        hull() {
            cylinder( d=15.1, h=3 );
            translate([0,metacarpal_length,0]) cylinder( d=15.1, h=3 );
            translate([-15.1/2,metacarpal_length,0]) cube( [15.1,10,3] );
        }
                        
        translate([0,0,-2]) cylinder( d=4, h=20, $fn=12 ); // 3mm screw
        translate([0,metacarpal_length,-2]) cylinder( d=4, h=20, $fn=12 ); // 3mm screw
    }
   
    
}

module finger( full=false )
{
    metacarpal_mount();
    if( full )
        translate([0,0,3])    
        {
            metacarpal();
            translate([0,-21,0])
            {
                rotate([0,0,180]) proximal();
                translate([-7,-23,7])
                {
                    rotate([0,-90,180]) phalange();
                    translate([0,-26,0])
                    {
                        rotate([0,-90,180]) phalange();
                        translate([0,-26,0])
                        {
                            rotate([0,-90,180]) phalange();
                        }
                    }
                }
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

module servo()
{
// SERVO
    translate([0,0,-1])
    rotate([0,180,0])
        {
            servo_spool();
            translate([-6,-6,14]) cube( [12,23,21] );
            translate([-6,-6-4,16]) cube( [12,10,1.2] );
            translate([-6,-6+23,16]) cube( [12,4,1.2] );
        }
}

module servo_mount()
{
    translate([-8,-7,-27])
    {
        difference()
        {
        translate( [0,-8-6,0] ) cube( [3,25+2*8+6+6,9.5] );
        translate([1.1,-4,4.5]) 
            rotate([0,90,0])
                    translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
        translate([1.1,25+4,4.5]) 
            rotate([0,90,0])
                    translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
        }
        
//        // horizontal support
//        intersection(){
////        rotate([0,-35,0])
//        translate( [-9.5+3,-8-6-3,-3] ) cube( [9.5,25+2*8+6+3,3] );
//        translate( [-9.5+3,-8-6-3,-3-3] ) cube( [9.5,25+2*8+6+3,3+6] );
//        }
        
//        translate( [0,36,0] )
//        rotate([ 90,90,0]) smallplate_two_holes();
    }   
}

module servo_mount_vertical_pressplate(upper=true)
{
    // 28mm distance between centres of holes
    difference()
    {
        union()
        {
            if( upper )
            {
                translate([-6-3,-6-3,-29]) cube([12+3+3,3,10]);
                translate([-6-3,-6-3,-29]) cube([3,26,10]);
                translate([-6-3-10,-6-3+26-3,-29]) cube([10,3,10]);
                translate([6,-6-3,-29]) cube([3,26,10]);
                translate([9,-6-3+26-3,-29]) cube([10,3,10]);
            }
            else
            {
                translate([-19,-6-3+26,-29]) cube([38,3,10]);
            }
            
        }
        translate([-6-3-5,-6-3+26-3,-24])
        rotate([90,90,0])
        {
            translate([0,0,-2]) cylinder( d=6.7, h=3, $fn=6 ); // 3mm nut
            translate([0,0,-7]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
        }
        translate([14,-6-3+26-3,-24])
        rotate([90,90,0])
        {
            translate([0,0,-2]) cylinder( d=6.7, h=3, $fn=6 ); // 3mm nut
            translate([0,0,-7]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
        }
    
    }

}
    
//
//show_fingers = false;
//translate([0,-12,0]) // a bit forward
//{
//    finger(full=show_fingers); // middle - 3
//    translate([30,10,0]) rotate([0,0,5]) finger(full=show_fingers); // ring - 4
//    translate([60,20,0]) rotate([0,0,10]) finger(full=show_fingers); // pinky - 5
//    translate([-30,18,0]) rotate([0,0,-5]) finger(full=show_fingers); // index - 2
//}
//translate([-20,115,10]) rotate([0,45,-60]) finger(full=show_fingers); // thumb - 1
// thumb with a hole:




/*
translate([13,40,20]) rotate([0,0,-90]) {
    servo(); // motor middle
    servo_mount();
}
translate([48,50,20]) rotate([0,0,-90]) servo(); // motor pinky
translate([18,70,20]) rotate([0,0,-90]) servo(); // motor ring
//translate([26,75,5]) rotate([90,180,-90]) servo(); // motor ring
//translate([-32,60,5]) rotate([90,180,-90]) servo(); // motor index
translate([-20,60,20]) rotate([0,0,-90]) servo(); // motor index
translate([28,100,20]) rotate([0,0,-90]) servo(); // motor thumb

*/
//
//z_offset = 3;
//show_motors = true;
//translate([50,45,5+z_offset]) rotate([0,270,10]) 
//{
//    if( show_motors )
//        servo(); // motor pinky
//    servo_mount();
//}
//translate([20,80,5+z_offset]) rotate([0,270,5])
//{
//    if( show_motors )
//        servo(); // motor ring
//    servo_mount();
//}
//translate([-5,35,5+z_offset]) rotate([0,270,0])
//{
//    if( show_motors )
//        servo(); // motor middle
//    servo_mount();
//}
//translate([-22,55,5+z_offset]) rotate([180,270,-5])
//{
//    if( show_motors )
//        servo(); // motor index
//    servo_mount();
//}
//
//
//// main plate
//
//hull() {
//    translate([75,30,0]) cylinder(h=3,d=10); // below pinky
//    translate([40,20,0]) cylinder(h=3,d=10); // between pinky and ring
//}
//hull() {
//    translate([40,20,0]) cylinder(h=3,d=10); // between pinky and ring
//    translate([0,5,0]) cylinder(h=3,d=10); // below middle
//}
//hull() {
//    translate([0,5,0]) cylinder(h=3,d=10); // below middle
//    translate([-25,25,0]) cylinder(h=3,d=10); // below index
//}
//hull() {
//    translate([-25,25,0]) cylinder(h=3,d=10); // below index
//    translate([-48,25,0]) cylinder(h=3,d=10); // index motor upper
//}
//
//
//difference()
//{
//    union()
//    {
//        hull() {
//            translate([-45,75,0]) cylinder(h=3,d=10); // index motor lower
//            translate([-10,85,0]) cylinder(h=3,d=10); // between index lower motor and middle lower motor
//        }
//        hull() {
//            translate([-10,85,0]) cylinder(h=3,d=10); // between index lower motor and middle lower motor
//            translate([15,65,0]) cylinder(h=3,d=10); // middle lower motor
//        }
//    }
//    translate([-10,85,-2]) cylinder( d=4, h=6, $fn=12 ); // 3mm screw
//}
//        
//
//
//hull() {
//    translate([40,95,0]) cylinder(h=3,d=10); // ring motor lower
//    translate([65,80,0]) cylinder(h=3,d=10); // pinky motor lower
//}
//
//hull() {
//    translate([17,45,0]) cylinder(h=3,d=10); // middle motor
//    translate([42,60,0]) cylinder(h=3,d=10); // ring lower motor
//}
//
//
//difference()
//{
//    union()
//    {
//
//        hull() {
//            translate([67,82,0]) cylinder(h=3,d=10); // pinky lower motor
//            translate([67,112,0]) cylinder(h=3,d=10); // left-most hand
//        }
//        hull() {
//            translate([67,112,0]) cylinder(h=3,d=10); // left-most hand
//            translate([40,115,0]) cylinder(h=3,d=10); // ring motor lower
//        }
//    }
//    translate([67,112,-1]) cylinder( d=4, h=6, $fn=12 ); // 3mm screw
//    translate([67,95,-1]) cylinder( d=4, h=6, $fn=12 ); // 3mm screw
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//






//
//
//
////hull() {
////    translate([-10,85,0]) cylinder(h=3,d=10); // between index lower motor and middle lower motor
////    translate([-13,130,0]) cylinder(h=3,d=10); // thumb motor upper
////}
////
////hull() {
////    translate([30,155,0]) cylinder(h=3,d=10); // thumb motor lower
////    translate([50,135,0]) cylinder(h=3,d=10); // left-most palm point
////}
////hull() {
////    translate([50,135,0]) cylinder(h=3,d=10); // left-most palm point
////    translate([40,115,0]) cylinder(h=3,d=10); // ring motor lower
////}
//
//translate([-25,115,10]) rotate([0,45,-60])
//    finger(full=show_fingers); // thumb - 1
//
//
//translate([25,125,5+z_offset]) rotate([120,270,0])
//{
//    if( show_motors )
//        servo(); // motor thumb
//    servo_mount();
//}
//
//// thumb support
//translate([-25,115,10])
//{
//    intersection()
//    { // clip at ground plane
//        rotate([0,45,-60])
//        {
//            translate([0,0,-20])
//                scale([1,1,7]) metacarpal_mount();
//        
//        }
//        translate([-20,-20,-10]) cube([40,40,30]);
//    }
//}

module servo_block(full=true)
{
    translate([-12.5,15,20])
    {
        rotate([-90,0,0])
        {
            if( full )
                servo();
            servo_mount_vertical_pressplate(upper=full);
        }
        translate([25,-30,0])
        rotate([-90,0,180])
        {
            if( full )
                servo();
            servo_mount_vertical_pressplate(upper=full);
        }
    }
    difference()
    {
        translate([-60/2,-4,0]) cube([60,8,3]);
        translate([-38/2,-5,-1]) cube([14,5,5]);
        translate([12/2,0,-1]) cube([14,5,5]);
    }
}

show_servo = true;
servo_block(full=show_servo);
translate([0,46,0]) servo_block(full=show_servo);
translate([-6.5,14,0]) cube([13,18,3]);

show_fingers = false;
translate([-50,-15,0]) rotate([0,0,270+10])
{
    //cube([10,10,3]);
    metacarpal_mount_semi(); // pinky
    finger(full=show_fingers);
}
translate([-55,12,0]) rotate([0,0,270+5])
{
    //cube([10,10,3]);
    metacarpal_mount_semi(); // ring
    finger(full=show_fingers);

}
hull()
{
    translate([-35,12,0]) cylinder( d=12,h=3 );
    translate([-30,0,0]) cylinder( d=12,h=3 );
}

translate([-60,12+27,0]) rotate([0,0,270])
{
    //cube([10,10,3]);
    metacarpal_mount_semi(); // middle
    finger(full=show_fingers);

}
translate([-52,12+27+27,0]) rotate([0,0,270-5])
{
    //cube([10,10,3]);
    metacarpal_mount_semi(); // index
    finger(full=show_fingers);

}
hull() {
    translate([-35,12,0]) cylinder( d=12,h=3 );
    translate([-35,12+27+3,0]) cylinder( d=12,h=3 );
}
hull() {
    translate([-35,12+27+3,0]) cylinder( d=12,h=3 );
    translate([-30,12+27+27,0]) cylinder( d=12,h=3 );
}




//
//
//
//use <bioloid_dynamixel_ax12.scad>
//
//translate([0,0,25])
//rotate([0,-90,0])
//dynamixel_ax12();
//translate([0,33,25])
//rotate([0,-90,0])
//dynamixel_ax12();
//translate([0,66,25])
//rotate([0,-90,0])
//dynamixel_ax12();
//translate([0,99,25])
//rotate([0,-90,0])
//dynamixel_ax12();
//translate([0,99+33,25])
//rotate([0,-90,0])
//dynamixel_ax12();