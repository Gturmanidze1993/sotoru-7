import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  final Map<String, String> _m;
  AppStrings(this._m);
  String t(String k) => _m[k] ?? k;
  static Future<AppStrings> load(Locale l) async {
    final code = l.languageCode == 'ka' ? 'ka' : 'en';
    final raw = await rootBundle.loadString('assets/strings_${code}.json');
    final map = Map<String, dynamic>.from(json.decode(raw));
    return AppStrings(map.map((k, v) => MapEntry(k, v.toString())));
  }
  static AppStrings of(BuildContext c) => Localizations.of<AppStrings>(c, AppStrings)!;
}
class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();
  @override
  bool isSupported(Locale locale) => ['en','ka'].contains(locale.languageCode);
  @override
  Future<AppStrings> load(Locale locale) => AppStrings.load(locale);
  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}
