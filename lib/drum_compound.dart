import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lb/overview.dart';
import 'package:lb/settings.dart';
import 'package:lb/two_text_module.dart';
import 'package:lb/warnings.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'global_variables.dart' as globals;

void main() {

  runApp(const DrumApp());
}

class DrumApp extends StatelessWidget {
  const DrumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lava Blue Drum Compound',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const DrumPage(),
    );
  }


}

class DrumPage extends StatefulWidget {
  const DrumPage({super.key});

  @override
  DrumPageState createState() => DrumPageState();
}

class DrumPageState extends State<DrumPage> {

  final MqttServerClient client = MqttServerClient(
      globals.server, globals.clientId);

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    subscribeToMqtt();
  }

  void updatePages() {
    setState(() {
      _pages = [
        { 'name': 'HCl Temperature',  'value': globals.dcVars[0], 'isOn': globals.dcVars[0] != '60'},
        { 'name': 'HCl PPM',  'value': globals.dcVars[1], 'isOn': globals.dcVars[1] != '10'},
        { 'name': 'Drum 1 Weight',  'value': globals.dcVars[2], 'isOn': globals.dcVars[2] != '1'},
        { 'name': 'Drum 2 Weight',  'value': globals.dcVars[3], 'isOn': globals.dcVars[3] != '1'},
        { 'name': 'Gas Detector High Alarm',  'value': globals.dcVars[4], 'isOn': globals.dcVars[4] == 'OFF'},
        { 'name': 'Gas Detector Low Alarm',  'value': globals.dcVars[5], 'isOn': globals.dcVars[5] == 'OFF'},
        { 'name': 'Gas Detector Fault Alarm',  'value': globals.dcVars[6], 'isOn': globals.dcVars[6] == 'OFF'},
        { 'name': 'HCl Heating Element',  'value': globals.dcVars[7], 'isOn': globals.dcVars[7] == 'ON'},
        { 'name': 'HCl Shut Off Valve',  'value': globals.dcVars[8], 'isOn': globals.dcVars[8] == 'HCl Available'},
        { 'name': 'Nitrogen Pressure',  'value': globals.dcVars[9], 'isOn': globals.dcVars[9] == 'ON'},
        { 'name': 'Bank 1 Valve',  'value': globals.dcVars[10], 'isOn': globals.dcVars[10] == 'ON'},
        { 'name': 'Bank 2 Valve',  'value': globals.dcVars[11], 'isOn': globals.dcVars[11] == 'ON'},
        { 'name': 'Sprinkler Pump',  'value': globals.dcVars[12], 'isOn': globals.dcVars[12] == 'OFF'},
        { 'name': 'Modulation Valve - % Open',  'value': globals.dcVars[13], 'isOn': globals.dcVars[13] != 'OFF'},
      ];
    });
  }

  void subscribeToMqtt() async {
    ByteData rootCA = await rootBundle.load('assets/certs/RootCA.pem');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes((rootCA.buffer.asUint8List()));

    client.securityContext = context;
    client.logging(on :true);
    client.keepAlivePeriod = 60;
    client.port = 8883;
    client.secure = true;
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(globals.clientId)
        .startClean()
        .authenticateAs(globals.username, globals.password);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      setState(() {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          isLoading = false;
        });
      });
    } catch (e) {
      client.disconnect();
    }

    void subscribeToTopics(List<String> topicNames) {
      final topics = topicNames.map((name) => name).toList();

      for (var i = 0; i < topics.length; i++) {
        client.subscribe(topics[i], MqttQos.atMostOnce);
      }

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        for (var i = 0; i < c!.length && i < topics.length; i++) {
          final recMess = c[i].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          final topicIndex = topics.indexOf(c[i].topic);
          if (topicIndex != -1) {
            setState(() {
              globals.dcVars[topicIndex] = pt;
            });
          }
        }
        updatePages();
      });
    }
    subscribeToTopics(globals.dcTopics);
  }

  late List<Map<String, dynamic>> _pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Lava Blue Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Drum Compound',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ) : ListView.builder(
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      TwoTextModule(
                        text1: _pages[index]['name'],
                        text2: _pages[index]['value'],
                        isOn: _pages[index]['isOn'],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home_outlined, color: Colors.black),
                onPressed: () {
                  navPage(context, "home");
                },
              ),
              IconButton(
                icon: const Icon(Icons.message_outlined, color: Colors.black),
                onPressed: () {
                  navPage(context, "warnings");
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {
                  navPage(context, "settings");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navPage(BuildContext ctx, String pageName) {
    final Map<String, Widget> pages = {
      'home': const MyApp(),
      'settings': const SettingsApp(),
      'warnings': const WarningsApp(),
    };

    final Widget page = pages[pageName.toLowerCase()]!;
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return page;
    }));
  }
}
