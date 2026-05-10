// Admin Data Models
// This file contains all data models used in the admin system

class AdminUser {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final String role; // 'super_admin', 'admin', 'moderator'
  final DateTime createdAt;
  final bool isActive;
  final List<String> permissions;

  AdminUser({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    required this.createdAt,
    required this.isActive,
    required this.permissions,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? 'admin',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      isActive: json['isActive'] ?? true,
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'permissions': permissions,
    };
  }
}

class AppUser {
  final String id;
  final String email;
  final String fullName;
  final DateTime registrationDate;
  final bool isActive;
  final String status; // 'active', 'inactive', 'suspended', 'archived'
  final int daysSober;
  final String recoveryPhase;
  final int streakDays;
  final List<String> assignedCounselors;
  final DateTime lastLogin;
  final int totalSessions;

  AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.registrationDate,
    required this.isActive,
    required this.status,
    required this.daysSober,
    required this.recoveryPhase,
    required this.streakDays,
    required this.assignedCounselors,
    required this.lastLogin,
    required this.totalSessions,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      registrationDate:
          DateTime.parse(json['registrationDate'] ?? DateTime.now().toString()),
      isActive: json['isActive'] ?? true,
      status: json['status'] ?? 'active',
      daysSober: json['daysSober'] ?? 0,
      recoveryPhase: json['recoveryPhase'] ?? 'Early',
      streakDays: json['streakDays'] ?? 0,
      assignedCounselors: List<String>.from(json['assignedCounselors'] ?? []),
      lastLogin: DateTime.parse(json['lastLogin'] ?? DateTime.now().toString()),
      totalSessions: json['totalSessions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'registrationDate': registrationDate.toIso8601String(),
      'isActive': isActive,
      'status': status,
      'daysSober': daysSober,
      'recoveryPhase': recoveryPhase,
      'streakDays': streakDays,
      'assignedCounselors': assignedCounselors,
      'lastLogin': lastLogin.toIso8601String(),
      'totalSessions': totalSessions,
    };
  }
}

class Counselor {
  final String id;
  final String email;
  final String fullName;
  final String specialization;
  final String qualification;
  final DateTime joinDate;
  final bool isVerified;
  final bool isActive;
  final int clientCount;
  final double rating;
  final int totalSessions;
  final List<String> assignedClients;
  final String availability;
  final String contactNumber;

  Counselor({
    required this.id,
    required this.email,
    required this.fullName,
    required this.specialization,
    required this.qualification,
    required this.joinDate,
    required this.isVerified,
    required this.isActive,
    required this.clientCount,
    required this.rating,
    required this.totalSessions,
    required this.assignedClients,
    required this.availability,
    required this.contactNumber,
  });

  factory Counselor.fromJson(Map<String, dynamic> json) {
    return Counselor(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toString()),
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      clientCount: json['clientCount'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      totalSessions: json['totalSessions'] ?? 0,
      assignedClients: List<String>.from(json['assignedClients'] ?? []),
      availability: json['availability'] ?? 'Available',
      contactNumber: json['contactNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'specialization': specialization,
      'qualification': qualification,
      'joinDate': joinDate.toIso8601String(),
      'isVerified': isVerified,
      'isActive': isActive,
      'clientCount': clientCount,
      'rating': rating,
      'totalSessions': totalSessions,
      'assignedClients': assignedClients,
      'availability': availability,
      'contactNumber': contactNumber,
    };
  }
}

class Resource {
  final String id;
  final String title;
  final String description;
  final String type; // 'article', 'tool', 'guide'
  final String category;
  final String source;
  final String sourceType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final int viewCount;
  final double rating;
  final String createdBy;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.source,
    required this.sourceType,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublished,
    required this.viewCount,
    required this.rating,
    required this.createdBy,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'article',
      category: json['category'] ?? '',
      source: json['source'] ?? '',
      sourceType: json['sourceType'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      isPublished: json['isPublished'] ?? true,
      viewCount: json['viewCount'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      createdBy: json['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'category': category,
      'source': source,
      'sourceType': sourceType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublished': isPublished,
      'viewCount': viewCount,
      'rating': rating,
      'createdBy': createdBy,
    };
  }
}

class Analytics {
  final int totalUsers;
  final int activeUsers;
  final int totalSessions;
  final int appointmentsScheduled;
  final double averageDaysSober;
  final int newRegistrations;
  final int activeCounselors;
  final double appRating;
  final DateTime generatedAt;

  Analytics({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalSessions,
    required this.appointmentsScheduled,
    required this.averageDaysSober,
    required this.newRegistrations,
    required this.activeCounselors,
    required this.appRating,
    required this.generatedAt,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      totalUsers: json['totalUsers'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      totalSessions: json['totalSessions'] ?? 0,
      appointmentsScheduled: json['appointmentsScheduled'] ?? 0,
      averageDaysSober: (json['averageDaysSober'] ?? 0).toDouble(),
      newRegistrations: json['newRegistrations'] ?? 0,
      activeCounselors: json['activeCounselors'] ?? 0,
      appRating: (json['appRating'] ?? 0).toDouble(),
      generatedAt:
          DateTime.parse(json['generatedAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'totalSessions': totalSessions,
      'appointmentsScheduled': appointmentsScheduled,
      'averageDaysSober': averageDaysSober,
      'newRegistrations': newRegistrations,
      'activeCounselors': activeCounselors,
      'appRating': appRating,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}

class SupportTicket {
  final String id;
  final String userId;
  final String subject;
  final String description;
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final String priority; // 'low', 'medium', 'high', 'critical'
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? assignedTo;
  final List<String> comments;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.resolvedAt,
    required this.assignedTo,
    required this.comments,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      assignedTo: json['assignedTo'],
      comments: List<String>.from(json['comments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subject': subject,
      'description': description,
      'status': status,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'assignedTo': assignedTo,
      'comments': comments,
    };
  }
}
