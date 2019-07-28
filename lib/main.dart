import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_plus/forms/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Проверка чеков',
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ru', ''),
      ],
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        FallbackCupertinoLocalisationsDelegate()
      ],
      theme: ThemeData(
          primarySwatch: MaterialColor(
            0xFF258ca1,
            <int, Color>{
              50: Color(0xFF82e8fd),
              100: Color(0xFF5de2fd),
              200: Color(0xFF43daf8),
              300: Color(0xFF40d0ed),
              400: Color(0xFF3dc7e3),
              500: Color(0xFF39bed9),
              600: Color(0xFF34b3cc),
              700: Color(0xFF30a8c0),
              800: Color(0xFF2d9eb5),
              900: Color(0xFF258ca1),
            },
          ),
      ),
      home: LoginPage(),
    );
  }
}
