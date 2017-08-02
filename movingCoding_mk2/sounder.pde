// makes a tone with pitch and volume relative to the target user's x and z positions
// no. of people on camera determines the waveform (sine, saw, square etc.)

void sounder()
{
  fill(255);
  stroke(255);
  rect(0, 0, w, h);  //draw output canvas
  fill(255, 0, 0);
  strokeWeight(1);
  stroke(0);

  translate(0, (h/2)-50);
  // draw the waveform of the output
  for (int i = 0; i < out.bufferSize () - 1; i++)
  {
    line( i, 50  - out.left.get(i)*50, i+1, 50  - out.left.get(i+1)*50 );
    //    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50 );
  }
  translate(0, -(h/2)+50);

  float zMap = map(z, 0, 255, 1, 0);
  wave.setAmplitude( zMap );
  
  float xMap = map(x, 0, 255, 110, 880);
  wave.setFrequency( xMap );

  switch( playerCount )
  {
  case 1: 
    wave.setWaveform( Waves.SINE );
    break;

  case 2:
    wave.setWaveform( Waves.TRIANGLE );
    break;

  case 3:
    wave.setWaveform( Waves.SAW );
    break;

  case 4:
    wave.setWaveform( Waves.SQUARE );
    break;

  case 5:
    wave.setWaveform( Waves.QUARTERPULSE );
    break;

  default: 
    break;
  }
}

