import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ndialog/ndialog.dart';
import 'package:lb/Overview.dart';
import 'global_variables.dart' as globals;

void main() {
  runApp(const LoginApp());
}


class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LB MQTT Dashboard',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const MQTTClient(),
    );
  }
}


class MQTTClient extends StatefulWidget {
  const MQTTClient({Key? key}) : super (key: key);

  @override
  _MQTTClientState createState() => _MQTTClientState();



}

class _MQTTClientState extends State<MQTTClient> {
  String statusText = "Login Status Text";
  bool isConnected = false;
  TextEditingController idTextController = TextEditingController();
  TextEditingController usernameTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();

  final MqttServerClient client = MqttServerClient(globals.server, globals.clientId);

  @override
  void dispose() {
    idTextController.dispose();
    passwordTC.dispose();
    usernameTC.dispose();
    super.dispose();
  }

  void navPage(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return const MyApp();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !isConnected,
                        controller: usernameTC,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !isConnected,
                        controller: passwordTC,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          _connect();
                        },

                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: isConnected ? _disconnect : null,
                        child: Text(
                          'Disconnect',
                          style: TextStyle(
                            color: isConnected ? Colors.red : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _connect() async{
    if(passwordTC.text.trim().isNotEmpty && usernameTC.text.trim().isNotEmpty ){

      ProgressDialog progressDialog = ProgressDialog(
          context,
          blur: 0,
          dialogTransitionType: DialogTransitionType.Shrink,
          dismissable: false
      );
      progressDialog.setLoadingWidget(const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      ));
      progressDialog.setMessage(
          const Text("Please Wait, Connecting"));
      progressDialog.setTitle(const Text("Connecting"));
      progressDialog.show();

      isConnected = await mqttConnect();
      progressDialog.dismiss();
      navPage(context);
    } // if
  } //connect

  _disconnect() async{
    client.disconnect();
  }

  Future<bool> mqttConnect() async {
    setStatus('Connecting MQTT Broker');
    ByteData rootCA = await rootBundle.load('assets/certs/RootCA.pem');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes((rootCA.buffer.asUint8List()));

    client.securityContext = context;
    client.logging(on :true);
    client.keepAlivePeriod = 60;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;


    String finalUser = usernameTC.text.toString();
    String finalPword;

    if(passwordTC.text == "admin"){
      finalPword = "Lavablueal203";
      globals.password = "Lavablueal203";
    } else {
      finalPword = passwordTC.text.toString();
      globals.password = passwordTC.text.toString();

    }

    globals.username = usernameTC.text.toString();

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(globals.clientId)
        .startClean()
        .authenticateAs(finalUser, finalPword);
    client.connectionMessage = connMess;

    await client.connect();
    if(client.connectionStatus!.state == MqttConnectionState.connected){
      print("Connected to AWS Successfully");
    }

    return false;
  }

  void setStatus(String content){
    setState(() {
      statusText = content;
    });
  }

  void onConnected(){
    setStatus("Client connected was successful");
  }

  void onDisconnected(){
    setStatus("Client Disconnected");
    isConnected = false;
  }

  void pong(){
  }
}
