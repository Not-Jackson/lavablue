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

  runApp(const RCNApp());
}

class RCNApp extends StatelessWidget {
  const RCNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lava Blue Crystalliser RC-N',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const RCNPage(),
    );
  }


}

class RCNPage extends StatefulWidget {
  const RCNPage({super.key});

  @override
  RCNPageState createState() => RCNPageState();
}

class RCNPageState extends State<RCNPage> {

  final MqttServerClient client = MqttServerClient(globals.server, globals.clientId);

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    subscribeToMqtt();
  }

  void updatePages() {
    setState(() {
      _pages = [
        { 'name': 'Temp Sensor 1',  'value': globals.rcnVars[0], 'isOn': globals.rcnVars[0] != '50'},
        { 'name': 'Temp Sensor 2',  'value': globals.rcnVars[1], 'isOn': globals.rcnVars[1] != '50'},
        { 'name': 'Temp Sensor 3',  'value': globals.rcnVars[2], 'isOn': globals.rcnVars[2] != '50'},
        { 'name': 'RC-N Level',  'value': globals.rcnVars[3], 'isOn': globals.rcnVars[3] != '50'},
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
              globals.rcnVars[topicIndex] = pt;
            });
          }
        }
        updatePages();
      });
    }
    subscribeToTopics(globals.rcnTopics);
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
              'Crystalliser RC-N',
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
      'home': const HomePage(),
      'warnings': const WarningsApp(),
      'settings': const SettingsApp(),
    };

    final Widget page = pages[pageName.toLowerCase()]!;
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return page;
    }));
  }
}
