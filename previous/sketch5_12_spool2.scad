module servo_horn(height=2) // PowerHD HD-1800A - cross horn
{
    quality = 12;
    hull()
    {
        translate( [-12.5,0,0] ) cylinder( d=4, h=height,$fn=quality );
        translate( [0,0,0] ) cylinder( d=6, h=height,$fn=quality );
        translate( [12.5,0,0] ) cylinder( d=4, h=height,$fn=quality );
    }
    hull()
    {
        translate( [0,6,0] ) cylinder( d=5, h=height, $fn=quality );
        translate( [0,-6,0] ) cylinder( d=5, h=height,$fn=quality );
    }
}


// assumptions for control wire displacement = 50mm
// diameter for full motor rotation should be 16mm
// 180 degrees (1/2) rotation should be around d=32mm
//translate([0,-30,0])
difference()
{
    union() // spool
    {
        cylinder( d1=36, d2=32,h=2 );
        translate([0,0,2]) cylinder( d=32,h=3 );
        translate([0,0,5]) cylinder( d1=32,d2=36, h=2 );
    }
    translate([0,0,5]) servo_horn(height=3); //servo
    translate([7,6.5,-6]) rotate([-30,0,0]) cylinder(d=4,h=10);
    translate([12,19,3.5]) rotate([90,90,-30]) cylinder(d=3.5,h=10);
    
    translate( [9,-6,-0.1] )
    {
        cylinder( d=6.7, h=2, $fn=6 ); // 3mm nut
        translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
    }
    translate( [-9,6,-0.1] )
    {
        cylinder( d=6.7, h=2, $fn=6 ); // 3mm nut
        translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
    }
}



// lid:

translate([0,-40,0])  // [0,0,15] to be above
difference()
{
    cylinder(d1=36,d2=32,h=2);
    translate( [0,0,-1] ) cylinder(d=8,h=6);
        translate( [9,-6,-0.1] )
        {
            translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
            translate([0,0,1]) cylinder( d=7.5, h=5, $fn=12 ); // 3mm screw
        }
        translate( [-9,6,-0.1] )
        {
            translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
            translate([0,0,1]) cylinder( d=7.5, h=5, $fn=12 ); // 3mm screw
        }
}






