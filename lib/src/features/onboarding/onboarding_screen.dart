import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _cards = const [
    _IntroCard(title:'Swipe to choose', subtitle:'Right to shortlist. Left to skip.', imageUrl:'https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=1600'),
    _IntroCard(title:'Share the vibe', subtitle:'Photos and 10s videos from people there.', imageUrl:'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1600'),
    _IntroCard(title:'Map and plan', subtitle:'See districts and plan your night.', imageUrl:'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=1600'),
  ];
  int _index = 0;
  final _ctrl = PageController();

  Future<void> _finish() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('onboarding_done', true);
    if (mounted) Navigator.pushReplacementNamed(context, HomeShell.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView.builder(controller: _ctrl, onPageChanged: (i) => setState(() => _index = i), itemCount: _cards.length, itemBuilder: (_, i) => _SwipeIntroCard(card: _cards[i])),
        Positioned(top: 48, right: 16, child: TextButton(onPressed: _finish, child: const Text('Skip'))),
        Positioned(bottom: 80, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_cards.length, (i) { final active = i == _index; return AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 4), width: active ? 20 : 8, height: 8, decoration: BoxDecoration(color: active ? Colors.orange : Colors.white70, borderRadius: BorderRadius.circular(4))); }))),
        Positioned(bottom: 24, left: 16, right: 16, child: ElevatedButton(onPressed: () { if (_index < _cards.length - 1) { _ctrl.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut); HapticFeedback.lightImpact(); } else { _finish(); } }, child: Text(_index < _cards.length - 1 ? 'Next' : 'Get started'))),
      ]),
    );
  }
}

class _IntroCard { final String title; final String subtitle; final String imageUrl; const _IntroCard({required this.title, required this.subtitle, required this.imageUrl}); }
class _SwipeIntroCard extends StatefulWidget { final _IntroCard card; const _SwipeIntroCard({required this.card}); @override State<_SwipeIntroCard> createState() => _SwipeIntroCardState(); }
class _SwipeIntroCardState extends State<_SwipeIntroCard> {
  double _dx = 0;
  @override
  Widget build(BuildContext context) {
    final c = widget.card;
    final size = MediaQuery.of(context).size;
    return Center(child: GestureDetector(
      onPanUpdate: (d) => setState(() => _dx += d.delta.dx),
      onPanEnd: (_) { final threshold = size.width * 0.25; if (_dx.abs() > threshold) { HapticFeedback.lightImpact(); } setState(() => _dx = 0); },
      child: Transform.translate(offset: Offset(_dx, 0), child: Transform.rotate(angle: _dx * 0.0008, child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8))], image: DecorationImage(image: NetworkImage(c.imageUrl), fit: BoxFit.cover)),
        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black54, Colors.transparent])),
          padding: const EdgeInsets.all(16), alignment: Alignment.bottomLeft,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(c.subtitle, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ]),
        ),
      ))),
    ));
  }
}
