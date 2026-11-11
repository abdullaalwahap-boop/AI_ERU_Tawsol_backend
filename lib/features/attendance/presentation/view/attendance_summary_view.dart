import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/attendance/data/models/attendance_models.dart';
import 'package:ai_eru_tawasol/features/attendance/presentation/view/attendance_scanner_view.dart';
import 'package:flutter/material.dart';

class AttendanceSummaryView extends StatefulWidget {
  const AttendanceSummaryView({super.key});

  static const String routeName = '/attendance-summary';

  @override
  State<AttendanceSummaryView> createState() => _AttendanceSummaryViewState();
}

class _AttendanceSummaryViewState extends State<AttendanceSummaryView> {
  late Future<List<CourseAttendanceSummary>> _futureSummary;
  late final AttendanceRemoteDatasource _datasource;

  @override
  void initState() {
    super.initState();
    _datasource = getIt<AttendanceRemoteDatasource>();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _futureSummary = _datasource.getMySummary();
    });
  }

  Color _rateColor(double rate) {
    if (rate >= 85) return const Color(0xFF10B981);
    if (rate >= 75) return Colors.amber.shade700;
    return const Color(0xFFF43F5E);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحضور والغياب', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'مسح كود الحضور',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AttendanceScannerView()),
              );
              if (result == true) {
                _refresh();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
        label: const Text('تسجيل حضور الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceScannerView()),
          );
          if (result == true) {
            _refresh();
          }
        },
      ),
      body: FutureBuilder<List<CourseAttendanceSummary>>(
        future: _futureSummary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.amber),
                  const SizedBox(height: 12),
                  Text('تعذر تحميل سجل الحضور: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _refresh, child: const Text('إعادة المحاولة')),
                ],
              ),
            );
          }

          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(
              child: Text('لا توجد بيانات حضور مسجلة لك حالياً', style: TextStyle(color: Colors.grey)),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final item = list[i];
                final rateColor = _rateColor(item.attendanceRate);

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.courseName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: rateColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${item.attendanceRate}%',
                                style: TextStyle(color: rateColor, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'حضور ${item.attendedSessions} من إجمالي ${item.totalSessions} محاضرة',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: item.totalSessions > 0
                                ? (item.attendedSessions / item.totalSessions).clamp(0.0, 1.0)
                                : 1.0,
                            backgroundColor: Colors.grey.withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(rateColor),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
