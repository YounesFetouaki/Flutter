import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/post.dart';

class PostService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com/posts';

  // GET all posts
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((jsonItem) => Post.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load posts (code: ${response.statusCode})');
    }
  }

  // GET single post (optional, not strictly needed)
  Future<Post> fetchPost(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post (code: ${response.statusCode})');
    }
  }

  // CREATE (POST)
  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create post (code: ${response.statusCode})');
    }
  }

  // UPDATE (PUT)
  Future<Post> updatePost(Post post) async {
    if (post.id == null) {
      throw Exception('Post ID is required for update.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${post.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update post (code: ${response.statusCode})');
    }
  }

  // DELETE
  Future<void> deletePost(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post (code: ${response.statusCode})');
    }
  }
}
