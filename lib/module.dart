import 'package:flutter/material.dart';
import 'package:lb/digester_area.dart';
import 'package:lb/drum_compound.dart';
import 'package:lb/hcl_valve_station.dart';
import 'package:lb/main.dart';
import 'package:lb/ultra_pure_water.dart';
import 'package:lb/overview.dart';
import 'package:lb/rcn.dart';
import 'package:lb/scrubber_area.dart';
import 'package:lb/system_supervisor.dart';
import 'package:lb/system_supply.dart';

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
                Icons.water_drop,
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
      'login': const LoginApp(),
      'home': const HomePage(),
      'hcl': const HCLApp(),
      'dc': const DrumApp(),
      'ss': const SystemApp(),
      'supply': const SupplyApp(),
      'rcn': const RCNApp(),
      'sa': const ScrubberApp(),
      'upw': const UPWAPP(),
      'da': const DigesterApp(),
    };

    final Widget page = pages[pageName.toLowerCase()]!;
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return page;
    }));
  }
}
