import 'package:hive_flutter/hive_flutter.dart';

import '../models/submission_dto.dart';

class HiveSubmissionDatasource {
  HiveSubmissionDatasource(this._box);

  static const boxName = 'submissions';

  final Box<Map> _box;

  static Future<HiveSubmissionDatasource> create() async {
    final box = await Hive.openBox<Map>(boxName);
    return HiveSubmissionDatasource(box);
  }

  List<SubmissionDto> getAll() {
    return _box.values
        .map((raw) => SubmissionDto.fromJson(Map<dynamic, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  SubmissionDto? getById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return SubmissionDto.fromJson(Map<dynamic, dynamic>.from(raw));
  }

  Future<void> save(SubmissionDto dto) async {
    await _box.put(dto.id, dto.toJson());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
