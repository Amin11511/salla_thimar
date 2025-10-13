class SliderData {
  final int id;
  final String media;

  SliderData({required this.id, required this.media});

  factory SliderData.fromJson(Map<String, dynamic> json) {
    String media;
    if (json['media'] is Map<String, dynamic>) {
      media = (json['media'] as Map<String, dynamic>)['url'] as String? ?? 'https://via.placeholder.com/150';
    } else {
      media = json['media'] as String? ?? 'https://via.placeholder.com/150';
    }

    return SliderData(
      id: json['id'] as int? ?? 0,
      media: media,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media': media,
    };
  }
}