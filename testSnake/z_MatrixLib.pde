class matrix{
  int rows,cols;
  float[][] data;
  
  matrix(int rows_,int cols_){
    cols=cols_;
    rows=rows_;
    data=new float[rows][cols];
  }
  
  
  void rand(int floor,int roof){
    for(int i=0; i<rows; i++){
      for(int j=0; j<cols; j++){
        data[i][j]=random(floor,roof);
      }
    }
  }
  
  void rand(int roof){
    for(int i=0; i<rows; i++){
      for(int j=0; j<cols; j++){
        data[i][j]=random(roof);
      }
    }
  }
  
  
  
  void mxadd(float n){
    for(int i=0; i<rows; i++){
      for(int j=0; j<cols; j++){
        data[i][j]+=n;
      }
    }
  }
  
  void mxadd(matrix m){
    for(int i=0; i<rows; i++){
      for(int j=0; j<cols; j++){
        data[i][j]+=m.data[i][j];
      }
    }
  }
  
  void mxsub(float n){
    for(int i=0; i<rows; i++){
      for(int j=0; j<cols; j++){
        data[i][j]-=n;
      }
    }
  }
  
  void mxsub(matrix m){
    for(int i=0; i<rows; i++){
      for(int j=0; j<cols; j++){
        data[i][j]-=m.data[i][j];
      }
    }
  }
  
  void mxmulti(float n){
    for(int i=0; i<rows; i++){
      for(int j=0; j<cols; j++){
        data[i][j]*=n;
      }
    }
  }
  
  matrix mxmulti(matrix b){
    matrix out=new matrix(rows,b.cols);
    for(int i=0; i<out.rows; i++){
      for(int j=0; j<out.cols; j++){
        float s=0;
        for(int k=0; k<cols; k++){
          s+=data[i][k]*b.data[k][j];
        }
        out.data[i][j]=s;
      }
    }
    return out;
  }
  matrix transpose(){
    matrix out=new matrix(cols,rows);
    for(int i=0; i<cols; i++){
      for(int j=0; j<rows; j++){
        out.data[i][j]=data[j][i];
      }
    }
    return out;
  }
  
}

matrix matrixFromArr(float[] arr){
  matrix out=new matrix(arr.length,1);
  for(int i=0; i<arr.length; i++){
    out.data[i][0]=arr[i];
  }
  return out;
}

float[] arrFromMatrix(matrix m){
  float[] f=new float[m.cols*m.rows];
  for(int i=0; i<m.rows; i++){
    for(int j=0; j<m.cols; j++){
      f[m.cols*i+j]=m.data[i][j];
    }
  }
  return(f);
}

void printmx(matrix m){
  for(int i=0; i<m.rows; i++){
    print("|"+" ");
    for(int j=0; j<m.cols; j++){
      print(m.data[i][j]+" ");
    }
    println('|');
  }
  println();
}