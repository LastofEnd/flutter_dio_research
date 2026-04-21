import 'package:flutter/foundation.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

class PostsViewModel extends ChangeNotifier {
  final PostRepository repository;

  PostsViewModel(this.repository);

  List<PostModel> _posts = [];
  List<PostModel> _filteredPosts = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _sortAscending = true;

  List<PostModel> get posts => _filteredPosts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get sortAscending => _sortAscending;

  Future<void> loadPosts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _posts = await repository.getPosts();
      _filteredPosts = List.from(_posts);
    } catch (e) {
      _errorMessage = 'Не вдалося завантажити пости';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPosts(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      _filteredPosts = List.from(_posts);
    } else {
      _filteredPosts = _posts.where((post) {
        return post.title.toLowerCase().contains(q) ||
            post.body.toLowerCase().contains(q);
      }).toList();
    }

    notifyListeners();
  }

  void sortPostsByTitle() {
    _sortAscending = !_sortAscending;
    _filteredPosts.sort((a, b) {
      return _sortAscending
          ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
          : b.title.toLowerCase().compareTo(a.title.toLowerCase());
    });
    notifyListeners();
  }

  Future<bool> createPost(String title, String body) async {
    try {
      final created = await repository.createPost(
        PostModel(userId: 1, title: title, body: body),
      );

      _posts.insert(0, created);
      _filteredPosts = List.from(_posts);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Не вдалося створити пост';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePost(int id, String title, String body) async {
    try {
      final updated = await repository.updatePost(
        id,
        PostModel(userId: 1, id: id, title: title, body: body),
      );

      final index = _posts.indexWhere((e) => e.id == id);
      if (index != -1) {
        _posts[index] = updated;
      }

      final filteredIndex = _filteredPosts.indexWhere((e) => e.id == id);
      if (filteredIndex != -1) {
        _filteredPosts[filteredIndex] = updated;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Не вдалося оновити пост';
      notifyListeners();
      return false;
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await repository.deletePost(id);
      _posts.removeWhere((e) => e.id == id);
      _filteredPosts.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Не вдалося видалити пост';
      notifyListeners();
    }
  }
}