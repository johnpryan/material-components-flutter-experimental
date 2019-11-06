import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<ByteData> fetchFont(String fontName, String fontUrl) async {
  print('fetchFont: $fontName');
  final response = await http.get(Uri.parse(fontUrl));

  if (response.statusCode == 200) {
    writeLocalFont(fontName, response.bodyBytes);
    return ByteData.view(response.bodyBytes.buffer);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load font');
  }
}

Future<void> loadFont(String fontName, String fontUrl) async {
  final fontLoader = FontLoader(fontName);
  var byteData = readLocalFont(fontName);
  if (await byteData == null) {
    byteData = fetchFont(fontName, fontUrl);
  }
  fontLoader.addFont(byteData);
  fontLoader.load();
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(String name) async {
  final path = await _localPath;
  return File('$path/$name.ttf');
}

Future<File> writeLocalFont(String name, List<int> bytes) async {
  print('writeLocalFont: $name');
  final file = await _localFile(name);
  return file.writeAsBytes(bytes);
}

Future<ByteData> readLocalFont(String name) async {
  print('readLocalFont: $name');
  try {
    final file = await _localFile(name);
    final fileExists = await file.exists();
    if (fileExists) {
      List<int> contents = await file.readAsBytes();
      if (contents != null && contents.isNotEmpty) {
        print('readLocalFont: $name EXISTS AND RETURNING');
        return ByteData.view(Uint8List
            .fromList(contents)
            .buffer);
      }
    }
  } catch (e) {
    print('readLocalFont: $name ERROR');
    return null;
  }
  print('readLocalFont: $name DOES NOT EXIST');
  return null;
}


// TODO: this might not be uniform for all fonts, and we might just have to
// name our files with weight numbers and styles the same way that the variants
// are listed. Alternativly, this could return a list of all possible filenames.
String _fileName(String regularFontFamily, FontWeight weight, FontStyle style) {
  final styleChunk = style == FontStyle.italic ? 'Italic' : '';
  var weightChunk = '';
  if (weight == FontWeight.w100) {
    weightChunk = 'Light';
  } else if (weight == FontWeight.w200) {
    weightChunk = 'Thin';
  } else if (weight == FontWeight.w300) {
    weightChunk = 'Thin';
  } else if (weight == null || weight == FontWeight.w400) {
    weightChunk = 'Regular';
  } else if (weight == FontWeight.w500) {
    weightChunk = 'SemiBold';
  } else if (weight == FontWeight.w600) {
    weightChunk = 'SemiBold';
  } else if (weight == FontWeight.w700) {
    weightChunk = 'Bold';
  } else if (weight == FontWeight.w800) {
    weightChunk = 'ExtraBold';
  } else if (weight == FontWeight.w900) {
    weightChunk = 'ExtraBold';
  }
  return '${regularFontFamily}-${weightChunk}${styleChunk}';
}