import '../../domain/entities/job.dart';
import '../../domain/repositories/jobs_repository.dart';
import '../datasources/jobs_remote_data_source.dart';

class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Job>> getJobs() async {
    return await remoteDataSource.fetchJobs();
  }

  @override
  Future<Job?> getJobById(String id) async {
    final jobs = await remoteDataSource.fetchJobs();
    try {
      return jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }
}
