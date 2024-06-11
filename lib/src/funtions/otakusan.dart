import 'package:ez_manga/src/model/manga/manga.dart';

import '../model/model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'dart:async';

class OtakuSan {
  static const String _otakusan = 'otakusan.net';

  static List<Uri> _getImagesSource(Document doc) {
    final List<Element> elements = doc.querySelectorAll('.image-wraper img');
    final List<String> imgStr = _getAttributes(elements: elements, attribute: 'src');
    return imgStr.map(Uri.parse).toList();
  }

  static Future<List<Uri>> read(Uri uri) async {
    final Document doc = await _loadDocument(uri);
    return _getImagesSource(doc);
  }

  static Future<List<MangaBase>> search(String name) async {
    final Uri searchUri = Uri.https(_otakusan, '/Home/Search', {'search': name});
    final Document doc = await _loadDocument(searchUri);
    final List<Element> elements = doc.querySelectorAll('.mdl-card--expand.tag a');
    return _mangaListSearch(elements);
  }

  static List<String> _getAttributes({required List<Element> elements, required String attribute}) {
    return elements.map((e) => e.attributes[attribute] ?? "Content is not loaded from document!").toList();
  }

  static List<MangaBase> _mangaListSearch(List<Element> elements) {
    return elements
        .map((e) => MangaBase(
            name: e.attributes['title'] ?? "Name is not loaded!",
            source: Uri.https(_otakusan, e.attributes['href'] ?? "Null"),
            img: e.querySelector('img')!.attributes['src'] ?? "Image is not loaded!"))
        .toList();
    // final List<MangaBase> list = <MangaBase>[];
    // for (Element e in elements) {
    //   String name = e.attributes['title'] ?? "Name is not loaded!";
    //   Uri source = Uri.https(_otakusan, e.attributes['href']!);
    //   String img = e.querySelector('img')!.attributes['src'] ?? "Image is not loaded!";
    //   list.add(MangaBase(name: name, source: source, img: img));
    // }
    // list.forEach((m) => print(m.source));
    // return list;
  }

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

  static Future<Manga> loadMangaInfo({required MangaBase manga}) async {
    final List<Chapter> chapters = await _loadChapters(manga: manga);
    final List<Genre> genres = await _loadGenres(manga: manga);
    return Manga(name: manga.name, source: manga.source, img: manga.img, chapters: chapters, genres: genres);
  }
}
