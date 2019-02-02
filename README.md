# Screwless (Almost) Robotic Anthropomorphic Hand

## HISTORY

19 May 2018 - I downloaded a gearModule.scad script from somewhere in OpenSCAD forums and placed 4 gears together.
20 May 2018 - first prototype, sketch5_3 is done
21 May 2018 - sketch5_6, with limits
22 May 2018 - sketch5_7, flex-back
26 May 2018 - sketch6_1, _2
12 September 2018 - better metacarpal bones
14 September 2018 - metacarpal body sketch6_0v2, 4 finger prototype

## Design

Nondestructive - this means that during assembly I do not glue, thread, break, melt anything. The whole hand
can be later on disassembled and reassembled without breaking a thing. Servos can be unmodified, even the servo horn is not
attached using a screw.

The whole design is made using source code-oriented tools, this simplifies sharing and modification of each element. Also, version control and comments.

## Difference between this and Pisa IIT Softhand

More prominent gears for support, more wires for the Hillberry rolling joint. More 3D printer-friendly, as parts are generally designed to be printed without supports or with minimal amount.


## Motors

### Servo-oriented prototype

The hand with servos is easier to replicate, but the flexibility and freedom of design suffers greatly. Despite that, the prototype is working and properly actuated.

PowerHD HD-1800A (SG90 should work too with changed mounting dimensions)


# Ideas storage for later:

## Bearings

First stage - no bearings

Quite a bit of friction, but the hand seems controllable.

Second stage - for control wire routing only

chart:
https://www.bearingworks.com/bearing-sizes/

MR52 - 2x5x2  1.50$ per 10 aliexpress
MR62 - 2x6x2  1.50$ per 10 aliexpress

# License

Whatever is mine (so without gearModule.scad) is licensed under CC-BY-4.0 - enjoy!
