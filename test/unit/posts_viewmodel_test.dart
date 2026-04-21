import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_dio_research/data/models/post_model.dart';
import 'package:flutter_dio_research/data/repositories/post_repository.dart';
import 'package:flutter_dio_research/presentation/viewmodels/posts_viewmodel.dart';

class MockPostRepository extends Mock implements PostRepository {}

class FakePostModel extends Fake implements PostModel {}

void main() {
  late MockPostRepository repository;
  late PostsViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(
      PostModel(userId: 0, id: 0, title: 'fake', body: 'fake'),
    );
  });

  setUp(() {
    repository = MockPostRepository();
    viewModel = PostsViewModel(repository);
  });

  group('PostsViewModel unit tests', () {
    test('loadPosts success should fill posts list', () async {
      final fakePosts = [
        PostModel(userId: 1, id: 1, title: 'Hello', body: 'World'),
        PostModel(userId: 1, id: 2, title: 'Flutter', body: 'Dio'),
      ];

      when(() => repository.getPosts()).thenAnswer((_) async => fakePosts);

      await viewModel.loadPosts();

      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, '');
      expect(viewModel.posts.length, 2);
      expect(viewModel.posts.first.title, 'Hello');
    });

    test('loadPosts failure should set error message', () async {
      when(() => repository.getPosts()).thenThrow(Exception('Network error'));

      await viewModel.loadPosts();

      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, 'Не вдалося завантажити пости');
      expect(viewModel.posts.isEmpty, true);
    });

    test('searchPosts should filter posts by title or body', () async {
      final fakePosts = [
        PostModel(userId: 1, id: 1, title: 'Hello world', body: 'First body'),
        PostModel(userId: 1, id: 2, title: 'Flutter app', body: 'Second body'),
        PostModel(userId: 1, id: 3, title: 'Another post', body: 'Hello text'),
      ];

      when(() => repository.getPosts()).thenAnswer((_) async => fakePosts);

      await viewModel.loadPosts();
      viewModel.searchPosts('hello');

      expect(viewModel.posts.length, 2);
      expect(viewModel.posts.any((e) => e.id == 1), true);
      expect(viewModel.posts.any((e) => e.id == 3), true);
    });

    test('sortPostsByTitle should change order', () async {
      final fakePosts = [
        PostModel(userId: 1, id: 1, title: 'Charlie', body: 'Body'),
        PostModel(userId: 1, id: 2, title: 'Alpha', body: 'Body'),
        PostModel(userId: 1, id: 3, title: 'Bravo', body: 'Body'),
      ];

      when(() => repository.getPosts()).thenAnswer((_) async => fakePosts);

      await viewModel.loadPosts();

      final beforeSort = viewModel.posts.map((e) => e.title).toList();

      viewModel.sortPostsByTitle();

      final afterSort = viewModel.posts.map((e) => e.title).toList();

      expect(beforeSort, isNot(equals(afterSort)));
    });

    test('createPost should add new post to list', () async {
      final fakePosts = [
        PostModel(userId: 1, id: 1, title: 'Old post', body: 'Old body'),
      ];

      final createdPost = PostModel(
        userId: 1,
        id: 101,
        title: 'New post',
        body: 'New body',
      );

      when(() => repository.getPosts()).thenAnswer((_) async => fakePosts);
      when(() => repository.createPost(any())).thenAnswer((_) async => createdPost);

      await viewModel.loadPosts();
      final oldLength = viewModel.posts.length;

      final result = await viewModel.createPost('New post', 'New body');

      expect(result, true);
      expect(viewModel.posts.length, oldLength + 1);
      expect(viewModel.posts.first.title, 'New post');
    });

    test('deletePost should remove post from list', () async {
      final fakePosts = [
        PostModel(userId: 1, id: 1, title: 'First', body: 'Body'),
        PostModel(userId: 1, id: 2, title: 'Second', body: 'Body'),
      ];

      when(() => repository.getPosts()).thenAnswer((_) async => fakePosts);
      when(() => repository.deletePost(1)).thenAnswer((_) async {});

      await viewModel.loadPosts();
      expect(viewModel.posts.length, 2);

      await viewModel.deletePost(1);

      expect(viewModel.posts.length, 1);
      expect(viewModel.posts.any((e) => e.id == 1), false);
    });
  });
}