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


// assumptions for control wire displacement = 50mm / 30mm
// diameter for full motor rotation should be 16mm / 10mm
// 180 degrees (1/2) rotation should be around d=32mm / 20mm
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
    translate([0,0,7]) servo_horn(height=3); //servo
    translate([7-5,6.5-2,-5]) rotate([-30,0,0]) cylinder(d=4,h=10);
    translate([12-5,19-2,3.5]) rotate([90,90,-30]) cylinder(d=3.5,h=10);
    
    translate( [6,-6,-1.1] )
    {
        cylinder( d=6.7, h=2, $fn=6 ); // 3mm nut
        translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
    }
    translate( [-6,6,-1.1] )
    {
        cylinder( d=6.7, h=2, $fn=6 ); // 3mm nut
        translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
    }
}



// lid:

translate([0,-40,-1])  // [0,0,15] to be above
difference()
{
    cylinder(d1=26,d2=22,h=2);
    translate( [0,0,-1] ) cylinder(d=8,h=6);
        translate( [6,-6,-0.1] )
        {
            translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
            translate([0,0,1]) cylinder( d=7.5, h=5, $fn=12 ); // 3mm screw
        }
        translate( [-6,6,-0.1] )
        {
            translate([0,0,-2]) cylinder( d=4, h=15, $fn=12 ); // 3mm screw
            translate([0,0,1]) cylinder( d=7.5, h=5, $fn=12 ); // 3mm screw
        }
}






