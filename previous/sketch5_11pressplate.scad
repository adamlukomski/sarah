
//  press-plate for the servo to hold it
translate([10,-37,-7])
        difference()
        {
            union()
            {
                cube( [14,25,9.5] ); // main shape
                translate( [0,-8,0] ) cube( [3,25+2*8,9.5] ); // mount around screws
            }
            translate([-0.1,1,-0.1])
                cube( [12,23,10] );
            translate([1.1,-4,4.5]) 
                rotate([0,90,0])
                    {
                        cylinder( d=6.7, h=2, $fn=6 ); // 3mm nut
                        translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
                    }
            translate([1.1,25+4,4.5]) 
                rotate([0,90,0])
                    {
                        cylinder( d=6.7, h=2, $fn=6 ); // 3mm nut
                        translate([0,0,-2]) cylinder( d=4, h=5, $fn=12 ); // 3mm screw
                    }
        }
