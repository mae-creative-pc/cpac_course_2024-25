


class outLine{
  
  ArrayList<PVector> paint;  
    
  outLine(){
    paint = new ArrayList<PVector>();    
    
    for (int i=0;i<400;i++)
    {
       paint.add(new PVector(100+i, 400));
       paint.add(new PVector(200+i, 500));
    }
    
    for (int i=0;i<400;i++)
    {
       paint.add(new PVector(100, 100+i));
       paint.add(new PVector(300, 300+i));
    }
  }
  
  ArrayList<PVector> getOutline(){
    return paint;
  }
  
}
