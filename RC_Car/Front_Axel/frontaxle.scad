/*-----------------------------------------------------------------------------------

 Front axle for model Unimog M 1:16 (Bruder Toys chassis)
  
 (c) 2013 by Stemer114 (stemer114@gmail.com)
 License: licensed under the 
          Creative Commons - Attribution - Share Alike license. 
          http://creativecommons.org/licenses/by-sa/3.0/

 Credits: polyholes by nophead from MCAD library
          https://github.com/SolidCode/MCAD

-----------------------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------------
//libraries
//-----------------------------------------------------------------------------------
use <MCAD/polyholes.scad>
//test_polyhole();


//-----------------------------------------------------------------------------------
//display settings
//-----------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------
// View settings
// (when exporting single stls for printing, enable these one by one)
//-----------------------------------------------------------------------------------
show_AxleBody       = true;
show_AxleArmRight   = true;
show_AxleArmLeft    = true;
show_ServoConnector = false;
//explosion view
ex = 0;  // 0 - disabled, 1 - enabled

//-----------------------------------------------------------------------------------
// printer/printing settings
// (some dimensions are tuned to printer settings)
//
// the axle arms need to be printed upside down!
//-----------------------------------------------------------------------------------
layer_h = 0.3;  //layer height when printing
nozzle_d = 0.4; //nozzle size (adjust for your printer)

//-----------------------------------------------------------------------------------
// support settings
// (for the axle arms, you can enable creating support walls for printing
// the slicer might be able to create supports automtically
// but I prefer to create them manually just the way I need them
// when creating supports, enable explosion view (see above)
// else the model might look weird
//-----------------------------------------------------------------------------------
create_Support = false;
support_d = nozzle_d*3;  //support wall thickness (multiple of nozzle size)
support_color = "green"; //support color and alpha settings
support_alpha = 0.4;     //adjust these for better viewing in F5 mode

//-----------------------------------------------------------------------------------
//global configuration settings
//-----------------------------------------------------------------------------------
de = 0.1; //epsilon param, so differences are scaled and do not become manifold
fn_hole = 12;  //fn setting for round holes/bores (polyhole)


//-----------------------------------------------------------------------------------
//parameter settings (object dimensions)
//-----------------------------------------------------------------------------------

//P1xx - axle body
P100 = 10;  //height
P101 = 110;  //length
P102 = 10;  //thickness
P110 = 14;  //center support thickness
P111 = 20;  //center support width
P112 = 10;  //center support outer width
P120 = 3;   //diameter Achsschenkelbohrung
P121 = 3;   //diameter central support bore

//P2xx axle arm 
P200exRight = [15, 0, 0];    //explosion view offset vector (right arm)
P200exLeft  = [-15, 0, 0];   //explosion view offset vector (left arm)
P201 = P100+1;  //clearance height
P202 = 7;     //thickness bottom
P203 = 6;     //thickness top
P205 = 15;      //arm width
P206 = 18;      //arm length towards wheel
P207 = 15;      //inner clearance
P2081 = 3;      //offset endcap (x)
P2082 = 3;      //offset endcap (z)
P2083 = 3;      //offset endcap (y)
P210 = 3;       //diameter wheel axle bore
P220 = 3;       //diameter axle connect bore
//steering arm
P230 = 19.7;    //steering arm y offset
P231 = 3.5;     //steering arm x offset
P232 = 8;       //steering arm end width
P233 = P205;    //steering arm width at axle arm
P235 = 2;       //dia for connecting tie rod
P236 = P220;    //dia for axle arm connect
//alignment cutout for servo connector beam
//(on both sides, so one is free where to put the servo connector beam)
P240 = 6;       //offset from axle connector
P241 = 3.5;       //diameter (polyhole)
P242 = P202+layer_h;       //depth

//P3xx - Servo connector arm (below)
P300ex = [15, 0, -9];    //explosion view offset vector
P300 = P101/2;  //length
P301 = P240;    //offset to alignemnt bolt
P302 = P206-P2081;    //length outside part
P305 = P205;    //width outside part
P306 = 6;       //thickness
P307 = 3;       //connecting beam width
P310 = 8;       //servo connector diameter
P320 = 2;       //dia for ball head mounting
P321 = P220;    //dia for axle mounting
P322 = P241-0.2;    //dia for alignment bolt

//-----------------------------------------------------------------------------------
// nut trap config
// screw/nut dimensions for use (plus clearance for fitting purpose)
//-----------------------------------------------------------------------------------
nut_trap_wrenchsize = 5.5; //for M3 nut
nut_trap_depth = 3.5;      //nyloc


//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

//for debugging, show transparent cube at origin
//if (show_debugging_cube)
//	%cube(10);

AxleAssembly();



//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

// render the complete assembly, depending what components are enabled
module AxleAssembly()
{
    union()
    {
        if (show_AxleBody) {
            translate([0, 0, 0])
                AxleBody();
        }
        if (show_AxleArmRight) {
            translate(P200exRight*ex)
            translate([P101/2, 0, -P202 - (P201-P100)/2])
                AxleArmRight();
        }
        if (show_AxleArmLeft) {
            translate(P200exLeft*ex)
            translate([-P101/2, 0, -P202 - (P201-P100)/2])
                AxleArmLeft();
        }
        if (show_ServoConnector) {
            translate(P300ex*ex)
            translate([0, 0, P100/2-P201/2-P202-P306])
            ServoConnector();
        }
 

    }  //end union

}  //end module


module AxleBody()
{
    //left arm
    AxleBodyArm();
    //right arm
    mirror([1, 0, 0]) AxleBodyArm();
}

//arm is oriented towards left
module AxleBodyArm()
{
    difference()
    {
        union()
        {
            //outer part
            hull() {
                translate([-P101/2, 0, 0])
                    //cylinder(h=P100, r=P102/2);
                    polyhole(P100, P102);
                translate([-P111/2, 0, P100/2])
                    cube([de, P102, P100], center=true);
             }
            
            //intermediate part
            hull() {
                translate([-P111/2, 0, P100/2])
                    cube([de, P102, P100], center=true);
                translate([-P112/2, 0, P100/2])
                    cube([de, P110, P100], center=true);
             }

            //center part
            hull() {
                translate([-P112/2, 0, P100/2])
                    cube([de, P110, P100], center=true);
                translate([0, 0, P100/2])
                    cube([de, P110, P100], center=true);
              }
        }

        union()
        {
            //outer bore for Achsschenkel
            translate([-P101/2, 0, -de])
                polyhole(P100+2*de, P120);

            //bore for central support
            translate([0, P110/2+de, P100/2])
                rotate([90, 0, 0])
                polyhole(P110+2*de, P121);

        }
    }
}

module AxleArmRight()
{
    AxleArm();
}

module AxleArmLeft()
{
    mirror([1, 0, 0]) 
    {
        AxleArm();
    }
}
 
 

//Achsschenkel rechts, nur mit Lenkhebel
module AxleArm()
{
    difference()
    {
        union()
        {
            //axle inner part with connector to axle body
            hull() {
                translate([0, 0, 0])
                    //cylinder(h=P201+P202+P203, r=P205/2);
                    polyhole(P201+P202+P203, P205);
                translate([P206-P2081, 0, (P201+P202+P203)/2])
                    cube([de, P205, P201+P202+P203], center=true);
            }
            //outer part with chamfers and bore for wheel axle
            hull() {
                translate([P206-P2081, 0, (P201+P202+P203)/2])
                    cube([de, P205, P201+P202+P203], center=true);
                translate([P206, 0, (P201+P202+P203)/2])
                    cube([de, P205-P2083, P201+P202+P203-P2082], center=true);
            }

            //steering arm
            hull() {
                //end on axle arm
                translate([0, 0, P201+P202]) cylinder(h=P203, r=P233/2);
                //end on tie rod
                //translate([-P231, P230, P201+P203]) cylinder(h=P203, r=P232/2);
                translate([-P231, P230, P201+P202]) cylinder(h=P203, r=P232/2);
            }

        }

        union()
        {
            //cutout for mounting on axle body
            translate([-P205/2-de, -(P205+2*de)/2, P202])
                cube([P207+de, P205+2*de, P201], center=false);

            //bore for wheel axle
            translate([0, 0, (P201+P202+P203)/2])
                rotate([90, 0, 90])
                polyhole(P206+2*de, P210);

            //nut trap
            //source: http://forum.openscad.org/Drawing-tools-td4551i20.html
            translate([-P205/2+P207-de, 0, (P201+P202+P203)/2])
            rotate([0,90,0])
            cylinder(r = nut_trap_wrenchsize / 2 / cos(180 / 6) + 0.05, h=nut_trap_depth, $fn=6);

            //bore for connecting to axle body
            translate([0, 0, -de])
                //cylinder(h=P201+P202+P203+2*de, r=P220/2);
                polyhole(P201+P202+P203+2*de, P220);

            //bore for steering arm on axle arm side
            translate([0, 0, P201+P203])
                //translate([0, 0, -de]) cylinder(h=P203+2*de, r=P236/2);
                translate([0, 0, -de]) polyhole(P203+2*de, P236);

            //bore for steering arm on tie rod connecting side
            translate([-P231, P230, P201+P203])
                translate([0, 0, -de]) polyhole(P203+2*de, P235);

            //cutout for servo connector
            translate([P240, 0, -de])
                polyhole(P242+de, P241);

        }
    }

    //now add support walls if configured
    if (create_Support) {
        color(support_color, support_alpha) {

            /*
               support structure is a cylinder with bore, bore diameter is P220
               that way, after printing, the support cylinder can be easily cut away
               the volume of the complete part is quite small anyway
               therefore, a hollow support structure would bring more problems
               than it could possibly solve
               */

            translate([0, 0, P202])
            {
                //outer
                difference() {
                    polyhole(P201, P205);
                    translate([0, 0, -de]) polyhole(P201+2*de, P220);
                }
            }  //translate

            /* support structure is one side of a cylinder
               with a bottom of one layer thickness
               when the arm is printed upside down (because of the steering arm being
               at the base then)
               the bottom of the support structure supports printing the upper brackets
               polyhole
             */
            /*
            translate([0, 0, P202])
            {
                difference() {
                    hull() {
                    polyhole(P201, P205);
                    translate([+de-P205/2+P207, 0, P201/2])
                        cube([de, P205, P201], center=true);
                     }
                    translate([0, 0, layer_h]) polyhole(P201-layer_h+de, P205*2/3);
                    translate([(P207+de)/2, 0, P201/2+layer_h])
                        cube([P207+de, P205+2*de, P201], center=true);
                }
            } 
            */
 

        }  //color

    } //if support
}


//ServoConnector - beam for connecting one of the axle arms to a ball coupling
//with the steering servo
module ServoConnector()
{
    difference()
    {
        union()
        {
            hull() {
            hull() {
                translate([P300, 0, 0])
                    cylinder(h=P306, r=P305/2);
                translate([P300+P302, 0, P306/2])
                    cube([de, P305, P306], center=true);
            }

            //servo connector
            translate([0, 0, 0])
                polyhole(P306, P310);
            }

        }

        union()
        {
            //bore for connecting to axle body
            translate([P300, 0, -de])
                //cylinder(h=P201+P202+P203+2*de, r=P220/2);
                polyhole(P201+P202+P203+2*de, P220);

            //bore for alignment bolt
            //in combination with the cutout in the axle arm, 
            //a piece of 3mm print wire can be used for fixing the alignment
            translate([P300+P301, 0, -de])
                polyhole(P306+2*de, P322);

            //bore for ball coupling to servo
            translate([0, 0, -de])
                polyhole(P306+2*de, P320);
 
        }
    }
}


