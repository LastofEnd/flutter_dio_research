class PostModel {
  final int? userId;
  final int? id;
  final String title;
  final String body;

  PostModel({
    this.userId,
    this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'] as int?,
      id: json['id'] as int?,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}