import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:services/l10n/l10n.dart';
import 'package:services/widgets/providerModels/aadhar_model.dart';
import 'package:services/widgets/providerModels/email_model.dart';
import 'package:services/widgets/providerModels/location_model.dart';
import 'package:services/widgets/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

final colorScheme = ColorScheme.fromSeed(
    seedColor:
        // const Color.fromARGB(255, 125, 94, 158),
        // Color.fromARGB(255, 196, 185, 207),
        Colors.deepPurpleAccent);

final darkColorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 38, 32, 53),
        brightness: Brightness.dark)
    .copyWith(
        onPrimary: Colors.black87,
        onPrimaryContainer: const Color.fromARGB(57, 15, 69, 47));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDE3CEW3kTZK5LxNN_qjLWCH4rx4A_2ues",
          appId: "1:69047120729:android:9f24bd5bba8f6da2a79248",
          messagingSenderId: "69047120729",
          projectId: "services-e8b07"));

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final lang = prefs.getString('lang') ?? 'en';

  SystemChrome.setPreferredOrientations(
    ([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]),
  ).then((_) {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmailModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AadharModel(),
        ),
      ],
      child: MyApp(
        isDarkMode: isDarkMode,
        key: myAppKey,
        lang: lang,
      ),
    ),
  );
  },);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isDarkMode, required this.lang});

  final bool isDarkMode;
  final String lang;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late String languageSelected;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    languageSelected = widget.lang;
  }

  void toggleLang(String newLang) async {
    setState(() {
      languageSelected = newLang;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', newLang);
  }

  void toggleTheme(bool isDarkMode) async {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      locale: Locale(languageSelected),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.from(colorScheme: colorScheme).copyWith(
        colorScheme: colorScheme,
        textTheme: GoogleFonts.montserratTextTheme(),
        primaryTextTheme: const TextTheme(
          displaySmall: TextStyle(color: Colors.black),
        ),
      ),
      home: const SplashScreen(),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.montserratTextTheme(),
        scaffoldBackgroundColor: Colors.black,
        primaryColorLight: Colors.black,
        primaryTextTheme:
            const TextTheme(displaySmall: TextStyle(color: Colors.white)),
      ),
      themeMode: _themeMode,
    );
  }
}
