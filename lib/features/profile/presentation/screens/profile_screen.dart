import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../domain/entities/profile.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileState.when(
        data: (profile) => ProfileForm(profile: profile),
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error loading profile: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}

class ProfileForm extends ConsumerStatefulWidget {
  final Profile profile;

  const ProfileForm({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _rollController;
  late TextEditingController _deptController;
  late TextEditingController _gpaController;
  late TextEditingController _resumeController;
  
  List<String> _skills = [];
  final _skillInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _rollController = TextEditingController(text: widget.profile.rollNo);
    _deptController = TextEditingController(text: widget.profile.department);
    _gpaController = TextEditingController(text: widget.profile.gpa);
    _resumeController = TextEditingController(text: widget.profile.resumeName);
    _skills = List<String>.from(widget.profile.skills);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _rollController.dispose();
    _deptController.dispose();
    _gpaController.dispose();
    _resumeController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = Profile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        rollNo: _rollController.text.trim(),
        department: _deptController.text.trim(),
        gpa: _gpaController.text.trim(),
        skills: _skills,
        resumeName: _resumeController.text.trim(),
      );

      await ref.read(profileProvider.notifier).saveProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully in Hive storage!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _addSkill() {
    final skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillInputController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: ResponsiveBuilder(
          mobile: (context) => _buildProfileLayout(context, isMobile: true),
          desktop: (context) => Center(
            child: SizedBox(
              width: 850,
              child: _buildProfileLayout(context, isMobile: false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileLayout(BuildContext context, {required bool isMobile}) {
    final formFields = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 20),
        
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (val) => val!.isEmpty ? 'Enter your name' : null,
              ),
            ),
            if (!isMobile) const SizedBox(width: 16),
            if (!isMobile)
              Expanded(
                child: _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  validator: (val) => !val!.contains('@') ? 'Enter a valid email' : null,
                ),
              ),
          ],
        ),
        if (isMobile) const SizedBox(height: 16),
        if (isMobile)
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            validator: (val) => !val!.contains('@') ? 'Enter a valid email' : null,
          ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _rollController,
                label: 'Roll / Student ID',
                icon: Icons.badge_outlined,
                validator: (val) => val!.isEmpty ? 'Enter student ID' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _gpaController,
                label: 'Current CGPA',
                icon: Icons.school_outlined,
                validator: (val) => val!.isEmpty ? 'Enter CGPA' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _deptController,
          label: 'Department / Course',
          icon: Icons.class_outlined,
          validator: (val) => val!.isEmpty ? 'Enter department' : null,
        ),
        const SizedBox(height: 32),

        // Resume PDF section
        const Text(
          'Documents',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _resumeController,
          label: 'Default Resume PDF',
          icon: Icons.picture_as_pdf_outlined,
          validator: (val) => val!.isEmpty ? 'Enter resume file name' : null,
        ),
        const SizedBox(height: 32),

        // Skill Set section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Skills & Tech Stack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            Text(
              '(${_skills.length} skills)',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _skillInputController,
                decoration: const InputDecoration(
                  hintText: 'Add new skill (e.g. React, Python)',
                  prefixIcon: Icon(Icons.star_border, size: 20),
                ),
                onFieldSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addSkill,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills.map((skill) {
            return Chip(
              label: Text(skill),
              onDeleted: () => _removeSkill(skill),
              deleteIconColor: AppColors.error,
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            );
          }).toList(),
        ),
        const SizedBox(height: 40),

        // Save Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _saveProfile,
            child: const Text('Save Profile Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );

    return isMobile
        ? Column(
            children: [
              _buildProfileHeader(isMobile: true),
              const SizedBox(height: 32),
              formFields,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildProfileHeader(isMobile: false),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: formFields,
              ),
            ],
          );
  }

  Widget _buildProfileHeader({required bool isMobile}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
              radius: 54,
              child: Text(
                _nameController.text.isNotEmpty ? _nameController.text.substring(0, 2).toUpperCase() : 'JD',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _nameController.text.isNotEmpty ? _nameController.text : 'John Doe',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _deptController.text.isNotEmpty ? _deptController.text : 'Computer Science',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 20),
            _buildHeaderStat('Academic Standing', 'CGPA: ${_gpaController.text}'),
            const SizedBox(height: 12),
            _buildHeaderStat('Student ID', _rollController.text),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
