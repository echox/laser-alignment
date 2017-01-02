// servo.scad
//
// servo base holder for laser cutter calibration
// semi-parameterizable
//

$fn=300;

dia_inner=40;
dia_hole=30;
dia_pipe=15;
pipe_height=20;
wall=8;
height=20;
servo_width=42;
servo_nipple_height=2;
dia_servo_nipple=2;

// ------ don't modify behind this ------

dia_outer=dia_inner+wall;
cut=height+10;

module cyl() {
    difference() {
        //base
        cylinder(h=cut, d=dia_outer); 
        //inner cutout
        translate([0,0,wall]) cylinder(h=30, d=dia_inner);
        //hole cutout
        translate([0,0,-1]) cylinder(h=cut+1, d=dia_hole); 
    }
}

module holder() {
    
    //holder blocks and servo nipples
    translate([-10,0,0]) {
        translate([0,(servo_width/2 -5),0]) {
            cube([10,5,wall]);
            translate([5,2.5,wall]) cylinder(h=servo_nipple_height,d=dia_servo_nipple);
        }
        translate([0,-(servo_width/2),0]) {
            cube([10,5,wall]);
            translate([5,2.5,wall]) cylinder(h=servo_nipple_height,d=dia_servo_nipple);
        }
    }

    //connection to base
    difference() {
  //  linear_extrude(height = wall) {
        polyhedron 
            (points = [
                    [0,(servo_width/2),0],
                    [0,-(servo_width/2),0],
                    [50,0,0],
                    [0,(servo_width/2),wall],
                    [0,-(servo_width/2),wall],
                    [50,0,wall]
                    ],
             faces= [[0,1,2],[4,3,5],
                     [0,2,5,3],
                     [4,5,2,1],
                     [0,3,4,1]]);
   // }
    translate([dia_outer/2+5,0,-1]) cylinder(h=cut, d=dia_outer);
   //dirty lazy hack
    translate([40,-10,-1]) cube([40,40,40]);
    }
}

module pipe(rotation) {
        rotate([0,0,rotation]) {
        hull(){
            translate([0,0,pipe_height]) rotate([0,90,0]) cylinder(h=cut*2, d=dia_pipe);
            translate([0,0,pipe_height+height]) rotate([0,90,0]) cylinder(h=cut*2, d=dia_pipe);
        }
    }
}

difference() {
    union() {
        cyl();
        translate([-dia_outer/2-3,0,0]) holder();
    }
    pipe(-90);
    pipe(-40);
}
