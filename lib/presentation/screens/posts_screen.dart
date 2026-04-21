import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/posts_viewmodel.dart';
import 'create_post_screen.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PostsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Manager'),
        actions: [
          IconButton(
            onPressed: vm.sortPostsByTitle,
            icon: Icon(
              vm.sortAscending ? Icons.sort_by_alpha : Icons.sort,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: vm.searchPosts,
              decoration: const InputDecoration(
                hintText: 'Пошук...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(vm.errorMessage),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: vm.loadPosts,
                          child: const Text('Спробувати ще раз'),
                        ),
                      ],
                    ),
                  );
                }

                if (vm.posts.isEmpty) {
                  return const Center(child: Text('Нічого не знайдено'));
                }

                return RefreshIndicator(
                  onRefresh: vm.loadPosts,
                  child: ListView.builder(
                    itemCount: vm.posts.length,
                    itemBuilder: (context, index) {
                      final post = vm.posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text(
                            post.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (post.id != null) {
                                await vm.deletePost(post.id!);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}