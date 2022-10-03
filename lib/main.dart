import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latihan_soal_flutter/constants/r.dart';
import 'package:latihan_soal_flutter/view/login_page.dart';
import 'package:latihan_soal_flutter/view/main/latihan_soal/mapel_page.dart';
import 'package:latihan_soal_flutter/view/main/latihan_soal/paket_soal_page.dart';
import 'package:latihan_soal_flutter/view/main_page.dart';
import 'package:latihan_soal_flutter/view/register_page.dart';
import 'package:latihan_soal_flutter/view/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Soal',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: R.colors.primary,
        )
      ),
      // home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        LoginPage.route: (context) => const LoginPage(),
        RegisterPage.route: (context) => const RegisterPage(),
        MainPage.route: (context) => const MainPage(),
      },
    );
  }
}
