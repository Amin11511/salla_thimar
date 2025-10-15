class RateModel {
  final List<RateData>? data;
  final RateLinks links;
  final RateMeta meta;
  final String status;
  final String message;

  RateModel({
    this.data,
    required this.links,
    required this.meta,
    required this.status,
    required this.message,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      data: (json['data'] as List<dynamic>?)?.map((item) => RateData.fromJson(item as Map<String, dynamic>)).toList() ?? [],
      links: RateLinks.fromJson(json['links'] as Map<String, dynamic>),
      meta: RateMeta.fromJson(json['meta'] as Map<String, dynamic>),
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }
}

class RateData {
  final int value;
  final String comment;
  final String clientName;
  final String clientImage;

  RateData({
    required this.value,
    required this.comment,
    required this.clientName,
    required this.clientImage,
  });

  factory RateData.fromJson(Map<String, dynamic> json) {
    return RateData(
      value: json['value'] as int,
      comment: json['comment'] as String,
      clientName: json['client_name'] as String,
      clientImage: json['client_image'] as String,
    );
  }
}

class RateLinks {
  final String first;
  final String last;
  final String? prev;
  final String? next;

  RateLinks({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory RateLinks.fromJson(Map<String, dynamic> json) {
    return RateLinks(
      first: json['first'] as String,
      last: json['last'] as String,
      prev: json['prev'] as String?,
      next: json['next'] as String?,
    );
  }
}

class RateMeta {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<RateMetaLink> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  RateMeta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory RateMeta.fromJson(Map<String, dynamic> json) {
    return RateMeta(
      currentPage: json['current_page'] as int,
      from: json['from'] as int,
      lastPage: json['last_page'] as int,
      links: (json['links'] as List<dynamic>)
          .map((item) => RateMetaLink.fromJson(item as Map<String, dynamic>))
          .toList(),
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      to: json['to'] as int,
      total: json['total'] as int,
    );
  }
}

class RateMetaLink {
  final String? url;
  final String label;
  final bool active;

  RateMetaLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory RateMetaLink.fromJson(Map<String, dynamic> json) {
    return RateMetaLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );
  }
}