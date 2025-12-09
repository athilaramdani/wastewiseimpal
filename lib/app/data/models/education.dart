class Education {
  final int id;
  final String title;
  final String? image;
  final String body;
  final DateTime? createdAt;

  Education({
    required this.id,
    required this.title,
    this.image,
    required this.body,
    this.createdAt,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['education_id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'],
      body: json['body'] ?? '',
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at']) 
        : null,
    );
  }
}
