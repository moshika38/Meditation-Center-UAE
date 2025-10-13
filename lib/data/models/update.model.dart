class AppUpdateModel {
  final String appVersion;
  final String appLink;

  AppUpdateModel({required this.appVersion, required this.appLink});

  factory AppUpdateModel.fromMap(Map<String, dynamic> data) {
    return AppUpdateModel(
      appVersion: data['appVersion'] ?? 'Unknown',
      appLink: data['appLink'] ?? 'No Link',
    );
  }
}
