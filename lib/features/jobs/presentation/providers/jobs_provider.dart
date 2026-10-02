import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/jobs_repository.dart';
import '../../data/repositories/jobs_repository_impl.dart';
import '../../data/datasources/jobs_remote_data_source.dart';
import '../../domain/usecases/get_jobs_usecase.dart';

// 1. Data Source Provider
final jobsRemoteDataSourceProvider = Provider<JobsRemoteDataSource>((ref) {
  return JobsRemoteDataSourceImpl();
});

// 2. Repository Provider
final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  final remoteDataSource = ref.watch(jobsRemoteDataSourceProvider);
  return JobsRepositoryImpl(remoteDataSource);
});

// 3. Use Case Provider
final getJobsUseCaseProvider = Provider<GetJobsUseCase>((ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return GetJobsUseCase(repository);
});

// 4. Filter State Classes
class JobsFilter {
  final String searchQuery;
  final String jobType; // 'All', 'Full-time', 'Internship'

  JobsFilter({
    this.searchQuery = '',
    this.jobType = 'All',
  });

  JobsFilter copyWith({
    String? searchQuery,
    String? jobType,
  }) {
    return JobsFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      jobType: jobType ?? this.jobType,
    );
  }
}

class JobsFilterNotifier extends StateNotifier<JobsFilter> {
  JobsFilterNotifier() : super(JobsFilter());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setJobType(String type) {
    state = state.copyWith(jobType: type);
  }
}

final jobsFilterProvider = StateNotifierProvider<JobsFilterNotifier, JobsFilter>((ref) {
  return JobsFilterNotifier();
});

// 5. Async Jobs Provider
final jobsListProvider = FutureProvider<List<Job>>((ref) async {
  final getJobsUseCase = ref.watch(getJobsUseCaseProvider);
  return await getJobsUseCase.execute();
});

// 6. Filtered Jobs Provider
final filteredJobsProvider = Provider<AsyncValue<List<Job>>>((ref) {
  final jobsAsync = ref.watch(jobsListProvider);
  final filter = ref.watch(jobsFilterProvider);

  return jobsAsync.whenData((jobs) {
    return jobs.where((job) {
      final matchesSearch = job.title.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
          job.company.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
          job.skillsNeeded.any((s) => s.toLowerCase().contains(filter.searchQuery.toLowerCase()));
          
      final matchesType = filter.jobType == 'All' || job.type == filter.jobType;
      
      return matchesSearch && matchesType;
    }).toList();
  });
});

// 7. Job Details Provider
final jobDetailsProvider = Provider.family<Job?, String>((ref, id) {
  final jobsAsync = ref.watch(jobsListProvider);
  return jobsAsync.maybeWhen(
    data: (jobs) {
      try {
        return jobs.firstWhere((j) => j.id == id);
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
});
