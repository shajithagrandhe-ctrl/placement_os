import '../../features/jobs/domain/entities/job.dart';

final List<Job> mockJobs = [
  Job(
    id: 'google-swe',
    title: 'Software Engineer',
    company: 'Google',
    logoText: 'G',
    location: 'Mountain View, CA (Hybrid)',
    salary: '\$140,000 - \$180,000 / yr',
    type: 'Full-time',
    deadline: 'Aug 15, 2026',
    description: 'We are seeking a Software Engineer to join our core product teams. You will work on building scalable applications, optimization algorithms, and infrastructure that powers billions of users.',
    requirements: [
      'Bachelor degree in Computer Science, or equivalent practical experience.',
      'Experience in software development in one or more general-purpose programming languages (e.g. Java, C++, Python, Go).',
      'Knowledge of data structures, algorithms, and software design.'
    ],
    skillsNeeded: ['Java', 'C++', 'Python', 'Algorithms', 'Distributed Systems'],
    eligibility: 'CGPA >= 8.5, No Active Backlogs',
  ),
  Job(
    id: 'meta-flutter',
    title: 'Mobile Engineer (Flutter)',
    company: 'Meta',
    logoText: 'M',
    location: 'Seattle, WA (Remote)',
    salary: '\$150,000 - \$195,000 / yr',
    type: 'Full-time',
    deadline: 'Aug 22, 2026',
    description: 'Join the product engineering team building next-generation hybrid applications. You will be responsible for defining UI standards, performance profiling, and state management optimization.',
    requirements: [
      '3+ years of experience in mobile application development.',
      'Proficiency in Dart and Flutter framework.',
      'Knowledge of mobile architectures (MVVM, Clean Architecture) and state management libraries.'
    ],
    skillsNeeded: ['Flutter', 'Dart', 'Riverpod', 'Clean Architecture', 'REST APIs'],
    eligibility: 'CGPA >= 8.0',
  ),
  Job(
    id: 'stripe-intern',
    title: 'Backend Engineering Intern',
    company: 'Stripe',
    logoText: 'S',
    location: 'San Francisco, CA (Hybrid)',
    salary: '\$48 / hr',
    type: 'Internship',
    deadline: 'Aug 10, 2026',
    description: 'Stripe is looking for backend interns to help build financial infrastructure. You will work on API reliability, data pipeline migrations, and transaction processing safety mechanisms.',
    requirements: [
      'Currently pursuing a degree in Computer Science, Software Engineering or related fields.',
      'Experience writing clean, tested backend code.',
      'Familiarity with SQL databases and API integrations.'
    ],
    skillsNeeded: ['Ruby', 'Go', 'PostgreSQL', 'REST APIs', 'Unit Testing'],
    eligibility: 'CGPA >= 7.5',
  ),
  Job(
    id: 'netflix-sre',
    title: 'Site Reliability Engineer',
    company: 'Netflix',
    logoText: 'N',
    location: 'Los Gatos, CA',
    salary: '\$180,000 - \$240,000 / yr',
    type: 'Full-time',
    deadline: 'Aug 30, 2026',
    description: 'Ensure the resilience, latency and capacity of the global content delivery networks. You will automate deployment validation, perform chaos engineering, and optimize resource auto-scaling rules.',
    requirements: [
      'Experience in Linux systems administration, networking, and cloud services (AWS).',
      'Scripting capability in Python, Bash, or Go.',
      'Experience running large-scale container platforms (Kubernetes).'
    ],
    skillsNeeded: ['Kubernetes', 'AWS', 'Python', 'Docker', 'Linux'],
    eligibility: 'CGPA >= 8.0',
  ),
];
