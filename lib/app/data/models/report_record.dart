class ReportRecord {
  const ReportRecord({
    this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.createdAt,
  });

  final String? id;
  final String title;
  final String category;
  final String location;
  final String description;
  final String imageUrl;
  final DateTime? createdAt;

  factory ReportRecord.fromMap(Map<String, dynamic> map) {
    DateTime? created;
    final createdRaw = map['created_at'];
    if (createdRaw is String && createdRaw.isNotEmpty) {
      created = DateTime.tryParse(createdRaw);
    } else if (createdRaw is DateTime) {
      created = createdRaw;
    }

    return ReportRecord(
      id: map['id']?.toString(),
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '-',
      location: map['location']?.toString() ?? '-',
      description: map['description']?.toString() ?? '-',
      imageUrl: map['image_url']?.toString() ?? '',
      createdAt: created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'location': location,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get createdAtLabel {
    final value = createdAt?.toLocal();
    if (value == null) return '-';
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
