void painter(int w, int h) {
  fill(255, 10);
  stroke(255);
  rect(0, 0, w, h);  //draw output canvas
  fill(255, 0, 0);
  float xMap = map(x, 0, 255, 0, w);
  float zMap = map(z, 0, 255, 0, h);
  ellipse(xMap, zMap, 10, 10);
}
