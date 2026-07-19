import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ScanRecord {
  const ScanRecord({
    required this.modelLabel,
    required this.yorubaName,
    required this.commonName,
    required this.scientificName,
    required this.igboName,
    required this.hausaName,
    required this.medicinalUses,
    required this.confidence,
    required this.scannedAt,
    required this.sourceLabel,
    required this.lowConfidence,
    required this.needsReview,
    required this.likelyUnsupported,
    required this.confidenceGap,
  });

  final String modelLabel;
  final String yorubaName;
  final String commonName;
  final String scientificName;
  final String igboName;
  final String hausaName;
  final String medicinalUses;
  final double confidence;
  final DateTime scannedAt;
  final String sourceLabel;
  final bool lowConfidence;
  final bool needsReview;
  final bool likelyUnsupported;
  final double confidenceGap;

  Map<String, dynamic> toJson() {
    return {
      'modelLabel': modelLabel,
      'yorubaName': yorubaName,
      'commonName': commonName,
      'scientificName': scientificName,
      'igboName': igboName,
      'hausaName': hausaName,
      'medicinalUses': medicinalUses,
      'confidence': confidence,
      'scannedAt': scannedAt.toIso8601String(),
      'sourceLabel': sourceLabel,
      'lowConfidence': lowConfidence,
      'needsReview': needsReview,
      'likelyUnsupported': likelyUnsupported,
      'confidenceGap': confidenceGap,
    };
  }

  factory ScanRecord.fromJson(Map<String, dynamic> json) {
    return ScanRecord(
      modelLabel: json['modelLabel'] as String,
      yorubaName: json['yorubaName'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      igboName: json['igboName'] as String,
      hausaName: json['hausaName'] as String,
      medicinalUses: json['medicinalUses'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      sourceLabel: json['sourceLabel'] as String,
      lowConfidence: json['lowConfidence'] as bool,
      needsReview:
          json['needsReview'] as bool? ??
          json['lowConfidence'] as bool? ??
          false,
      likelyUnsupported: json['likelyUnsupported'] as bool? ?? false,
      confidenceGap: (json['confidenceGap'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ScanHistoryStore {
  static const String _storageKey = 'scan_history';
  static const int _maxItems = 30;

  Future<List<ScanRecord>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_storageKey) ?? const <String>[];
    return values
        .map((value) => jsonDecode(value) as Map<String, dynamic>)
        .map(ScanRecord.fromJson)
        .toList(growable: false);
  }

  Future<void> save(List<ScanRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = records.take(_maxItems).toList(growable: false);
    final encoded = trimmed
        .map((record) => jsonEncode(record.toJson()))
        .toList(growable: false);
    await prefs.setStringList(_storageKey, encoded);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
