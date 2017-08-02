# movingCoding
Moving & Coding - a workshop about using your body as a
controller, using Kinects and Processing.
This is base code to give a starting point for the workshop.

Input data from the kinect is shown on the left of the canvas,
output visuals are shown on the right.
Key commands: 
*'i' - toggle input canvas visibility
*'o' - toggle output canvas visibility
*'s' - toggle skeleton visibility (when input is visible)

The kinect camera view is masked in horizontal
and depth dimensions to create a 'play area',
and adjusted using the sliders:
*xWindow - adjusts the horizontal masking of the kinect camera
*zMin - adjusts the near-camera depth limit
*zMax - adjusts the far-from-camera depth limit

Two examples are provided for the output canvas:
*painter() - draws a dot positioned relative to the target user's x and z positions.
*sounder() - makes a tone with pitch and volume relative to the target user's x and z positions.
You need to choose which of these you want to use
and call them from the place shown in the draw() loop.

Useful variables for using in output coding:
*userCount (no. people on camera),
*playerCount (no. people in play area),
*targetUser (closest player),
*x, y, z, (targetUser's position)

Written for Windows, Kinect SDK 1.8, Kinect Sensor v1
and the SimpleOpenNI, minim and controlP5 libraries.
Based on code written by Roy Shearer for
Be The Goalie - www.cargocollective.com/bethegoalie
as well as example code by Andreas Schlegel and Max Rheiner.
