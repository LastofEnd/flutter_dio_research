import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/dio_client.dart';
import 'data/repositories/post_repository.dart';
import 'data/services/post_api_service.dart';
import 'presentation/screens/posts_screen.dart';
import 'presentation/viewmodels/posts_viewmodel.dart';

void main() {
  final dio = DioClient.createDio();
  final apiService = PostApiService(dio);
  final repository = PostRepository(apiService);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final PostRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostsViewModel(repository)..loadPosts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dio Research',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const PostsScreen(),
      ),
    );
  }
}