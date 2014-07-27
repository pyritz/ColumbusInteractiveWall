ColumbusInteractiveWall
=======================

This project initially designed for the European Astronaut Center is an installation allowing visitors to browse through content projected on a wall. You can navigate in the various parts of the Colombus module, the European laboratory of the International Space Station.

The system uses the data of a Microsoft Kinect sensor, placed on the ceiling, pointing down and generates the position coordinates of the hand (or any object near enough to the wall) that is processed by a first processing app (DetectorSender), which sends an OSC message to a second app (DisplayReceiver). The DisplayReceiver will display the appropriate image on the wall using a short throw projector fixed to the ceiling.
