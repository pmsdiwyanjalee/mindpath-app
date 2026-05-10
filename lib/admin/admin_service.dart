// Admin Service Layer
// Handles all admin-related business logic and data operations

import 'admin_data_models.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();

  factory AdminService() {
    return _instance;
  }

  AdminService._internal();

  // Sample admin users database
  final List<AdminUser> _adminUsers = [
    AdminUser(
      id: 'admin001',
      email: 'superadmin@mindpath.com',
      password: 'SuperAdmin@2024', // Note: In production, use proper hashing
      fullName: 'Super Administrator',
      role: 'super_admin',
      createdAt: DateTime(2024, 1, 1),
      isActive: true,
      permissions: [
        'manage_users',
        'manage_counselors',
        'manage_resources',
        'manage_admins',
        'view_analytics',
        'manage_support_tickets',
        'system_settings'
      ],
    ),
    AdminUser(
      id: 'admin002',
      email: 'admin@mindpath.com',
      password: 'Admin@2024',
      fullName: 'Administrator',
      role: 'admin',
      createdAt: DateTime(2024, 1, 15),
      isActive: true,
      permissions: [
        'manage_users',
        'manage_counselors',
        'manage_resources',
        'view_analytics',
        'manage_support_tickets'
      ],
    ),
  ];

  // Sample app users database
  final List<AppUser> _appUsers = [
    AppUser(
      id: 'user001',
      email: 'john@example.com',
      fullName: 'John Doe',
      registrationDate: DateTime(2024, 1, 1),
      isActive: true,
      status: 'active',
      daysSober: 47,
      recoveryPhase: 'Early',
      streakDays: 47,
      assignedCounselors: ['counselor001'],
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      totalSessions: 12,
    ),
    AppUser(
      id: 'user002',
      email: 'jane@example.com',
      fullName: 'Jane Smith',
      registrationDate: DateTime(2024, 2, 15),
      isActive: true,
      status: 'active',
      daysSober: 30,
      recoveryPhase: 'Early',
      streakDays: 30,
      assignedCounselors: ['counselor002'],
      lastLogin: DateTime.now().subtract(const Duration(hours: 5)),
      totalSessions: 8,
    ),
  ];

  // Sample counselors database
  final List<Counselor> _counselors = [
    Counselor(
      id: 'counselor001',
      email: 'counselor1@mindpath.com',
      fullName: 'Dr. Sarah Williams',
      specialization: 'Addiction Recovery',
      qualification: 'PhD in Clinical Psychology',
      joinDate: DateTime(2023, 6, 1),
      isVerified: true,
      isActive: true,
      clientCount: 15,
      rating: 4.8,
      totalSessions: 250,
      assignedClients: ['user001'],
      availability: 'Available',
      contactNumber: '+1-555-0101',
    ),
    Counselor(
      id: 'counselor002',
      email: 'counselor2@mindpath.com',
      fullName: 'Dr. Michael Johnson',
      specialization: 'Substance Abuse Treatment',
      qualification: 'Master\'s in Social Work',
      joinDate: DateTime(2023, 7, 15),
      isVerified: true,
      isActive: true,
      clientCount: 12,
      rating: 4.7,
      totalSessions: 200,
      assignedClients: ['user002'],
      availability: 'Available',
      contactNumber: '+1-555-0102',
    ),
  ];

  // Sample resources database
  final List<Resource> _resources = [
    Resource(
      id: 'resource001',
      title: 'Understanding Cravings',
      description: 'Learn what triggers cravings and how to manage them.',
      type: 'article',
      category: 'Coping Strategies',
      source: 'SAMHSA',
      sourceType: 'Government Health Agency',
      createdAt: DateTime(2024, 1, 5),
      updatedAt: DateTime(2024, 1, 5),
      isPublished: true,
      viewCount: 1250,
      rating: 4.6,
      createdBy: 'admin001',
    ),
    Resource(
      id: 'resource002',
      title: 'Building Healthy Habits',
      description:
          'Practical tips for creating routines that support recovery.',
      type: 'guide',
      category: 'Lifestyle',
      source: 'American Psychological Association',
      sourceType: 'Professional Organization',
      createdAt: DateTime(2024, 1, 10),
      updatedAt: DateTime(2024, 1, 15),
      isPublished: true,
      viewCount: 890,
      rating: 4.5,
      createdBy: 'admin001',
    ),
  ];

  // Sample support tickets database
  final List<SupportTicket> _supportTickets = [
    SupportTicket(
      id: 'ticket001',
      userId: 'user001',
      subject: 'Cannot log in to account',
      description: 'I am unable to log into my account. Error message appears.',
      status: 'open',
      priority: 'high',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      resolvedAt: null,
      assignedTo: 'admin001',
      comments: [],
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // ADMIN AUTHENTICATION
  // ─────────────────────────────────────────────────────────────────────────

  Future<AdminUser?> loginAdmin(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    try {
      final user = _adminUsers.firstWhere(
        (u) => u.email == email && u.password == password && u.isActive,
      );
      return user;
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ADMIN MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<AdminUser>> getAllAdmins() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _adminUsers;
  }

  Future<AdminUser?> getAdminById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _adminUsers.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> createAdmin(AdminUser admin) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      if (_adminUsers.any((a) => a.email == admin.email)) {
        return false;
      }
      _adminUsers.add(admin);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateAdmin(AdminUser admin) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _adminUsers.indexWhere((a) => a.id == admin.id);
      if (index == -1) return false;
      _adminUsers[index] = admin;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteAdmin(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _adminUsers.removeWhere((a) => a.id == id);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // APP USER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<AppUser>> getAllAppUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _appUsers;
  }

  Future<AppUser?> getAppUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _appUsers.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> suspendUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _appUsers.indexWhere((u) => u.id == userId);
      if (index == -1) return false;
      final user = _appUsers[index];
      _appUsers[index] = AppUser(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        registrationDate: user.registrationDate,
        isActive: false,
        status: 'suspended',
        daysSober: user.daysSober,
        recoveryPhase: user.recoveryPhase,
        streakDays: user.streakDays,
        assignedCounselors: user.assignedCounselors,
        lastLogin: user.lastLogin,
        totalSessions: user.totalSessions,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> activateUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _appUsers.indexWhere((u) => u.id == userId);
      if (index == -1) return false;
      final user = _appUsers[index];
      _appUsers[index] = AppUser(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        registrationDate: user.registrationDate,
        isActive: true,
        status: 'active',
        daysSober: user.daysSober,
        recoveryPhase: user.recoveryPhase,
        streakDays: user.streakDays,
        assignedCounselors: user.assignedCounselors,
        lastLogin: user.lastLogin,
        totalSessions: user.totalSessions,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COUNSELOR MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<Counselor>> getAllCounselors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _counselors;
  }

  Future<Counselor?> getCounselorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _counselors.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> verifyCounselor(String counselorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _counselors.indexWhere((c) => c.id == counselorId);
      if (index == -1) return false;
      final counselor = _counselors[index];
      _counselors[index] = Counselor(
        id: counselor.id,
        email: counselor.email,
        fullName: counselor.fullName,
        specialization: counselor.specialization,
        qualification: counselor.qualification,
        joinDate: counselor.joinDate,
        isVerified: true,
        isActive: counselor.isActive,
        clientCount: counselor.clientCount,
        rating: counselor.rating,
        totalSessions: counselor.totalSessions,
        assignedClients: counselor.assignedClients,
        availability: counselor.availability,
        contactNumber: counselor.contactNumber,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deactivateCounselor(String counselorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _counselors.indexWhere((c) => c.id == counselorId);
      if (index == -1) return false;
      final counselor = _counselors[index];
      _counselors[index] = Counselor(
        id: counselor.id,
        email: counselor.email,
        fullName: counselor.fullName,
        specialization: counselor.specialization,
        qualification: counselor.qualification,
        joinDate: counselor.joinDate,
        isVerified: counselor.isVerified,
        isActive: false,
        clientCount: counselor.clientCount,
        rating: counselor.rating,
        totalSessions: counselor.totalSessions,
        assignedClients: counselor.assignedClients,
        availability: 'Not Available',
        contactNumber: counselor.contactNumber,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RESOURCE MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<Resource>> getAllResources() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _resources;
  }

  Future<Resource?> getResourceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _resources.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> createResource(Resource resource) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _resources.add(resource);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateResource(Resource resource) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _resources.indexWhere((r) => r.id == resource.id);
      if (index == -1) return false;
      _resources[index] = resource;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteResource(String resourceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _resources.removeWhere((r) => r.id == resourceId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> publishResource(String resourceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _resources.indexWhere((r) => r.id == resourceId);
      if (index == -1) return false;
      final resource = _resources[index];
      _resources[index] = Resource(
        id: resource.id,
        title: resource.title,
        description: resource.description,
        type: resource.type,
        category: resource.category,
        source: resource.source,
        sourceType: resource.sourceType,
        createdAt: resource.createdAt,
        updatedAt: DateTime.now(),
        isPublished: true,
        viewCount: resource.viewCount,
        rating: resource.rating,
        createdBy: resource.createdBy,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ANALYTICS
  // ─────────────────────────────────────────────────────────────────────────

  Future<Analytics> getAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final activeUsers =
        _appUsers.where((u) => u.isActive && u.status == 'active').length;
    final totalSessions =
        _appUsers.fold(0, (sum, user) => sum + user.totalSessions);
    final averageDaysSoberValue = _appUsers.isNotEmpty
        ? _appUsers.fold(0.0, (sum, user) => sum + user.daysSober) /
            _appUsers.length
        : 0.0;
    final newRegistrations = _appUsers
        .where((u) => u.registrationDate
            .isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .length;

    return Analytics(
      totalUsers: _appUsers.length,
      activeUsers: activeUsers,
      totalSessions: totalSessions,
      appointmentsScheduled: 45,
      averageDaysSober: averageDaysSoberValue,
      newRegistrations: newRegistrations,
      activeCounselors: _counselors.where((c) => c.isActive).length,
      appRating: 4.7,
      generatedAt: DateTime.now(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SUPPORT TICKETS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<SupportTicket>> getAllSupportTickets() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _supportTickets;
  }

  Future<bool> updateTicketStatus(String ticketId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _supportTickets.indexWhere((t) => t.id == ticketId);
      if (index == -1) return false;
      final ticket = _supportTickets[index];
      _supportTickets[index] = SupportTicket(
        id: ticket.id,
        userId: ticket.userId,
        subject: ticket.subject,
        description: ticket.description,
        status: newStatus,
        priority: ticket.priority,
        createdAt: ticket.createdAt,
        resolvedAt: newStatus == 'resolved' || newStatus == 'closed'
            ? DateTime.now()
            : null,
        assignedTo: ticket.assignedTo,
        comments: ticket.comments,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addCommentToTicket(String ticketId, String comment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _supportTickets.indexWhere((t) => t.id == ticketId);
      if (index == -1) return false;
      final ticket = _supportTickets[index];
      final updatedComments = [...ticket.comments, comment];
      _supportTickets[index] = SupportTicket(
        id: ticket.id,
        userId: ticket.userId,
        subject: ticket.subject,
        description: ticket.description,
        status: ticket.status,
        priority: ticket.priority,
        createdAt: ticket.createdAt,
        resolvedAt: ticket.resolvedAt,
        assignedTo: ticket.assignedTo,
        comments: updatedComments,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STATISTICS HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  int getTotalUsers() => _appUsers.length;
  int getActiveUsers() => _appUsers.where((u) => u.isActive).length;
  int getSuspendedUsers() =>
      _appUsers.where((u) => u.status == 'suspended').length;
  int getTotalCounselors() => _counselors.length;
  int getVerifiedCounselors() => _counselors.where((c) => c.isVerified).length;
  int getTotalResources() => _resources.length;
  int getOpenTickets() =>
      _supportTickets.where((t) => t.status == 'open').length;
}
