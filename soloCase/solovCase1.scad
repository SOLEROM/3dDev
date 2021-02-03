// aaaa




///////////////////////////////
///////////////////////////////


/* [GLOBAL] */
CREATE = "full"; //[full:Full, base:Base, case:Case]


// --------------
/*[General parameters]*/
// the number of facets used to generate an arc
$fn = 64 ;

// Tolerance for assembling part in mm
Margin=0.1 ;

// --------------
// Adjustable variables

/*[(1) Box size]*/
// inner length (X axis) in mm
Length=48 ;
// inner width (Y axis) in mm
Width=29 ;
// inner base height (Z axis) in mm
Base_height=16 ;
// Inner top height in mm
Top_height=5 ;

// Wall thickness in mm
Thickness=2 ;


/*[(1) PCB size]*/
// Space between the center of first support and the front side
Space_x = 4 ;
// Space between the center of support and the side (for left ot right alignment)
Space_y = 5 ;

//
// Distance between holes in X axis
Support_x=10;
// Distance between holes in Y axis
Support_y=15;


/*[(2) Supports]*/

SUPPORT_TYPE="pipe"; //[pipe:Pipe,corner:Corner]


// alignment mode : centered | align on right side | align on left side
Align = 0 ; // [0:center, 1:right, 2:left]




/*[(2) SupportType#1-pipes]*/

// Type of support : 0=simple, 1=with column, 2=M3x6 Bolt from above in hexagonal nut, 3=M3 Bolt from bottom in column
Support_type = [1, 3, 1, 3] ;


// diameter of the support plot (need to be wide enough if using nut)
Support_r = 4.5 ;
// diameter of the column above the plot
Column_r = 2.7 ;
// length of the Bolt (for type 3 support)
Bolt_length = 12 ;

// Height of the support
Support_z=3 ;

/* [(2) SupportType#2-Corner] */
// Size of PCB clamps
holder_spacing = 2;
// Size of platfrom supporting the PCB
holder_width = 2;
// Height that the PCB will be held
holder_height = 4;
// Height of the PCB clamps
holder_grip_height = 1.5;
// Offset of the PCB clamps. 0 = PCB width and height, >0 = looser fit, <0 = tighter fit. This value depends on your 3D printer
holder_offset = 0.2; //Ultimaker 2
// Hole in the PCB clamps. This is meant to screw the holder blocks in place. 0 for no hole
holder_hole_diameter = 1.2;

/*[(3) Top]*/
// help open ears
earsSize=2;

/*[(3) Top-image]*/
// Enable image
lid_image = false;
// Image path
lid_image_file = "topLogos/ping0.svg";
// Depth of the image inset
lid_image_depth = 0.5;
// Scale of the image
lid_image_scale = 1.1;
// Rotation of the image
lid_image_rotation = 0; //[0:0.1:360]
// Positional offset of the image
lid_image_offset = [0,0];

/*[(3) Top-Vents]*/
// Enable vents
lid_vent = false;
// Length and width of the vents
lid_vent_dimentions = [30,3];
// Ammount if vent slots
lid_vent_ammount = 4;
// Spaceing between the vents
lid_vent_spacing = 3;
// Rotation of the vents
lid_vent_rotation = 0; //[0:0.1:360]
// Positional offset of the vents
lid_vent_offset = [0,0];



/*[(4) RIGHT Panel]*/
R_cable_shape = "none"; //[none:None, rectangle:Rectangle, circle:Circle]
// Dimentions of the rectangular cable opening
R_cable_rec_dimentions = [15,5];
// Diameter of the circular cable opening
R_cable_cir_diameter = 3;
// Ammount of circular cable openings
R_cable_cir_ammount = 2;
// Distance between circular cable opening
R_cable_cir_spaceing = 2;
// Cable opening offset from its center position
R_cable_offset = [0,0];



/*[(4) LEFT Panel]*/
L_cable_shape = "none"; //[none:None, rectangle:Rectangle, circle:Circle]
// Dimentions of the rectangular cable opening
L_cable_rec_dimentions = [15,5];
// Diameter of the circular cable opening
L_cable_cir_diameter = 3;
// Ammount of circular cable openings
L_cable_cir_ammount = 2;
// Distance between circular cable opening
L_cable_cir_spaceing = 2;
// Cable opening offset from its center position
L_cable_offset = [0,0];



/*[ (5) Front Panel]*/
// Y center position (from center of board)
F_y=-2.5;
// Z lower position (from bottom of board)
F_z=3;
// Y size
F_size_y=10;
// Z size
F_size_z=6; 
// Text centered below the hole
F_Text="FRONT"; 
// Text size
F_Text_size = 3;   
F_Text_depp = 3; 

/*[ (5) BACK Panel]*/
// Y center position (from center of board)
B_y=-2.5;
// Z lower position (from bottom of board)
B_z=3;
// Y size
B_size_y=10;
// Z size
B_size_z=6; 
// Text centered below the hole
B_Text="FRONT"; 
// Text size
B_Text_size = 3;   
B_Text_depp = 3; 

/*[Power Cord hole]*/
// X position for the center of the power cord hole (from outside)
Hole_x=43;
// Z position for the center of the power cord hole
Hole_z=9;
//Diameter in mm (-1 to remove completly)
Hole_r=-1;


/* [Hidden] */
// M3 Bolt parameters
Bolt_hole_d = 2.5 ;
Bolt_passage_d = 3.1 ;
Bolt_head_h = 2.1 ; // 2 + 0.1 mm
Bolt_head_d = 6.4 ; // 5.4 + 1 mm
Nut_h = 2.5 ; // 2.3 + 0.2 mm
Nut_d = 6.6 ; // 6.4 + 0.2 mm
Screwing_length = 6 ;

// Pcb size
Pcb_height = 1.7 ;

// Translation for the center of the support
Y_translation = ( Align==0 ? Width/2 : (Align==1 ? Space_y+Support_y/2 : Width - (Space_y+ Support_y/2) ) ) ;



///////////////////////////////
///////////////////////////////

module true_mirror(m, o){
    children();
    translate(o){
        mirror(m){
            children();    
        }
    }
}

module dual_true_mirror(m1, o1, m2, o2){
    true_mirror(m1, o1){
        true_mirror(m2, o2){
            children();
        };
    };
}

module rotate_around_point(r, pt){
    translate(pt){
        rotate(r){
            translate(-pt){
                children();
            }
        }
    }   
}

// --------------
// modules definition

// Cube with rounded vertical ridge
module roundedCube(size, radius) {
    hull() {
        translate([radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        translate([radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
    }
}

// triangular prism for holding the top part
module prism(e,w){
   translate([-w/2, 0, -e]) polyhedron(
       points=[[0,0,0], [w,0,0], [w,e,e], [0,e,e], [0,0,2*e], [w,0,2*e]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
   ) ;
}


module plot(type)
{
   translate([0,0,Thickness - Margin]) {
      cylinder(r=Support_r, h=Support_z + Margin);
      cylinder(d=Bolt_hole_d, h=Support_z + 2*Pcb_height + Margin);
   }
}

module plot_hole(type)
{
   if (type==2) {
      translate([0,0,-Margin]) cylinder (h=Nut_h+Margin, d=Nut_d, $fn=6 ) ;
      cylinder (h=Thickness+Support_z+2*Pcb_height+3*Margin, d=Bolt_passage_d );
   }
   if (type==3) {
      translate([0,0,-Margin]) cylinder (h=Thickness+Support_z+2*Pcb_height+3*Margin, d=Bolt_passage_d );
      translate([0,0,-Margin]) cylinder(h=Bolt_head_h + Margin, d = Bolt_head_d) ;
   }
}

module plot_top(type)
{
   Column_height = Base_height + Top_height + Thickness - (Support_z + Pcb_height + 2*Margin) ;
   Column_Bolt_hole_height = Bolt_length + Bolt_head_h - (Support_z + Pcb_height + Margin) ;
   Screw_length = min(Screwing_length, Column_Bolt_hole_height) ;
   
   hole_length = (type==1 ? Pcb_height + 2*Margin : Column_Bolt_hole_height+Margin) ;
   diameter = (type==1 ? Bolt_hole_d+2*Margin : Bolt_hole_d) ;
 
   if (type==1 || type==3)
      difference () {
         cylinder(h=Column_height, r=Column_r) ;

         translate ([0,0,Column_height-hole_length-2*Margin]) cylinder (h=hole_length + 3*Margin, d=diameter) ;
         if (type==3) 
            translate ([0,0,Column_height-hole_length+Screwing_length]) cylinder (h=hole_length + 3*Margin, d=Bolt_passage_d) ;
      }
}


module plot_case_image()
{
    translate([
    (Length/2)+lid_image_offset[0],
    Width/2+Thickness+lid_image_offset[1],
    -0.1
]){
    rotate([0,0,lid_image_rotation]){
        scale([-lid_image_scale,lid_image_scale,1]){
            linear_extrude(lid_image_depth+0.1){
                import(lid_image_file,center=true);
            }
        }
    }
}
}


module plot_case_vents()
{      
          translate([
    (Length/2)-((lid_vent_dimentions[1]+lid_vent_spacing)*lid_vent_ammount-lid_vent_spacing)/2+lid_vent_offset[0],
    Width/2+Thickness-(lid_vent_dimentions[0])/2+lid_vent_offset[1],
    -0.1
])    
        {
            rotate_around_point([0,0,lid_vent_rotation],[((lid_vent_dimentions[1]+lid_vent_spacing)*lid_vent_ammount-lid_vent_spacing)/2,lid_vent_dimentions[0]/2]){
                for(i=[0:lid_vent_ammount-1]){
                    translate([i*(lid_vent_spacing+lid_vent_dimentions[1]),0,0]){
                        cube([lid_vent_dimentions[1],lid_vent_dimentions[0],Thickness+0.2]);
                    }
                }
            }
        }
  
    
    
}


module openSideForCable()
{
    render_offset = 0.1;
    
    if(R_cable_shape == "rectangle")
    {
       translate([Length/2+ R_cable_offset[0]
                ,-render_offset,
                Base_height/2+R_cable_offset[1]  ])   {
        cube([R_cable_rec_dimentions[0], Thickness +          render_offset, R_cable_rec_dimentions[1]]);    
      }
    }
    
    if(L_cable_shape == "rectangle")
    {
       translate([Length/2+ L_cable_offset[0]
                ,Width+Thickness,
                Base_height/2+L_cable_offset[1]  ])   {
        cube([L_cable_rec_dimentions[0], Thickness +          render_offset, L_cable_rec_dimentions[1]]);    
      }
    }
    
    
}

module conrner_support()
{
    
    pcb_width=Width;
    pcb_length=Length;
    render_offset = 0.1;  
    //Space_x Space_y
    //Support_x Support_y
       
    //Corner support
    translate([Thickness + Space_x, Thickness + Space_y])   
    {
        dual_true_mirror([0,1,0], [0,holder_spacing*2 + Support_y,0], [1,0,0], [holder_spacing*2 + Support_x ,0,0]){
            difference(){
                //Cube
                union(){
                    cube([holder_spacing-holder_offset,holder_spacing + holder_width,holder_height + holder_grip_height]);
                    cube([holder_spacing + holder_width,holder_spacing-holder_offset,holder_height + holder_grip_height]);
                    cube([holder_spacing + holder_width,holder_spacing + holder_width,holder_height]);
                }
                //Hole
                translate([holder_spacing+0.9,holder_spacing+0.8,0]){
                    cylinder(holder_height + holder_grip_height + render_offset,d=holder_hole_diameter,$fn=25);
                }
            }
        }
    }
}

// --------------
// Objects definition


module base(){
    difference () {
        // Base unit
        roundedCube( [Length+2*Thickness, Width+2*Thickness, Base_height+Thickness], Thickness) ;

        // hollowing the box
        translate([Thickness,Thickness,Thickness]) cube ([Length, Width, Base_height+Thickness], false);
        translate([Thickness/2, Thickness/2, Base_height]) cube ([Length + Thickness, Width + Thickness, 2*Thickness]);
        
        
        // Recess for lid
        translate([Thickness+(Length/2), 1.5*Thickness + Width - 0.1, Base_height + Thickness/2]) prism(Thickness/4+0.1, 10) ;
        translate([Thickness+(Length/2), 0.5*Thickness + 0.1, Base_height + Thickness/2]) rotate([0,0,180]) prism(Thickness/4+0.1, 10) ;
        

    // FRONT PANNEL 
        translate([-Thickness, Thickness + Y_translation + F_y - F_size_y/2, Thickness + Support_z + F_z]) cube([3*Thickness, F_size_y, F_size_z], false) ;
        
        translate([1-Margin, Thickness + Y_translation + F_y , Thickness + Support_z + F_z - F_Text_size - 1 ]) 
    rotate([90,0,-90])
    linear_extrude(height = 1+Margin)
    text(F_Text, size=F_Text_size, font="Arial:style=bold", halign="center");
        
    // BACK PANNEL 
        translate([Thickness+Length, Thickness + Y_translation + B_y - B_size_y/2, Thickness + Support_z + B_z]) cube([3*Thickness, B_size_y, B_size_z], false) ;
        
    translate([1-Margin+Length+Thickness, Thickness + Y_translation + B_y , Thickness + Support_z + B_z - B_Text_size - 1 ]) 
rotate([90,0,-270])
linear_extrude(height = 1+Margin)
text(B_Text, size=B_Text_size, font="Arial:style=bold", halign="center");
   
 
  
        
        openSideForCable() ;
        
       
        // Outside opening for power cord
        translate([Hole_x, -Thickness, Hole_z]) {
            rotate([-90, 0,0]) cylinder(r = Hole_r, h = Width+4*Thickness);
        }
        translate([Hole_x-Hole_r, -Thickness, Hole_z]) cube([2*Hole_r, Width+4*Thickness, Base_height-Hole_z+2*Thickness ], false) ;

        // Inside shape for power cord 
        translate([Hole_x-Hole_r-Thickness/2, Thickness/2, Hole_z]) cube([2*Hole_r+Thickness, Width+Thickness, Base_height-Hole_z+2*Thickness ], false) ;
    }


    //SupportsType1
    if(SUPPORT_TYPE == "pipe"){
            // SupportsType1
            translate([Thickness + Space_x, Thickness + Y_translation]) union () {
              translate([0, -Support_y/2])           plot(Support_type[0]);
              translate([0,  Support_y/2])           plot(Support_type[1]);
              translate([Support_x,  Support_y/2])   plot(Support_type[2]);
              translate([Support_x, -Support_y/2])   plot(Support_type[3]);
            }
            //SupportsType1
           translate([Thickness + Space_x, Thickness + Y_translation, -Margin]) union () {
              translate([0, -Support_y/2])           plot_hole(Support_type[0]);
              translate([0,  Support_y/2])           plot_hole(Support_type[1]);
              translate([Support_x,  Support_y/2])   plot_hole(Support_type[2]);
              translate([Support_x, -Support_y/2])   plot_hole(Support_type[3]);
           }
   }
  
  
   //SupportsType2
   if(SUPPORT_TYPE == "corner"){
       conrner_support() ;
   } 
   


}


///////////////////////////////
///////////////////////////////
///////////////////////////////


module render_base(){
translate([0, 0, 0]) difference(){
   base() ;}
}



module render_case(){
// lid
translate([0, Width+2*Thickness + 10, 0]) {
   difference(){
      union() {
         // Base unit
         roundedCube( [Length+2*Thickness, Width+2*Thickness, Top_height+Thickness], Thickness) ;
          
          //openEars
     translate([0, Width/2+Thickness, 0])
          roundedCube( [0, 0, Thickness], earsSize) ;
     translate([Length+2*Thickness, Width/2+Thickness, 0])
          roundedCube( [0, 0, Thickness], earsSize) ;
          
         // inside wall
         translate([Thickness/2+Margin, Thickness/2+Margin, Top_height+Thickness]) roundedCube( [Length+Thickness-2*Margin, Width+Thickness-2*Margin, Thickness-Margin], Thickness/2-Margin) ;


         // closing recess
         translate([Thickness+(Length/2), 1.5*Thickness + Width - Margin, Top_height+ 1.5*Thickness]) prism(Thickness/4, 10) ;
         translate([Thickness+(Length/2), Thickness/2 + Margin, Top_height+ 1.5*Thickness]) rotate([0,0,180]) prism(Thickness/4, 10) ;


         // Wall for closing power cord hole
         // extern wall
         translate([Hole_x-Hole_r+Margin, 0, Top_height+Thickness]) cube([2*(Hole_r-Margin), Width+2*Thickness, Base_height-Hole_z+Thickness ], false) ;
         // inside wall (bigger) 
         translate([Hole_x-Hole_r-Thickness/2+Margin, Thickness/2+Margin, Top_height+Thickness]) cube([2*(Hole_r-Margin)+Thickness, Width+Thickness-2*Margin, Base_height-Hole_z+Thickness ], false) ;
      }//union


   //diff the top image if selected
   if(lid_image == true){
       plot_case_image() ;
   }

   //Vent
   if(lid_vent == true){
       plot_case_vents() ;
    }

     // hollowing the lid
      translate([Thickness,Thickness,Thickness]) cube ([Length, Width, Top_height+Base_height], false);

      // Hole for power Cord
      translate([Hole_x, -Thickness, Top_height+Base_height-Hole_z+2*Thickness ]) 
         rotate([-90, 0,0]) cylinder(r = Hole_r, h = Width+4*Thickness);
      
   } ; //diff
  
   
   //SupportsType1
   if(SUPPORT_TYPE == "pipe"){ 
   // Column above the support plots
       translate([Thickness + Space_x, Thickness + Width - Y_translation]) union () {
          translate([0,  Support_y/2])           plot_top(Support_type[0]);
          translate([0, -Support_y/2])           plot_top(Support_type[1]);
          translate([Support_x, -Support_y/2])   plot_top(Support_type[2]);
          translate([Support_x,  Support_y/2])   plot_top(Support_type[3]);
       }
   }
   
   //SupportsType2
   if(SUPPORT_TYPE == "corner"){
       
   } 
   
}
}


///////////////////////////////
///////////////////////////////
///////////////////////////////

/* Generate */
if(CREATE == "full"){
render_base() ;
render_case() ;   
}
if(CREATE == "base"){
render_base() ;
}
if(CREATE == "case"){
render_case() ;
}