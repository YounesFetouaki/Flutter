import 'package:flutter/material.dart';

import '../model/post.dart';
import '../services/post_service.dart';

class PostFormPage extends StatefulWidget {
  final Post? post;
  final void Function(Post)? onSaved;
  final void Function(int)? onDeleted;

  const PostFormPage({
    super.key,
    this.post,
    this.onSaved,
    this.onDeleted,
  });

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final PostService _postService = PostService();

  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  bool _isSubmitting = false;

  bool get _isEditMode => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final postToSend = Post(
        id: widget.post?.id,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      Post result;

      if (_isEditMode) {
        // Call API to "update"
        result = await _postService.updatePost(postToSend);
      } else {
        // Call API to "create"
        result = await _postService.createPost(postToSend);
      }

      // Update local list through callback
      widget.onSaved?.call(result);

      if (mounted) {
        Navigator.pop(context); // no need to return data; parent already updated
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    if (widget.post?.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete post'),
          content:
              const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _postService.deletePost(widget.post!.id!);

      // Update local list through callback
      widget.onDeleted?.call(widget.post!.id!);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while deleting: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = _isEditMode ? 'Edit Post' : 'New Post';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: [
          if (_isEditMode)
            IconButton(
              onPressed: _isSubmitting ? null : _delete,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _isSubmitting,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      labelText: 'Body',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: null,
                    expands: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Body is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isEditMode ? 'Update' : 'Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
