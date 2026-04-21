import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/post_model.dart';
import '../viewmodels/posts_viewmodel.dart';
import 'create_post_screen.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<PostsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Деталі поста'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePostScreen(post: post),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if (post.id != null) {
                await vm.deletePost(post.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text('ID: ${post.id ?? '-'}'),
            Text('User ID: ${post.userId ?? '-'}'),
          ],
        ),
      ),
    );
  }
}