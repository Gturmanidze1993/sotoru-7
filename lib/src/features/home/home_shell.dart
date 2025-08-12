import 'package:flutter/material.dart';
import '../swipe/swipe_screen.dart';
import '../map/map_screen.dart';
import '../shortlist/shortlist_screen.dart';

class HomeShell extends StatefulWidget {
  static const route = '/home';
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = const [SwipeScreen(), MapScreen(), ShortlistScreen()];
    final labels = ['Tonight','Map','Shortlist'];
    final icons = const [Icons.bolt, Icons.map, Icons.favorite];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i),
        destinations: List.generate(pages.length, (i) => NavigationDestination(icon: Icon(icons[i]), label: labels[i])),
      ),
    );
  }
}
