import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final done = sp.getBool('onboarding_done') ?? false;
  runApp(ProviderScope(child: SotoruApp(showOnboarding: !done)));
}
