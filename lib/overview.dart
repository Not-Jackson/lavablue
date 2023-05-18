import 'package:flutter/material.dart';
import 'package:lb/main.dart';
import 'package:lb/module.dart';
import 'package:lb/warnings.dart';

import 'global_variables.dart' as globals;
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lava Blue Home Page',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List pageName = [
    'HCl Valve Station',
    'Drum Compound',
    'Digester Area',
    'Crystalliser RC-N',
    'Scrubber Area',
    'System Supervisor',
    'Ultra Pure Water',
    'System Supply',
  ];

  final List pageNav = [
    'hcl',
    'dc',
    'da',
    'rcn',
    'sa',
    'ss',
    'upw',
    'supply',
  ];

  @override
  void initState() {
    super.initState();

    switch (globals.username) {
      case 'lb-admin2':
      setState(() {
        globals.user = 'Jackson';
      });
        break;
      case 'admin':
        setState(() {
          globals.user = 'Mr Des';
        });
        break;
      default:
        setState(() {
          globals.user = 'Other User';
        });
        break;
    }
  }

  @override

Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFE5E5E5),
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Hello, ${globals.user}',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select an area to view.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: pageName.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return MyModule(
                  child: pageName[index],
                  child2: pageNav[index],
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
    'login': const LoginApp(),
    'warnings': const WarningsApp(),
    'settings': const SettingsApp(),
  };

  final Widget page = pages[pageName.toLowerCase()]!;
  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
    return page;
  }));
}
}