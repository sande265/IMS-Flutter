import 'dart:io';
import 'package:ims_flutter/Screens/dashboard.dart';
import 'package:ims_flutter/Screens/home_page.dart';
import 'package:ims_flutter/Screens/login.dart';
import 'package:ims_flutter/Screens/profile.dart';
import 'package:ims_flutter/helpers/general_helpers.dart';
import 'package:ims_flutter/popups/popup_card.dart';
import 'package:ims_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            title: 'Inventory Management System',
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: AppTheme.textTheme,
              platform: TargetPlatform.iOS,
            ),
            // home: const HomeScreen(),
            initialRoute: isAuthenticated() ? HomeScreen.id : LoginScreen.id,
            routes: {
              LoginScreen.id: (context) => const LoginScreen(),
              HomeScreen.id: (context) => const HomeScreen(),
              PopupCard.id: (context) => const PopupCard(),
              ProfilePage.id: (context) => const ProfilePage(),
              Dashboard.id: (context) => const Dashboard(),
            },
          );
        });
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
