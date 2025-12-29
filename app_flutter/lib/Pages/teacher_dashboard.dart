import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key, required String facultyName}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  // Timer for OTP/QR refresh
  Timer? _refreshTimer;
  Timer? _countdownTimer;
  Duration _timeUntilRefresh = Duration(minutes: 10);

  // Dummy Data
  final String teacherName = 'Dr. Johnson';
  final String subjectType = 'Data Structures';
  final String sessionId = 'SESSION_001';
  final String sessionSubject = 'Data Structures';
  String qrValue = 'ATT-CS101-20250915-1003';
  String currentOtp = '482719';

  final List<Map<String, dynamic>> studentsPresent = [
    {'name': 'Aarav Sharma', 'id': 'STU101', 'time': '07:28 PM'},
    {'name': 'Ananya Reddy', 'id': 'STU102', 'time': '07:25 PM'},
    {'name': 'Rohan Mehta', 'id': 'STU103', 'time': '07:22 PM'},
    {'name': 'Priya Nair', 'id': 'STU104', 'time': '07:26 PM'},
    {'name': 'Karthik Iyer', 'id': 'STU105', 'time': '07:24 PM'},
    {'name': 'Sneha Patil', 'id': 'STU106', 'time': '07:20 PM'},
    {'name': 'Aditya Verma', 'id': 'STU107', 'time': '07:23 PM'},
    {'name': 'Kavya Rao', 'id': 'STU108', 'time': '07:21 PM'},
    {'name': 'Arjun Singh', 'id': 'STU109', 'time': '07:19 PM'},
    {'name': 'Pooja Mishra', 'id': 'STU110', 'time': '07:27 PM'},
    {'name': 'Rahul Deshmukh', 'id': 'STU111', 'time': '07:18 PM'},
    {'name': 'Neha Choudhary', 'id': 'STU112', 'time': '07:17 PM'},
    {'name': 'Manish Gupta', 'id': 'STU113', 'time': '07:16 PM'},
    {'name': 'Aishwarya Menon', 'id': 'STU114', 'time': '07:15 PM'},
    {'name': 'Siddharth Joshi', 'id': 'STU115', 'time': '07:14 PM'},
    {'name': 'Divya Kulkarni', 'id': 'STU116', 'time': '07:13 PM'},
    {'name': 'Vivek Shaurya', 'id': 'STU117', 'time': '07:12 PM'},
    {'name': 'Meera Pillai', 'id': 'STU118', 'time': '07:11 PM'},
    {'name': 'Varun Bhatia', 'id': 'STU119', 'time': '07:10 PM'},
    {'name': 'Shruti Das', 'id': 'STU120', 'time': '07:09 PM'},
  ];

  final List<Map<String, String>> todayClasses = [
    {'time': '09:00-10:30', 'subject': 'Advanced Programming', 'info': 'CS-101 | Section A', 'type': 'Programming'},
    {'time': '11:00-12:30', 'subject': 'Data Structures & Algorithms', 'info': 'CS-102 | Section B', 'type': 'Algorithms'},
    {'time': '14:00-15:30', 'subject': 'Database Management Systems', 'info': 'CS-201 | Section A', 'type': 'Database Systems'},
  ];

  final Map<String, List<Map<String, String>>> teachingSchedule = {
    'Monday': [
      {'time': '09:00-10:30', 'subject': 'Advanced Programming', 'info': 'CS-101 | Section A', 'type': 'Programming'},
      {'time': '11:00-12:30', 'subject': 'Data Structures & Algorithms', 'info': 'CS-102 | Section B', 'type': 'Algorithms'},
      {'time': '14:00-15:30', 'subject': 'Database Management Systems', 'info': 'CS-201 | Section A', 'type': 'Database Systems'},
    ],
    'Tuesday': [
      {'time': '10:00-11:30', 'subject': 'Object-Oriented Programming', 'info': 'CS-101 | Section B', 'type': 'Programming'},
      {'time': '13:00-14:30', 'subject': 'Software Engineering Principles', 'info': 'CS-103 | Section A', 'type': 'Software Engineering'},
    ],
    'Wednesday': [
      {'time': '09:00-10:30', 'subject': 'Advanced Database Concepts', 'info': 'CS-201 | Section B', 'type': 'Database Systems'},
      {'time': '15:00-16:30', 'subject': 'Algorithm Design & Analysis', 'info': 'CS-101 | Section C', 'type': 'Algorithms'},
    ],
    'Thursday': [
      {'time': '11:00-12:30', 'subject': 'System Design', 'info': 'CS-301 | Section A', 'type': 'Software Engineering'},
      {'time': '14:00-15:30', 'subject': 'Competitive Programming', 'info': 'CS-102 | Section C', 'type': 'Programming'},
    ],
    'Friday': [
      {'time': '09:00-10:30', 'subject': 'Machine Learning Basics', 'info': 'CS-401 | Section A', 'type': 'AI/ML'},
      {'time': '13:00-14:30', 'subject': 'Web Development', 'info': 'CS-201 | Section B', 'type': 'Programming'},
    ],
  };

  String selectedDay = 'Monday';

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
    _startCountdownTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(Duration(minutes: 10), (timer) {
      _refreshOtpAndQr();
    });
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeUntilRefresh.inSeconds > 0) {
          _timeUntilRefresh = _timeUntilRefresh - Duration(seconds: 1);
        } else {
          _timeUntilRefresh = Duration(minutes: 10);
        }
      });
    });
  }

  void _refreshOtpAndQr() {
    setState(() {
      Random random = Random();
      currentOtp = (100000 + random.nextInt(900000)).toString();

      DateTime now = DateTime.now();
      String timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      qrValue = 'ATT-CS101-$timestamp';

      _timeUntilRefresh = Duration(minutes: 10);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // Helper method to get subject type dynamically
  String _getSubjectType(Map<String, String> classInfo) {
    return classInfo['type'] ?? 'General';
  }


  // Responsive helper methods
  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return 12.0; // Mobile
    if (screenWidth < 900) return 16.0; // Tablet
    return 20.0; // Desktop
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth < 600 ? 0.9 : screenWidth < 900 ? 1.0 : 1.1;
    return baseFontSize * scaleFactor;
  }

  double _getQRSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return 120.0; // Mobile
    if (screenWidth < 900) return 150.0; // Tablet
    return 180.0; // Desktop
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2C3E50);
    const accentColor = Color(0xFF4CAF50);
    const cardColor = Color(0xFF5E8471);

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final responsivePadding = _getResponsivePadding(context);
    final qrSize = _getQRSize(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(responsivePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Responsive Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 8.0 : 12.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            color: primaryColor,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text(
                            "Attendly",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontSize: _getResponsiveFontSize(context, 20),
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: isSmallScreen ? 18 : 22,
                            child: Text(
                              'DJ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: _getResponsiveFontSize(context, 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Responsive Welcome Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back, $teacherName!",
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Text(
                          isSmallScreen
                              ? "Manage classes and attendance"
                              : "Manage your classes and student attendance\nfrom your dashboard",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: _getResponsiveFontSize(context, 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Responsive Student Attendance Dropdown
                    Card(
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.qr_code_2_rounded,
                          color: primaryColor,
                          size: isSmallScreen ? 20 : 24,
                        ),
                        title: Text(
                          isSmallScreen
                              ? 'Attendance - 2FA'
                              : 'Student Attendance - 2FA Verification',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _getResponsiveFontSize(context, 16),
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(Icons.timer, size: isSmallScreen ? 14 : 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Refreshes in ${_timeUntilRefresh.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timeUntilRefresh.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: _getResponsiveFontSize(context, 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(responsivePadding),
                            child: Column(
                              children: [
                                // Responsive Current Session Info
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Session: $sessionSubject',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _getResponsiveFontSize(context, 14),
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 3 : 4),
                                      Wrap(
                                        children: [
                                          Text(
                                            'Session ID: ',
                                            style: TextStyle(fontSize: _getResponsiveFontSize(context, 12)),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: isSmallScreen ? 6 : 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange[200],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              sessionId,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: _getResponsiveFontSize(context, 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 20),

                                // Responsive QR Code Section
                                Text(
                                  'QR Code for Students',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _getResponsiveFontSize(context, 16),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 12),
                                Container(
                                  width: qrSize,
                                  height: qrSize,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: QrImageView(
                                      data: qrValue,
                                      version: QrVersions.auto,
                                      size: qrSize - 16,
                                      backgroundColor: Colors.white,
                                      foregroundColor: primaryColor,
                                      errorStateBuilder: (cxt, err) {
                                        return Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: qrSize * 0.3,
                                                ),
                                                Text(
                                                  "QR Error",
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: isSmallScreen ? 6 : 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
                                  child: Text(
                                    qrValue,
                                    style: TextStyle(
                                      fontSize: _getResponsiveFontSize(context, 12),
                                      letterSpacing: isSmallScreen ? 0.5 : 1,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 12 : 16),

                                // Responsive Generate Button
                                SizedBox(
                                  width: double.infinity,
                                  height: isSmallScreen ? 40 : 45,
                                  child: ElevatedButton(
                                    onPressed: _refreshOtpAndQr,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(
                                      'Generate New QR',
                                      style: TextStyle(fontSize: _getResponsiveFontSize(context, 14)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 20),

                                // Responsive OTP Section
                                Text(
                                  'Manual OTP Entry',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _getResponsiveFontSize(context, 16),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 12),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    currentOtp,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 24 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: isSmallScreen ? 4 : 6,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 6 : 8),
                                Text(
                                  'Students use this OTP in their mobile app',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: _getResponsiveFontSize(context, 12),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: responsivePadding),

                    // Responsive Students Present Dropdown
                    Card(
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.group,
                          color: primaryColor,
                          size: isSmallScreen ? 20 : 24,
                        ),
                        title: Text(
                          'Students Present (${studentsPresent.length})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _getResponsiveFontSize(context, 16),
                          ),
                        ),
                        subtitle: Text(
                          '${studentsPresent.length} students checked in',
                          style: TextStyle(fontSize: _getResponsiveFontSize(context, 12)),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(responsivePadding),
                            child: Column(
                              children: studentsPresent.map((student) => Container(
                                margin: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9F1EB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 12 : 16,
                                    vertical: isSmallScreen ? 4 : 8,
                                  ),
                                  title: Text(
                                    student['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: _getResponsiveFontSize(context, 14),
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${student['id']} • ${student['time']}',
                                    style: TextStyle(fontSize: _getResponsiveFontSize(context, 12)),
                                  ),
                                  trailing: Icon(
                                    Icons.check_circle,
                                    color: accentColor,
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: responsivePadding),

                    // Teaching Schedule Dropdown with improved cards
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: primaryColor,
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                        title: Text(
                          'My Teaching Schedule',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _getResponsiveFontSize(context, 16),
                            color: primaryColor,
                          ),
                        ),
                        subtitle: Text(
                          '$selectedDay schedule • ${teachingSchedule[selectedDay]?.length ?? 0} classes',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 12),
                            color: Colors.grey[600],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(responsivePadding),
                            child: Column(
                              children: [
                                // Day selector with beautiful design
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [primaryColor.withOpacity(0.1), primaryColor.withOpacity(0.05)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: primaryColor.withOpacity(0.2)),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedDay,
                                    decoration: InputDecoration(
                                      labelText: 'Select Day',
                                      labelStyle: TextStyle(
                                        fontSize: _getResponsiveFontSize(context, 14),
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 12 : 16,
                                        vertical: isSmallScreen ? 8 : 12,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.today,
                                        color: primaryColor,
                                        size: isSmallScreen ? 18 : 20,
                                      ),
                                    ),
                                    items: teachingSchedule.keys.map((day) {
                                      return DropdownMenuItem(
                                        value: day,
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            fontSize: _getResponsiveFontSize(context, 14),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDay = value!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: responsivePadding),

                                // Beautiful schedule cards
                                ...teachingSchedule[selectedDay]!.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, String> classInfo = entry.value;

                                  // Different gradient colors for variety
                                  List<List<Color>> gradients = [
                                    [const Color(0xFF2C3E50), const Color(0xFF3498DB)], // Dark blue to blue
                                    [const Color(0xFF8E44AD), const Color(0xFF3498DB)], // Purple to blue
                                    [const Color(0xFF27AE60), const Color(0xFF2ECC71)], // Dark green to light green
                                    [const Color(0xFFE74C3C), const Color(0xFFF39C12)], // Red to orange
                                    [const Color(0xFF34495E), const Color(0xFF2C3E50)], // Dark gray to darker gray
                                  ];

                                  List<Color> currentGradient = gradients[index % gradients.length];

                                  return Container(
                                    margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: currentGradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: currentGradient[0].withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.access_time,
                                                  color: Colors.white,
                                                  size: isSmallScreen ? 16 : 18,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                classInfo['time']!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: _getResponsiveFontSize(context, 16),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isSmallScreen ? 8 : 10,
                                                  vertical: isSmallScreen ? 4 : 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'Active',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: _getResponsiveFontSize(context, 10),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            classInfo['subject']!,
                                            style: TextStyle(
                                              fontSize: _getResponsiveFontSize(context, 18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            classInfo['info']!,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: _getResponsiveFontSize(context, 13),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: isSmallScreen ? 8 : 12,
                                                    vertical: isSmallScreen ? 6 : 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.15),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: Colors.white.withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.school,
                                                        color: Colors.white,
                                                        size: isSmallScreen ? 14 : 16,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        "Academic",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: _getResponsiveFontSize(context, 11),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: responsivePadding),

                    // Today's Classes with improved cards
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.star,
                            color: const Color(0xFFFFD700),
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                        title: Text(
                          "Today's Classes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _getResponsiveFontSize(context, 16),
                            color: primaryColor,
                          ),
                        ),
                        subtitle: Text(
                          '${todayClasses.length} classes scheduled • Active day',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 12),
                            color: Colors.grey[600],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(responsivePadding),
                            child: Column(
                              children: todayClasses.asMap().entries.map((entry) {
                                int index = entry.key;
                                Map<String, String> cls = entry.value;

                                // Special gradients for today's classes
                                List<List<Color>> todayGradients = [
                                  [const Color(0xFF1A252F), const Color(0xFF2C3E50)], // Very dark to dark blue
                                  [const Color(0xFF8E44AD), const Color(0xFF9B59B6)], // Purple shades
                                  [const Color(0xFF27AE60), const Color(0xFF16A085)], // Green shades
                                  [const Color(0xFFE74C3C), const Color(0xFFC0392B)], // Red shades
                                  [const Color(0xFFF39C12), const Color(0xFFE67E22)], // Orange shades
                                ];


                                List<Color> currentGradient = todayGradients[index % todayGradients.length];

                                return Container(
                                  margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: currentGradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: currentGradient[0].withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.schedule,
                                                color: Colors.white,
                                                size: isSmallScreen ? 18 : 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cls['time']!,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: _getResponsiveFontSize(context, 16),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Duration: 90 mins',
                                                    style: TextStyle(
                                                      color: Colors.white.withOpacity(0.8),
                                                      fontSize: _getResponsiveFontSize(context, 11),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: isSmallScreen ? 8 : 10,
                                                vertical: isSmallScreen ? 4 : 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.greenAccent,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Today',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: _getResponsiveFontSize(context, 10),
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          cls['subject']!,
                                          style: TextStyle(
                                            fontSize: _getResponsiveFontSize(context, 20),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          cls['info']!,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: _getResponsiveFontSize(context, 14),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isSmallScreen ? 10 : 14,
                                                  vertical: isSmallScreen ? 8 : 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.white.withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.category,
                                                      color: Colors.white,
                                                      size: isSmallScreen ? 14 : 16,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "Academic",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: _getResponsiveFontSize(context, 12),
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: isSmallScreen ? 14 : 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
