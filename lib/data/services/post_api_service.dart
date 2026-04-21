import 'package:dio/dio.dart';
import '../models/post_model.dart';

class PostApiService {
  final Dio dio;

  PostApiService(this.dio);

  Future<List<PostModel>> getPosts() async {
    final response = await dio.get('/posts');
    final data = response.data as List;
    return data.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<PostModel> createPost(PostModel post) async {
    final response = await dio.post('/posts', data: post.toJson());
    return PostModel.fromJson(response.data);
  }

  Future<void> deletePost(int id) async {
    await dio.delete('/posts/$id');
  }
}