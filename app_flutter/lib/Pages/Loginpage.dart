import 'package:flutter/material.dart';
import 'package:demo/Pages/admin_dashboard.dart';
import 'package:demo/Pages/student_dashboard.dart';
import 'package:demo/Pages/teacher_dashboard.dart';
import 'package:demo/Pages/studentOnboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static Map<String, Map<String, dynamic>> userPreferences = {};
  static Set<String> completedOnboarding = {};

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'Student';
  bool _obscurePassword = true;

  // Role colors
  final Map<String, Color> roleColors = {
    'Student': Color(0xFF2D4A5C),
    'Faculty': Color(0xFF5A8A7A),
    'Admin': Color(0xFFB8956B),
  };

  final Map<String, Color> role_Colors = {
    'Student': Color(0xFF4C8093),
    'Faculty': Color(0xFF629786),
    'Admin': Color(0xFFCCA774),
  };

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  Color _getCurrentPrimaryColor() {
    return roleColors[_selectedRole] ?? Color(0xFF2D4A5C);
  }

  Color _getCurrentSecondaryColor() {
    return role_Colors[_selectedRole] ?? Color(0xFF2D4A5C);
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      switch (_selectedRole) {
        case 'Student':
          _handleStudentLogin();
          break;
        case 'Faculty':
          _navigateToFacultyDashboard();
          break;
        case 'Admin':
          _navigateToAdminDashboard();
          break;
      }
    }
  }

  Future<void> _handleStudentLogin() async {
    String studentName = _usernameController.text.isNotEmpty
        ? _usernameController.text
        : 'John Smith';

    bool hasCompletedOnboarding = completedOnboarding.contains(studentName);

    if (hasCompletedOnboarding) {
      Map<String, dynamic>? preferences = userPreferences[studentName];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentDashboard(
            studentName: studentName,
            userPreferences: preferences,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              StudentOnboardingScreen(studentName: studentName),
        ),
      );
    }
  }

  void _navigateToFacultyDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherDashboard(
          facultyName: _usernameController.text.isNotEmpty
              ? _usernameController.text
              : 'Dr. Sarah Johnson',
        ),
      ),
    );
  }

  void _navigateToAdminDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminDashboard(
          adminName: _usernameController.text.isNotEmpty
              ? _usernameController.text
              : 'System Administrator',
        ),
      ),
    );
  }

  Future<void> _clearOnboardingData() async {
    completedOnboarding.clear();
    userPreferences.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All onboarding data cleared'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getCurrentPrimaryColor().withOpacity(0.15),
            _getCurrentPrimaryColor().withOpacity(0.85),
            _getCurrentPrimaryColor().withOpacity(
              0.33,
            ), // Slightly more visible
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 60),
                Column(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _getCurrentPrimaryColor(),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: _getCurrentPrimaryColor().withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.school, color: Colors.white, size: 40),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Attendly',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getCurrentSecondaryColor(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Login as $_selectedRole',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getCurrentSecondaryColor(),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Access your $_selectedRole account',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getCurrentSecondaryColor(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRoleButton(
                      'Student',
                      'lib/icons/1',
                      Color(0xFF2D4A5C),
                    ),
                    _buildRoleButton(
                      'Faculty',
                      'lib/icons/2',
                      Color(0xFF5A8A7A),
                    ),
                    _buildRoleButton('Admin', 'lib/icons/3', Color(0xFFB8956B)),
                  ],
                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getCurrentPrimaryColor().withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getCurrentPrimaryColor().withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: _getCurrentPrimaryColor().withOpacity(0.7),
                            ),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username or email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getCurrentPrimaryColor().withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getCurrentPrimaryColor().withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: _getCurrentPrimaryColor().withOpacity(0.7),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _getCurrentPrimaryColor().withOpacity(
                                  0.7,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getCurrentPrimaryColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: _getCurrentPrimaryColor().withOpacity(0.3),
                    ),
                    child: Text(
                      'LOGIN AS $_selectedRole'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Forgot password functionality'),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: _getCurrentSecondaryColor(),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (_selectedRole == 'Student')
                      TextButton(
                        onPressed: _clearOnboardingData,
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role, String iconPath, Color color) {
    bool isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () => _selectRole(role),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: color, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 12 : 4,
              offset: Offset(0, isSelected ? 6 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getRoleIcon(role),
              color: isSelected ? color : Colors.white,
              size: 28,
            ),
            SizedBox(height: 4),
            Text(
              role,
              style: TextStyle(
                color: isSelected ? color : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Student':
        return Icons.school;
      case 'Faculty':
        return Icons.menu_book;
      case 'Admin':
        return Icons.settings;
      default:
        return Icons.person;
    }
  }
}
