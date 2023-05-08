import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lb/Overview.dart';
import 'package:lb/list1.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:io';
import 'global_variables.dart' as globals;

void main() {

  runApp(const SupplyApp());
}

class SupplyApp extends StatelessWidget {
  const SupplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lava Blue System Supply',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const SupplyPage(),
    );
  }


}

class SupplyPage extends StatefulWidget {
  const SupplyPage({super.key});

  @override
  SupplyPageState createState() => SupplyPageState();
}

class SupplyPageState extends State<SupplyPage> {

  final MqttServerClient client = MqttServerClient(
      '14d164bea9f34cd886de103d28cfdc12.s2.eu.hivemq.cloud', 'a');

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    subscribeToMqtt();
  }

  void updatePages() {
    setState(() {
      _pages = [
        { 'name': 'Safety System L1 Voltage',  'value': globals.ssVars[5], },
        { 'name': 'Safety System L1 Current',  'value': globals.ssVars[6], },
        { 'name': 'Safety System L2 Current',  'value': globals.ssVars[7], },
        { 'name': 'Safety System L2 Current',  'value': globals.ssVars[8], },
        { 'name': 'Safety System L3 Current',  'value': globals.ssVars[9], },
        { 'name': 'Safety System L3 Current',  'value': globals.ssVars[10], },
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
              globals.ssVars[topicIndex] = pt;
            });
          }
        }
        updatePages();
      });
    }
    subscribeToTopics(globals.ssTopics);
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
              'System Supply Information',
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
                icon: const Icon(Icons.search_outlined, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border_outlined, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void navPage(BuildContext ctx, String pageName) {
    final Map<String, Widget> pages = {
      'home': HomePage(),
    };

    final Widget page = pages[pageName.toLowerCase()]!;
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return page;
    }));
  }
}
