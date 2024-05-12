import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Nettruyen {
  static void crawl() async {
    Uri uri = Uri.https('otakusan.net', '/chapter/1758786/kakkou-no-iinazuke-chap-126');
    // http.Response response = await http.get(uri);
    // Document html;
    // if (response.statusCode != 200) {
    //   return;
    // } else {
    //   html = parser.parse(response.body.toString());
    // }
    // List<Element> elements = html.getElementsByClassName('image-wraper');
    // for (var e in elements) {
    //   print(e.attributes);
    // }
    final client = HttpClient();
    final request = await client.getUrl(uri);
    final response = await request.close();
    final contentAsString =
        await utf8.decodeStream(response); //  https://stackoverflow.com/questions/52244542/make-a-http-request-in-dart-whith-dartio
    final html = parser.parse(contentAsString);
    List<Element> elements = html.getElementsByClassName('image-wraper');

    List<Element> tags;
    for (var e in elements) {
      e.getElementsByTagName('img').forEach((t) {
        print(t.attributes['src']);
      });
    } //  https://stackoverflow.com/questions/66581833/how-to-get-attribute-value-from-attribute-name-in-dart-eventvalidation-from-htm

    // response.transform(utf8.decoder).listen((data) {
    //   print(data);
    // });  // https://stackoverflow.com/questions/27808848/retrieving-the-response-body-from-an-httpclientresponse
  }

  static void search() async {}
}
