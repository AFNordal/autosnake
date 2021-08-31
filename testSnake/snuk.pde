class snuk{
  int x=int(w/2);
  int y=int(h/2);
  int dir=0;
  int pdir=0;
  int l=3;
  ArrayList<PVector> trail = new ArrayList<PVector>();
  int add=0;
  
  snuk(){
    for(int i=0; i<l+2; i++){
      trail.add(new PVector(x,y));
    }
  }
  
  void decide(){
    float[] in=new float[brainDim[0]];
    float dx=fx-x;
    float dy=fy-y;
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
    if(y+1>=h-1){
      danger[0]=true;
    }
    if(x+1>=w-1){
      danger[1]=true;
    }
    if(y-1<=0){
      danger[2]=true;
    }
    if(x-1<=0){
      danger[3]=true;
    }
    for(int i=trail.size()-1; i>=trail.size()-l; i--){
      if(trail.get(i).x==x){
        if(trail.get(i).y==y+1){
          danger[0]=true;
        }
        if(trail.get(i).y==y-1){
          danger[2]=true;
        }
      }
      if(trail.get(i).y==y){
        if(trail.get(i).x==x+1){
          danger[1]=true;
        }
        if(trail.get(i).x==x-1){
          danger[3]=true;
        }
      }
    }
    
    for(int i=0; i<3; i++){
      if(dir_[((((dir-1+i)%4)+4)%4)]==true){
        in[i]=1.0;
      }else{
        in[i]=0.0;
      }
      if(danger[((((dir-1+i)%4)+4)%4)]==true){
        in[3+i]=1.0;
      }else{
        in[3+i]=0.0;
      }
    }
    
    float[] ans=brain.feed(in);
    float max=max(ans);
    for(int i=0; i<ans.length; i++){
      if(ans[i]==max){
        input(i);
      }
    }
  }
  
  void input(int dir_){
    dir=(((dir+dir_-1)%4)+4)%4;
  }
  
  void move(){
    decide();
    if(dir==0){
      y++;
    }else if(dir==1){
      x++;
    }else if(dir==2){
      y--;
    }else{
      x--;
    }
    pdir=dir;
    if(x==fx && y==fy){
      score++;
      add+=prize;
      pickFood();
    }
    if(add>0){
      l++;
      add--;
    }
    if(x==0||x==w-1||y==0||y==h-1){
      stage=2;
    }
    
    for(int i=snek.trail.size()-snek.l; i<snek.trail.size(); i++){
      if(x==snek.trail.get(i).x && y==snek.trail.get(i).y){
        stage=2;
      }
    }
    trail.add(new PVector(x,y));
    if(trail.size()>l+5){
      trail.remove(0);
    }
  }
  
  void display(){
    float t=0;
    for(int i=trail.size()-1; i>=trail.size()-l; i--){
      t+=0.5;
      fill(0,0,255-noise(t)*155);
      noStroke();
      rect(trail.get(i).x*size,trail.get(i).y*size,size,size); 
    }
    strokeWeight(size/6);
    stroke(0);
    if(dir==0){
      stroke(0);
      point(x*size+size/4,y*size+size*3/4);
      point(x*size+size*3/4,y*size+size*3/4);
      stroke(255,100,100);
      line(x*size+size/2,y*size+size*5/6,x*size+size/2,y*size+size*7/6);
    }else if(dir==1){
      stroke(0);
      point(x*size+size*3/4,y*size+size/4);
      point(x*size+size*3/4,y*size+size*3/4);
      stroke(255,100,100);
      line(x*size+size*5/6,y*size+size/2,x*size+size*7/6,y*size+size/2);
    }else if(dir==2){
      stroke(0);
      point(x*size+size/4,y*size+size/4);
      point(x*size+size*3/4,y*size+size/4);
      stroke(255,100,100);
      line(x*size+size/2,y*size+size/6,x*size+size/2,y*size-size/6);
    }else if(dir==3){
      stroke(0);
      point(x*size+size/4,y*size+size/4);
      point(x*size+size/4,y*size+size*3/4);
      stroke(255,100,100);
      line(x*size+size/6,y*size+size/2,x*size-size/6,y*size+size/2);
    }
  }
}