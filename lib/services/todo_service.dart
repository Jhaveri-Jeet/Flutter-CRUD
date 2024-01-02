import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoServices {
  static String baseUrl = 'use your api';
  static Future<bool> deleteData(int id) async {
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchData() async {
    final url = baseUrl;
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List;
      return jsonData;
    } else {
      return null;
    }
  }

  static Future<bool> updateData(int id, Map body) async {
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  static Future<bool> addData(Map body) async {
    final url = baseUrl;
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }
}
