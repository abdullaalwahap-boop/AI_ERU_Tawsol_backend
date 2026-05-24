import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

// ---------- Student Courses ----------

final List<Course> mockStudentCourses = [
  const Course(
    id: 'cs301',
    name: 'Data Structures',
    code: 'CS301',
    doctorName: 'Dr. Ahmed Hassan',
    description:
        'Fundamental data structures and their algorithms including arrays, linked lists, trees, graphs, and hash tables.',
    accentColor: Color(0xff3D6FFF),
    studentCount: 28,
    contentCount: 12,
    duration: 48,
  ),
  const Course(
    id: 'cs302',
    name: 'Algorithms',
    code: 'CS302',
    doctorName: 'Dr. Sarah Mohamed',
    description:
        'Design and analysis of algorithms, complexity theory, sorting, searching, and dynamic programming.',
    accentColor: Color(0xff7C3AED),
    studentCount: 31,
    contentCount: 8,
    duration: 36,
  ),
  const Course(
    id: 'cs303',
    name: 'Operating Systems',
    code: 'CS303',
    doctorName: 'Dr. Khalid Ibrahim',
    description:
        'Operating system concepts including process management, memory management, file systems, and concurrency.',
    accentColor: Color(0xff059669),
    studentCount: 25,
    contentCount: 15,
    duration: 54,
  ),
  const Course(
    id: 'cs401',
    name: 'Database Systems',
    code: 'CS401',
    doctorName: 'Dr. Amira Samir',
    description:
        'Relational database design, SQL, normalization, transactions, and modern database architectures.',
    accentColor: Color(0xffEA580C),
    studentCount: 22,
    contentCount: 6,
    duration: 42,
  ),
];

// ---------- Doctor Courses ----------

final List<Course> mockDoctorCourses = [
  const Course(
    id: 'cs301',
    name: 'Data Structures',
    code: 'CS301',
    doctorName: 'Dr. Ahmed Hassan',
    description:
        'Fundamental data structures and their algorithms including arrays, linked lists, trees, graphs, and hash tables.',
    accentColor: Color(0xff3D6FFF),
    studentCount: 28,
    contentCount: 12,
    duration: 48,
  ),
  const Course(
    id: 'cs401adv',
    name: 'Advanced Algorithms',
    code: 'CS401',
    doctorName: 'Dr. Ahmed Hassan',
    description:
        'Advanced algorithmic techniques including approximation algorithms, randomized algorithms, and computational complexity.',
    accentColor: Color(0xff3D6FFF),
    studentCount: 19,
    contentCount: 9,
    duration: 60,
  ),
];

// ---------- Content for CS301 ----------

final List<CourseContent> mockContentCs301 = [
  CourseContent(
    id: 'cs301_c1',
    title: 'Lecture 1: Introduction to Data Structures',
    body:
        'Welcome to Data Structures! This lecture covers the fundamental concepts of data organization, abstract data types, and why efficient data structures matter in software engineering.',
    type: ContentType.material,
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
    attachments: [
      const ContentAttachment(
        name: 'Lecture_1_Intro_DS.pdf',
        sizeLabel: '3.2 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Ahmed Hassan',
  ),
  CourseContent(
    id: 'cs301_c2',
    title: 'Midterm Exam — November 20',
    body:
        'Dear Students, the midterm examination for Data Structures (CS301) is scheduled for November 20 at 10:00 AM in Hall A. The exam will cover all topics from Lectures 1 through 6. Please review your notes and practice problems.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    isFromAdmin: false,
    authorName: 'Dr. Ahmed Hassan',
  ),
  CourseContent(
    id: 'cs301_c3',
    title: 'Assignment 1: Linked Lists Implementation',
    body:
        'Implement a doubly linked list in C++ with full support for insertion, deletion, search, and reversal. Submit your source code and a brief report explaining your design choices. Deadline: November 15.',
    type: ContentType.assignment,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
    attachments: [
      const ContentAttachment(
        name: 'Assignment_1_Requirements.pdf',
        sizeLabel: '1.1 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Ahmed Hassan',
  ),
  CourseContent(
    id: 'cs301_c4',
    title: 'University Holiday — National Day',
    body:
        'Dear All, the university will be closed on November 23 in observance of the National Day holiday. All academic activities are suspended. Regular operations resume on November 24.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
    isFromAdmin: true,
    authorName: 'University Admin',
  ),
  CourseContent(
    id: 'cs301_c5',
    title: 'Chapter 3 Slides: Binary Trees & BST',
    body:
        'Slides for Chapter 3 covering Binary Trees, Binary Search Trees, insertion, deletion, and tree traversal algorithms (in-order, pre-order, post-order) are now available.',
    type: ContentType.material,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    attachments: [
      const ContentAttachment(
        name: 'Chapter3_BinaryTrees.pdf',
        sizeLabel: '4.7 MB',
        fileType: ContentFileType.pdf,
      ),
      const ContentAttachment(
        name: 'BST_Examples.png',
        sizeLabel: '0.8 MB',
        fileType: ContentFileType.image,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Ahmed Hassan',
  ),
  CourseContent(
    id: 'cs301_c6',
    title: 'Quiz 1 Results Published',
    body:
        'Quiz 1 results are now available on the student portal. The average score was 78%. Students scoring below 60% are encouraged to attend office hours for additional help before the midterm.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    isFromAdmin: false,
    authorName: 'Dr. Ahmed Hassan',
  ),
  CourseContent(
    id: 'cs301_c7',
    title: 'Assignment 2: Binary Search Tree Operations',
    body:
        'Implement a full Binary Search Tree with insert, delete, search, and all three traversal methods. Include time complexity analysis in your report. Deadline: December 1.',
    type: ContentType.assignment,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    attachments: [
      const ContentAttachment(
        name: 'Assignment_2_BST.pdf',
        sizeLabel: '1.4 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Ahmed Hassan',
  ),
  CourseContent(
    id: 'cs301_c8',
    title: 'Spring 2025 Registration Reminder',
    body:
        'Course registration for Spring 2025 opens December 8. Please consult your academic advisor and check prerequisite requirements before registering. Maximum 21 credit hours per semester.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    isFromAdmin: true,
    authorName: 'Academic Affairs',
  ),
];

// ---------- Content for CS302 ----------

final List<CourseContent> mockContentCs302 = [
  CourseContent(
    id: 'cs302_c1',
    title: 'Lecture Notes: Sorting Algorithms',
    body:
        'Comprehensive notes on comparison-based sorting algorithms including merge sort, quicksort, and heapsort, with time and space complexity analysis.',
    type: ContentType.material,
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
    attachments: [
      const ContentAttachment(
        name: 'Sorting_Algorithms_Notes.pdf',
        sizeLabel: '2.9 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Sarah Mohamed',
  ),
  CourseContent(
    id: 'cs302_c2',
    title: 'Assignment: Graph Traversal',
    body:
        'Implement BFS and DFS for a weighted undirected graph. Analyze the time complexity and test your implementation on the provided sample graphs. Deadline: November 28.',
    type: ContentType.assignment,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    attachments: [
      const ContentAttachment(
        name: 'Graph_Assignment.pdf',
        sizeLabel: '1.6 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Sarah Mohamed',
  ),
  CourseContent(
    id: 'cs302_c3',
    title: 'Lab Session Rescheduled',
    body:
        'The lab session for CS302 originally on Tuesday has been moved to Wednesday at 2:00 PM in Lab B-204 due to maintenance. Please update your schedules.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    isFromAdmin: false,
    authorName: 'Dr. Sarah Mohamed',
  ),
  CourseContent(
    id: 'cs302_c4',
    title: 'Semester Calendar Update',
    body:
        'Please review the updated academic calendar for the current semester on the university portal. Key dates include final exam registration (Dec 5-10) and final exams (Jan 8-20).',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isFromAdmin: true,
    authorName: 'University Admin',
  ),
];

// ---------- Content for CS303 ----------

final List<CourseContent> mockContentCs303 = [
  CourseContent(
    id: 'cs303_c1',
    title: 'Process Management Slides',
    body:
        'Slides covering process states, PCB, context switching, and process scheduling algorithms including FCFS, SJF, Round Robin, and Priority Scheduling.',
    type: ContentType.material,
    createdAt: DateTime.now().subtract(const Duration(days: 9)),
    attachments: [
      const ContentAttachment(
        name: 'Process_Management.pdf',
        sizeLabel: '5.1 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Khalid Ibrahim',
  ),
  CourseContent(
    id: 'cs303_c2',
    title: 'Assignment: Scheduling Simulator',
    body:
        'Build a CPU scheduling simulator that supports FCFS, SJF, and Round Robin. Visualize the Gantt chart and compute average waiting time and turnaround time.',
    type: ContentType.assignment,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    isFromAdmin: false,
    authorName: 'Dr. Khalid Ibrahim',
  ),
  CourseContent(
    id: 'cs303_c3',
    title: 'Mid-Term Exam Reminder',
    body:
        'The OS mid-term exam is on November 22 at 9:00 AM in Hall C. Bring your student ID. The exam covers Chapters 1-5. No electronic devices allowed.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isFromAdmin: false,
    authorName: 'Dr. Khalid Ibrahim',
  ),
  CourseContent(
    id: 'cs303_c4',
    title: 'Library System Maintenance',
    body:
        'The university library digital system will undergo maintenance on November 25 from 10 PM to 2 AM. Online resources will be temporarily unavailable during this window.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    isFromAdmin: true,
    authorName: 'IT Department',
  ),
];

// ---------- Content for CS401 ----------

final List<CourseContent> mockContentCs401 = [
  CourseContent(
    id: 'cs401_c1',
    title: 'Chapter 1: Relational Model',
    body:
        'Introduction to the relational data model, relations, keys, schemas, and the relational algebra including selection, projection, join, and set operations.',
    type: ContentType.material,
    createdAt: DateTime.now().subtract(const Duration(days: 11)),
    attachments: [
      const ContentAttachment(
        name: 'Chapter1_Relational_Model.pdf',
        sizeLabel: '3.8 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Amira Samir',
  ),
  CourseContent(
    id: 'cs401_c2',
    title: 'SQL Project: University DB',
    body:
        'Design and implement a university database schema. Create tables, apply normalization up to 3NF, and write at least 20 SQL queries covering joins, aggregates, and subqueries.',
    type: ContentType.assignment,
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
    attachments: [
      const ContentAttachment(
        name: 'DB_Project_Requirements.pdf',
        sizeLabel: '2.2 MB',
        fileType: ContentFileType.pdf,
      ),
    ],
    isFromAdmin: false,
    authorName: 'Dr. Amira Samir',
  ),
  CourseContent(
    id: 'cs401_c3',
    title: 'Office Hours Schedule Change',
    body:
        'Office hours are now every Tuesday and Thursday from 2:00 PM to 4:00 PM in Room 305. Please book your slot via the student portal to avoid waiting.',
    type: ContentType.announcement,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isFromAdmin: false,
    authorName: 'Dr. Amira Samir',
  ),
];

// ---------- Content Map ----------

final Map<String, List<CourseContent>> mockCourseContentMap = {
  'cs301': mockContentCs301,
  'cs302': mockContentCs302,
  'cs303': mockContentCs303,
  'cs401': mockContentCs401,
  'cs401adv': mockContentCs401,
};
