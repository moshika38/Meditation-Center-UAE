class UserModel {
  final String? id;
  final String name;
  final String email;
  final String uid;
  final String profileImage;
  final bool isAdmin; 
  final bool isVerify; 
  final bool allowNotification; 

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.uid,
    required this.profileImage,
    required this.isAdmin,
    required this.isVerify,
    required this.allowNotification,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      uid: json['uid'] as String,
      profileImage: json['profileImage'] as String,
      isAdmin: json['isAdmin'] as bool,
      isVerify: json['isVerify'] as bool,
      allowNotification: json['allowNotification'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'uid': uid,
      'profileImage': profileImage,
      'isAdmin': isAdmin,
      'isVerify': isVerify,
      'allowNotification': allowNotification,
    };
  }
}
