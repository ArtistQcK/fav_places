import 'package:fav_places/screens/places_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kLightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Color.fromARGB(255, 172, 128, 238),
);

final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 40, 0, 100),
);

final lightTheme = ThemeData(
  colorScheme: kLightColorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme(),
);

final darkTheme = ThemeData(
  colorScheme: kDarkColorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kDarkColorScheme.surface,
    foregroundColor: kDarkColorScheme.onSurface,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: kDarkColorScheme.primary,
      backgroundColor: kDarkColorScheme.onPrimary,
    ),
  ),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          ThemeMode.dark, // Automatically switch between light and dark theme
      home: PlacesScreen(),
    );
  }
}
