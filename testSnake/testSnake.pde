int w=40;
int h=20;
int size=20;
int prize=1;
int wait=1;
int[] brainDim={6,5,3};
snuk snek=new snuk();
int index=0;
int fx,fy;
int stage=0;
int score=0;
int mode=0;
nNet brain=new nNet(brainDim[0],brainDim[1],brainDim[2]);

void settings(){
  size(w*size+240,h*size+40);
}

void setup(){
  brain=fromTxt(brainDim,"veldigbra.txt");
  pickFood();
}

void draw(){
  if(stage==0){
    screen();
    textSize(40);
    fill(255,0,0);
    textAlign(CENTER);
    text("Welcome to snuk",w*size/2,h*size/3);
    text("Click to play",w*size/2,2*h*size/3);
  }else if(stage==1){
    if(index==wait){
      background(100);
      world();
      snek.move();
      snek.display();
      index=0;
      score();
      drawNet(brain);
    }
    index++;
  }else if(stage==2){
    screen();
    textSize(33);
    textAlign(CENTER);
    fill(255,0,0);
    text("You got "+score+" points",w*size/2,h*size/3);
    text("Click to try again",w*size/2,2*h*size/3);
  }
}

void world(){
  noStroke();
  float xt=0;
  for(int x=0; x<w; x++){
    xt+=0.1;
    float yt=0;
    for(int y=0; y<h; y++){
      yt+=0.1;
      float n=noise(xt,yt)*100;
      fill(100-n,240-n,100-n);
      if(x==0||x==w-1||y==0||y==h-1){
        fill(100+n);
      }
      rect(x*size,y*size,size,size);
    }
  }
  fill(200,0,0);
  rect(fx*size,fy*size,size,size);
}

void pickFood(){
  
  boolean placed=false;
  
  while(placed==false){
    fx=int(random(1,w-2));
    fy=int(random(1,h-2));
    
    placed=true;
    for(int i=snek.trail.size()-snek.l; i<snek.trail.size(); i++){
      if(fx==snek.trail.get(i).x && fy==snek.trail.get(i).y){
        placed=false;
      }
    }
  }
}


void screen(){
  noStroke();
  float xt=0;
  for(int x=0; x<w; x++){
    xt+=0.1;
    float yt=0;
    for(int y=0; y<h+10; y++){
      yt+=0.1;
      float n=noise(xt,yt)*100;
      fill(100-n,240-n,100-n);
      rect(x*size,y*size,size,size);
    }
  }
}

void score(){
  textSize(35);
  fill(255,0,0);
  textAlign(CENTER);
  text(score,w*size/2,h*size+35);
}

void mousePressed(){
  if(stage==0){
    stage=1;
  }else if(stage==2){
    pickFood();
    stage=1;
    snek=new snuk();
    index=0;
    score=0;
  }
}

void drawNet(nNet net){
  strokeWeight(3);
  int[][] nodes=new int[3][];
  nodes[0]=new int[net.inNodes];
  for(int i=0; i<net.inNodes; i++){
    nodes[0][i]=180;
  }
  
  nodes[1]=new int[net.hidNodes];
  for(int i=0; i<net.hidNodes; i++){
    nodes[1][i]=int(map(net.b_h.data[i][0],-1,1,0,255));
    if(nodes[1][i]>255){
      nodes[1][i]=255;
    }else if(nodes[1][i]<0){
      nodes[1][i]=0;
    }
  }
  
  nodes[2]=new int[net.outNodes];
  for(int i=0; i<net.outNodes; i++){
    nodes[2][i]=int(map(net.b_o.data[i][0],-1,1,0,255));
    if(nodes[2][i]>255){
      nodes[2][i]=255;
    }else if(nodes[2][i]<0){
      nodes[2][i]=0;
    }
  }
  rectMode(CORNER);
  fill(255,50);
  noStroke();
  rect(w*size,0,240,180);
  
  float[] in=new float[brainDim[0]];
  float dx=fx-snek.x;
  float dy=fy-snek.y;
  boolean[] dir_=new boolean[4];
  boolean[] danger=new boolean[4];
  if(dy>0){
    dir_[0]=true;
  }else if(dy<0){
    dir_[2]=true;
  }
  if(dx>0){
    dir_[1]=true;
  }else if(dx<0){
    dir_[3]=true;
  }
  if(snek.y+1>=h-1){
    danger[0]=true;
  }
  if(snek.x+1>=w-1){
    danger[1]=true;
  }
  if(snek.y-1<=0){
    danger[2]=true;
  }
  if(snek.x-1<=0){
    danger[3]=true;
  }
  for(int i=snek.trail.size()-1; i>=snek.trail.size()-snek.l; i--){
    if(snek.trail.get(i).x==snek.x){
      if(snek.trail.get(i).y==snek.y+1){
        danger[0]=true;
      }
      if(snek.trail.get(i).y==snek.y-1){
        danger[2]=true;
      }
    }
    if(snek.trail.get(i).y==snek.y){
      if(snek.trail.get(i).x==snek.x+1){
        danger[1]=true;
      }
      if(snek.trail.get(i).x==snek.x-1){
        danger[3]=true;
      }
    }
  }
  
  for(int i=0; i<3; i++){
    if(dir_[((((snek.dir-1+i)%4)+4)%4)]==true){
      in[i]=1.0;
    }else{
      in[i]=0.0;
    }
    if(danger[((((snek.dir-1+i)%4)+4)%4)]==true){
      in[3+i]=1.0;
    }else{
      in[3+i]=0.0;
    }
  }
  float[] ans=net.feed(in);
  
  for(int i=0; i<net.inNodes; i++){
    fill(255-in[i]*255,in[i]*255,0);
    rect(w*size+10,180/(1+net.inNodes)*(i+1)-5,10,10);
  }
  
  for(int i=0; i<net.outNodes; i++){
    fill(255-ans[i]*255,ans[i]*255,0);
    rect(w*size+220,180/(1+net.outNodes)*(i+1)-5,10,10);
  }
  
  for(int i=0; i<net.w_ih.data.length; i++){
    for(int j=0; j<net.w_ih.data[i].length; j++){
      stroke(map(net.w_ih.data[i][j],-1,1,0,255),map(net.w_ih.data[i][j],-1,1,255,0),0);
      line(w*size+120,180/(1+nodes[1].length)*(i+1),w*size+40,180/(1+nodes[0].length)*(j+1));
    }
  }
  for(int i=0; i<net.w_ho.data.length; i++){
    for(int j=0; j<net.w_ho.data[i].length; j++){
      stroke(map(net.w_ho.data[i][j],-1,1,0,255),map(net.w_ho.data[i][j],-1,1,255,0),0);
      line(w*size+200,180/(1+nodes[2].length)*(i+1),w*size+120,180/(1+nodes[1].length)*(j+1));
    }
  }
  noStroke();
  for(int i=0; i<nodes.length; i++){
    for(int j=0; j<nodes[i].length; j++){
      fill(nodes[i][j]);
      ellipse(w*size+40+80*i,180/(1+nodes[i].length)*(j+1),20,20);
    }
  }
}
