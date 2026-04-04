import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

/// Lab 9 – API Integration Service
/// Handles all GET requests to the JSONPlaceholder API.
/// API Base URL: https://jsonplaceholder.typicode.com
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetches list of posts from the API
  /// Returns a List<Post> on success, throws ApiException on failure.
  static Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');
    try {
      await Future.delayed(const Duration(seconds: 3)); // TEMP: for loading screenshot
      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse JSON response body
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Convert each JSON object into a Post model
        return jsonData.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw ApiException(
          'Server returned status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on HttpException {
      throw ApiException('Unable to reach the server. Try again later.');
    } on FormatException {
      throw ApiException('Failed to parse server response.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('An unexpected error occurred: $e');
    }
  }

  /// Fetches a single post by ID
  static Future<Post> fetchPostById(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw ApiException(
          'Post not found (status ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection.');
    } catch (e) {
      throw ApiException('Failed to fetch post: $e');
    }
  }
}

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}
