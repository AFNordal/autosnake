class nNet{
  int inNodes;
  int hidNodes;
  int outNodes;
  matrix w_ih;
  matrix w_ho;
  matrix b_h;
  matrix b_o;
  float lr=.01;
  
  nNet(int in, int hid, int out){
    inNodes=in;
    hidNodes=hid;
    outNodes=out;
    
    w_ih=new matrix(hidNodes,inNodes);
    w_ho=new matrix(outNodes,hidNodes);
    
    w_ih.rand(-1,1);
    w_ho.rand(-1,1);
    
    b_h=new matrix(hidNodes,1);
    b_o=new matrix(outNodes,1);
    
    b_h.rand(-1,1);
    b_o.rand(-1,1);
  }
  
  
  
  float[] feed(float[] inarr){
    matrix in=matrixFromArr(inarr);
    matrix hidden=w_ih.mxmulti(in);
    hidden.mxadd(b_h);
    for(int i=0; i<hidden.rows; i++){
      hidden.data[i][0]=sigmoid(hidden.data[i][0]);
    }
    
    matrix out=w_ho.mxmulti(hidden);
    out.mxadd(b_o);
    for(int i=0; i<out.rows; i++){
      out.data[i][0]=sigmoid(out.data[i][0]);
    }
    return arrFromMatrix(out);
  }
  
  void toTxt(String fileName){
    ArrayList<String> strList=new ArrayList<String>();
    for(int i=0; i<w_ih.data.length; i++){
      for(int j=0; j<w_ih.data[i].length; j++){
        strList.add(str(w_ih.data[i][j]));
      }
    }
    
    for(int i=0; i<w_ho.data.length; i++){
      for(int j=0; j<w_ho.data[i].length; j++){
        strList.add(str(w_ho.data[i][j]));
      }
    }
    
    for(int i=0; i<b_h.data.length; i++){
      for(int j=0; j<b_h.data[i].length; j++){
        strList.add(str(b_h.data[i][j]));
      }
    }
    
    for(int i=0; i<b_o.data.length; i++){
      for(int j=0; j<b_o.data[i].length; j++){
        strList.add(str(b_o.data[i][j]));
      }
    }
    
    String[] strArr=strList.toArray(new String[strList.size()]);
    saveStrings(fileName,strArr);
  }
  
//  void train(float[] inArr,float[] targetArr){
    
//    matrix in=matrixFromArr(inArr);
//    matrix hidden=w_ih.mxmulti(in);
//    hidden.mxadd(b_h);
//    for(int i=0; i<hidden.rows; i++){
//      hidden.data[i][0]=sigmoid(hidden.data[i][0]);
//    }
    
//    matrix outputs=w_ho.mxmulti(hidden);
//    outputs.mxadd(b_o);
//    for(int i=0; i<outputs.rows; i++){
//      outputs.data[i][0]=sigmoid(outputs.data[i][0]);
//    }
    
    
//    //matrix targets=matrixFromArr(targetArr);
//    matrix output_errors=matrixFromArr(targetArr);
//    output_errors.mxsub(outputs);
//    matrix gradients=new matrix(outputs.rows, outputs.cols);
//    for(int i=0; i<outputs.rows; i++){
//      gradients.data[i][0]=dsigmoid(outputs.data[i][0]);
//    }
//    gradients=gradients.mxmulti(output_errors);
//    gradients.mxmulti(lr);
//    b_o.mxadd(gradients);
//    matrix hidden_t=hidden.transpose();
//    matrix delta_ho=gradients.mxmulti(hidden_t);
//    w_ho.mxadd(delta_ho);
    
    
//    matrix w_ho_t=w_ho.transpose();
//    matrix hidden_errors=w_ho_t.mxmulti(output_errors);
    
//    matrix hidden_gradients=new matrix(hidden.rows, hidden.cols);
//    for(int i=0; i<hidden.rows; i++){
//      hidden_gradients.data[i][0]=dsigmoid(hidden.data[i][0]);
//    }
//    hidden_gradients=hidden_gradients.mxmulti(hidden_errors);
//    hidden_gradients.mxmulti(lr);
//    b_h.mxadd(hidden_gradients);
//    matrix inputs_t=in.transpose();
//    matrix delta_ih=hidden_gradients.mxmulti(inputs_t);
//    w_ih.mxadd(delta_ih);
//  }

}

float sigmoid(float x){
  return 1/(1+exp(-x));
}

nNet fromTxt(int[] shape,String file){
  String[] str=loadStrings(file);
  nNet fileNet=new nNet(shape[0],shape[1],shape[2]);
  int index=0;
  for(int i=0; i<fileNet.w_ih.data.length; i++){
    for(int j=0; j<fileNet.w_ih.data[i].length; j++){
      fileNet.w_ih.data[i][j]=float(str[index]);
      index++;
    }
  }
  
  for(int i=0; i<fileNet.w_ho.data.length; i++){
    for(int j=0; j<fileNet.w_ho.data[i].length; j++){
      fileNet.w_ho.data[i][j]=float(str[index]);
      index++;
    }
  }
  
  for(int i=0; i<fileNet.b_h.data.length; i++){
    for(int j=0; j<fileNet.b_h.data[i].length; j++){
      fileNet.b_h.data[i][j]=float(str[index]);
      index++;
    }
  }
  
  for(int i=0; i<fileNet.b_o.data.length; i++){
    for(int j=0; j<fileNet.b_o.data[i].length; j++){
      fileNet.b_o.data[i][j]=float(str[index]);
      index++;
    }
  }
  
  return(fileNet);
}

//float dsigmoid(float y){
//  return y*(1-y);
//}