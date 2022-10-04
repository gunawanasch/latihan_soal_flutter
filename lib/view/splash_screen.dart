import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latihan_soal_flutter/constants/r.dart';
import 'package:latihan_soal_flutter/helpers/user_email.dart';
import 'package:latihan_soal_flutter/models/network_response.dart';
import 'package:latihan_soal_flutter/models/user_by_email.dart';
import 'package:latihan_soal_flutter/repository/auth_api.dart';
import 'package:latihan_soal_flutter/view/login_page.dart';
import 'package:latihan_soal_flutter/view/main_page.dart';
import 'package:latihan_soal_flutter/view/register_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () async {
      final user = UserEmail.getUserEmail();
      if (user != null) {
        final dataUser = await AuthApi().getUserByEmail();
        if (dataUser.status == Status.success) {
          final data = UserByEmail.fromJson(dataUser.data!);
          if (data.status == 1) {
            Navigator.of(context).pushReplacementNamed(MainPage.route);
          } else {
            Navigator.of(context).pushReplacementNamed(RegisterPage.route);
          }
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(R.assets.icSplash),
      ),
    );
  }
}
