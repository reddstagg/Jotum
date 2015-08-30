//-- Servo Tray for Carbon Fibre Rod
//-- Mrhamer.com
//-- GPL V3
servowidth= 20.5 ;
servoheight= 28.5 ;
servolength= 42 ;
fuselog = 10.5 ; 
internalbuffer =  5;
outsidebuffer = 5;
gap = servowidth + fuselog;

//Bracket


difference(){
translate([-outsidebuffer,-outsidebuffer,0])cube([servolength+outsidebuffer+outsidebuffer, servowidth+internalbuffer+fuselog+internalbuffer+servowidth+outsidebuffer+outsidebuffer, servoheight]);

//Removal
union(){
translate([0, servowidth + internalbuffer + (fuselog/2),servoheight/2])translate([-20,0,0])rotate(90,[0,1,0])cylinder(r=fuselog/2, h=servolength+50);
cube([42,servowidth,28.5]) ;
translate([0,gap+internalbuffer+internalbuffer,0])cube([42,servowidth,28.5]) ;
translate([servolength/2, servowidth + internalbuffer + (fuselog/2),-11])cylinder(r=2.8, 50);}
translate([-outsidebuffer,-outsidebuffer,10])cube([outsidebuffer+outsidebuffer+servolength,servowidth+outsidebuffer,servoheight-10]) ;
translate([-outsidebuffer,servowidth + fuselog + internalbuffer+ internalbuffer, 10])cube([outsidebuffer+outsidebuffer+servolength,servowidth+outsidebuffer,servoheight-10]) ;

}