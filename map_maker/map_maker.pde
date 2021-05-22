int im_x = 4500;
int im_y = 2234;
float im_scal = 0.3;
int mX=-1;
int mY=-1;
PImage img;

boolean makeTextbox = false;
boolean deleteMode = false;
String curr_name = "";
int cursor_pos = curr_name.length();
boolean cursor_init = false;
ArrayList<City> arr = new ArrayList<City>();
City queued;

void settings(){
  im_x *= im_scal;
  im_y *= im_scal;
  size(im_x, im_y);
}
void setup(){
  img = loadImage("../../data/map.png");
}

void draw(){
  imageMode(CORNER);
  image(img, 0,0, width, height);
  
  fill(255);
  text( mouseX+ "," + mouseY, mouseX, mouseY);
  
  //done box
  
  fill(255,0,0);
  for(City c: arr){
    ellipse(c.mX, c.mY,5,5);
  }
  
  fill(255);
  rect(0,0,10,10);
  
  if(makeTextbox){
    //text field
    fill(255);
    rect(im_x*0.3, im_y*0.3, 400,200);
    fill(0);
    String info;
    if(curr_name.length() > 1 && cursor_init){
      info = curr_name.substring(0,cursor_pos) + "|" + curr_name.substring(cursor_pos,curr_name.length());
    }
    else{
      info = curr_name + "|";
    }
 
    text(info, im_x*0.3 + 150, im_y*0.3 + 100);
    
    
    //enter box
    fill(255,0,0);
    rect(im_x*0.3, im_y*0.3+300, 400,100);
    fill(0);
    text("Enter",im_x*0.3 + 190, im_y*0.3+350 );
  }
  
  if(deleteMode){
    fill(255);
    rect(im_x*0.3, im_y*0.3+300, 400,100);
    fill(0);
    text("Delete?",im_x*0.3 + 190, im_y*0.3+350);
  }
}


void mousePressed(){
  if(deleteMode){
    //to delete
    if (mouseX > im_x*0.3 && mouseX < im_x*0.3 + 400 && mouseY > im_y*0.3+300 && mouseY < im_y*0.3+400){
      arr.remove(queued);
      deleteMode = false;
    }
  }
  else if(makeTextbox){
      //hit enter
      if (mouseX > im_x*0.3 && mouseX < im_x*0.3 + 400 && mouseY > im_y*0.3+300 && mouseY < im_y*0.3+400){
         arr.add(new City(mX, mY, curr_name));
         curr_name = "";
         makeTextbox = false;
         return;
      }
  }
  else{
    //exit
    if (mouseX > 0 && mouseX < 10 && mouseY > 0 && mouseY < 10){
       writetoFile();
    }
    else{
      //get mouse info
      mX = mouseX;
      mY = mouseY;
      
      //prompt text box
      makeTextbox = true;
    }
  }
  for(int i=0; i < arr.size(); i++){
      City c = arr.get(i);
     if(mouseX< c.mX+5 && mouseX > c.mX -5 && mouseY < c.mY+5 && mouseY > c.mY-5){
        deleteMode = true;
        makeTextbox = false;
        queued = c;
     }
  }
  
  
}

void keyPressed(){
  if(makeTextbox){
    if(!cursor_init){
      cursor_pos = curr_name.length();
    }
    if(keyCode != 8 && keyCode != 16 && keyCode != 37 && keyCode != 39){
      if(curr_name.length() > 1){
        curr_name= curr_name.substring(0,cursor_pos) + key + curr_name.substring(cursor_pos,curr_name.length());
        cursor_pos +=1;
      }
      else{
        curr_name += key;
      }
      
    }
    else if(key == BACKSPACE){
      if(curr_name.length() > 1 && cursor_pos > 0){
        curr_name= curr_name.substring(0,cursor_pos-1) + curr_name.substring(cursor_pos,curr_name.length());
        cursor_pos -=1;
      }
      else if(cursor_pos == curr_name.length()){
        curr_name = curr_name.substring(0,curr_name.length()-1);
      }
    }
    else if(keyCode == 37 && cursor_pos > 0){
      cursor_pos -=1;
      cursor_init = true;
    }
    else if(keyCode == 39 && cursor_pos < curr_name.length()){
      cursor_pos +=1;
      cursor_init = true;
    }
  }
}

void writetoFile(){
  String file = "../../data/custom_loc.txt";
  PrintWriter output;
  output = createWriter(file);
  
  for(City c: arr){
    output.println(c.getString());
  }
  
  output.close();
  exit();
}

class City{
  int mX;
  int mY;
  String name;
  
  City(int mX, int mY, String name){
    this.mX = mX;
    this.mY = mY;
    this.name = name;
  }
  
  String getString(){
    return name + "\t" + mX + "\t" + mY;
  }
}
