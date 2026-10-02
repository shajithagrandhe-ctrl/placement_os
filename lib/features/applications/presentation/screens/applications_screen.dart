import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../providers/applications_provider.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: applications.isEmpty
          ? _buildEmptyState()
          : ResponsiveBuilder(
              mobile: (context) => _buildList(context, applications),
              desktop: (context) => Center(
                child: SizedBox(
                  width: 900,
                  child: _buildList(context, applications),
                ),
              ),
            ),
    );
  }

  Widget _buildList(BuildContext context, List applications) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final app = applications[index];
        final formattedDate = DateFormat('MMM dd, yyyy').format(app.appliedDate);

        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.surface,
            collapsedBackgroundColor: AppColors.surface,
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.textSecondary,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      app.job.logoText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.job.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${app.job.company} • Applied on $formattedDate',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(app.status),
                ],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: AppColors.border, height: 24),
                    
                    // Stepper timeline
                    const Text(
                      'Application Progress',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    _buildStepper(app.status),
                    const SizedBox(height: 24),

                    // Stage status description
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                app.statusStep,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            app.feedback,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
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
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color textColor;

    switch (status) {
      case 'Selected':
        badgeColor = AppColors.success.withOpacity(0.12);
        textColor = AppColors.success;
        break;
      case 'Interview':
        badgeColor = AppColors.primary.withOpacity(0.12);
        textColor = AppColors.primaryLight;
        break;
      case 'Aptitude Test':
        badgeColor = AppColors.secondary.withOpacity(0.12);
        textColor = AppColors.secondary;
        break;
      case 'Rejected':
        badgeColor = AppColors.error.withOpacity(0.12);
        textColor = AppColors.error;
        break;
      default: // Applied
        badgeColor = AppColors.textMuted.withOpacity(0.12);
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStepper(String status) {
    final stages = ['Applied', 'Aptitude Test', 'Interview', 'Selected'];
    final currentIdx = stages.indexOf(status);
    final isRejected = status == 'Rejected';

    return Row(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        final isCompleted = index <= currentIdx;
        final isCurrent = index == currentIdx;

        Color circleColor;
        Color textColor;
        
        if (isRejected && index == 3) {
          circleColor = AppColors.error;
          textColor = AppColors.error;
        } else if (isCompleted) {
          circleColor = AppColors.primary;
          textColor = AppColors.primaryLight;
        } else {
          circleColor = AppColors.border;
          textColor = AppColors.textMuted;
        }

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  // Left connector line
                  Expanded(
                    child: Container(
                      height: 3,
                      color: index == 0
                          ? Colors.transparent
                          : (index <= currentIdx ? AppColors.primary : AppColors.border),
                    ),
                  ),
                  // Icon node
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent ? Colors.white : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isCompleted && !isCurrent
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                  // Right connector line
                  Expanded(
                    child: Container(
                      height: 3,
                      color: index == stages.length - 1
                          ? Colors.transparent
                          : (index < currentIdx ? AppColors.primary : AppColors.border),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isRejected && index == 3 ? 'Rejected' : stage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? textColor : AppColors.textMuted,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 64, color: AppColors.textMuted),
          SizedBox(height: 16),
          Text(
            'No Applications Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 8),
          Text(
            'Go to the Jobs page and apply to active recruitment drives.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
