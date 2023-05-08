import 'package:flutter/material.dart';
import 'package:lb/Overview.dart';
import 'package:lb/main.dart';
import 'package:lb/HClValveStation.dart';
import 'package:lb/DrumCompound.dart';
import 'package:lb/SystemSupervisor.dart';
import 'package:lb/SystemSupply.dart';
import 'package:lb/RCN.dart';

class MyModule extends StatelessWidget {
  final String child;
  final String child2;

  const MyModule({super.key, required this.child, required this.child2 });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          navPage(context, child2);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.grey[800],
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                child,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navPage(BuildContext ctx, String pageName) {
    final Map<String, Widget> pages = {
      'login': LoginApp(),
      'home': HomePage(),
      'hcl': const HCLApp(),
      'dc': const DrumApp(),
      'ss': const SystemApp(),
      'supply': const SupplyApp(),
      'rcn': const RCNApp(),
    };

    final Widget page = pages[pageName.toLowerCase()]!;
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return page;
    }));
  }
}
