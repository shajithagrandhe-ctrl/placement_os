import '../../../../core/constants/mock_data.dart';
import '../models/job_model.dart';

abstract class JobsRemoteDataSource {
  Future<List<JobModel>> fetchJobs();
}

class JobsRemoteDataSourceImpl implements JobsRemoteDataSource {
  @override
  Future<List<JobModel>> fetchJobs() async {
    // Simulate remote network latency
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Map domain Job entities from mockJobs into JobModels
    return mockJobs.map((job) => JobModel(
      id: job.id,
      title: job.title,
      company: job.company,
      logoText: job.logoText,
      location: job.location,
      salary: job.salary,
      type: job.type,
      deadline: job.deadline,
      description: job.description,
      requirements: job.requirements,
      skillsNeeded: job.skillsNeeded,
      eligibility: job.eligibility,
    )).toList();
  }
}
