import 'package:volume_vault/services/models/book_stats.dart';
import 'package:volume_vault/services/stats_service.dart';

class StatsController {
  final StatsService _service;

  StatsController({required StatsService service}) : _service = service;

  Future<BookStats> getUserBooksCount() async {
    return await _service.getUserBooksStats();
  }
}
