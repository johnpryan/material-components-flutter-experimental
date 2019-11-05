import 'dart:io';
import 'fonts_data.dart';

void main() {
  final file = File('lib/google_fonts.g.dart');
  final sink = file.openWrite();
  int currentIndent = 0;

  void indent() {
    currentIndent++;
  }

  void unindent() {
    currentIndent--;
    if (currentIndent < 0) currentIndent = 0;
  }

  String indentString() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < currentIndent; i++) {
      buffer.write('  ');
    }
    return buffer.toString();
  }

  void newline() {
    sink.write('\n');
  }

  void line(String line) {
    sink.write('${indentString()}${line}\n');
  }

  line('// GENERATED CODE - DO NOT EDIT');
  newline();
  line('library google_fonts_test;');
  newline();
  line('import \'package:flutter/material.dart\';');
  line("import 'package:http/http.dart' as http;");
  line("import 'package:flutter/services.dart';");
  newline();
  line('part \'google_fonts_base.dart\';');
  newline();
  line('class GoogleFonts {');
  indent();
  for (final item in fontsData['items']) {
    final family = item['family'].toString().replaceAll(' ', '');
    final lowerFamily = family[0].toLowerCase() + family.substring(1);
    for (final variant in item['variants']) {
      final upperVariant = variant == 'regular' ? '' : variant[0].toLowerCase() + variant.substring(1);
      final fullFamily = '${family}${upperVariant}';
      final fontUrl = item['files'][variant];
      line('static TextStyle ${lowerFamily}${upperVariant}(TextStyle textStyle) {');
      indent();
      line("_loadFont('$fullFamily', '$fontUrl');");
      line('return textStyle.copyWith(');
      indent();
      line('fontFamily: \'${fullFamily}\',');
      unindent();
      line(');');
      unindent();
      line('}');
      newline();
    }
  }
  unindent();
  line('}');

  sink.close();
}