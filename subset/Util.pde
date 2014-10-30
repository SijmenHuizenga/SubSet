int getUnixTime() {
  return (int) (System.currentTimeMillis() / 1000);
}

// http://rick.measham.id.au/paste/explain.pl?regex=%5E%28%3F%3A%28.%29%28%3F%21.*%3F%5C1%29%29*%24
boolean isSameOrDiff(String toCheck) {
  return toCheck.matches(toCheck.charAt(0) + "+") || toCheck.matches("^(?:(.)(?!.*?\\1))*$");
}

String loadFileAsString(String fileName) {
  String[] in = loadStrings(fileName);
  String out = "";
  for (String line : in) {
    out += line + "\n";
  }
  return out;
}

String toTwoDigets(int i) {
  return (i < 10 ? "0" : "") + i;
}

void doSuperSecretStuff() {
  noStroke();
  String[] x = superSeceretString.split(";");
  int[] y = new int[x.length];
  for (int z = 0; z < x.length; z++) {
    y[z] = Integer.parseInt(x[z]);
  }
  for (int a = 0; a < 36; a++) {
    for (int b = 0; b < 17; b++) {
      int z = a + b * 36;
      if (y[z] == -1)
        continue;
      fill(y[z]);
      rect(60 + a * 20, 100 + b * 20, 20, 20);
    }
  }
}

