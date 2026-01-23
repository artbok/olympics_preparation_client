import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/localstorage.dart';


class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    String? email = getValue("email");
    String? password = getValue("password");
    const Color backgroundColor = Color.fromRGBO(24, 45, 85, 1);
    const Color surface = Color.fromRGBO(36, 55, 94, 1);
    const Color primary = Color.fromRGBO(109, 224, 255, 1);
    const Color secondary = Colors.blueGrey;

    return MaterialApp(
      title: 'WortZap',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,

          primary: primary, // Accent color for buttons, highlights
          onPrimary: Colors.black, // Text/icons on primary

          surface: surface, // Cards, containers
          onSurface: Colors.white, // Text/icons on surfaces

          error: Colors.red, // Default error color
          onError: Colors.white, // Text/icons on error color

          secondary: secondary, // Optional secondary accent
          onSecondary: Colors.white,
        ), // Text/icons on secondary
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
        ),

        textSelectionTheme: TextSelectionThemeData(cursorColor: primary),

        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: secondary, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          filled: true,
          fillColor: surface,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surface,
          indicatorColor: primary,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primary,
              );
            }
            return const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white, size: 26.0);
            }
            return const IconThemeData(
              color: Colors.white,
              size: 24.0,
            );
          }),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 24),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
          bodySmall: TextStyle(color: Colors.grey, fontSize: 16),
          labelLarge: TextStyle(color: primary, fontSize: 24),
          labelMedium: TextStyle(color: primary, fontSize: 18),
          labelSmall: TextStyle(color: primary, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30
        )
      ),
      
      debugShowCheckedModeBanner: false,

      
    );
  }
}