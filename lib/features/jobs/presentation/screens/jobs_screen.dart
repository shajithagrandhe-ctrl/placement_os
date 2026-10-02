import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../providers/jobs_provider.dart';

class JobsScreen extends ConsumerWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(filteredJobsProvider);
    final filter = ref.watch(jobsFilterProvider);

    return Column(
      children: [
        // Search & Filter Panel
        _buildFilterHeader(context, ref, filter),

        // Jobs Grid/List
        Expanded(
          child: jobsAsync.when(
            data: (jobs) => jobs.isEmpty
                ? _buildEmptyState()
                : _buildJobsContent(context, jobs),
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            error: (err, stack) => Center(
              child: Text(
                'Error loading jobs: $err',
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterHeader(BuildContext context, WidgetRef ref, JobsFilter filter) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final padding = isDesktop ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16) : const EdgeInsets.all(16);

    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Search Field
          Expanded(
            flex: isDesktop ? 3 : 0,
            child: SizedBox(
              width: double.infinity,
              child: TextField(
                onChanged: (val) => ref.read(jobsFilterProvider.notifier).setSearchQuery(val),
                decoration: const InputDecoration(
                  hintText: 'Search roles, companies, or skills...',
                  prefixIcon: Icon(Icons.search, size: 20),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ),
          SizedBox(width: isDesktop ? 24 : 0, height: isDesktop ? 0 : 16),
          // Type filter chips
          Expanded(
            flex: isDesktop ? 2 : 0,
            child: Row(
              children: ['All', 'Full-time', 'Internship'].map((type) {
                final isSelected = filter.jobType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(jobsFilterProvider.notifier).setJobType(type);
                      }
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.background,
                    side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsContent(BuildContext context, List jobs) {
    final columns = ResponsiveLayout.select(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 2,
    );

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: ResponsiveLayout.isMobile(context) ? 1.15 : 1.35,
      ),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Company logo + details)
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        job.logoText,
                        style: const TextStyle(
                          fontSize: 20,
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
                            job.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job.company,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.type,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info row (Location, Salary)
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        job.location,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.payments_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      job.salary,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Skills row (Capsules)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (job.skillsNeeded as List<String>).take(3).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    );
                  }).toList(),
                ),

                const Spacer(),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Apply by: ${job.deadline}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to detail page
                        context.go('/jobs/${job.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 64, color: AppColors.textMuted),
          SizedBox(height: 16),
          Text(
            'No Jobs Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search keywords or filter settings.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
