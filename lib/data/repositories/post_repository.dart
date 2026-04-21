import '../models/post_model.dart';
import '../services/post_api_service.dart';

class PostRepository {
  final PostApiService apiService;

  PostRepository(this.apiService);

  Future<List<PostModel>> getPosts() {
    return apiService.getPosts();
  }

  Future<PostModel> getPost(int id) {
    return apiService.getPost(id);
  }

  Future<PostModel> createPost(PostModel post) {
    return apiService.createPost(post);
  }

  Future<PostModel> updatePost(int id, PostModel post) {
    return apiService.updatePost(id, post);
  }

  Future<void> deletePost(int id) {
    return apiService.deletePost(id);
  }
}