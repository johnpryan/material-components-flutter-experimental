// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

    methods.add({
      'methodName': '$lowerFamily',
      'fontFamily': family,
      'fontUrls': [
        for(final variant in item['variants'])
          {'variant': variant, 'url': item['files'][variant]}
      ],
    });
  }

  final template = Template(
    File('lib/generator/google_fonts.tmpl').readAsStringSync(),
    htmlEscapeValues: false,
  );
  final result = template.renderString({'method': methods});

  sink.write(result);
  sink.close();
}
