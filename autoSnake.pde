int w=15;
int h=15;
int size=20;
int popSize=500;
long pFrame=0;
int frameLim=1800;
int[] brainDim={6,5,3};
game[] gams=new game[popSize];
int growth=1;
int prize=30;
int mutRate=20;
float mutMult=1;
int best=0;
long frameC=0;
int fast;
int bestNext;
int genC=0;
int at_fit=0;
int alpha=20;

void settings(){
  size(w*size,h*size+40);
}

void setup(){
  for(int i=0; i<popSize; i++){
    gams[i]=new game();
  }
}

void draw(){
  if(mousePressed){
    fast=1;
  }else{
    fast=100;
  }
  background(0);
  for(int i=0; i<fast; i++){
    run();
    frameC++;
  }
  if(keyPressed&&key==' '){
    gams[0].display();
  }else{
    for(int i=0; i<popSize; i++){
      gams[i].display();
    }
  }
}



void findBest(){
  int bestF=0;
  for(int i=0; i<popSize; i++){
    if(gams[i].snek.fitness>bestF){
      bestF=gams[i].snek.fitness;
      best=i;
    }
  }
  if(genC%5==0){
    gams[best].snek.brain.toTxt("genFiles/gen"+genC+".txt");
  }
  if(bestF>at_fit){
    gams[best].snek.brain.toTxt("backup.txt");
    println("backup");
    at_fit=bestF;
    println(at_fit+" "+gams[best].snek.l);
  }
}

void run(){
  boolean going=false;
  for(int i=0; i<popSize; i++){
    gams[i].core();
    if(gams[i].snek.dead==false){
      going=true;
    }
  }
  if(going==false||frameC==pFrame+frameLim){
    pFrame=frameC;
    findBest();
    nNet[] doneBrains=nextGen();
    for(int i=0; i<popSize; i++){
      gams[i].restart();
      gams[i].snek.brain=doneBrains[i];
    }
    genC++;
  }
}

nNet[] nextGen(){
  nNet[] gen=new nNet[popSize];
  IntList lotto=pool();
  for(int i=0; i<popSize; i++){
    lotto.shuffle();
    gen[i]=mutate(gams[lotto.get(0)].snek.brain);
    if(lotto.get(0)==best){
      bestNext=i;
    }
  }
  return gen;
}

nNet mutate(nNet mutee){
  nNet mutated=new nNet(brainDim[0],brainDim[1],brainDim[2]);
  
  for(int i=0; i<mutee.w_ih.data.length; i++){
    for(int j=0; j<mutee.w_ih.data[i].length; j++){
      if(random(100)>mutRate){
        mutated.w_ih.data[i][j]=mutee.w_ih.data[i][j]+randomGaussian()*mutMult/10.0;
      }
    }
  }
  
  for(int i=0; i<mutee.w_ho.data.length; i++){
    for(int j=0; j<mutee.w_ho.data[i].length; j++){
      if(random(100)>mutRate){
        mutated.w_ho.data[i][j]=mutee.w_ho.data[i][j]+randomGaussian()*mutMult/10.0;
      }
    }
  }
  
  for(int i=0; i<mutee.b_h.data.length; i++){
    for(int j=0; j<mutee.b_h.data[i].length; j++){
      if(random(100)>mutRate){
        mutated.b_h.data[i][j]=mutee.b_h.data[i][j]+randomGaussian()*mutMult/10.0;
      }
    }
  }
  
  for(int i=0; i<mutee.b_o.data.length; i++){
    for(int j=0; j<mutee.b_o.data[i].length; j++){
      if(random(100)>mutRate){
        mutated.b_o.data[i][j]=mutee.b_o.data[i][j]+randomGaussian()*mutMult/10.0;
      }
    }
  }
  
  return(mutated);
}

IntList pool(){
  IntList genePool=new IntList();
  for(int i=0; i<popSize; i++){
    for(int j=0; j<gams[i].snek.fitness; j++){
      genePool.append(i);
    }
  }
  return genePool;
}

void keyPressed(){
  if(key=='s'){
    saveBest();
  }
}

void saveBest(){
  game[] testGams=new game[popSize];
  for(int i=0; i<popSize; i++){
    testGams[i]=new game();
  }
  int[] totFit=new int[popSize];
  for(int i=0; i<10; i++){
    boolean done=false;
    int count=0;
    for(int j=0; j<popSize; j++){
      testGams[j].snek.brain=gams[j].snek.brain;
    }
    while(done==false&&count<frameLim){
      count++;
      for(int j=0; j<popSize; j++){
        testGams[j].core();
        if(testGams[j].snek.dead==true){
          done=true;
        }
      }
    }
    for(int j=0; j<popSize; j++){
      totFit[j]+=testGams[j].snek.fitness;
      testGams[j].restart();
    }
  }
  int maxFit=max(totFit);
  int saveBest=0;
  for(int i=0; i<popSize; i++){
    if(totFit[i]==maxFit){
      saveBest=i;
    }
  }
  testGams[saveBest].snek.brain.toTxt("weights.txt");
  println("save "+maxFit/10.0);
}