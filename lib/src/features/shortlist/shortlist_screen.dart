import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/providers.dart';
import '../../models/venue.dart';

class ShortlistScreen extends ConsumerWidget {
  const ShortlistScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shortlistProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Shortlist'), actions: [
        if (items.isNotEmpty) IconButton(onPressed: () { final text = items.map((v) => '${v.name} • ${v.address}').join('\n'); Share.share(text); }, icon: const Icon(Icons.share)),
      ]),
      body: items.isEmpty ? const Center(child: Text('Swipe right to add places')) : ListView.builder(itemCount: items.length, itemBuilder: (c, i) => _Tile(v: items[i])),
    );
  }
}
class _Tile extends ConsumerWidget {
  final Venue v; const _Tile({required this.v});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(v.photoUrl)), title: Text(v.name), subtitle: Text('${v.district} • GEL ${v.priceBand}'), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => ref.read(shortlistProvider.notifier).remove(v)));
  }
}
