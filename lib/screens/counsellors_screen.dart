import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CounsellorsScreen extends StatefulWidget {
  const CounsellorsScreen({Key? key}) : super(key: key);

  @override
  State<CounsellorsScreen> createState() => _CounsellorsScreenState();
}

class _CounsellorsScreenState extends State<CounsellorsScreen> {
  // List of counsellors (mutable)
  List<Map<String, dynamic>> _counsellors = [];
  List<Map<String, dynamic>> _filteredCounsellors = [];
  
  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Form controllers for add/edit
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  final _educationController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _ratingController = TextEditingController();
  final _reviewsController = TextEditingController();
  
  List<String> _specialties = [];
  List<String> _languages = [];
  
  String _selectedSpecialty = '';
  String _selectedLanguage = '';
  Color _selectedColor = const Color(0xFF7CA982);
  IconData _selectedIcon = Icons.person_rounded;
  
  // Current editing counsellor ID
  int? _editingId;
  
  // Available colors for counsellors
  final List<Color> _availableColors = [
    const Color(0xFF7CA982),
    const Color(0xFF4A9EAF),
    const Color(0xFFE8926A),
    const Color(0xFF9B8EC4),
    const Color(0xFFF4C542),
    const Color(0xFFD94F4F),
  ];
  
  // Available icons
  final List<IconData> _availableIcons = [
    Icons.person_rounded,
    Icons.medical_services_rounded,
    Icons.psychology_rounded,
    Icons.health_and_safety_rounded,
    Icons.emoji_emotions_rounded,
    Icons.spa_rounded,
  ];

  // Colors
  static const Color _bg = Color(0xFFF6F4F0);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _textDark = Color(0xFF2D3142);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE8E5E0);
  static const Color _sage = Color(0xFF7CA982);
  static const Color _sageLight = Color(0xFFD4EAD7);
  static const Color _teal = Color(0xFF4A9EAF);
  static const Color _tealLight = Color(0xFFD6EEF3);
  static const Color _peach = Color(0xFFE8926A);
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _lavender = Color(0xFF9B8EC4);
  static const Color _lavLight = Color(0xFFEAE6F5);

  @override
  void initState() {
    super.initState();
    _loadCounsellors();
    _searchController.addListener(_filterCounsellors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _titleController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _educationController.dispose();
    _certificationsController.dispose();
    _availabilityController.dispose();
    _ratingController.dispose();
    _reviewsController.dispose();
    super.dispose();
  }

  // Save counsellors to SharedPreferences
  Future<void> _saveCounsellors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> counsellorsToSave = [];
      
      for (var counsellor in _counsellors) {
        // Convert Color to integer for storage
        Map<String, dynamic> copy = Map.from(counsellor);
        copy['color'] = (counsellor['color'] as Color).value;
        copy['imageIcon'] = _iconToIndex(counsellor['imageIcon']);
        counsellorsToSave.add(copy);
      }
      
      final String encodedData = json.encode(counsellorsToSave);
      await prefs.setString('counsellors_data', encodedData);
      debugPrint('Counsellors saved successfully: ${_counsellors.length} counsellors');
    } catch (e) {
      debugPrint('Error saving counsellors: $e');
    }
  }

  // Load counsellors from SharedPreferences
  Future<void> _loadCounsellors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('counsellors_data');
      
      if (encodedData != null) {
        List<dynamic> decodedList = json.decode(encodedData);
        _counsellors = decodedList.map((item) {
          Map<String, dynamic> counsellor = Map<String, dynamic>.from(item);
          
          // Convert integer back to Color
          counsellor['color'] = Color(counsellor['color']);
          
          // Convert icon index back to IconData
          counsellor['imageIcon'] = _indexToIcon(counsellor['imageIcon']);
          
          // FIX: Convert specialties from List<dynamic> to List<String>
          if (counsellor['specialties'] != null) {
            counsellor['specialties'] = List<String>.from(counsellor['specialties']);
          }
          
          // FIX: Convert languages from List<dynamic> to List<String>
          if (counsellor['languages'] != null) {
            counsellor['languages'] = List<String>.from(counsellor['languages']);
          }
          
          return counsellor;
        }).toList();
        debugPrint('Counsellors loaded successfully: ${_counsellors.length} counsellors');
      } else {
        // Initialize with default counsellors if no saved data
        _initializeDefaultCounsellors();
        await _saveCounsellors();
      }
    } catch (e) {
      debugPrint('Error loading counsellors: $e');
      _initializeDefaultCounsellors();
    }
    
    setState(() {
      _filteredCounsellors = List.from(_counsellors);
    });
  }

  // Convert IconData to index for storage
  int _iconToIndex(IconData icon) {
    for (int i = 0; i < _availableIcons.length; i++) {
      if (icon == _availableIcons[i]) {
        return i;
      }
    }
    return 0; // Default to first icon
  }

  // Convert index back to IconData
  IconData _indexToIcon(int index) {
    if (index >= 0 && index < _availableIcons.length) {
      return _availableIcons[index];
    }
    return Icons.person_rounded; // Default icon
  }

  void _initializeDefaultCounsellors() {
    _counsellors = [
      {
        'id': 1,
        'name': 'Dr. Sarah Johnson',
        'title': 'Clinical Psychologist & Addiction Specialist',
        'specialties': ['Substance Abuse', 'Anxiety', 'Trauma'],
        'experience': '12+ years',
        'languages': ['English', 'Spanish'],
        'bio': 'Dr. Johnson specializes in evidence-based treatments for addiction recovery, including CBT and motivational interviewing. She has helped hundreds of individuals achieve lasting sobriety.',
        'education': 'Ph.D. in Clinical Psychology - Stanford University',
        'certifications': 'Certified Addiction Specialist (CAS), Licensed Clinical Psychologist',
        'availability': 'Mon, Wed, Fri: 9 AM - 5 PM',
        'rating': 4.9,
        'reviews': 128,
        'imageIcon': Icons.person_rounded,
        'color': const Color(0xFF7CA982),
      },
      {
        'id': 2,
        'name': 'Michael Chen, LCSW',
        'title': 'Licensed Clinical Social Worker',
        'specialties': ['Dual Diagnosis', 'Family Therapy', 'Relapse Prevention'],
        'experience': '8+ years',
        'languages': ['English', 'Mandarin'],
        'bio': 'Michael brings a compassionate, client-centered approach to recovery. He specializes in working with individuals facing co-occurring mental health conditions.',
        'education': 'Master of Social Work - University of Michigan',
        'certifications': 'Licensed Clinical Social Worker (LCSW), Certified Clinical Trauma Professional',
        'availability': 'Tue, Thu: 10 AM - 7 PM, Sat: 9 AM - 1 PM',
        'rating': 4.8,
        'reviews': 94,
        'imageIcon': Icons.person_rounded,
        'color': const Color(0xFF4A9EAF),
      },
      {
        'id': 3,
        'name': 'Dr. Emily Rodriguez',
        'title': 'Psychiatrist & Addiction Medicine',
        'specialties': ['Medication Management', 'Co-occurring Disorders', 'Crisis Intervention'],
        'experience': '15+ years',
        'languages': ['English', 'Portuguese'],
        'bio': 'Dr. Rodriguez is board-certified in both Psychiatry and Addiction Medicine. She offers medication-assisted treatment alongside therapeutic support.',
        'education': 'M.D. - Johns Hopkins University School of Medicine',
        'certifications': 'Board Certified in Psychiatry and Addiction Medicine',
        'availability': 'Mon-Thu: 8 AM - 4 PM',
        'rating': 4.95,
        'reviews': 203,
        'imageIcon': Icons.medical_services_rounded,
        'color': const Color(0xFFE8926A),
      },
      {
        'id': 4,
        'name': 'David Okonkwo, MA',
        'title': 'Certified Addiction Counselor',
        'specialties': ['Recovery Coaching', 'Life Skills', 'Motivation Enhancement'],
        'experience': '10+ years',
        'languages': ['English', 'Igbo'],
        'bio': 'David is a person in long-term recovery who brings lived experience to his counseling approach. He specializes in helping clients build meaningful lives in sobriety.',
        'education': 'M.A. in Counseling Psychology - Loyola University',
        'certifications': 'Certified Alcohol and Drug Counselor (CADC), Peer Recovery Specialist',
        'availability': 'Mon-Fri: 12 PM - 8 PM',
        'rating': 4.85,
        'reviews': 156,
        'imageIcon': Icons.person_rounded,
        'color': const Color(0xFF9B8EC4),
      },
      {
        'id': 5,
        'name': 'Dr. Lisa Thompson',
        'title': 'Clinical Psychologist',
        'specialties': ['Cognitive Behavioral Therapy', 'Mindfulness', 'Stress Management'],
        'experience': '9+ years',
        'languages': ['English'],
        'bio': 'Dr. Thompson integrates mindfulness-based approaches with traditional CBT to help clients develop healthier coping mechanisms and reduce relapse risk.',
        'education': 'Psy.D. in Clinical Psychology - Rutgers University',
        'certifications': 'Licensed Psychologist, Certified Mindfulness-Based Stress Reduction Instructor',
        'availability': 'Tue, Wed, Thu: 9 AM - 6 PM',
        'rating': 4.9,
        'reviews': 112,
        'imageIcon': Icons.person_rounded,
        'color': const Color(0xFFF4C542),
      },
      {
        'id': 6,
        'name': 'Rachel Green, LPC',
        'title': 'Licensed Professional Counselor',
        'specialties': ['Young Adult Recovery', 'Relationship Issues', 'Self-Esteem'],
        'experience': '7+ years',
        'languages': ['English', 'French'],
        'bio': 'Rachel specializes in working with young adults navigating recovery while managing career, relationships, and identity development.',
        'education': 'M.Ed. in Counseling - University of Pennsylvania',
        'certifications': 'Licensed Professional Counselor (LPC), Certified in TEAM-CBT',
        'availability': 'Mon, Wed, Fri: 11 AM - 7 PM',
        'rating': 4.75,
        'reviews': 87,
        'imageIcon': Icons.person_rounded,
        'color': const Color(0xFF7CA982),
      },
    ];
  }

  void _filterCounsellors() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredCounsellors = List.from(_counsellors);
      } else {
        _filteredCounsellors = _counsellors.where((counsellor) {
          return counsellor['name'].toLowerCase().contains(_searchQuery) ||
              counsellor['title'].toLowerCase().contains(_searchQuery) ||
              (counsellor['specialties'] as List<String>).any((s) => s.toLowerCase().contains(_searchQuery));
        }).toList();
      }
    });
  }

  void _addCounsellor() {
    _resetForm();
    _editingId = null;
    _showCounsellorFormDialog();
  }

  void _editCounsellor(Map<String, dynamic> counsellor) {
    _editingId = counsellor['id'];
    _nameController.text = counsellor['name'];
    _titleController.text = counsellor['title'];
    _experienceController.text = counsellor['experience'];
    _bioController.text = counsellor['bio'];
    _educationController.text = counsellor['education'];
    _certificationsController.text = counsellor['certifications'];
    _availabilityController.text = counsellor['availability'];
    _ratingController.text = counsellor['rating'].toString();
    _reviewsController.text = counsellor['reviews'].toString();
    _specialties = List<String>.from(counsellor['specialties']);
    _languages = List<String>.from(counsellor['languages']);
    _selectedColor = counsellor['color'];
    _selectedIcon = counsellor['imageIcon'];
    _showCounsellorFormDialog();
  }

  Future<void> _deleteCounsellor(Map<String, dynamic> counsellor) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Counsellor'),
        content: Text('Are you sure you want to delete ${counsellor['name']}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _counsellors.removeWhere((c) => c['id'] == counsellor['id']);
                _filterCounsellors();
              });
              await _saveCounsellors(); // Save after deletion
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Counsellor deleted successfully'),
                  backgroundColor: _peach,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: _peach)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCounsellor() async {
    if (_formKey.currentState!.validate()) {
      final newCounsellor = {
        'id': _editingId ?? DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text,
        'title': _titleController.text,
        'specialties': List<String>.from(_specialties), // Ensure it's List<String>
        'experience': _experienceController.text,
        'languages': List<String>.from(_languages), // Ensure it's List<String>
        'bio': _bioController.text,
        'education': _educationController.text,
        'certifications': _certificationsController.text,
        'availability': _availabilityController.text,
        'rating': double.parse(_ratingController.text),
        'reviews': int.parse(_reviewsController.text),
        'imageIcon': _selectedIcon,
        'color': _selectedColor,
      };

      setState(() {
        if (_editingId == null) {
          _counsellors.add(newCounsellor);
        } else {
          final index = _counsellors.indexWhere((c) => c['id'] == _editingId);
          if (index != -1) {
            _counsellors[index] = newCounsellor;
          }
        }
        _filterCounsellors();
      });

      await _saveCounsellors(); // Save after add/edit

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingId == null ? 'Counsellor added successfully' : 'Counsellor updated successfully'),
          backgroundColor: _sage,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _titleController.clear();
    _experienceController.clear();
    _bioController.clear();
    _educationController.clear();
    _certificationsController.clear();
    _availabilityController.clear();
    _ratingController.clear();
    _reviewsController.clear();
    _specialties = [];
    _languages = [];
    _selectedColor = _availableColors[0];
    _selectedIcon = Icons.person_rounded;
  }

  void _addSpecialty() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Specialty'),
        content: TextField(
          onSubmitted: (value) {
            if (value.isNotEmpty && !_specialties.contains(value)) {
              setState(() => _specialties.add(value));
            }
            Navigator.pop(ctx);
          },
          decoration: const InputDecoration(
            hintText: 'Enter specialty',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addLanguage() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Language'),
        content: TextField(
          onSubmitted: (value) {
            if (value.isNotEmpty && !_languages.contains(value)) {
              setState(() => _languages.add(value));
            }
            Navigator.pop(ctx);
          },
          decoration: const InputDecoration(
            hintText: 'Enter language',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _removeSpecialty(String specialty) {
    setState(() {
      _specialties.remove(specialty);
    });
  }

  void _removeLanguage(String language) {
    setState(() {
      _languages.remove(language);
    });
  }

  void _showCounsellorFormDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.95,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) => Container(
              decoration: const BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        color: _border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.all(20),
                        children: [
                          Text(
                            _editingId == null ? 'Add New Counsellor' : 'Edit Counsellor',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Name
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Title
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Professional Title *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.work_outline),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Experience
                          TextFormField(
                            controller: _experienceController,
                            decoration: const InputDecoration(
                              labelText: 'Experience (e.g., 10+ years) *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.timer_outlined),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Rating
                          TextFormField(
                            controller: _ratingController,
                            decoration: const InputDecoration(
                              labelText: 'Rating (0-5) *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.star_outline),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v?.isEmpty ?? true) return 'Required';
                              final rating = double.tryParse(v!);
                              if (rating == null || rating < 0 || rating > 5) {
                                return 'Enter rating between 0-5';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Reviews
                          TextFormField(
                            controller: _reviewsController,
                            decoration: const InputDecoration(
                              labelText: 'Number of Reviews *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.reviews_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Specialties
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Specialties *', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  ..._specialties.map((s) => Chip(
                                    label: Text(s),
                                    onDeleted: () => _removeSpecialty(s),
                                    deleteIcon: const Icon(Icons.close, size: 16),
                                  )),
                                  ActionChip(
                                    label: const Text('+ Add'),
                                    onPressed: _addSpecialty,
                                    backgroundColor: _tealLight,
                                  ),
                                ],
                              ),
                              if (_specialties.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Add at least one specialty',
                                    style: TextStyle(color: _peach, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Languages
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Languages *', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  ..._languages.map((l) => Chip(
                                    label: Text(l),
                                    onDeleted: () => _removeLanguage(l),
                                    deleteIcon: const Icon(Icons.close, size: 16),
                                  )),
                                  ActionChip(
                                    label: const Text('+ Add'),
                                    onPressed: _addLanguage,
                                    backgroundColor: _tealLight,
                                  ),
                                ],
                              ),
                              if (_languages.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Add at least one language',
                                    style: TextStyle(color: _peach, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Bio
                          TextFormField(
                            controller: _bioController,
                            decoration: const InputDecoration(
                              labelText: 'Biography *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.description_outlined),
                            ),
                            maxLines: 3,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Education
                          TextFormField(
                            controller: _educationController,
                            decoration: const InputDecoration(
                              labelText: 'Education *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.school_outlined),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Certifications
                          TextFormField(
                            controller: _certificationsController,
                            decoration: const InputDecoration(
                              labelText: 'Certifications *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.verified_outlined),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Availability
                          TextFormField(
                            controller: _availabilityController,
                            decoration: const InputDecoration(
                              labelText: 'Availability *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Color Selection
                          const Text('Profile Color', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _availableColors.map((color) {
                              return GestureDetector(
                                onTap: () => setSheetState(() => _selectedColor = color),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _selectedColor == color ? _textDark : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          
                          // Icon Selection
                          const Text('Profile Icon', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _availableIcons.map((icon) {
                              return GestureDetector(
                                onTap: () => setSheetState(() => _selectedIcon = icon),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _selectedIcon == icon ? _selectedColor : _bg,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _selectedIcon == icon ? _selectedColor : _border,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(icon, color: _selectedIcon == icon ? Colors.white : _textMid),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          
                          // Save Button
                          ElevatedButton(
                            onPressed: () {
                              if (_specialties.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please add at least one specialty'),
                                    backgroundColor: _peach,
                                  ),
                                );
                                return;
                              }
                              if (_languages.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please add at least one language'),
                                    backgroundColor: _peach,
                                  ),
                                );
                                return;
                              }
                              _saveCounsellor();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _sage,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Save Counsellor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCounsellorCard(Map<String, dynamic> counsellor) {
    // Ensure specialties and languages are List<String>
    final specialties = List<String>.from(counsellor['specialties'] ?? []);
    final languages = List<String>.from(counsellor['languages'] ?? []);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (counsellor['color'] as Color).withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: counsellor['color'],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (counsellor['color'] as Color).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    counsellor['imageIcon'],
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        counsellor['name'],
                        style: const TextStyle(
                          color: _textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        counsellor['title'],
                        style: TextStyle(
                          color: counsellor['color'],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF4C542), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${counsellor['rating']}',
                            style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${counsellor['reviews']} reviews)',
                            style: const TextStyle(
                              color: _textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.work_rounded,
                      counsellor['experience'],
                      _teal,
                      _tealLight,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.schedule_rounded,
                      '${counsellor['availability'].split(',').first}...',
                      _sage,
                      _sageLight,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: specialties.map((specialty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: Text(
                        specialty,
                        style: const TextStyle(
                          color: _textMid,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.language_rounded, color: _textLight, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      languages.join(' · '),
                      style: const TextStyle(color: _textMid, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  counsellor['bio'],
                  style: const TextStyle(
                    color: _textMid,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Divider(color: _border, height: 1),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showCounsellorDetails(context, counsellor),
                          icon: const Icon(Icons.info_rounded, size: 18),
                          label: const Text('View Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _teal,
                            side: BorderSide(color: _teal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _editCounsellor(counsellor),
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _sage,
                            side: BorderSide(color: _sage),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _deleteCounsellor(counsellor),
                          icon: const Icon(Icons.delete_rounded, size: 18),
                          label: const Text('Delete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _peach,
                            side: BorderSide(color: _peach),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color, Color lightColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCounsellorDetails(BuildContext context, Map<String, dynamic> counsellor) {
    final specialties = List<String>.from(counsellor['specialties'] ?? []);
    final languages = List<String>.from(counsellor['languages'] ?? []);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: counsellor['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            counsellor['imageIcon'],
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                counsellor['name'],
                                style: const TextStyle(
                                  color: _textDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                counsellor['title'],
                                style: TextStyle(
                                  color: counsellor['color'],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Color(0xFFF4C542), size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${counsellor['rating']}',
                                    style: const TextStyle(
                                      color: _textDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${counsellor['reviews']} reviews)',
                                    style: const TextStyle(
                                      color: _textLight,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailSection('Education', Icons.school_rounded, counsellor['education'], _sage),
                    const SizedBox(height: 16),
                    _buildDetailSection('Certifications', Icons.verified_rounded, counsellor['certifications'], _teal),
                    const SizedBox(height: 16),
                    _buildDetailSection('Availability', Icons.schedule_rounded, counsellor['availability'], _peach),
                    const SizedBox(height: 16),
                    _buildDetailSection('Languages', Icons.language_rounded, languages.join(' · '), _lavender),
                    const SizedBox(height: 16),
                    _buildDetailSection('Biography', Icons.description_rounded, counsellor['bio'], _textMid, isLongText: true),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _editCounsellor(counsellor);
                            },
                            icon: const Icon(Icons.edit_rounded),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _sage,
                              side: BorderSide(color: _sage),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('Close'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    String content,
    Color iconColor, {
    bool isLongText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: _textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            content,
            style: TextStyle(
              color: _textMid,
              fontSize: isLongText ? 14 : 13,
              height: isLongText ? 1.5 : 1.4,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          'Our Counsellors',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w700),
        ),
        backgroundColor: _surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: _textMid),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CounsellorSearchDelegate(_counsellors),
              ).then((result) {
                if (result != null) {
                  setState(() {
                    _filteredCounsellors = [result];
                  });
                } else {
                  _filterCounsellors();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: _sage),
            onPressed: _addCounsellor,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, title, or specialty...',
                prefixIcon: const Icon(Icons.search_rounded, color: _textLight),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _filterCounsellors();
                        },
                      )
                    : null,
                filled: true,
                fillColor: _surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _sage),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filteredCounsellors.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: _textLight),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty ? 'No counsellors added yet' : 'No counsellors found',
                    style: TextStyle(color: _textMid, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (_searchQuery.isEmpty)
                    ElevatedButton(
                      onPressed: _addCounsellor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _sage,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Your First Counsellor'),
                    ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCounsellors.length,
              itemBuilder: (context, index) {
                return _buildCounsellorCard(_filteredCounsellors[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCounsellor,
        backgroundColor: _sage,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class CounsellorSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  final List<Map<String, dynamic>> counsellors;

  CounsellorSearchDelegate(this.counsellors);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = counsellors.where((counsellor) {
      return counsellor['name'].toLowerCase().contains(query.toLowerCase()) ||
          counsellor['title'].toLowerCase().contains(query.toLowerCase()) ||
          (counsellor['specialties'] as List<String>).any((s) => s.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final counsellor = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: counsellor['color'],
            child: Icon(counsellor['imageIcon'], color: Colors.white),
          ),
          title: Text(counsellor['name']),
          subtitle: Text(counsellor['title']),
          onTap: () {
            close(context, counsellor);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = counsellors.where((counsellor) {
      return counsellor['name'].toLowerCase().contains(query.toLowerCase()) ||
          counsellor['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final counsellor = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: counsellor['color'],
            child: Icon(counsellor['imageIcon'], color: Colors.white),
          ),
          title: Text(counsellor['name']),
          subtitle: Text(counsellor['title']),
          onTap: () {
            query = counsellor['name'];
            showResults(context);
          },
        );
      },
    );
  }
}