import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/venue.dart';
import '../services/places_repository.dart';

final deckProvider = StateNotifierProvider<DeckNotifier, List<Venue>>((ref) => DeckNotifier(ref));
final shortlistProvider = StateNotifierProvider<ShortlistNotifier, List<Venue>>((ref) => ShortlistNotifier());
final searchQueryProvider = StateProvider<String>((ref) => '');
final quickChipsProvider = StateProvider<Set<String>>((ref) => <String>{});

class DeckNotifier extends StateNotifier<List<Venue>> {
  final Ref ref;
  DeckNotifier(this.ref) : super(const []) { refresh(); }
  Future<void> refresh() async {
    final repo = ref.read(repoProvider);
    state = await repo.sample();
    final sp = await SharedPreferences.getInstance();
    await sp.setString('deck', json.encode(state.map((e) => e.name).toList()));
  }
  void swipeLeft(Venue v) { state = [...state]..removeWhere((e) => e.id == v.id); }
}
class ShortlistNotifier extends StateNotifier<List<Venue>> {
  ShortlistNotifier() : super(const []);
  void add(Venue v) { if (state.any((e) => e.id == v.id)) return; state = [...state, v]; }
  void remove(Venue v) { state = [...state]..removeWhere((e) => e.id == v.id); }
}

final repoProvider = Provider<PlacesRepository>((ref) => PlacesRepository());
