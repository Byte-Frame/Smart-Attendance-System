import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key, required String adminName}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _systemTimer;

  // Admin Data
  final String adminName = 'Admin';
  final String institutionName = 'Attendly';
  int totalStudents = 1247;
  int totalFaculty = 89;
  int activeSessions = 23;
  double systemHealth = 98.5;
  String? selectedTimetableTemplate; // For dropdown selection
  // Time slots for scheduling
  final List<String> timeSlots = [
    '9:00-10:30', '11:00-12:30', '2:00-3:30', '4:00-5:30'
  ];



  // Predefined timetables for demo
  List<Map<String, dynamic>> generatedTimetables = [];
  // REPLACE THIS ENTIRE SECTION:
  final List<Map<String, dynamic>> timetableTemplates = [
    {'name': 'Computer Science - B.Tech 2nd Year'},
    {'name': 'Electrical Engineering - B.Tech 3rd Year'},
    {'name': 'Mechanical Engineering - B.Tech 1st Year'},
    {'name': 'Business Administration - MBA 1st Year'},
  ];


  // Dynamic data that updates
  List<Map<String, dynamic>> recentActivities = [
    {'action': 'CRITICAL: Server overload detected', 'user': 'System Monitor', 'time': '1 min ago', 'type': 'critical'},
    {'action': 'WARNING: Low storage space (85%)', 'user': 'System', 'time': '3 min ago', 'type': 'warning'},
    {'action': 'New student enrolled', 'user': 'Aarav Sharma', 'time': '5 min ago', 'type': 'info'},
    {'action': 'Faculty schedule updated', 'user': 'Dr. Johnson', 'time': '8 min ago', 'type': 'info'},
    {'action': 'ERROR: Database connection timeout', 'user': 'System', 'time': '12 min ago', 'type': 'error'},
    {'action': 'Attendance marked', 'user': 'Multiple Students', 'time': '15 min ago', 'type': 'info'},
  ];

  final List<Map<String, dynamic>> facultyList = [
    {'name': 'Dr. Johnson', 'department': 'Computer Science', 'subjects': 3, 'status': 'Active', 'rating': '4.8'},
    {'name': 'Prof. Smith', 'department': 'Mathematics', 'subjects': 2, 'status': 'Active', 'rating': '4.6'},
    {'name': 'Dr. Brown', 'department': 'Physics', 'subjects': 4, 'status': 'On Leave', 'rating': '4.7'},
    {'name': 'Prof. Davis', 'department': 'English', 'subjects': 2, 'status': 'Active', 'rating': '4.9'},
  ];

  final List<Map<String, dynamic>> studentMetrics = [
    {'department': 'Computer Science', 'enrolled': 425, 'attendance': 94, 'performance': 87},
    {'department': 'Mathematics', 'enrolled': 312, 'attendance': 91, 'performance': 85},
    {'department': 'Physics', 'enrolled': 298, 'attendance': 89, 'performance': 83},
    {'department': 'English', 'enrolled': 212, 'attendance': 96, 'performance': 92},
  ];

  final Map<String, List<Map<String, dynamic>>> systemAnalytics = {
    'performance': [
      {'metric': 'Server Uptime', 'value': '99.9', 'unit': '%', 'status': 'excellent'},
      {'metric': 'Response Time', 'value': '120', 'unit': 'ms', 'status': 'good'},
      {'metric': 'Database Health', 'value': '98.2', 'unit': '%', 'status': 'excellent'},
      {'metric': 'Storage Usage', 'value': '85.3', 'unit': '%', 'status': 'warning'},
      {'metric': 'Memory Usage', 'value': '92.1', 'unit': '%', 'status': 'critical'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _startSystemMonitoring();
  }

  void _startSystemMonitoring() {
    _systemTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateSystemMetrics();
    });
  }

  void _updateSystemMetrics() {
    setState(() {
      systemHealth = 95.0 + Random().nextDouble() * 5.0;
      activeSessions = 20 + Random().nextInt(10);
    });
  }

  // REPLACE THE ENTIRE _generateTimetable METHOD:
  void _generateTimetable() {
    if (selectedTimetableTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a class to generate timetable'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      // Generate dynamic schedule
      final dynamicSchedule = _generateDynamicSchedule(selectedTimetableTemplate!);

      // Check if this timetable already exists and update it
      final existingIndex = generatedTimetables.indexWhere(
            (generated) => generated['name'] == selectedTimetableTemplate,
      );

      if (existingIndex != -1) {
        // Update existing timetable with NEW data
        generatedTimetables[existingIndex] = {
          'name': selectedTimetableTemplate,
          'schedule': dynamicSchedule, // NEW dynamic schedule
          'generatedAt': DateTime.now(),
          'id': generatedTimetables[existingIndex]['id'], // Keep same ID
          'version': (generatedTimetables[existingIndex]['version'] ?? 1) + 1, // Increment version
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Timetable updated: $selectedTimetableTemplate (v${generatedTimetables[existingIndex]['version']})'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      } else {
        // Add new timetable
        generatedTimetables.add({
          'name': selectedTimetableTemplate,
          'schedule': dynamicSchedule, // NEW dynamic schedule
          'generatedAt': DateTime.now(),
          'id': 'TT${generatedTimetables.length + 1}',
          'version': 1,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New timetable generated: $selectedTimetableTemplate'),
            backgroundColor: const Color(0xFF2F4156),
          ),
        );
      }
    });
  }



  @override
  void dispose() {
    _systemTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Responsive helper methods
  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return 16.0;
    if (screenWidth < 900) return 20.0;
    return 24.0;
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth < 600 ? 0.9 : screenWidth < 900 ? 1.0 : 1.1;
    return baseFontSize * scaleFactor;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF2F4156); // Navy
      case 'good':
        return const Color(0xFF567C8D); // Teal
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'critical':
        return Colors.red;
      case 'error':
        return Colors.red.shade700;
      case 'warning':
        return Colors.orange;
      case 'info':
        return const Color(0xFF567C8D);
      default:
        return const Color(0xFF567C8D);
    }
  }

  // ADD THIS NEW METHOD:
  Map<String, dynamic> _generateDynamicSchedule(String templateName) {
    final Random random = Random();
    final Map<String, dynamic> schedule = {};
    final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    // Different subject pools based on template name
    List<String> subjects = [];

    if (templateName.contains('Computer Science')) {
      subjects = [
        'Data Structures', 'Algorithms', 'Database Systems', 'Web Development',
        'Machine Learning', 'Software Engineering', 'Computer Networks', 'AI',
        'Programming Lab', 'Project Work', 'Mobile Development', 'Cloud Computing',
        'Cybersecurity', 'Game Development', 'IoT Systems', 'Blockchain'
      ];
    } else if (templateName.contains('Electrical')) {
      subjects = [
        'Power Systems', 'Control Systems', 'Electronics', 'Microprocessors',
        'Communication Systems', 'VLSI Design', 'Renewable Energy', 'Robotics',
        'Control Lab', 'Power Lab', 'Industrial Automation', 'Smart Systems',
        'Electric Vehicles', 'Smart Grids', 'Signal Processing', 'Electromagnetics'
      ];
    } else if (templateName.contains('Mechanical')) {
      subjects = [
        'Thermodynamics', 'Fluid Mechanics', 'Machine Design', 'Manufacturing',
        'Heat Transfer', 'Automotive', 'Robotics', 'Quality Control',
        'Workshop', 'CAD/CAM', 'Materials Science', 'Industrial Engineering',
        'Mechatronics', 'Aerospace', 'Production Planning', 'Tribology'
      ];
    } else if (templateName.contains('Business')) {
      subjects = [
        'Strategic Management', 'Financial Management', 'Marketing', 'Operations',
        'HR Management', 'Business Analytics', 'Digital Marketing', 'Leadership',
        'Case Studies', 'Entrepreneurship', 'International Business', 'Ethics',
        'Supply Chain', 'Innovation Management', 'Project Management', 'E-Commerce'
      ];
    }

    // Generate random schedule for each day
    for (String day in days) {
      final List<String> daySchedule = [];
      final shuffledSubjects = [...subjects]..shuffle(random);
      final classesPerDay = 3 + random.nextInt(2); // 3-4 classes per day

      for (int i = 0; i < classesPerDay && i < timeSlots.length; i++) {
        final subject = shuffledSubjects[i % shuffledSubjects.length];
        final timeSlot = timeSlots[i];
        daySchedule.add('$subject ($timeSlot)');
      }

      schedule[day] = daySchedule;
    }

    return schedule;
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'critical':
        return Icons.error;
      case 'error':
        return Icons.error_outline;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  // Timetable Grid Builder Method - NEW
  Widget _buildTimetableGrid(Map<String, dynamic> schedule, BuildContext context) {
    const primaryColor = Color(0xFF2F4156);
    const textColor = Color(0xFF2F4156);

    // Days and colors for better visual distinction
    final List<Color> dayColors = [
      const Color(0xFF2196F3), // Monday - Blue
      const Color(0xFF4CAF50), // Tuesday - Green
      const Color(0xFFFF9800), // Wednesday - Orange
      const Color(0xFF9C27B0), // Thursday - Purple
      const Color(0xFFE91E63), // Friday - Pink
    ];

    final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Schedule',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),

        // Grid layout for timetable
        ...days.asMap().entries.map((entry) {
          int index = entry.key;
          String day = entry.value;
          List<dynamic> subjects = schedule[day] ?? [];
          Color dayColor = dayColors[index % dayColors.length];

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  dayColor.withOpacity(0.1),
                  dayColor.withOpacity(0.05),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: dayColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day header
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: dayColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 14),
                            fontWeight: FontWeight.bold,
                            color: dayColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: dayColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${subjects.length} classes',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 10),
                            color: dayColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Subjects for the day
                  if (subjects.isNotEmpty)
                    ...subjects.map<Widget>((subject) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: dayColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: dayColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subject.toString(),
                              style: TextStyle(
                                fontSize: _getResponsiveFontSize(context, 12),
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    )).toList()
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'No classes scheduled',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(context, 12),
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Color palette - keeping original scheme
    const primaryColor = Color(0xFF2F4156); // Navy
    const secondaryColor = Color(0xFF567C8D); // Teal
    const accentColor = Color(0xFFC8D9E6); // Sky Blue
    const backgroundColor = Color(0xFFF5EFEB); // Beige
    const cardColor = Color(0xFFFFFFFF); // White
    const textColor = Color(0xFF2F4156); // Navy

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final responsivePadding = _getResponsivePadding(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Fixed overflow with smooth scrolling
          child: Padding(
            padding: EdgeInsets.all(responsivePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Enhanced Admin Header
                Container(
                  width: double.infinity, // Fix overflow
                  padding: EdgeInsets.all(responsivePadding),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.admin_panel_settings,
                          color: primaryColor,
                          size: isSmallScreen ? 28 : 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              institutionName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontSize: _getResponsiveFontSize(context, 22),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Admin Portal',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: _getResponsiveFontSize(context, 14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // System health indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: systemHealth > 95 ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              systemHealth > 95 ? Icons.check_circle : Icons.warning,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'System ${systemHealth.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsivePadding),

                // Welcome Section
                Text(
                  'Welcome back, $adminName!',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 28),
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your institution, monitor systems, and oversee academic operations',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: _getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: responsivePadding),

                // Enhanced Quick Stats Cards
                // Enhanced Quick Stats Cards - FIXED OVERFLOW
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: isSmallScreen
                      ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildEnhancedStatCard(
                              'Students',
                              totalStudents.toString(),
                              Icons.school,
                              primaryColor,
                              context,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildEnhancedStatCard(
                              'Faculty',
                              totalFaculty.toString(),
                              Icons.people,
                              secondaryColor,
                              context,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildEnhancedStatCard(
                              'Sessions',
                              activeSessions.toString(),
                              Icons.wifi,
                              const Color(0xFF4CAF50),
                              context,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildEnhancedStatCard(
                              'Health',
                              '${systemHealth.toStringAsFixed(1)}%',
                              Icons.health_and_safety,
                              systemHealth > 95 ? const Color(0xFF4CAF50) : Colors.orange,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedStatCard(
                          'Total Students',
                          totalStudents.toString(),
                          Icons.school,
                          primaryColor,
                          context,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildEnhancedStatCard(
                          'Faculty Members',
                          totalFaculty.toString(),
                          Icons.people,
                          secondaryColor,
                          context,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildEnhancedStatCard(
                          'Active Sessions',
                          activeSessions.toString(),
                          Icons.wifi,
                          const Color(0xFF4CAF50),
                          context,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildEnhancedStatCard(
                          'System Health',
                          '${systemHealth.toStringAsFixed(1)}%',
                          Icons.health_and_safety,
                          systemHealth > 95 ? const Color(0xFF4CAF50) : Colors.orange,
                          context,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: responsivePadding),

                // Timetable Generator Section - FIXED WITH GRID LAYOUT
                // Timetable Generator Section - UPDATED WITH DROPDOWN
                Card(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - (responsivePadding * 2),
                    ),
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.schedule,
                          color: primaryColor,
                          size: isSmallScreen ? 20 : 24,
                        ),
                      ),
                      title: Text(
                        'Timetable Generator',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _getResponsiveFontSize(context, 16),
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        '${generatedTimetables.length} timetables generated',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(context, 12),
                          color: secondaryColor,
                        ),
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.all(responsivePadding),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.05),
                                secondaryColor.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Class Selection Dropdown
                              Text(
                                'Select Class/Course:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _getResponsiveFontSize(context, 14),
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: accentColor),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: selectedTimetableTemplate,
                                  decoration: const InputDecoration(
                                    hintText: 'Choose a class to generate timetable',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  items: timetableTemplates.map((template) {
                                    return DropdownMenuItem<String>(
                                      value: template['name'],
                                      child: Text(
                                        template['name'],
                                        style: TextStyle(
                                          fontSize: _getResponsiveFontSize(context, 14),
                                          color: textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTimetableTemplate = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Generate Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _generateTimetable,
                                  icon: const Icon(Icons.auto_awesome, size: 20),
                                  label: Text(
                                    selectedTimetableTemplate != null &&
                                        generatedTimetables.any((t) => t['name'] == selectedTimetableTemplate)
                                        ? 'Update Selected Timetable'
                                        : 'Generate New Timetable',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedTimetableTemplate != null &&
                                        generatedTimetables.any((t) => t['name'] == selectedTimetableTemplate)
                                        ? const Color(0xFF4CAF50) // Green for update
                                        : primaryColor, // Navy for new
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),

                              // Clear All Button
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  onPressed: generatedTimetables.isNotEmpty ? () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Clear All Timetables'),
                                        content: const Text('Are you sure you want to delete all generated timetables?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                generatedTimetables.clear();
                                                selectedTimetableTemplate = null;
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('All timetables cleared'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  } : null,
                                  icon: const Icon(Icons.clear_all, size: 16),
                                  label: const Text('Clear All Timetables'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Generated Timetables List
                              if (generatedTimetables.isNotEmpty) ...[
                                Text(
                                  'Generated Timetables:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _getResponsiveFontSize(context, 14),
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...generatedTimetables.map((timetable) => Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: accentColor),
                                  ),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            timetable['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: _getResponsiveFontSize(context, 14),
                                              color: textColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        if (timetable['version'] != null && timetable['version'] > 1)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF4CAF50),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'v${timetable['version']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'ID: ${timetable['id']} | Generated: ${DateTime.now().difference(timetable['generatedAt']).inMinutes} min ago',
                                      style: TextStyle(
                                        fontSize: _getResponsiveFontSize(context, 11),
                                        color: secondaryColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    trailing: PopupMenuButton(
                                      icon: Icon(Icons.more_vert, color: primaryColor, size: 20),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'update',
                                          child: const Row(
                                            children: [
                                              Icon(Icons.refresh, size: 16),
                                              SizedBox(width: 8),
                                              Text('Update'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: const Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.red, size: 16),
                                              SizedBox(width: 8),
                                              Text('Delete', style: TextStyle(color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'update') {
                                          setState(() {
                                            selectedTimetableTemplate = timetable['name'];
                                          });
                                          _generateTimetable();
                                        } else if (value == 'delete') {
                                          setState(() {
                                            generatedTimetables.removeWhere((t) => t['id'] == timetable['id']);
                                            if (selectedTimetableTemplate == timetable['name']) {
                                              selectedTimetableTemplate = null;
                                            }
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Deleted: ${timetable['name']}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        child: _buildTimetableGrid(timetable['schedule'], context),
                                      ),
                                    ],
                                  ),
                                )).toList(),
                              ] else
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No timetables generated yet',
                                        style: TextStyle(
                                          fontSize: _getResponsiveFontSize(context, 14),
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Select a class and click Generate',
                                        style: TextStyle(
                                          fontSize: _getResponsiveFontSize(context, 12),
                                          color: Colors.grey[500],
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
                  ),
                ),

                SizedBox(height: responsivePadding),

                // System Health Analytics - Enhanced with better contrast
                Card(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.analytics,
                        color: primaryColor,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    title: Text(
                      'System Health Analytics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _getResponsiveFontSize(context, 16),
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      'Real-time system performance monitoring',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 12),
                        color: secondaryColor,
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity, // Fix overflow
                        padding: EdgeInsets.all(responsivePadding),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.05),
                              secondaryColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Performance Metrics',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _getResponsiveFontSize(context, 16),
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Generating detailed report...'),
                                        backgroundColor: primaryColor,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.download, size: 16),
                                  label: const Text('Export'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(80, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...systemAnalytics['performance']!.map((metric) => Container(
                              width: double.infinity, // Fix overflow
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                  left: BorderSide(
                                    color: _getStatusColor(metric['status']),
                                    width: 4,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(metric['status']).withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          metric['metric'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: _getResponsiveFontSize(context, 14),
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${metric['value']}${metric['unit']}',
                                          style: TextStyle(
                                            color: _getStatusColor(metric['status']),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _getResponsiveFontSize(context, 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(metric['status']).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      metric['status'].toUpperCase(),
                                      style: TextStyle(
                                        color: _getStatusColor(metric['status']),
                                        fontSize: _getResponsiveFontSize(context, 11),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsivePadding),

                // Recent Activities with Red Alerts - Enhanced
                Card(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: Colors.red,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    title: Text(
                      'System Alerts & Activities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _getResponsiveFontSize(context, 16),
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      '${recentActivities.where((a) => a['type'] == 'critical' || a['type'] == 'error').length} critical alerts',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 12),
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity, // Fix overflow
                        padding: EdgeInsets.all(responsivePadding),
                        child: Column(
                          children: recentActivities.map((activity) => Container(
                            width: double.infinity, // Fix overflow
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                left: BorderSide(
                                  color: _getActivityColor(activity['type']),
                                  width: 4,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getActivityColor(activity['type']).withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _getActivityColor(activity['type']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getActivityIcon(activity['type']),
                                    color: _getActivityColor(activity['type']),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity['action'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _getResponsiveFontSize(context, 14),
                                          color: activity['type'] == 'critical' || activity['type'] == 'error'
                                              ? Colors.red
                                              : textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${activity['user']} • ${activity['time']}',
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: _getResponsiveFontSize(context, 12),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (activity['type'] == 'critical' || activity['type'] == 'error')
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      activity['type'].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsivePadding),

                // Faculty Management - Enhanced
                Card(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.people_alt,
                        color: primaryColor,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    title: Text(
                      'Faculty Management',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _getResponsiveFontSize(context, 16),
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      '${facultyList.length} faculty members',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 12),
                        color: secondaryColor,
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity, // Fix overflow
                        padding: EdgeInsets.all(responsivePadding),
                        child: Column(
                          children: [
                            // Search and Add Faculty
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: accentColor),
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search faculty...',
                                        hintStyle: TextStyle(color: secondaryColor),
                                        prefixIcon: Icon(Icons.search, color: secondaryColor),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Add Faculty - Coming Soon!'),
                                        backgroundColor: primaryColor,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Add'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...facultyList.map((faculty) => Container(
                              width: double.infinity, // Fix overflow
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: accentColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: faculty['status'] == 'Active' ? primaryColor : Colors.grey,
                                  radius: 24,
                                  child: Text(
                                    faculty['name'].split(' ').map((n) => n[0]).join(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  faculty['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _getResponsiveFontSize(context, 16),
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      '${faculty['department']} • ${faculty['subjects']} subjects',
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: _getResponsiveFontSize(context, 13),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 16, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          faculty['rating'],
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: _getResponsiveFontSize(context, 13),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: faculty['status'] == 'Active' ? primaryColor : Colors.grey,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            faculty['status'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert, color: primaryColor),
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(value: 'edit', child: Text('Edit Profile')),
                                    PopupMenuItem(value: 'schedule', child: Text('View Schedule')),
                                    PopupMenuItem(value: 'performance', child: Text('Performance')),
                                  ],
                                  onSelected: (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$value - Coming Soon!'),
                                        backgroundColor: primaryColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsivePadding),

                // Student Analytics - Enhanced
                Card(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: primaryColor,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    title: Text(
                      'Student Analytics & Performance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _getResponsiveFontSize(context, 16),
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      'Comprehensive academic performance insights',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 12),
                        color: secondaryColor,
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity, // Fix overflow
                        padding: EdgeInsets.all(responsivePadding),
                        child: Column(
                          children: studentMetrics.map((dept) => Container(
                            width: double.infinity, // Fix overflow
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.1),
                                  secondaryColor.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: accentColor.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dept['department'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _getResponsiveFontSize(context, 18),
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildMetricColumn(
                                      'Enrolled',
                                      dept['enrolled'].toString(),
                                      primaryColor,
                                      context,
                                    ),
                                    _buildMetricColumn(
                                      'Attendance',
                                      '${dept['attendance']}%',
                                      dept['attendance'] > 90 ? const Color(0xFF4CAF50) : Colors.orange,
                                      context,
                                    ),
                                    _buildMetricColumn(
                                      'Performance',
                                      '${dept['performance']}%',
                                      dept['performance'] > 85 ? const Color(0xFF4CAF50) : Colors.orange,
                                      context,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsivePadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildEnhancedStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      BuildContext context,
      ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: isSmallScreen ? 24 : 28,
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(
              value,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, isSmallScreen ? 18 : 22),
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, isSmallScreen ? 11 : 13),
                color: const Color(0xFF567C8D),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMetricColumn(String title, String value, Color color, BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 12),
              color: const Color(0xFF567C8D),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
