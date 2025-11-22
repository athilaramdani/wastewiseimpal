import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';
import '../../../data/models/report_record.dart';
import '../../../routes/app_pages.dart';

class HistoryController extends GetxController {
  final reports = <ReportRecord>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final client = SClient.I;
      final currentUser = client.auth.currentUser;

      if (currentUser == null) {
        errorMessage.value = 'Session expired. Please login again.';
        reports.clear();
        return;
      }

      final List<dynamic> result = await client
          .from('reports')
          .select('*')
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      reports
        ..clear()
        ..addAll(
          result.map((item) {
            if (item is Map<String, dynamic>) {
              return ReportRecord.fromMap(item);
            }
            return ReportRecord.fromMap(Map<String, dynamic>.from(item as Map));
          }),
        );
    } on PostgrestException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'Unable to load history: $error';
    } finally {
      isLoading.value = false;
    }
  }

  void openDetail(ReportRecord report) {
    Get.toNamed(Routes.REPORT_DETAIL, arguments: report);
  }
}
