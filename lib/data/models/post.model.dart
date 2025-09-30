import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String? description;
  final String userId;
  final String userName;
  final DateTime dateTime;
  final List<String> assetsUrls;
  final int likes;
  final int comments;
  final List<String> commentsIds;
  final List<String> likedUsersIds;
  final bool isApproved;
  final bool isReel;

  PostModel({
    required this.id,
    required this.description,
    required this.userId,
    required this.userName,
    required this.dateTime,
    required this.assetsUrls,
    required this.likes,
    required this.comments,
    required this.commentsIds,
    required this.likedUsersIds,
    required this.isApproved,
    required this.isReel,
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
      assetsUrls: List<String>.from(json['assetsUrls'] ?? []),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      commentsIds: List<String>.from(json['commentsIds'] ?? []),
      likedUsersIds: List<String>.from(json['likedUsersIds'] ?? []),
      isApproved: json['isApproved'] as bool,
      isReel: json['isReel'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'userId': userId,
      'userName': userName,
      'dateTime': dateTime,
      'assetsUrls': assetsUrls,
      'likes': likes,
      'comments': comments,
      'commentsIds': commentsIds,
      'likedUsersIds': likedUsersIds,
      'isApproved': isApproved,
      'isReel': isReel,
    };
  }
}
