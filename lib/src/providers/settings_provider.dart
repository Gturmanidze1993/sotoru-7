import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final Locale locale;
  const SettingsState({required this.locale});
  SettingsState copyWith({Locale? locale}) => SettingsState(locale: locale ?? this.locale);
}
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState(locale: Locale('en'))) { _load(); }
  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final code = sp.getString('locale') ?? 'en';
    state = state.copyWith(locale: Locale(code));
  }
  Future<void> setLocale(Locale l) async { state = state.copyWith(locale: l); final sp = await SharedPreferences.getInstance(); await sp.setString('locale', l.languageCode); }
}
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) => SettingsNotifier());
