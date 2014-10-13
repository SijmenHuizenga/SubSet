final int quad = 0, ellipse = 1, triangle = 2;

String card = "ROE1";

void setup(){
  println(getAmount(card));
}

int getBackgroundColor(String card){
  if(card.contains("O"))
    return color(255, 106, 0);
  if(card.contains("G"))
    return color(16, 106, 0);
  if(card.contains("P"))
    return color(104, 106, 213);
  return 255;
}

int getShapeColor(String card){
  if(card.contains("R"))
    return color(255, 0, 0);
  if(card.contains("B")) 
    return color(0, 0, 255);
  if(card.contains("Y")) 
    return color(255, 255, 0);
  throw new IllegalArgumentException("This is an invalid card!"); 
}

int getShape(String card){
  if(card.contains("E")) 
    return ellipse;
  if(card.contains("Q")) 
    return quad;
  if(card.contains("YT")) 
    return triangle;
  throw new IllegalArgumentException("This is an invalid card!"); 
}

int getAmount(String card){
  if(card.contains("1"))
   return 1;
  if(card.contains("2"))
   return 2;
  if(card.contains("3"))
   return 3;
  throw new IllegalArgumentException("This is an invalid card!"); 
}
