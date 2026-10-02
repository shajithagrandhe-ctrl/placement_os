import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../applications/presentation/providers/applications_provider.dart';
import '../providers/jobs_provider.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(jobDetailsProvider(jobId));
    final applications = ref.watch(applicationsProvider);
    
    if (job == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Job Details')),
        body: const Center(
          child: Text('Job not found.', style: TextStyle(color: AppColors.textPrimary)),
        ),
      );
    }

    final isApplied = applications.any((app) => app.job.id == job.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/jobs'),
        ),
        title: Text(job.company),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ResponsiveBuilder(
          mobile: (context) => _buildDetailLayout(context, ref, job, isApplied),
          desktop: (context) => Center(
            child: SizedBox(
              width: 800,
              child: _buildDetailLayout(context, ref, job, isApplied),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailLayout(BuildContext context, WidgetRef ref, dynamic job, bool isApplied) {
    // Get resume name from Hive storage
    final resumeName = HiveService.getProfileValue<String>('resumeName') ?? 'Resume_Not_Found.pdf';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Info Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        job.logoText,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            job.company,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.border),
                const SizedBox(height: 24),
                
                // Details Grid
                _buildInfoGrid(context, job),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Job Description
        const Text(
          'Role Overview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Text(
          job.description,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.6),
        ),
        const SizedBox(height: 32),

        // Requirements List
        const Text(
          'Minimum Requirements',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ...List.generate(job.requirements.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Icon(Icons.circle, size: 6, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    job.requirements[index],
                    style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 32),

        // Skills Needed
        const Text(
          'Skills Highlighted',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (job.skillsNeeded as List<String>).map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                skill,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        // Eligibility Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryLight, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Academic Eligibility Criteria',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.eligibility,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // Action Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isApplied ? null : () => _showApplyBottomSheet(context, ref, job, resumeName),
            style: ElevatedButton.styleFrom(
              backgroundColor: isApplied ? AppColors.surfaceLight : AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isApplied ? 'Application Submitted' : 'Apply Now',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context, dynamic job) {
    final infoItems = [
      _InfoGridItem(Icons.location_on_outlined, 'Location', job.location),
      _InfoGridItem(Icons.payments_outlined, 'Compensation', job.salary),
      _InfoGridItem(Icons.work_history_outlined, 'Job Type', job.type),
      _InfoGridItem(Icons.event_busy_outlined, 'Deadline', job.deadline),
    ];

    final isMobile = ResponsiveLayout.isMobile(context);

    return isMobile
        ? Column(
            children: infoItems
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildInfoRow(item),
                    ))
                .toList(),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 4,
            ),
            itemCount: infoItems.length,
            itemBuilder: (context, index) => _buildInfoRow(infoItems[index]),
          );
  }

  Widget _buildInfoRow(_InfoGridItem item) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: AppColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showApplyBottomSheet(BuildContext context, WidgetRef ref, dynamic job, String resumeName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Submit Application',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'You are applying for the ${job.title} role at ${job.company}.',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              
              // Resume Container info
              const Text(
                'Attached Resume',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        resumeName,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await ref.read(applicationsProvider.notifier).applyForJob(job);
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Successfully applied to ${job.company}!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoGridItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoGridItem(this.icon, this.label, this.value);
}
