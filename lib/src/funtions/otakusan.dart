import '../model/model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'dart:async';

class OtakuSan {
  static const String _otakusan = 'otakusan.net';
  // static void chapterCrawl(Uri chapter) async {
  //   final Document doc = await _loadDocument(chapter);
  //   // var list = getResource(doc: doc, query: '.image-wraper img', attribute: 'src');
  //   final List<Element> elements = doc.querySelectorAll('.image-wraper img');
  //   final List<String?> attributes = _getAttributes(elements: elements, attribute: 'src');
  //   attributes.forEach(print);
  // }

  static List<String> _getImagesSource(Document doc) {
    // var list = getResource(doc: doc, query: '.image-wraper img', attribute: 'src');
    final List<Element> elements = doc.querySelectorAll('.image-wraper img');
    final List<String> images = _getAttributes(elements: elements, attribute: 'src');
    // images.forEach(print);
    return images;
  }

  static void crawl() async {
    final Uri uri = Uri.https(_otakusan, '/chapter/1758786/kakkou-no-iinazuke-chap-126');
    final Document doc = await _loadDocument(uri);
    // var list = getResource(doc: doc, query: '.image-wraper img', attribute: 'src');
    final List<Element> elements = doc.querySelectorAll('.image-wraper img');
    final List<String?> attributes = _getAttributes(elements: elements, attribute: 'src');
    attributes.forEach(print);
  }

  static Future<List<Manga>> search(String name) async {
    final Uri searchUri = Uri.https(_otakusan, '/Home/Search', {
      'search': name,
    });
    // print(searchUri);
    final Document doc = await _loadDocument(searchUri);
    // final List<String?> list = getResource(doc: doc, query: '.mdl-card--expand.tag', attribute: 'href');
    final List<Element> elements = doc.querySelectorAll('.mdl-card--expand.tag a');
    // final List<String?> list = _getAttributes(elements: elements, attribute: 'href');
    // list.forEach(print);
    // print(list.length);
    return _toMangaList(elements);
  }

  static List<String> _getAttributes({required List<Element> elements, required String attribute}) {
    final List<String> resources = [];
    // add attributes
    for (Element e in elements) {
      resources.add(e.attributes[attribute] ?? "Content is not loaded from document!");
    } //  https://stackoverflow.com/questions/66581833/how-to-get-attribute-value-from-attribute-name-in-dart-eventvalidation-from-htm
    return resources;
  }

  // static List<String?> getResource({required Document doc, required String query, String? attribute}) {
  //   final List<String?> resources = [];
  //   final List<Element> elements = doc.querySelectorAll(query);
  //   // log attributes
  //   for (Element e in elements) {
  //     // e.getElementsByTagName('img').forEach((t) {
  //     //   print(t.attributes['src']);
  //     // });
  //     // print(e.attributes['src']);
  //     resources.add(e.attributes[attribute]);
  //   } //  https://stackoverflow.com/questions/66581833/how-to-get-attribute-value-from-attribute-name-in-dart-eventvalidation-from-htm
  //   return resources;
  // }

  static List<Manga> _toMangaList(List<Element> elements) {
    final List<Manga> list = [];
    for (Element e in elements) {
      // e.getElementsByTagName('a').forEach((e) => e.attributes['href']);
      // print((e.attributes['title']));
      String name = e.attributes['title'] ?? "Name is not loaded!";
      // print(_otakusan + e.attributes['href']!);
      Uri source = Uri.https(_otakusan, e.attributes['href']!);
      String img = e.querySelector('img')!.attributes['src'] ?? "Image is not loaded!";
      list.add(Manga(name: name, source: source, img: img));
    }
    // mangas.forEach(print);
    return list;
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
}
