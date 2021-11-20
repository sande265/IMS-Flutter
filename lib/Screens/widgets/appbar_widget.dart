import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ims_flutter/main.dart';
import 'package:ims_flutter/theme/app_theme.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: const BackButton(),
    backgroundColor: AppTheme.nearlyDarkBlue,
    elevation: 2,
    actions: [
      IconButton(
        icon: Icon(icon),
        onPressed: () {
          print('toggled');
          MyApp.themeNotifier.value =
          MyApp.themeNotifier.value == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
        },
      ),
    ],
  );
}