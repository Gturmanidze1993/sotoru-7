import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/venue.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});
  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> {
  bool _tutorial = true;

  @override
  Widget build(BuildContext context) {
    final deck = ref.watch(deckProvider);
    final query = ref.watch(searchQueryProvider);
    final chips = ref.watch(quickChipsProvider);
    final filtered = deck.where((v) {
      final q = query.toLowerCase();
      final qok = q.isEmpty || v.name.toLowerCase().contains(q) || v.district.toLowerCase().contains(q);
      bool chok = true;
      if (chips.contains('open_now') && !v.openNow) chok = false;
      if (chips.contains('terrace') && !v.tags.contains('terrace')) chok = false;
      if (chips.contains('quiet') && v.noise > 2) chok = false;
      if (chips.contains('live_music') && !v.tags.contains('live_music')) chok = false;
      if (chips.contains('hookah') && !v.tags.contains('hookah')) chok = false;
      if (chips.contains('late_kitchen') && !v.tags.contains('late_kitchen')) chok = false;
      return qok && chok;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tonight'),
        actions: [IconButton(onPressed: () => ref.read(deckProvider.notifier).refresh(), icon: const Icon(Icons.refresh))],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(92), child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(children: [
            TextField(onChanged: (s) => ref.read(searchQueryProvider.notifier).state = s, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by name or district')),
            const SizedBox(height: 8),
            _ChipsRow(),
          ]),
        )),
      ),
      body: Stack(children: [
        if (filtered.isEmpty) const Center(child: Text('No results')),
        ...List.generate(min(filtered.length, 3), (i) => _DraggableCard(v: filtered[i], i: i, onRight: (v) { ref.read(shortlistProvider.notifier).add(v); ref.read(deckProvider.notifier).swipeLeft(v); if (mounted) HapticFeedback.lightImpact(); }, onLeft: (v) { ref.read(deckProvider.notifier).swipeLeft(v); })),
        if (_tutorial) _SwipeTutorial(onClose: () => setState(() => _tutorial = false)),
      ]),
    );
  }
}

class _ChipsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = const [('open_now','Open now'),('terrace','Terrace'),('quiet','Quiet'),('live_music','Live music'),('hookah','Hookah'),('late_kitchen','Late kitchen')];
    final sel = ref.watch(quickChipsProvider);
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: options.map((pair) {
      final key = pair.$1; final label = pair.$2; final selected = sel.contains(key);
      return Padding(padding: const EdgeInsets.only(right: 8.0), child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) { final set = {...sel}; if (selected) set.remove(key); else set.add(key); ref.read(quickChipsProvider.notifier).state = set; }));
    }).toList()));
  }
}

class _SwipeTutorial extends StatelessWidget {
  final VoidCallback onClose;
  const _SwipeTutorial({required this.onClose});
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: Material(color: Colors.black54, child: Stack(children: [
      Align(alignment: Alignment.center, child: Icon(Icons.swipe, size: 96, color: Colors.white)),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: const [
        Text('Swipe right to shortlist', style: TextStyle(color: Colors.white)),
        SizedBox(height: 6),
        Text('Swipe left to skip', style: TextStyle(color: Colors.white70)),
      ]))),
      Positioned(top: 48, right: 16, child: TextButton(onPressed: onClose, child: const Text('Got it', style: TextStyle(color: Colors.white)))),
    ])));
  }
}

class _DraggableCard extends StatefulWidget {
  final Venue v; final int i; final void Function(Venue) onRight; final void Function(Venue) onLeft;
  const _DraggableCard({required this.v, required this.i, required this.onRight, required this.onLeft});
  @override
  State<_DraggableCard> createState() => _DraggableCardState();
}
class _DraggableCardState extends State<_DraggableCard> {
  @override
  Widget build(BuildContext context) {
    final v = widget.v;
    final width = MediaQuery.of(context).size.width;
    final threshold = width * 0.25;
    return Positioned.fill(
      top: 12.0 * widget.i, left: 12.0 * widget.i, right: 12.0 * widget.i, bottom: 12.0 * widget.i,
      child: Draggable(
        feedback: _card(v), childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (d) { final dx = d.offset.dx; if (dx > threshold) widget.onRight(v); else if (dx < -threshold) widget.onLeft(v); },
        child: _card(v),
      ),
    );
  }
  Widget _badge(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), margin: const EdgeInsets.only(right: 6, bottom: 6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)));
  Widget _card(Venue v) {
    return Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: DecorationImage(image: NetworkImage(v.photoUrl), fit: BoxFit.cover)),
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black54, Colors.transparent])),
        padding: const EdgeInsets.all(16), alignment: Alignment.bottomLeft,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${v.name} • ${v.type} • ${v.rating.toStringAsFixed(1)}★', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(children: [ _badge(v.district), _badge('GEL ${v.priceBand}'), _badge('Queue ${v.queueMinutes}m'), _badge('Noise ${v.noise}/5'), if (v.openNow) _badge('Open') ]),
        ]),
      ),
    );
  }
}
