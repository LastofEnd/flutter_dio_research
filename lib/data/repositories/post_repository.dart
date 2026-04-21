import '../models/post_model.dart';
import '../services/post_api_service.dart';

class PostRepository {
  final PostApiService apiService;

  PostRepository(this.apiService);

  Future<List<PostModel>> getPosts() {
    return apiService.getPosts();
  }

  Future<PostModel> createPost(PostModel post) {
    return apiService.createPost(post);
  }

  Future<void> deletePost(int id) {
    return apiService.deletePost(id);
  }
}