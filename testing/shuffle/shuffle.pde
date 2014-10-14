import java.util.Arrays;

String[] shuffle(String[] in){
  for(int i = 0; i < in.length; i++){
    int toSwich = round(random(in.length-1));
    String tmp = in[i];
    in[i] = in[toSwich];
    in[toSwich] = tmp;
  }
  return in;
}

String[] fishShuffle(String[] in){
  
  return in;
}

void setup(){
  String[] toShuffle = new String[]{"a","b","c","d","e","f","g","h"};
  println(Arrays.toString(shuffle(toShuffle)));
}
