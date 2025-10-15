class NotificationsResponse {
  final NotificationData data;
  final Links links;
  final Meta meta;
  final String status;
  final String message;

  NotificationsResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.status,
    required this.message,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      data: NotificationData.fromJson(json['data'] ?? {}),
      links: Links.fromJson(json['links'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class NotificationData {
  final int unreadNotificationsCount;
  final List<NotificationItem> notifications;

  NotificationData({
    required this.unreadNotificationsCount,
    required this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    var notifications = (json['notifications'] as List<dynamic>?)
        ?.map((e) => NotificationItem.fromJson(e))
        .toList() ??
        [];
    return NotificationData(
      unreadNotificationsCount: json['unreadnotifications_count'] ?? 0,
      notifications: notifications,
    );
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class Links {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class Meta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final List<Link> links;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  Meta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    var links = (json['links'] as List<dynamic>?)
        ?.map((e) => Link.fromJson(e))
        .toList() ??
        [];
    return Meta(
      currentPage: json['current_page'] ?? 1,
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      links: links,
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({this.url, required this.label, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }
}

class NotificationResponse {
  final String status;
  final String message;
  final dynamic data;

  NotificationResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}