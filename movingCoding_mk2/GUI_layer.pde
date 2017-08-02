import controlP5.*;

ControlP5 cp5;

Range range;

Slider abc;

void controlP5Setup() {  
  cp5 = new ControlP5(this);
  range = cp5.addRange("x window")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(100, 50)
        .setSize(640, 40)
          .setHandleSize(20)
            .setRange(0, 640)
              .setRangeValues(xMin, xMax)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
//                  .setColorForeground(color(255, 40))
//                    .setColorBackground(color(255, 40))  
                      ;
  cp5.addSlider("zMax")
    .setPosition(75, 100)
      .setSize(20, 480)
        .setRange(200, 4000)
          .setSliderMode(Slider.FLEXIBLE)
            .setValue(zMaxCP5)
              ;
  cp5.addSlider("zMin")
    .setPosition(50, 100)
      .setSize(20, 480)
        .setRange(200, 4000)
          .setSliderMode(Slider.FLEXIBLE)
            .setValue(zMinCP5)
              ;
              
  cp5.getController("x window").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("zMin").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM+4000).setPaddingX(0);
  cp5.getController("zMax").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM+4000).setPaddingX(0);
  zMin=zMinCP5;
  zMax=zMaxCP5;
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("x window")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    xMin = int(theControlEvent.getController().getArrayValue(0));
    xMax = int(theControlEvent.getController().getArrayValue(1));
    println("X window adjust: "+xMin+","+xMax);
  }
  if (theControlEvent.isFrom("zMin")||theControlEvent.isFrom("zMax")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    println("Z window adjust: "+zMin+","+zMax);
  }
}

