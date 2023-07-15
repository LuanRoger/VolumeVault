import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

TextStyle get _titleStyle => GoogleFonts.libreCaslonDisplay();
TextStyle get titleSmall => _titleStyle.copyWith(fontSize: 20);
TextStyle get titleMedium => _titleStyle.copyWith(fontSize: 25);
TextStyle get titleLarge => _titleStyle.copyWith(fontSize: 30);

TextStyle get _headlinesStyle => GoogleFonts.libreCaslonText();
TextStyle get headlineSmall => _headlinesStyle.copyWith(fontSize: 35);
TextStyle get headlineMedium => _headlinesStyle.copyWith(fontSize: 40);
TextStyle get headlineLarge => _headlinesStyle.copyWith(fontSize: 45);
