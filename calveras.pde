//Calcula la distribucion de perforaciones en un cilindro y genera el gcode para enviarlo a una maquina CNC
//Parametros Todos las medidas en milimetros.
//Diametro: diametro exterior del cilindro.
//Largo   : Largo del cilindro.
//Separacion Perimetro: Separacion de las perforaciones a lo largo del perimetro.
//Separacion Largo: Separacion de las perforaciones a lo largo del cilindro.
//Agujas: Largo de las agujas que sobresale del cilindro. Eventualmente se colocan agujas en las perforaciones, cuando eso sucede hay que tenrlo
//        en cuenta para el calculo.
//Pared: Grosor de la pered del cilindro.
//Trasbolillo: es una forma de distribuir las perforaciones
//             Consiste en intercalar una hilera de perforaciones alrededor del perimetro
//             a la mitad de la distancia indicada por Separacion_Largo y desplazada
//             una distancia equivalente  la mitad de Separacion_Perimetro


import processing.video.*;

import peasy.*;
import controlP5.*;
import processing.opengl.*;


PeasyCam cam;
ControlP5 cp5;
String textValue = "";
//Textfield Valor;
float Desp_t;
float Desp_angle;
float Desp_angle_i;
float x_pos;
int x_par;

float D_z_pos;

float Diame = 50;
float Larg= 50;
float Sep_Per = 5;
float Sep_Lar = 30;
float Agu;
float Par = 3;
float _tb = 0;
//int Agujas;
//int Pared;
//int TB;
int TBol=0;
int Rpor=0;
int D_TBol=0;
int D_Rpor=0;
int sides = 72;
int margen= 3;
PrintWriter output;
int myColor = color(211, 171, 26);


void setup()
{
   size(1200, 700, OPENGL);
   

   cam = new PeasyCam(this,0,0,0,100);
   cam.setMinimumDistance(150);
   cam.setMaximumDistance(300);
   cam.setDistance(175);
   
   
 //  cam.setYawRotationMode();   // like spinning a globe
cam.setPitchRotationMode(); // like a somersault
//cam.setRollRotationMode();  // like a radio knob
//cam.setSuppressRollRotationMode();  // Permit pitch/yaw only.
  
 
   
 //background(255);
  cp5 = new ControlP5(this);
  PFont font = createFont("Arial",24);


 
 
 Textfield d = cp5.addTextfield("Diametro")
     .setPosition(1000,50)
     .setSize(150,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,0))
     .setAutoClear(false)
     ;
  Label labeld = d.getCaptionLabel(); 
  labeld.setFont(font);
  labeld.setColor(color(255,0,0));
  labeld.toUpperCase(false);
  labeld.setText("Diametro"); 
  labeld.align(ControlP5.LEFT_OUTSIDE, CENTER);
  labeld.getStyle().setPaddingLeft(-10);

 
    Textfield l = cp5.addTextfield("Largo")
     .setPosition(1000,120)
     .setSize(150,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,0))
     .setAutoClear(false)
     ;
  Label labell = l.getCaptionLabel(); 
  labell.setFont(font);
  labell.setColor(color(255,0,0));
  labell.toUpperCase(false);
  labell.setText("Largo"); 
  labell.align(ControlP5.LEFT_OUTSIDE, CENTER);
  labell.getStyle().setPaddingLeft(-10); 
  
  
  Textfield sp = cp5.addTextfield("Sep_Perimetro")
     .setPosition(1000,190)
     .setSize(150,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,0))
     .setAutoClear(false)
     ;
Label labelsp = sp.getCaptionLabel(); 
  labelsp.setFont(font);
  labelsp.setColor(color(255,0,0));
  labelsp.toUpperCase(false);
  labelsp.setText("Separacion Perimetro"); 
  labelsp.align(ControlP5.LEFT_OUTSIDE, CENTER);
  labelsp.getStyle().setPaddingLeft(-10); 
 
  
   Textfield sl = cp5.addTextfield("Sep_Largo")
     .setPosition(1000,260)
     .setSize(150,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,0))
     .setAutoClear(false)
     ;
 Label labelsl = sl.getCaptionLabel(); 
  labelsl.setFont(font);
  labelsl.setColor(color(255,0,0));
  labelsl.toUpperCase(false);
  labelsl.setText("Separacion Largo"); 
  labelsl.align(ControlP5.LEFT_OUTSIDE, CENTER);
  labelsl.getStyle().setPaddingLeft(-10); 
 
   Textfield a = cp5.addTextfield("Agujas")
     .setPosition(1000,330)
     .setSize(150,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,0))
     .setAutoClear(false)
     ;   
  Label labela = a.getCaptionLabel(); 
  labela.setFont(font);
  labela.setColor(color(255,0,0));
  labela.toUpperCase(false);
  labela.setText("Largo Agujas"); 
  labela.align(ControlP5.LEFT_OUTSIDE, CENTER);
  labela.getStyle().setPaddingLeft(-10); 
  
  
  
   Textfield p = cp5.addTextfield("Pared")
     .setPosition(1000,400)
     .setSize(150,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,0))
     .setAutoClear(false)
     ;        
  Label labelp = p.getCaptionLabel(); 
  labelp.setFont(font);
  labelp.setColor(color(255,0,0));
  labelp.toUpperCase(false);
  labelp.setText("Espesor Pared"); 
  labelp.align(ControlP5.LEFT_OUTSIDE, CENTER);
  labelp.getStyle().setPaddingLeft(-10); 
 
 
  Textfield tb = cp5.addTextfield("TB")
     .setPosition(1000,470)
     .setSize(150,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,0))
     .setAutoClear(false)
     ;      
  Label labeltb = tb.getCaptionLabel(); 
  labeltb.setFont(font);
  labeltb.setColor(color(255,0,0));
  labeltb.toUpperCase(false);
  labeltb.setText("Trasbolillo"); 
  labeltb.align(ControlP5.LEFT_OUTSIDE, CENTER);
  labeltb.getStyle().setPaddingLeft(-10); 
 
 
    
    
    cp5.addButton("Gcode")
     .setPosition(900,590)
     .setSize(60,30)
     .setValue(0)
     .activateBy(ControlP5.RELEASE);
     ;

    cp5.addButton("clear")
     .setPosition(1100,590)
     .setSize(40,20)
     .setValue(0)
     .activateBy(ControlP5.RELEASE);
     ;
  
    cp5.addButton("Save")
     .setPosition(1000,590)
     .setSize(60,30)
     .setValue(0)
     .activateBy(ControlP5.RELEASE);
     ; 
  
    cp5.setAutoDraw(false);
 
 output = createWriter("cilinder.gcode");
 output.println("G21 G90");
 output.println("G0 F800");

}


void draw()
{
   background(200);
   lights();
   fill(255, 0, 0);
   drawCylinder(sides, Diame , Larg , Sep_Per, Sep_Lar, Agu, Par, _tb);
   gui();
}













void gui() {
  
  hint(DISABLE_DEPTH_TEST);
  stroke(220);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}



public void Diametro(String theText) {
  // automatically receives results from controller Diametro
  println("a textfield event for controller 'Diametro' : "+theText);
  Diame = float(theText);
  cp5.draw();
 
}

public void Largo(String theText) {
  // automatically receives results from controller Diametro
  println("a textfield event for controller 'Largo' : "+theText);
  Larg = float(theText);
  cp5.draw();
}

public void Sep_Perimetro(String theText) {
  // automatically receives results from controller Diametro
  println("a textfield event for controller 'Set_Perimetro' : "+theText);
  Sep_Per = float(theText);
  cp5.draw();
 
}

public void Sep_Largo(String theText) {
  // automatically receives results from controller Diametro
  println("a textfield event for controller 'Set_Perimetro' : "+theText);
  Sep_Lar = float(theText);
  cp5.draw();
}

public void Agujas(String theText) {
  // automatically receives results from controller Diametro
  println("a textfield event for controller 'Set_Perimetro' : "+theText);
  Agu = float(theText);
  cp5.draw();
}

public void Pared(String theText) {
  // automatically receives results from controller Diametro
  println("a textfield event for controller 'Set_Perimetro' : "+theText);
  Par = float(theText);
  cp5.draw();
}

public void TB(String theText) {
  // automatically receives results from controller Diametro
  println("a textfield event for controller 'Set_Perimetro' : "+theText);
  _tb = float(theText);
  cp5.draw();
}


void Gcode(int value) {
  int sides = 36;
  
 holes(Diame, Larg, Agu, Sep_Per, Sep_Lar, Par, _tb);
 
}


void holes(float D, float L, float A, float S_P, float S_L, float P, float T)
{
 int Cant_holes = round((((D +(A * 2)) * PI) / S_P));
 print("Cant_holes: ");
 println(Cant_holes);
 float Dist_holes = (D * PI) / Cant_holes;
 print("Dist_holes: ");
 println(Dist_holes);
 int Cant_ring = round((L - (margen * 2))/ S_L);
 float Dist_ring = ((L - (margen *2)) / Cant_ring);
 
 
 if(T > 0)
 {
   TBol = 2;
   Rpor = 2;
  } 
 else
 {
   TBol = 1;
   Rpor = 1;
 }
 
 
  for(int x = 0; x <= (Cant_ring * Rpor) + 1; x++){
 
x_pos = x * (Dist_ring / TBol);
 
   int x_par = x%2;
   print("x_par: ");
   println(x_par);
   if ( x_par == 0)
     {
      
       Desp_t = Dist_holes / 2.0;
     }
   else
     {
      Desp_t = 0;
     }
     
    
   println(x_pos);
  for(int y = 0; y <= Cant_holes-1; y++){
    
    
   output.println("G0 Z2.0 F800");
   output.println("G0 X" + x_pos +" Y" + ((y * Dist_holes) + Desp_t));
   output.println("G0 Z-" + (P + 1)+ ".0 F300");
   
   
  } 
 }
 println(Cant_holes);
 println(Dist_holes);
 println(Desp_t);
 println(Cant_ring);
 println(Dist_ring);
 print("T ");
 println(T);
 print("TBol ");
 println(TBol);
 println(Rpor);
 println(Cant_holes * Cant_ring);

}


void clear(int value) {
 
background(255);
}


void SAVE(int value)
{
 // endRecord();
  output.println("G0 Z2.0 F800");
  output.println("G0 X0.0 Y0.0");
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
}




 void drawCylinder (int sides, float d, float h, float Se_Pe , float Se_La, float Ag, float Pd, float tb)
{
    float r = d/2;
    background(255);
    noStroke();
    translate(-50,0,0);
    rotateX(PI);
    rotateY(-PI/3);
    rotateZ(PI);
    float angle = 360 / sides;
    float halfHeight = h / 2;
    
    
//******************************    
    // draw top shape
    beginShape();
       fill(myColor);
       for (int i = 0; i <=sides; i++) 
         {
           float x = cos( radians( i * angle ) ) * r;
           float y = sin( radians( i * angle ) ) * r;
           vertex( x, y, -halfHeight );    
         }
       fill(0);
       for (int i = 0; i <=sides; i++) 
         {
           float x = cos( radians( i * angle ) ) * (r-Pd);
           float y = sin( radians( i * angle ) ) * (r-Pd);
           vertex( x, y, -halfHeight );    
         }
    
    endShape(CLOSE);
    
//*********************************
     // draw body
    fill(myColor);  
    beginShape(TRIANGLE_STRIP);
 
       for (int i = 0; i <= sides + 1; i++) 
         {
           float x = cos( radians( i * angle ) ) * r;
           float y = sin( radians( i * angle ) ) * r;
           vertex( x, y, halfHeight);
           vertex( x, y, -halfHeight);  
         }

       for (int i = 0; i <= sides + 1; i++) 
         {
           float x = cos( radians( i * angle ) ) * (r-Pd);
           float y = sin( radians( i * angle ) ) * (r-Pd);
           vertex( x, y, halfHeight);
           vertex( x, y, -halfHeight);  
         }

      endShape(CLOSE); 

//*******************************
    //DRAW HOLES
      int C_h = round((((d +(Ag * 2)) * PI) / Se_Pe)); //C_h = Cant. agujeros; 
      float angle_holes = ((degrees( 2*PI)) / C_h);
      int Ca_ring = round((h - (margen * 2))/ Se_La);
      float Di_ring = ((h - (margen *2)) / Ca_ring);
      if(tb > 0)
         {
           D_TBol = 2;
         } 
           else
         {
           D_TBol = 1;
         }
      for (float z = -halfHeight+margen; z <=(halfHeight-margen); z+=(Di_ring/D_TBol))
         {
           int z_par = int(z)%2;
         if ( z_par == 0)
           {
             Desp_angle = 0.5;
           }
         else
           {
             Desp_angle = 0.0;
           }
         for (float i = 0+Desp_angle; i <= C_h + 1; i++) 
            {
              float x = cos( radians( (i) * angle_holes ) )*r; 
              float y = sin( radians( (i) * angle_holes ) )*r;
              translate(x, y, z);
              stroke(50, 50, 10);
              sphereDetail(3);
              sphere(0.2);
              stroke(255,0,0);
              translate(-x, -y, -z);
            }
         }
    
    
    //Interior
    for (float z = -halfHeight+margen; z <=(halfHeight - margen); z+=Di_ring/D_TBol)
    {
       
       int z_par_i = int(z%2);
   
   if ( z_par_i == 0)
     {
      
       Desp_angle_i = 0.5;
     }
   else
     {
       Desp_angle_i = 0.0;
     }
      
      for (int i = 0 ; i <= C_h + 1; i++) 
       {
         float x = cos( radians( (i+Desp_angle_i) * angle_holes ) )*(r-Pd);
         float y = sin( radians( (i+Desp_angle_i) * angle_holes ) )*(r-Pd);
         translate(x, y, z);
         stroke(255);
         sphereDetail(3);
         sphere(0.2);
         stroke(255,0,0);
         translate(-x, -y, -z);
       }
    }


} 
/*
 int Cant_holes = round((((D +(A * 2)) * PI) / S_P));
 print("Cant_holes: ");
 println(Cant_holes);
 float Dist_holes = (D * PI) / Cant_holes;
 print("Dist_holes: ");
 println(Dist_holes);
 int Cant_ring = round((L - (margen * 2))/ S_L);
 float Dist_ring = ((L - (margen *2)) / Cant_ring);
*/
