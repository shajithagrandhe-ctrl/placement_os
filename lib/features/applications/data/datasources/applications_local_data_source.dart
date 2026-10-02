import 'package:hive/hive.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/application_model.dart';
import '../../../../core/constants/mock_data.dart';
import '../../../jobs/data/models/job_model.dart';

abstract class ApplicationsLocalDataSource {
  Future<List<ApplicationModel>> getApplications();
  Future<void> saveApplication(ApplicationModel application);
  Future<void> updateApplication(ApplicationModel application);
}

class ApplicationsLocalDataSourceImpl implements ApplicationsLocalDataSource {
  final Box _box = HiveService.applicationsBox;

  @override
  Future<List<ApplicationModel>> getApplications() async {
    if (_box.isEmpty) {
      final defaultApp1 = ApplicationModel(
        id: 'app-uber',
        job: JobModel(
          id: mockJobs[0].id,
          title: mockJobs[0].title,
          company: mockJobs[0].company,
          logoText: mockJobs[0].logoText,
          location: mockJobs[0].location,
          salary: mockJobs[0].salary,
          type: mockJobs[0].type,
          deadline: mockJobs[0].deadline,
          description: mockJobs[0].description,
          requirements: mockJobs[0].requirements,
          skillsNeeded: mockJobs[0].skillsNeeded,
          eligibility: mockJobs[0].eligibility,
        ),
        appliedDate: DateTime.now().subtract(const Duration(days: 8)),
        status: 'Interview',
        statusStep: 'Round 2: Technical Interview (July 27, 10:00 AM)',
        feedback: 'Coding assessment cleared successfully with score 400/400.',
      );

      final defaultApp2 = ApplicationModel(
        id: 'app-stripe',
        job: JobModel(
          id: mockJobs[2].id,
          title: mockJobs[2].title,
          company: mockJobs[2].company,
          logoText: mockJobs[2].logoText,
          location: mockJobs[2].location,
          salary: mockJobs[2].salary,
          type: mockJobs[2].type,
          deadline: mockJobs[2].deadline,
          description: mockJobs[2].description,
          requirements: mockJobs[2].requirements,
          skillsNeeded: mockJobs[2].skillsNeeded,
          eligibility: mockJobs[2].eligibility,
        ),
        appliedDate: DateTime.now().subtract(const Duration(days: 3)),
        status: 'Applied',
        statusStep: 'Resume Screening',
        feedback: 'Your resume has been forwarded to the hiring team.',
      );

      await saveApplication(defaultApp1);
      await saveApplication(defaultApp2);
    }

    final List<ApplicationModel> list = [];
    for (final key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        list.add(ApplicationModel.fromMap(Map<String, dynamic>.from(data)));
      }
    }
    list.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
    return list;
  }

  @override
  Future<void> saveApplication(ApplicationModel application) async {
    await _box.put(application.id, application.toMap());
  }

  @override
  Future<void> updateApplication(ApplicationModel application) async {
    await _box.put(application.id, application.toMap());
  }
}
