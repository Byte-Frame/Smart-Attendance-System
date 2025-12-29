import 'package:flutter/material.dart';
import 'package:demo/Pages/Loginpage.dart';

class StudentDashboard extends StatefulWidget {
  final dynamic studentName;
  final Map<String, dynamic>? userPreferences;

  const StudentDashboard({
    Key? key,
    required this.studentName,
    this.userPreferences,
  }) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late List<Map<String, dynamic>> weeklyTasks;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generatePersonalizedTasks();
  }

  void _generatePersonalizedTasks() {
    List<Map<String, dynamic>> baseTasks = [];

    if (widget.userPreferences != null) {
      List<String> interests = List<String>.from(
        widget.userPreferences!['interests'] ?? [],
      );
      List<String> skills = List<String>.from(
        widget.userPreferences!['skills'] ?? [],
      );
      List<String> learningStyles = List<String>.from(
        widget.userPreferences!['learningStyles'] ?? [],
      );

      // Generate tasks based on interests
      if (interests.contains('Science & Technology')) {
        baseTasks.addAll([
          {
            'task': 'Complete IoT Lab Experiment',
            'subject': 'Computer Science',
            'due': 'Oct 5',
            'completed': false,
            'type': 'practical',
          },
          {
            'task': 'Research AI Applications',
            'subject': 'Technology',
            'due': 'Oct 8',
            'completed': false,
            'type': 'research',
          },
        ]);
      }

      if (interests.contains('Mathematics & Logic')) {
        baseTasks.addAll([
          {
            'task': 'Advanced Calculus Problem Set',
            'subject': 'Matrices and Calculus',
            'due': 'Oct 3',
            'completed': false,
            'type': 'practice',
          },
          {
            'task': 'Logic Puzzle Challenge',
            'subject': 'Mathematics',
            'due': 'Oct 6',
            'completed': false,
            'type': 'challenge',
          },
        ]);
      }

      if (interests.contains('Arts & Literature')) {
        baseTasks.addAll([
          {
            'task': 'Creative Writing Portfolio',
            'subject': 'English',
            'due': 'Oct 7',
            'completed': false,
            'type': 'creative',
          },
          {
            'task': 'Poetry Analysis Assignment',
            'subject': 'Literature',
            'due': 'Oct 4',
            'completed': false,
            'type': 'analysis',
          },
        ]);
      }

      if (interests.contains('Environmental Studies')) {
        baseTasks.addAll([
          {
            'task': 'Sustainability Project Proposal',
            'subject': 'Environmental Science',
            'due': 'Oct 10',
            'completed': false,
            'type': 'project',
          },
          {
            'task': 'Climate Change Research',
            'subject': 'Environmental Studies',
            'due': 'Oct 9',
            'completed': false,
            'type': 'research',
          },
        ]);
      }

      // Generate skill-based tasks
      if (skills.contains('Critical Thinking')) {
        baseTasks.add({
          'task': 'Case Study Analysis',
          'subject': 'Critical Thinking',
          'due': 'Oct 5',
          'completed': false,
          'type': 'analysis',
        });
      }

      if (skills.contains('Creative Expression')) {
        baseTasks.add({
          'task': 'Digital Art Project',
          'subject': 'Creative Arts',
          'due': 'Oct 8',
          'completed': false,
          'type': 'creative',
        });
      }

      if (skills.contains('Leadership')) {
        baseTasks.add({
          'task': 'Team Leadership Workshop',
          'subject': 'Leadership Development',
          'due': 'Oct 6',
          'completed': false,
          'type': 'workshop',
        });
      }

      // Add learning style specific tasks
      if (learningStyles.contains('Project-Based Learning')) {
        baseTasks.add({
          'task': 'Interdisciplinary Group Project',
          'subject': 'Multidisciplinary',
          'due': 'Oct 12',
          'completed': false,
          'type': 'project',
        });
      }

      if (learningStyles.contains('Visual Learning')) {
        baseTasks.add({
          'task': 'Create Infographic Presentation',
          'subject': 'Visual Communication',
          'due': 'Oct 7',
          'completed': false,
          'type': 'visual',
        });
      }

      // Add some completed tasks for demonstration
      baseTasks.addAll([
        {
          'task': 'NEP 2020 Orientation Module',
          'subject': 'Educational Policy',
          'due': 'Sept 28',
          'completed': true,
          'type': 'orientation',
        },
        {
          'task': 'Learning Style Assessment',
          'subject': 'Self-Assessment',
          'due': 'Sept 25',
          'completed': true,
          'type': 'assessment',
        },
      ]);
    }

    // Default tasks if no preferences
    if (baseTasks.isEmpty) {
      baseTasks = [
        {
          'task': 'Submit Programming Assignment',
          'subject': 'Programming for Problem Solving',
          'due': 'Sept 18',
          'completed': false,
          'type': 'assignment',
        },
        {
          'task': 'Prepare COA Lab Report',
          'subject': 'Computer Organization and Architecture',
          'due': 'Sept 20',
          'completed': false,
          'type': 'lab',
        },
        {
          'task': 'Physics Quiz Preparation',
          'subject': 'Physics',
          'due': 'Sept 22',
          'completed': true,
          'type': 'quiz',
        },
        {
          'task': 'English Essay Draft',
          'subject': 'English',
          'due': 'Sept 25',
          'completed': false,
          'type': 'essay',
        },
        {
          'task': 'Calculus Problem Set 3',
          'subject': 'Matrices and Calculus',
          'due': 'Sept 28',
          'completed': false,
          'type': 'practice',
        },
        {
          'task': 'Read Chapter 5 - Physics',
          'subject': 'Physics',
          'due': 'Sept 19',
          'completed': true,
          'type': 'reading',
        },
      ];
    }

    weeklyTasks = baseTasks;
  }

  // Add this method for task type colors
  Color _getTaskTypeColor(String type) {
    switch (type) {
      case 'project':
        return const Color(0xFF9C27B0);
      case 'research':
        return const Color(0xFF2196F3);
      case 'creative':
        return const Color(0xFFFF9800);
      case 'practical':
        return const Color(0xFF4CAF50);
      case 'analysis':
        return const Color(0xFF607D8B);
      case 'workshop':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  void _toggleTask(int index) {
    setState(() {
      weeklyTasks[index]['completed'] = !weeklyTasks[index]['completed'];
    });
  }

  // NEW METHOD: Build day card for timetable
  Widget _buildDayCard(String dayName, List<Map<String, dynamic>> classes) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F6F0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              dayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),

          // Classes
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: classes.map((classInfo) {
                final isCurrentClass = classInfo['isCurrentClass'] as bool;
                final isLunchBreak = classInfo['subject'] == 'Lunch Break';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentClass
                        ? const Color(
                            0xFFFFF8E1,
                          ) // Cream color highlight for current class
                        : isLunchBreak
                        ? const Color(
                            0xFFFFF8E1,
                          ) // Light yellow for lunch break
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isCurrentClass
                        ? Border.all(color: const Color(0xFFFFCC02), width: 1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Time
                      SizedBox(
                        width: 120,
                        child: Text(
                          classInfo['time'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isCurrentClass
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[700],
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Subject
                      Expanded(
                        child: Text(
                          classInfo['subject'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isCurrentClass
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCurrentClass
                                ? const Color(0xFF2E7D32)
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // NEW METHOD: Get current time and determine which class is active
  Map<String, dynamic> _getCurrentClassInfo() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    // Check if it's currently 12:48 PM (lunch time) on Monday - adjust based on actual time logic needed
    if (currentTime.hour == 12 && now.weekday == 1) {
      // Monday
      return {'day': 'Monday', 'classIndex': 3}; // Lunch Break index
    }

    return {'day': '', 'classIndex': -1};
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Profile Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF4CAF50),
                      radius: 30,
                      child: const Text(
                        'JS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Smith',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'john.smith@student.edu',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Menu Options
              ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF2C3E50)),
                title: const Text('Profile Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile Settings - Coming Soon!'),
                      backgroundColor: Color(0xFF2C3E50),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.info, color: Color(0xFF2C3E50)),
                title: const Text('Account Info'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  _showAccountInfoDialog();
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: Color(0xFF2C3E50),
                ),
                title: const Text('Notifications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification Settings - Coming Soon!'),
                      backgroundColor: Color(0xFF2C3E50),
                    ),
                  );
                },
              ),

              const Divider(),

              // Sign Out Option
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSignOutDialog();
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAccountInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: Color(0xFF2C3E50)),
              SizedBox(width: 8),
              Text('Account Information'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student ID: STU2025001'),
              SizedBox(height: 8),
              Text('Email: john.smith@student.edu'),
              SizedBox(height: 8),
              Text('Department: Computer Science'),
              SizedBox(height: 8),
              Text('Year: 1st Year'),
              SizedBox(height: 8),
              Text('Enrollment Date: Sept 2024'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Sign Out'),
            ],
          ),
          content: const Text(
            'Are you sure you want to sign out of your account?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signed out successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showBleBeaconDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.bluetooth, color: Color(0xFF2C3E50)),
              const SizedBox(width: 8),
              const Text('BLE Beacon'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BLE Beacon Mode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text('This feature will:'),
              SizedBox(height: 8),
              Text('• Make your phone broadcast BLE signals'),
              Text('• Enable automatic proximity detection'),
              Text('• Allow for contactless attendance marking'),
              Text('• Work in the background'),
              SizedBox(height: 12),
              Text(
                'Note: BLE functionality may lead to higher power consumption.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your Presence is being monitored'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Enable Beacon'),
            ),
          ],
        );
      },
    );
  }

  void _showAttendanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: Color(0xFF2C3E50)),
              const SizedBox(width: 8),
              const Text('Mark Attendance'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose your preferred method to confirm attendance:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _showQrScanDialog();
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _showOtpDialog();
              },
              icon: const Icon(Icons.password),
              label: const Text('Enter OTP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showQrScanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: Color(0xFF4CAF50)),
              const SizedBox(width: 8),
              const Text('QR Code Scanner'),
            ],
          ),
          content: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, size: 64, color: Color(0xFF4CAF50)),
                SizedBox(height: 16),
                Text('QR Scanner Placeholder'),
                Text(
                  'Point camera at QR code',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attendance marked successfully via QR!'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simulate Scan'),
            ),
          ],
        );
      },
    );
  }

  void _showOtpDialog() {
    _otpController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.password, color: Color(0xFF2C3E50)),
              const SizedBox(width: 8),
              const Text('Enter OTP'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the 6-digit OTP provided by your instructor:'),
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP',
                  hintText: '123456',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, letterSpacing: 4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_otpController.text.length == 6) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Attendance marked with OTP: ${_otpController.text}',
                      ),
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid 6-digit OTP'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = [
      {
        'subject': 'Programming for Problem Solving',
        'percent': 88,
        'grade': 'A-',
      },
      {
        'subject': 'Computer Organization and Architecture',
        'percent': 82,
        'grade': 'B+',
      },
      {'subject': 'Physics', 'percent': 78, 'grade': 'B+'},
      {'subject': 'English', 'percent': 85, 'grade': 'A-'},
      {'subject': 'Matrices and Calculus', 'percent': 92, 'grade': 'A'},
    ];

    final materials = {
      'Programming for Problem Solving': [
        {'name': 'C Programming Notes', 'size': '3.2 MB'},
        {'name': 'Problem Set 1-5', 'size': '2.1 MB'},
      ],
      'Computer Organization and Architecture': [
        {'name': 'COA Lab Manual', 'size': '4.5 MB'},
        {'name': 'Assembly Language Guide', 'size': '1.8 MB'},
      ],
      'Physics': [
        {'name': 'Physics Lab Manual', 'size': '4.1 MB'},
        {'name': 'Formula Sheet', 'size': '0.5 MB'},
      ],
      'English': [
        {'name': 'Grammar Handbook', 'size': '2.3 MB'},
        {'name': 'Essay Writing Guide', 'size': '1.9 MB'},
      ],
      'Matrices and Calculus': [
        {'name': 'Calculus Notes', 'size': '3.7 MB'},
        {'name': 'Matrix Operations', 'size': '2.4 MB'},
      ],
    };

    final attendance = [
      {
        'subject': 'Programming for Problem Solving',
        'attended': 18,
        'total': 20,
        'percent': 90,
      },
      {
        'subject': 'Computer Organization and Architecture',
        'attended': 22,
        'total': 25,
        'percent': 88,
      },
      {'subject': 'Physics', 'attended': 17, 'total': 18, 'percent': 94},
      {'subject': 'English', 'attended': 23, 'total': 25, 'percent': 92},
      {
        'subject': 'Matrices and Calculus',
        'attended': 19,
        'total': 20,
        'percent': 95,
      },
    ];

    const primaryColor = Color(0xFF2C3E50);
    const accentColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header as SliverAppBar
          SliverAppBar(
            backgroundColor: primaryColor,
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                child: Row(
                  children: [
                    // Clickable Profile Avatar
                    GestureDetector(
                      onTap: _showProfileMenu,
                      child: CircleAvatar(
                        backgroundColor: accentColor,
                        radius: 25,
                        child: const Text(
                          'JS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'John Smith',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),

          // Content as SliverList
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NEW TIMETABLE DROPDOWN with card-style layout
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.schedule,
                          color: primaryColor,
                        ),
                        title: const Text(
                          'Student Timetable',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: const Text('View weekly schedule'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Monday
                                _buildDayCard('Monday', [
                                  {
                                    'time': '9:00 – 10:00 AM',
                                    'subject': 'Study',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '10:00 – 11:00 AM',
                                    'subject': 'Math',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '11:00 – 12:00 PM',
                                    'subject': 'Science',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '12:00 – 1:00 PM',
                                    'subject': 'Lunch Break',
                                    'isCurrentClass': true,
                                  },
                                  {
                                    'time': '2:00 – 3:00 PM',
                                    'subject': 'English',
                                    'isCurrentClass': false,
                                  },
                                ]),

                                const SizedBox(height: 16),

                                // Tuesday
                                _buildDayCard('Tuesday', [
                                  {
                                    'time': '9:00 – 10:00 AM',
                                    'subject':
                                        'Programming for Problem Solving',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '10:00 – 11:00 AM',
                                    'subject': 'Room 101',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '11:00 – 12:00 PM',
                                    'subject': 'Study',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '12:00 – 1:00 PM',
                                    'subject': 'Lunch Break',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '2:00 – 3:00 PM',
                                    'subject': 'Math',
                                    'isCurrentClass': false,
                                  },
                                ]),

                                const SizedBox(height: 16),

                                // Thursday
                                _buildDayCard('Thursday', [
                                  {
                                    'time': '9:00 – 10:00 AM',
                                    'subject': 'Study',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '10:00 – 11:00 AM',
                                    'subject': 'Science',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '11:00 – 12:00 PM',
                                    'subject': 'Lunch Break',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '2:00 – 3:00 PM',
                                    'subject': 'Math',
                                    'isCurrentClass': false,
                                  },
                                ]),

                                const SizedBox(height: 16),

                                // Saturday
                                _buildDayCard('Saturday', [
                                  {
                                    'time': '9:00 – 10:00 AM',
                                    'subject': 'Study',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '10:00 – 11:00 AM',
                                    'subject': 'Physics Lab',
                                    'isCurrentClass': false,
                                  },
                                  {
                                    'time': '11:00 – 12:00 PM',
                                    'subject': 'Computer Lab',
                                    'isCurrentClass': false,
                                  },
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Progress Dropdown
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.trending_up,
                          color: primaryColor,
                        ),
                        title: const Text(
                          'Student Progress',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: const Text('View academic performance'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: progress
                                  .map(
                                    (p) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  p['subject'].toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${p['percent']}% - ${p['grade']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          LinearProgressIndicator(
                                            value: (p['percent'] as int) / 100,
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Study Materials Dropdown
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.library_books,
                          color: primaryColor,
                        ),
                        title: const Text(
                          'Study Materials',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: const Text('Download course materials'),
                        children: materials.entries
                            .map(
                              (e) => ExpansionTile(
                                title: Text(
                                  e.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                children: e.value
                                    .map(
                                      (m) => ListTile(
                                        leading: const Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                        ),
                                        title: Text(m['name'].toString()),
                                        subtitle: Text('PDF ${m['size']}'),
                                        trailing: ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Downloading ${m['name']}...',
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Download'),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Attendance Dropdown
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.how_to_reg,
                          color: primaryColor,
                        ),
                        title: const Text(
                          'Student Attendance',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: const Text('View attendance records'),
                        children: [
                          Column(
                            children: attendance
                                .map(
                                  (a) => ListTile(
                                    title: Text(
                                      a['subject'].toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    subtitle: Text(
                                      '${a['attended']}/${a['total']} classes',
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (a['percent'] as int) >= 90
                                            ? accentColor
                                            : (a['percent'] as int) >= 75
                                            ? Colors.orange
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${a['percent']}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Weekly Tasks Dropdown
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.task_alt,
                          color: primaryColor,
                        ),
                        title: const Text(
                          'Weekly Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${weeklyTasks.where((t) => !(t['completed'] as bool)).length} pending tasks',
                        ),
                        children: [
                          Column(
                            children: weeklyTasks.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> task = entry.value;
                              bool isCompleted = task['completed'] as bool;

                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () => _toggleTask(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      isCompleted
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isCompleted
                                          ? accentColor
                                          : Colors.grey,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  task['task'].toString(),
                                  style: TextStyle(
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: isCompleted
                                        ? Colors.grey
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      margin: const EdgeInsets.only(
                                        top: 4,
                                        bottom: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? Colors.grey
                                            : accentColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        task['subject'].toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Due: ${task['due']}',
                                      style: TextStyle(
                                        color: isCompleted
                                            ? Colors.grey
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _toggleTask(index),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      // Bottom Navigation Bar with BLE and Attendance buttons
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // BLE Beacon Button
            GestureDetector(
              onTap: _showBleBeaconDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bluetooth, color: Colors.white, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'BLE Beacon',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            // Attendance Button
            GestureDetector(
              onTap: _showAttendanceDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'Mark Attendance',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
