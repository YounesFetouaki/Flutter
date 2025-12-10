import 'package:flutter/material.dart';

import '../model/post.dart';
import '../services/post_service.dart';
import 'post_form_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostService _postService = PostService();

  Future<List<Post>>? _postsFuture; // used for the initial load & refresh
  List<Post> _posts = []; // local in-memory list

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    setState(() {
      _postsFuture = _postService.fetchPosts().then((value) {
        _posts = value;
        return value;
      });
    });
  }

  Future<void> _refresh() async {
    _fetchPosts();
    await _postsFuture;
  }

  // ====== Local list helpers ======

  void _addPost(Post post) {
    setState(() {
      // Insert at top so it’s visible immediately
      _posts.insert(0, post);
    });
  }

  void _updatePostInList(Post updated) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        _posts[index] = updated;
      }
    });
  }

  void _removePostFromList(int id) {
    setState(() {
      _posts.removeWhere((p) => p.id == id);
    });
  }

  // ====== Navigation to forms ======

  Future<void> _openCreateForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostFormPage(
          onSaved: _addPost,
        ),
      ),
    );
  }

  Future<void> _openEditForm(Post post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostFormPage(
          post: post,
          onSaved: _updatePostInList,
          onDeleted: _removePostFromList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _fetchPosts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // No data
          if (_posts.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No posts available.')),
                ],
              ),
            );
          }

          // Show local list (_posts)
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _posts.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final post = _posts[index];
                return ListTile(
                  title: Text(
                    post.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _openEditForm(post),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
