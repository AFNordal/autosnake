class snuk{
  int x=int(w/2);
  int y=int(h/2);
  int fx,fy;
  int dir=0;
  int pdir=0;
  int l=3;
  ArrayList<PVector> trail = new ArrayList<PVector>();
  int add=0;
  nNet brain=new nNet(brainDim[0],brainDim[1],brainDim[2]);
  boolean dead=false;
  int fitness=1;
  float pDist;
  
  snuk(){
    for(int i=0; i<l+2; i++){
      trail.add(new PVector(x,y));
    }
    
    pickFood();
    pDist=dist(x,y,fx,fy);
  }
  
  void core(){
    if(dead==false){
      decide();
      move();
      checkFood();
      checkDead();
      trail();
    }
  }
  
  void pickFood(){
    
    boolean placed=false;
    while(placed==false){
      fx=int(random(0,w-1));
      fy=int(random(0,h-1));
      
      placed=true;
      for(int i=trail.size()-l; i<trail.size(); i++){
        if(fx==trail.get(i).x && fy==trail.get(i).y){
          placed=false;
        }
      }
    }
    pDist=dist(x,y,fx,fy);
  }
  
  void move(){
    if(dir==0){
      y++;
    }else if(dir==1){
      x++;
    }else if(dir==2){
      y--;
    }else if(dir==3){
      x--;
    }
    pdir=dir;
    if(dist(x,y,fx,fy)>pDist){
      if(fitness>1){
        fitness--;
      }
    }else{
      fitness++;
    }
    pDist=dist(x,y,fx,fy);
  }
  
  void checkFood(){
    if(x==fx && y==fy){
      fitness+=prize;
      add+=growth;
      pickFood();
    }
  }
   
  void checkDead(){
    if(x==-1||x==w||y==-1||y==h){
      dead=true;
    }
    
    for(int i=trail.size()-l; i<trail.size(); i++){
      if(x==trail.get(i).x && y==trail.get(i).y){
        dead=true;
      }
    }
  }
  
  void trail(){
    if(add>0){
      l++;
      add--;
    }
    trail.add(new PVector(x,y));
    if(trail.size()>l+5){
      trail.remove(0);
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
    if(y+1>=h){
      danger[0]=true;
    }
    if(x+1>=w){
      danger[1]=true;
    }
    if(y-1<0){
      danger[2]=true;
    }
    if(x-1<0){
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
  
  void display(){
    //float t=0;
    for(int i=trail.size()-1; i>=trail.size()-l; i--){
      //t+=0.5;
      //fill(0,0,255-noise(t)*155);
      fill(255,alpha);
      noStroke();
      rect(trail.get(i).x*size,trail.get(i).y*size,size,size); 
    }
  }
}