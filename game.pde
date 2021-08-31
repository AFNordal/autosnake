class game{
  snuk snek;
  
  game(){
    snek=new snuk();
  }
  
  void core(){ //<>//
    snek.core();
  }
  
  void display(){
    world();
    snek.display();
    score();
  }
  
  void world(){
    stroke(255);
    noFill();
    rect(0,0,w*size-1,h*size);
    noStroke();
    fill(200,0,0,alpha);
    //rect(fx*size,fy*size,size,size);
  }
  
  
  
  


  void score(){
    textSize(30);
    textAlign(CENTER);
    fill(255,alpha);
    text(snek.fitness,width/2,height-6);
  }
  
  void restart(){
    snek=new snuk();
    snek.pickFood();
  }
}