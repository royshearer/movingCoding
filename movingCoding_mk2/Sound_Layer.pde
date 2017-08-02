import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave;

void soundSetup() {  
  minim = new Minim(this);

  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();

  // create a sine wave Oscil, set to 440 Hz, at 0 amplitude
  wave = new Oscil( 440, 0f, Waves.SINE );
  // patch the Oscil to the output
  wave.patch( out );
}


