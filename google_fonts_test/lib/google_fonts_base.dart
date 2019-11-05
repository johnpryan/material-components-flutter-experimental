part of 'google_fonts.g.dart';

Future<ByteData> fetchFont(String fontUrl) async {
  final response = await http.get(Uri.parse(fontUrl));

  if (response.statusCode == 200) {
    return ByteData.view(response.bodyBytes.buffer);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load font');
  }
}

void _loadFont(String fontName, String fontUrl) {
  final fontLoader = FontLoader(fontName);
  fontLoader.addFont(fetchFont(fontUrl));
  fontLoader.load();
}