class Job {
  final String id;
  final String title;
  final String company;
  final String logoText;
  final String location;
  final String salary;
  final String type; // e.g. Full-time, Internship
  final String deadline;
  final String description;
  final List<String> requirements;
  final List<String> skillsNeeded;
  final String eligibility;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.logoText,
    required this.location,
    required this.salary,
    required this.type,
    required this.deadline,
    required this.description,
    required this.requirements,
    required this.skillsNeeded,
    required this.eligibility,
  });
}
