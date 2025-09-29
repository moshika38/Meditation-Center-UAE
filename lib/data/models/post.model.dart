import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String? description;
  final String userId;
  final String userName;
  final DateTime dateTime;
  final List<String> images;
  final int likes;
  final int comments;
  final List<String> comment_ids;
  final List<String> likedUsersIds;
  final bool isApproved;

  PostModel({
    required this.id,
    required this.description,
    required this.userId,
    required this.userName,
    required this.dateTime,
    required this.images,
    required this.likes,
    required this.comments,
    required this.comment_ids,
    required this.likedUsersIds,
    required this.isApproved,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      dateTime: (json['dateTime'] as dynamic) is DateTime
          ? json['dateTime'] as DateTime
          : (json['dateTime'] as Timestamp).toDate(),
      images: List<String>.from(json['images'] ?? []),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      comment_ids: List<String>.from(json['comments_id'] ?? []),
      likedUsersIds: List<String>.from(json['likedUsersIds'] ?? []),
      isApproved: json['isApproved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'userId': userId,
      'userName': userName,
      'dateTime': dateTime,
      'images': images,
      'likes': likes,
      'comments': comments,
      'comments_id': comment_ids,
      'likedUsersIds': likedUsersIds,
      'isApproved': isApproved,
    };
  }
}
