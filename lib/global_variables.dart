library my_globals;

String username = ''; //set by main.dart once logged in, does not save
String password = ''; //set by main.dart once logged in, does not save
String clientId = ''; //set by main.dart once logged in, does not save
String user = ''; //set by main.dart once logged in, does not save


//Valve Station
List<String> hclVars = [
  'hc1var', //gd-01 ppm - valve station
  'hc2var', //hcl flow rate
  'hc3var', //gd-01 high alarm
  'hc4var', //gd-01 low alarm
  'hc5var', //gd-01 fault alarm
  'hc6var', //pneumatic pressure switch
  'hc7var', //hcl supply valve
];
List<String> hclTopics = [
  'lb/hcl1', //gd-01 ppm - valve station
  'lb/hcl2', //hcl flow rate
  'lb/hcl3', //gd-01 high alarm
  'lb/hcl4', //gd-01 low alarm
  'lb/hcl5', //gd-01 fault alarm
  'lb/hcl6', //pneumatic pressure switch
  'lb/hcl7', //hcl supply valve
];

//Drum Compound
List<String> dcVars = [
  'dc1var', //hcl temperature
  'dc2var', //hcl ppm - drum compound
  'dc3var', //drum 1 weight
  'dc4var', //drum 2 weight
  'dc5var', //gd-02 high alarm
  'dc6var', //gd-02 low alarm
  'dc7var', //gd-02 fault alarm
  'dc8var', //hcl heating element
  'dc9var', //hcl shutoff valve
  'dc10var', //nitrogen pressure
  'dc11var', //bank 1 valve
  'dc12var', //bank 2 valve
  'dc13var', //sprinkler pump
];
List<String> dcTopics = [
  'lb/dc1', //hcl temperature
  'lb/dc2', //hcl ppm - drum compound
  'lb/dc3', //drum 1 weight
  'lb/dc4', //drum 2 weight
  'lb/dc5', //gd-02 high alarm
  'lb/dc6', //gd-02 low alarm
  'lb/dc7', //gd-02 fault alarm
  'lb/dc8', //hcl heating element
  'lb/dc9', //hcl shutoff valve
  'lb/dc10', //nitrogen pressure
  'lb/dc11', //bank 1 valve
  'lb/dc12', //bank 2 valve
  'lb/dc13', //sprinkler pump
];

//System Supervisor
List<String> ssVars = [
  'ss1var', //valve station ppm
  'ss2var', //drum compound ppm
  'ss3var', //scrubber line ppm
  'ss4var', //apu intake ppm
  'ss5var', //chimney ppm
  'ss6var', //safety system l1 voltage
  'ss7var', //safety system l1 current
  'ss8var', //safety system l2 voltage
  'ss9var', //safety system l2 current
  'ss10var', //safety system l3 voltage
  'ss11var', //safety system l3 current
];
List<String> ssTopics = [
  'lb/ss1', //valve station ppm
  'lb/ss2', //drum compound ppm
  'lb/ss3', //scrubber line ppm
  'lb/ss4', //apu intake ppm
  'lb/ss5', //chimney ppm
  'lb/ss6', //safety system l1 voltage
  'lb/ss7', //safety system l1 current
  'lb/ss8', //safety system l2 voltage
  'lb/ss9', //safety system l2 current
  'lb/ss10', //safety system l3 voltage
  'lb/ss11', //safety system l3 current
];

// Crystalliser RC-N
List<String> rcnVars = [
  'rcn1var', //temp sensor 1
  'rcn2var', //temp sensor 2
  'rcn3var', //temp sensor 3
];
List<String> rcnTopics = [
  'lb/rcn1', //temp sensor 1
  'lb/rcn2', //temp sensor 2
  'lb/rcn3', //temp sensor 3
];

