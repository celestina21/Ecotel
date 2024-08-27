// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  // Create a StreamController to manage the colour theme data
  StreamController<Color> themeStreamController =
      StreamController<Color>.broadcast();
  // Create a StreamController to manage the heading font data
  StreamController<String> headingFontStreamController =
      StreamController<String>.broadcast();
  // Create a StreamController to manage the body font data
  StreamController<String> bodyFontStreamController =
      StreamController<String>.broadcast();
  // Store preferences for preservation
  SharedPreferences? prefs;

  // Create getters for the colour theme and fonts stream
  Stream<Color> getThemeStream() {
    return themeStreamController.stream;
  }

  Stream<String> getHeadingFontStream() {
    return headingFontStreamController.stream;
  }

  Stream<String> getBodyFontStream() {
    return bodyFontStreamController.stream;
  }

  // Methods to set/change the colour theme and fonts
  Future<void> setTheme(Color selectedTheme, String stringTheme) async {
    themeStreamController.add(selectedTheme);
    await prefs!.setString('selectedTheme', stringTheme);
  }

  Future<void> setHeadingFont(String selectedheadingFont) async {
    headingFontStreamController.add(selectedheadingFont);
    await prefs!.setString('selectedheadingFont', selectedheadingFont);
  }

  Future<void> setBodyFont(String selectedBodyFont) async {
    bodyFontStreamController.add(selectedBodyFont);
    await prefs!.setString('selectedBodyFont', selectedBodyFont);
  }

  // Methods to load the set colour theme and fonts
  Future<void> loadTheme() async {
    prefs = await SharedPreferences.getInstance();
    // Ensure prefs is not null before accessing it further
    Color currentTheme = const Color.fromRGBO(125, 227, 88, 1);
    if (prefs != null && prefs!.containsKey('selectedTheme')) {
      String selectedTheme = prefs!.getString('selectedTheme')!;
      if (selectedTheme == 'light')
        currentTheme = const Color.fromRGBO(125, 227, 88, 1);
      else if (selectedTheme == 'dark')
        currentTheme = const Color.fromARGB(255, 69, 69, 69);
    }
    themeStreamController.add(currentTheme);
  }

  Future<void> loadheadingFont() async {
    prefs = await SharedPreferences.getInstance();
    // Ensure prefs is not null before accessing it further
    String currentheadingFont = 'Nunito Sans';
    if (prefs != null && prefs!.containsKey('selectedheadingFont')) {
      String selectedheadingFont = prefs!.getString('selectedheadingFont')!;
      if (selectedheadingFont == 'Nunito Sans')
        currentheadingFont = prefs!.getString('selectedheadingFont')!;
      else if (selectedheadingFont == 'Arsenal SC')
        currentheadingFont = prefs!.getString('selectedheadingFont')!;
    }
    headingFontStreamController.add(currentheadingFont);
  }

  Future<void> loadBodyFont() async {
    prefs = await SharedPreferences.getInstance();
    // Ensure prefs is not null before accessing it further
    String currentBodyFont = 'Arial';
    if (prefs != null && prefs!.containsKey('selectedBodyFont')) {
      String selectedBodyFont = prefs!.getString('selectedBodyFont')!;
      if (selectedBodyFont == 'Arial')
        currentBodyFont = prefs!.getString('selectedBodyFont')!;
      else if (selectedBodyFont == 'Roboto Slab')
        currentBodyFont = prefs!.getString('selectedBodyFont')!;
    }
    bodyFontStreamController.add(currentBodyFont);
  }

  // Methods to retrieve the currently set colour theme and fonts for use when creating app UI
  // This method returns the type of colour theme to determine the colour to be used
  String getCurrentTheme() {
    // Load theme from SharedPreferences if available
    if (prefs != null && prefs!.containsKey('selectedTheme')) {
      String selectedTheme = prefs!.getString('selectedTheme')!;
      return selectedTheme;
    }
    // Default theme if no theme is set by the user yet
    return 'light';
  }

  // This method returns the heading font to be used directly
  String getCurrentHeadingFont() {
    // Load theme from SharedPreferences if available
    if (prefs != null && prefs!.containsKey('selectedheadingFont')) {
      String selectedheadingFont = prefs!.getString('selectedheadingFont')!;
      return selectedheadingFont;
    }
    // Default font if no heading is set by the user yet
    return 'Nunito Sans';
  }

  // This method returns the body font to be used directly
  String getCurrentBodyFont() {
    // Load theme from SharedPreferences if available
    if (prefs != null && prefs!.containsKey('selectedBodyFont')) {
      String selectedBodyFont = prefs!.getString('selectedBodyFont')!;
      return selectedBodyFont;
    }
    // Default font if no body font is set by the user yet
    return 'Arial';
  }
}
