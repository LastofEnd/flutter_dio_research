import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:flutter_dio_research/core/network/dio_client.dart';
import 'package:flutter_dio_research/data/repositories/post_repository.dart';
import 'package:flutter_dio_research/data/services/post_api_service.dart';
import 'package:flutter_dio_research/presentation/screens/posts_screen.dart';
import 'package:flutter_dio_research/presentation/viewmodels/posts_viewmodel.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app loads list and search field is visible', (tester) async {
    final Dio dio = DioClient.createDio();
    final repository = PostRepository(PostApiService(dio));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PostsViewModel(repository)..loadPosts(),
          ),
        ],
        child: const MaterialApp(
          home: PostsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Posts Manager'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}