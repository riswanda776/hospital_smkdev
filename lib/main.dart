import 'package:animations/animations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rumahsakit_smkdev/provider/select_pasien_provider.dart';
import 'package:rumahsakit_smkdev/services/auth_services/auth_services.dart';

import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/constant/primary_color.dart';
import 'package:rumahsakit_smkdev/ui/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setPreferredOrientations(
        [
        DeviceOrientation.portraitUp, 
        DeviceOrientation.portraitDown
        ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectPasienProvider(),
      child: StreamProvider.value(
        value: AuthServices.firebaseUserStream,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('id'),
          ],
          theme: ThemeData(
            primarySwatch: primaryMaterialColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: primaryColor,
            accentColor: primaryColor,
            cursorColor: primaryColor,
            fontFamily: "Poppins",
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.horizontal,
              ),
              TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.horizontal,
              ),
            }),
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
