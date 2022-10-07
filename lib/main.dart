import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latihan_soal_flutter/constants/r.dart';
import 'package:latihan_soal_flutter/providers/auth_provider.dart';
import 'package:latihan_soal_flutter/providers/latihan_soal_provider.dart';
import 'package:latihan_soal_flutter/view/auth/login_page.dart';
import 'package:latihan_soal_flutter/view/main/main_page.dart';
import 'package:latihan_soal_flutter/view/auth/register_page.dart';
import 'package:latihan_soal_flutter/view/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>( create: (context) => AuthProvider()),
        ChangeNotifierProvider<LatihanSoalProvider>( create: (context) => LatihanSoalProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
