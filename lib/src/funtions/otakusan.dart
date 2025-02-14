import '../model/model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

// !All of documents in this class was generated by github copilot pls check it before you use this code!!!
class OtakuSan {
  static const String _otakusan = 'otakusan.net';

  /// Retrieves the source URIs of the images from the given [doc].
  ///
  /// The method searches for elements with the class name 'image-wraper' and
  /// selects the 'img' elements within them. It then extracts the 'src'
  /// attribute values of these elements and converts them into [Uri] objects.
  ///
  /// Returns a list of [Uri] objects representing the source URIs of the images.
  static List<Uri> _getImagesSource(Document doc) {
    final List<Element> elements = doc.querySelectorAll('.image-wraper img');
    final List<String> imgStr =
        _getAttributes(elements: elements, attribute: 'src');
    return imgStr.map(Uri.parse).toList();
  }

  /// Reads the content of the given [uri] and returns a list of URIs for the images found.
  ///
  /// This method asynchronously loads the document from the specified [uri] and extracts
  /// the source URIs of the images present in the document. It returns a [Future] that
  /// completes with a list of [Uri] objects representing the image sources.
  ///
  /// Example usage:
  /// ```dart
  /// Uri uri = Uri.parse('https://otakusan.net/chapter/244902/tao-muon-tro-thanh-chua-te-bong-toi');
  /// List<Uri> imageUris = await Otakusan.read(uri);
  /// ```
  static Future<List<Uri>> read(Uri uri) async {
    final Document doc = await _loadDocument(uri);
    return _getImagesSource(doc);
  }

  /// Searches for manga with the given [name] on Otakusan website.
  ///
  /// Returns a [Future] that completes with a list of [MangaBase] objects.
  /// The [name] parameter specifies the name of the manga to search for.
  /// The search is performed by making a request to the Otakusan website and parsing the response.
  /// The search results are then converted into a list of [MangaBase] objects.
  static Future<List<MangaBase>> search(String name) async {
    final Uri searchUri =
        Uri.https(_otakusan, '/Home/Search', {'search': name});
    final Document doc = await _loadDocument(searchUri);
    final List<Element> elements =
        doc.querySelectorAll('.mdl-card--expand.tag a');
    return _mangaListSearch(elements);
  }

  /// Returns a list of attributes from the given list of elements.
  ///
  /// The [elements] parameter is a required list of elements from which to extract attributes.
  /// The [attribute] parameter is a required string representing the name of the attribute to extract.
  ///
  /// If an element does not have the specified attribute, the default value "Content is not loaded from document!" is used.
  ///
  /// Returns a list of strings representing the extracted attributes.
  static List<String> _getAttributes(
      {required List<Element> elements, required String attribute}) {
    return elements
        .map((e) =>
            e.attributes[attribute] ?? "Content is not loaded from document!")
        .toList();
  }

  /// Converts a list of HTML elements into a list of MangaBase objects.
  ///
  /// The [elements] parameter is a list of HTML elements representing manga items.
  /// Each element should have attributes for 'title', 'href', and contain an 'img' tag.
  /// If any of these attributes are missing, default values will be used.
  ///
  /// Returns a list of MangaBase objects created from the HTML elements.
  static List<MangaBase> _mangaListSearch(List<Element> elements) {
    final List<MangaBase> mangaList = [];
    for (Element e in elements) {
      String name = e.attributes['title'] ?? "Name is not loaded!";
      Uri source = Uri.https(_otakusan, e.attributes['href'] ?? "Null");
      Uri img = Uri.parse(
          e.querySelector('img')?.attributes['src'] ?? "Image is not loaded!");
      mangaList.add(MangaBase(name: name, source: source, img: img));
    }
    return mangaList;
  }

  /// Loads a document from the specified [uri].
  ///
  /// This method makes an HTTP GET request to the [uri] and parses the response
  /// body as HTML using the `html` package. The parsed HTML document is then
  /// returned as a [Document] object.
  ///
  /// There are two ways to make the HTTP request:
  ///   - Way 1: Uses the `http` package to send the GET request and receive the
  ///     response. If the response status code is not 200, an exception is thrown.
  ///   - Way 2: Uses the `dart:io` package to create an HTTP client, send the GET
  ///     request, and receive the response. The response body is decoded as UTF-8
  ///     and parsed as HTML. This way is commented out in the code.
  ///
  /// Note: Uncomment the code for way 2 and comment out the code for way 1 if you
  /// prefer to use the second way of making the HTTP request.
  ///
  /// Example usage:
  /// ```dart
  /// Uri uri = Uri.parse('https://example.com');
  /// Document document = await _loadDocument(uri);
  /// ```
  static Future<Document> _loadDocument(Uri uri) async {
    // way 1
    final Document html;
    try {
      http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Status code ${response.statusCode}');
      } else {
        html = parser.parse(response.body.toString());
      }
    } on Exception catch (e) {
      print(e);
      rethrow;
    }

    // way 2
    // final client = HttpClient();
    // final request = await client.getUrl(uri);
    // final response = await request.close();
    // final contentAsString =
    //     await utf8.decodeStream(response); //  https://stackoverflow.com/questions/52244542/make-a-http-request-in-dart-whith-dartio
    // final html = parser.parse(contentAsString);
    // List<Element> elements = html.getElementsByClassName('image-wraper');

    // log content
    // response.transform(utf8.decoder).listen((data) {
    //   print(data);
    // });  // https://stackoverflow.com/questions/27808848/retrieving-the-response-body-from-an-httpclientresponse

    return html;
  }

  /// Loads the chapters of a manga from the Otakusan source.
  ///
  /// This method retrieves the HTML document from the manga's source URL and
  /// extracts the chapter elements using the CSS selector '.thrilldown'. It then
  /// creates a list of [Chapter] objects based on the extracted elements and
  /// returns the list.
  ///
  /// The [manga] parameter specifies the manga for which to load the chapters.
  ///
  /// Returns a [Future] that completes with a list of [Chapter] objects.
  static Future<List<Chapter>> _loadChapters({required MangaBase manga}) async {
    final Document doc = await _loadDocument(manga.source);
    final List<Element> elements = doc.querySelectorAll('.thrilldown');
    final List<Chapter> chapters = <Chapter>[];
    for (Element e in elements) {
      String name = e.text;
      Uri uri = Uri.https(_otakusan, e.attributes['href']!);
      chapters.add(Chapter(name: name, uri: uri));
    }
    return chapters;
  }

  /// Loads the genres for the given manga from the Otakusan website.
  ///
  /// This function fetches the HTML document from the manga's source URL and
  /// extracts the genre information by querying the '.tag-link' elements.
  /// It then creates a list of [Genre] objects with the name and URI of each genre.
  ///
  /// Parameters:
  /// - manga: The manga for which to load the genres.
  ///
  /// Returns:
  /// A [Future] that completes with a list of [Genre] objects.
  static Future<List<Genre>> _loadGenres({required MangaBase manga}) async {
    final Document doc = await _loadDocument(manga.source);
    final List<Element> elements = doc.querySelectorAll('.tag-link');
    final List<Genre> genres = <Genre>[];
    for (Element e in elements) {
      String name = e.text;
      Uri uri = Uri.https(_otakusan, e.attributes['href']!);
      genres.add(Genre(name: name, uri: uri));
    }
    return genres;
  }

  /// Loads the manga information for the given [manga].
  ///
  /// This method asynchronously loads the chapters and genres for the manga.
  /// It returns a [Manga] object containing the manga name, source, image,
  /// chapters, and genres.
  ///
  /// Example usage:
  /// ```dart
  /// MangaBase manga = MangaBase(name: 'One Piece', source: 'Otakusan', img: 'one_piece.jpg');
  /// Manga mangaInfo = await Otakusan.loadMangaInfo(manga: manga);
  /// print(mangaInfo.name); // Output: One Piece
  /// print(mangaInfo.chapters); // Output: [Chapter1, Chapter2, ...]
  /// print(mangaInfo.genres); // Output: [Genre1, Genre2, ...]
  /// ```
  static Future<Manga> loadMangaInfo({required MangaBase manga}) async {
    final List<Chapter> chapters = await _loadChapters(manga: manga);
    final List<Genre> genres = await _loadGenres(manga: manga);
    return Manga(
        name: manga.name,
        source: manga.source,
        img: manga.img,
        chapters: chapters,
        genres: genres);
  }
}
