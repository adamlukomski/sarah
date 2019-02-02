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
        translate([0,0,12-5.5]) cylinder( d=6.5, h=5+5.5, $fn=12 ); // screw head

        translate([0,metacarpal_length,-2]) cylinder( d=4, h=20, $fn=12 ); // 3mm screw
        translate([0,metacarpal_length,12-5.5]) cylinder( d=6.5, h=5+5.5, $fn=12 ); // screw head
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


module metacarpal_mount(full=true)
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


// show this:
metacarpal();
// or:
//metacarpal_mount();