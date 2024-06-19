import 'package:ez_manga/ez_manga.dart';
import 'package:test/test.dart';

void main() {
  group('OtakuSan', () {
    // Mock HTTP client setup
    late Uri testSource;
    late MangaBase base;
    setUp(() {
      base = MangaBase(
          name: 'Setup test',
          source: Uri.parse('https://otakusan.net/manga-detail/15119/tao-muon-tro-thanh-chua-te-bong-toi'),
          img: Uri.parse('https://imagepi.otakusan.net/extendContent/Manga/15119/7dc8dd9c-447f-4be5-bce1-532e8722f2bc.jpeg'));
      testSource = Uri.parse('https://otakusan.net/chapter/244902/tao-muon-tro-thanh-chua-te-bong-toi');
      print("Setup complete!");

      // http.Client client = MockClient((request) async {
      //   if (request.url.toString().contains('search')) {
      //     return http.Response('<html></html>', 200); // Mock search response
      //   }
      //   return http.Response('<html></html>', 200); // Mock general response
      // });
      // Inject mock client into OtakuSan (if dependency injection is used)
    });

    test('search returns a list of MangaBase on valid input', () async {
      final List<MangaBase> result = await OtakuSan.search('One Piece');
      expect(result, isA<List<MangaBase>>());
      expect(result.isNotEmpty, isTrue);
      result.forEach(print);
    });

    test('get manga detail', () async {
      final Manga result = await OtakuSan.loadMangaInfo(manga: base);
      expect(result, isA<Manga>());
      expect(result.chapters, isNotEmpty);
      print(result);
    });

    test('read returns a list of Uri on valid input', () async {
      final List<Uri> result = await OtakuSan.read(testSource);
      expect(result, isA<List<Uri>>());
      expect(result.isNotEmpty, isTrue);
      result.forEach(print);
    });

    // Additional tests for other methods like _loadChapters, _loadGenres, and loadMangaInfo
    // would follow a similar structure, but might require more specific mock responses
    // and possibly more setup for mocking the Document parsing.
  });
}
