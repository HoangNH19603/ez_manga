import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'dart:async';

const String otakusan = 'otakusan.net';

class Nettruyen {
  static void crawl() async {
    Uri uri = Uri.https(otakusan, '/chapter/1758786/kakkou-no-iinazuke-chap-126');
    var doc = await getResponse(uri);
    var list = getResource(doc: doc, query: '.image-wraper img', attributes: 'src');
    list.forEach(print);
  }

  static void search(String name) async {
    final Uri searchUri = Uri.https(otakusan, '/Home/Search', {
      'search': name,
    });
    print(searchUri);
    // TODO: complete this!!!
  }

  static List<String?> getResource({required Document doc, required String query, String? attributes}) {
    final List<String?> resources = [];
    final List<Element> elements = doc.querySelectorAll(query);
    // log attributes
    for (Element e in elements) {
      // e.getElementsByTagName('img').forEach((t) {
      //   print(t.attributes['src']);
      // });
      // print(e.attributes['src']);
      resources.add(e.attributes[attributes]);
    } //  https://stackoverflow.com/questions/66581833/how-to-get-attribute-value-from-attribute-name-in-dart-eventvalidation-from-htm
    return resources;
  }

  static Future<Document> getResponse(Uri uri) async {
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
