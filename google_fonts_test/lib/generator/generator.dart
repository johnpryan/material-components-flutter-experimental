import 'dart:io';
import '../data/fonts_data.dart';

import 'package:mustache/mustache.dart';

void main() {
  final file = File('lib/google_fonts.g.dart');
  final sink = file.openWrite();

  final methods = [];

  for (final item in fontsData['items']) {
    final family = item['family'].toString().replaceAll(' ', '');
    final lowerFamily = family[0].toLowerCase() + family.substring(1);

    for (final variant in item['variants']) {
      // TODO: s/italic/Italic
      final upperVariant = variant == 'regular'
          ? ''
          : '${variant[0].toLowerCase()}${variant.substring(1)}';
      final fullFamily = '$family$upperVariant';
      final fontUrl = item['files'][variant];

      methods.add({
        'methodName': '$lowerFamily$upperVariant',
        'fontFamily': fullFamily,
        'fontUrl': '$fontUrl',
      });
    }
  }

  final template = Template(
    File('lib/generator/google_fonts.tmpl').readAsStringSync(),
  );
  final result = template.renderString({'method': methods});

  sink.write(result);
  sink.close();
}
