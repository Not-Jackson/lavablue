import 'package:flutter/material.dart';
import 'package:lb/overview.dart';
import 'package:lb/warnings.dart';

import 'global_variables.dart' as globals;

void main() {

  runApp(const SettingsApp());
}

class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lava Blue Settings Page',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home:  SettingsPage(),
    );
  }


}

class SettingsPage extends StatelessWidget {
  final List<MyListItem> items = [    MyListItem('Server', globals.server),    MyListItem('Port', globals.port.toString()),    MyListItem('Username', globals.username),    MyListItem('Password', globals.password),    MyListItem('Version', globals.version),  ];

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 1,
                  child: Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
}

void navPage(BuildContext ctx, String pageName) {
  final Map<String, Widget> pages = {
    'home': const MyApp(),
    'warnings': const WarningsApp(),
    'settings': const SettingsApp(),
  };

  final Widget page = pages[pageName.toLowerCase()]!;
  Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
    return page;
  }));
}

class MyListItem {
  final String title;
  final String value;

  MyListItem(this.title, this.value);
}
