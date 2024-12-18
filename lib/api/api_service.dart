import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.115.104/kel6_apk/restful_api_php";

  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/user/register.php"),
        body: jsonEncode({"name": name, "email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      // Debugging untuk response HTTP
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Pastikan respons JSON valid
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"message": "Failed to connect to server"};
      }
    } catch (e) {
      print("Error: $e");
      return {"message": "An error occurred"};
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/user/login.php"),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse("$baseUrl/api/post/read.php"));
    return jsonDecode(response.body);
  }

  //create post
  static Future<Map<String, dynamic>> addPost(
      int userId, String title, String content) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/post/create.php"),
      body: jsonEncode({
        "user_id": userId,
        "title": title,
        "content": content,
      }),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }

  // Update post
  static Future<Map<String, dynamic>> updatePost(
      int id, int userId, String title, String content) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/post/update.php"),
      body: jsonEncode(
          {"id": id, "user_id": userId, "title": title, "content": content}),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }

// Delete post
  static Future<Map<String, dynamic>> deletePost(int id, int userId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/post/delete.php"),
      body: jsonEncode({"id": id, "user_id": userId}),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
