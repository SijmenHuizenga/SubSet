int getUnixTime(){
  return (int) (System.currentTimeMillis() / 1000); 
}

float round(float nr, int decimals){
  return floor(nr * (pow(10, decimals+1)))/((float)(pow(10, decimals+1)));
}

String timeFloatToString(float nr){
  return (nr + ((getNumbersAfterDot(nr) % 10 == 0) ? "0" : "")).replace(".", ":");
}

int getNumbersAfterDot(float nr){
  return (int) ((nr)*100)%100;
}
