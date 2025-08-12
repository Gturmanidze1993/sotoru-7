import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/strings.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_shell.dart';
import 'providers/settings_provider.dart';
import 'ui/theme.dart';

class SotoruApp extends ConsumerWidget {
  final bool showOnboarding;
  const SotoruApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(settingsProvider.select((s) => s.locale));
    return MaterialApp(
      title: 'Sotoru',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ka')],
      localizationsDelegates: const [
        AppStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: showOnboarding ? const OnboardingScreen() : const HomeShell(),
      routes: { HomeShell.route: (_) => const HomeShell() },
    );
  }
}
