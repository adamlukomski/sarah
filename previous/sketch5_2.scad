module spool() {
    a = 1;
    r1=7.5;
    r2=5;
    //middle
    hull() {
        translate( [0,0,0] )
            cylinder( r1=r1, r2=r2, h=a );
        translate( [0,10,0] )
            cylinder( r1=r1, r2=r2, h=a );
    }
    
    hull() {
        translate( [0,0,a] )
            cylinder( r1=r2, r2=r2, h=a );
        translate( [0,10,a] )
            cylinder( r1=r2, r2=r2, h=a );
    }
    hull() {
        translate( [0,0,2*a] )
            cylinder( r1=r2, r2=r1, h=a );
        translate( [0,10,2*a] )
            cylinder( r1=r2, r2=r1, h=a );
    }
}

// lower
translate([0,0,-5]) hull()
{
    cylinder( d1=10, d2=15, h=5 );
    translate( [0,10,0] ) cylinder( d1=20, d2=15, h=5 );
}

//upper
translate([0,0,6]) hull()
{
    cylinder( d1=15, d2=10, h=5 );
    translate( [0,10,0] ) cylinder( d1=15, d2=20, h=5 );
}

spool();
translate( [0,0,3] ) spool();