/*   File    : EAC Columbus Corridor Detector-Sender Configuration File
 *   Version : 1.0.0
 *   Update  : 02/05/2014
 *   Authors : Alexandros M. Cardaris (alexandros@cardaris.gr)
 *   Company : European Space Agency - EAC
 */


/* -------------------- Scene & Camera Properties ----------------------------- */

public float zoom = 0.3f;
public float rotX =  radians(0);
public float rotY = radians(0);

/* -------------------- Kinect Properties ------------------------------------- */

public int depthMin = 1500; 
public int depthMax = 2200;         // Kinect maximum depth in mm with minimum 500 to maximum 3050
public int reducedAngle = 330;     // Kinect reduced angle
public int quality = 3;            // The depth points resolution with minimum 6 to maximum 1
 
/* -------------------- Network Properties & Configuration -------------------- */

public String broadcastAddress = "127.0.0.1";
public int broadcastPort = 12000;

public OscP5 oscP5 = new OscP5(this, broadcastPort);
public NetAddress remoteLocation = new NetAddress(broadcastAddress, broadcastPort);
