import 'package:flutter/material.dart';
import 'package:demo/Pages/student_dashboard.dart';

class StudentOnboardingScreen extends StatefulWidget {
  final dynamic studentName;

  const StudentOnboardingScreen({Key? key, required this.studentName})
    : super(key: key);

  @override
  State<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen> {
  // Add static variables here instead
  static Map<String, Map<String, dynamic>> userPreferences = {};
  static Set<String> completedOnboarding = {};

  int currentStep = 0;
  List<String> selectedLearningStyles = [];
  List<String> selectedInterests = [];
  List<String> selectedSkills = [];
  List<String> selectedCareerPaths = [];
  String selectedLearningPace = '';

  final List<String> learningStyles = [
    'Visual Learning',
    'Auditory Learning',
    'Kinesthetic Learning',
    'Reading/Writing',
    'Experiential Learning',
    'Project-Based Learning',
  ];
  final List<String> interests = [
    'Science & Technology',
    'Arts & Literature',
    'Mathematics & Logic',
    'Sports & Physical Education',
    'Music & Performing Arts',
    'Environmental Studies',
    'Social Sciences',
    'Entrepreneurship',
    'Languages',
    'Philosophy & Ethics',
  ];
  final List<String> skills = [
    'Critical Thinking',
    'Problem Solving',
    'Creative Expression',
    'Communication',
    'Leadership',
    'Collaboration',
    'Digital Literacy',
    'Research & Analysis',
    'Time Management',
    'Emotional Intelligence',
  ];
  final List<String> careerPaths = [
    'Engineering & Technology',
    'Medicine & Healthcare',
    'Arts & Design',
    'Business & Management',
    'Research & Academia',
    'Social Work',
    'Media & Communication',
    'Agriculture & Environment',
    'Sports & Fitness',
    'Entrepreneurship',
  ];
  final List<String> learningPaces = [
    'Self-Paced (Flexible)',
    'Moderate Pace',
    'Intensive Learning',
  ];

  static const primaryColor = Color(0xFF2C3E50);
  static const accentColor = Color(0xFF4CAF50);
  static const backgroundColor = Color(0xFFF5F5F5);

  void _nextStep() {
    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _completeOnboarding() {
    Map<String, dynamic> preferences = {
      'learningStyles': selectedLearningStyles,
      'interests': selectedInterests,
      'skills': selectedSkills,
      'careerPaths': selectedCareerPaths,
      'learningPace': selectedLearningPace,
      'completedDate': DateTime.now().toIso8601String(),
    };

    // Save to local static variables instead
    completedOnboarding.add(widget.studentName);
    userPreferences[widget.studentName] = preferences;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Learning profile created successfully!'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDashboard(
          studentName: widget.studentName,
          userPreferences: preferences,
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildLearningStyleStep();
      case 1:
        return _buildInterestsStep();
      case 2:
        return _buildSkillsStep();
      case 3:
        return _buildCareerPathStep();
      case 4:
        return _buildLearningPaceStep();
      default:
        return Container();
    }
  }

  Widget _buildSelectionCard(
    String title,
    List<String> options,
    List<String> selectedOptions,
    bool multiSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...options.map((option) {
          bool isSelected = multiSelect
              ? selectedOptions.contains(option)
              : selectedLearningPace == option;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? accentColor : Colors.grey,
              ),
              title: Text(option),
              selected: isSelected,
              selectedTileColor: accentColor.withOpacity(0.1),
              onTap: () {
                setState(() {
                  if (multiSelect) {
                    if (isSelected) {
                      selectedOptions.remove(option);
                    } else {
                      selectedOptions.add(option);
                    }
                  } else {
                    selectedLearningPace = option;
                  }
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLearningStyleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How do you prefer to learn?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select your preferred learning styles (you can choose multiple)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildSelectionCard(
          'Learning Styles',
          learningStyles,
          selectedLearningStyles,
          true,
        ),
      ],
    );
  }

  Widget _buildInterestsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What are your interests?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose subjects and areas that fascinate you',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildSelectionCard(
          'Areas of Interest',
          interests,
          selectedInterests,
          true,
        ),
      ],
    );
  }

  Widget _buildSkillsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Which skills would you like to develop?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the 21st-century skills you want to focus on',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildSelectionCard('Skills to Develop', skills, selectedSkills, true),
      ],
    );
  }

  Widget _buildCareerPathStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What career paths interest you?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Explore different career possibilities',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildSelectionCard(
          'Career Interests',
          careerPaths,
          selectedCareerPaths,
          true,
        ),
      ],
    );
  }

  Widget _buildLearningPaceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What\'s your preferred learning pace?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose how fast you\'d like to progress through your studies',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildSelectionCard('Learning Pace', learningPaces, [], false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${widget.studentName}!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const Text(
                          'Let\'s personalize your learning journey',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                value: (currentStep + 1) / 5,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(accentColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Step ${currentStep + 1} of 5',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(child: _buildStepContent()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    ElevatedButton(
                      onPressed: _previousStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Previous'),
                    )
                  else
                    const SizedBox(),
                  ElevatedButton(
                    onPressed: _canProceed() ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(currentStep == 4 ? 'Complete' : 'Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0:
        return selectedLearningStyles.isNotEmpty;
      case 1:
        return selectedInterests.isNotEmpty;
      case 2:
        return selectedSkills.isNotEmpty;
      case 3:
        return selectedCareerPaths.isNotEmpty;
      case 4:
        return selectedLearningPace.isNotEmpty;
      default:
        return false;
    }
  }
}
