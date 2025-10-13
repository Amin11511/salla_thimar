class CategoryResponse {
  final List<Category> data;
  final Links links;
  final Meta meta;
  final String status;
  final String message;

  CategoryResponse({
    this.data = const [],
    required this.links,
    required this.meta,
    this.status = 'success',
    this.message = '',
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
          ?.toList() ?? [],
      links: Links.fromJson(json['links'] as Map<String, dynamic>),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'success',
      message: json['message'] as String? ?? '',
    );
  }
}

class Category {
  final int id;
  final String name;
  final String description;
  final String media;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.media,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String media;
    if (json['media'] is Map<String, dynamic>) {
      media = (json['media'] as Map<String, dynamic>)['url'] as String? ?? 'https://via.placeholder.com/150';
    } else {
      media = json['media'] as String? ?? 'https://via.placeholder.com/150';
    }

    return Category(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      media: media,
    );
  }
}

class Links {
  final String first;
  final String last;
  final String? prev;
  final String? next;

  Links({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'] as String? ?? '',
      last: json['last'] as String? ?? '',
      prev: json['prev'] as String?,
      next: json['next'] as String?,
    );
  }
}

class Meta {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<Link> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] as int? ?? 1,
      from: json['from'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
      links: (json['links'] as List<dynamic>?)
          ?.map((item) => Link.fromJson(item as Map<String, dynamic>))
          ?.toList() ?? [],
      path: json['path'] as String? ?? '',
      perPage: json['per_page'] as int? ?? 0,
      to: json['to'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'] as String?,
      label: json['label'] as String? ?? '',
      active: json['active'] as bool? ?? false,
    );
  }
}