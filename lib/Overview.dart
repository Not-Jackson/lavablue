import 'package:flutter/material.dart';
import 'package:lb/RCN.dart';
import 'package:lb/SystemSupervisor.dart';
import 'package:lb/SystemSupply.dart';
import 'package:lb/module.dart';
import 'package:lb/main.dart';
import 'package:lb/HClValveStation.dart';
import 'package:lb/DrumCompound.dart';
import 'package:lb/SystemSupervisor.dart';
import 'package:lb/SystemSupply.dart';
import 'Settings.dart';
import 'global_variables.dart' as globals;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lava Blue Home Page',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List TestTemps = [
    'HCl Valve Station',
    'Drum Compound',
    'System Supervisor',
    'System Supply',
    'Crystalliser RC-N',
  ];

  final List PageNav = [
    'hcl',
    'dc',
    'ss',
    'supply',
    'rcn',
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
    backgroundColor: Color(0xFFE5E5E5),
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Hello, ' + globals.user,
        style: TextStyle(
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
          Text(
            'Select an area to view.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: TestTemps.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return MyModule(
                  child: TestTemps[index],
                  child2: PageNav[index],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () {
                navPage(context, "login");
              },
            ),
            IconButton(
              icon: Icon(Icons.search_outlined, color: Colors.black),
              onPressed: () {

              },
            ),
            IconButton(
              icon: Icon(Icons.favorite_border_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {
                navPage(context, "settings");
              },
            ),
          ],
        ),
      ),
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}

void navPage(BuildContext ctx, String pageName) {
  final Map<String, Widget> pages = {
    'login': const LoginApp(),
    'hcl': const HCLApp(),
    'dc': const DrumApp(),
    'ss': const SystemApp(),
    'rcn': const RCNApp(),
    'supply': const SupplyApp(),
    'settings': const SettingsApp(),
  };

  final Widget page = pages[pageName.toLowerCase()]!;
  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
    return page;
  }));
}
}