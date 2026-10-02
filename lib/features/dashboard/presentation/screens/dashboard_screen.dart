import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome banner
          _buildWelcomeBanner(context),
          const SizedBox(height: 32),

          // Statistics Grid
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatsGrid(context),
          const SizedBox(height: 32),

          // Responsive Split Section: Placement Drives & Upcoming Interviews
          ResponsiveBuilder(
            mobile: (context) => Column(
              children: [
                _buildPlacementDrivesSection(context),
                const SizedBox(height: 32),
                _buildUpcomingInterviewsSection(context),
              ],
            ),
            desktop: (context) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildPlacementDrivesSection(context),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: _buildUpcomingInterviewsSection(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back, John!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have 2 pending assessments and 1 upcoming interview this week. Stay focused!',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('View Assessments'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final columns = ResponsiveLayout.select(
      context,
      mobile: 2,
      tablet: 2,
      desktop: 4,
    );

    final stats = [
      _StatItem(label: 'Applied Jobs', value: '18', icon: Icons.send_rounded, color: AppColors.primary),
      _StatItem(label: 'Shortlists', value: '5', icon: Icons.star_rounded, color: AppColors.secondary),
      _StatItem(label: 'Interviews', value: '2', icon: Icons.chat_rounded, color: AppColors.accent),
      _StatItem(label: 'Job Offers', value: '1', icon: Icons.emoji_events_rounded, color: AppColors.success),
    ];

    if (columns == 4) {
      return Row(
        children: stats
            .map((stat) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildStatCard(stat),
                  ),
                ))
            .toList(),
      );
    }

    // Grid layout for mobile/tablet
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index]),
    );
  }

  Widget _buildStatCard(_StatItem stat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stat.value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 20),
                ),
              ],
            ),
            Text(
              stat.label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacementDrivesSection(BuildContext context) {
    final drives = [
      _DriveItem(
        company: 'Google',
        role: 'Software Engineer - Intern',
        package: '\$45/hr',
        date: 'July 28, 2026',
        status: 'Open',
        logoText: 'G',
        logoColor: Colors.redAccent,
      ),
      _DriveItem(
        company: 'Microsoft',
        role: 'Full Stack Engineer',
        package: '\$145,000 / yr',
        date: 'August 02, 2026',
        status: 'Closing Soon',
        logoText: 'M',
        logoColor: Colors.blueAccent,
      ),
      _DriveItem(
        company: 'Stripe',
        role: 'Backend SDE',
        package: '\$160,000 / yr',
        date: 'August 05, 2026',
        status: 'Open',
        logoText: 'S',
        logoColor: Colors.purpleAccent,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Placement Drives',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: drives.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 24),
              itemBuilder: (context, index) {
                final drive = drives[index];
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: drive.logoColor.withOpacity(0.15),
                      foregroundColor: drive.logoColor,
                      radius: 22,
                      child: Text(drive.logoText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drive.role,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${drive.company} • ${drive.package}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: drive.status == 'Open'
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            drive.status,
                            style: TextStyle(
                              color: drive.status == 'Open' ? AppColors.success : AppColors.warning,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Deadline: ${drive.date}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingInterviewsSection(BuildContext context) {
    final interviews = [
      _InterviewItem(
        company: 'Uber',
        type: 'Technical Interview (Round 2)',
        dateTime: 'July 27 at 10:00 AM',
        interviewer: 'Sarah Jenkins',
      ),
      _InterviewItem(
        company: 'Google',
        type: 'System Design (Round 1)',
        dateTime: 'July 29 at 2:00 PM',
        interviewer: 'David Chen',
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Interviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: interviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final interview = interviews[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            interview.company,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                          ),
                          const Icon(Icons.videocam, color: AppColors.accent, size: 18),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        interview.type,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        interview.dateTime,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.person_pin, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            'Interviewer: ${interview.interviewer}',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _DriveItem {
  final String company;
  final String role;
  final String package;
  final String date;
  final String status;
  final String logoText;
  final Color logoColor;

  _DriveItem({
    required this.company,
    required this.role,
    required this.package,
    required this.date,
    required this.status,
    required this.logoText,
    required this.logoColor,
  });
}

class _InterviewItem {
  final String company;
  final String type;
  final String dateTime;
  final String interviewer;

  _InterviewItem({
    required this.company,
    required this.type,
    required this.dateTime,
    required this.interviewer,
  });
}
