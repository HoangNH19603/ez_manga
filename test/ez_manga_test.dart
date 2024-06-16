import 'package:ez_manga/ez_manga.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group('OtakuSan', () {
    // Mock HTTP client setup
    setUp(() {
      http.Client client = MockClient((request) async {
        if (request.url.toString().contains('search')) {
          return http.Response('<html></html>', 200); // Mock search response
        }
        return http.Response('<html></html>', 200); // Mock general response
      });
      // Inject mock client into OtakuSan (if dependency injection is used)
    });

    test('search returns a list of MangaBase on valid input', () async {
      final List<MangaBase> result = await OtakuSan.search('One Piece');
      expect(result, isA<List<MangaBase>>());
      expect(result.isNotEmpty, isTrue);
      result.forEach(print);
    });

    test('read returns a list of Uri on valid input', () async {
      final List<Uri> result =
          await OtakuSan.read(Uri.parse('https://otakusan.net/chapter/244902/tao-muon-tro-thanh-chua-te-bong-toi'));
      expect(result, isA<List<Uri>>());
      expect(result.isNotEmpty, isTrue);
      result.forEach(print);
    });

    // Additional tests for other methods like _loadChapters, _loadGenres, and loadMangaInfo
    // would follow a similar structure, but might require more specific mock responses
    // and possibly more setup for mocking the Document parsing.
  });
}
