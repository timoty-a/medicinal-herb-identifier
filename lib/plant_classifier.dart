import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'plant_catalog.dart';

class RankedPrediction {
  const RankedPrediction({required this.profile, required this.confidence});

  final PlantProfile profile;
  final double confidence;
}

class ClassificationResult {
  const ClassificationResult({
    required this.topPrediction,
    required this.rankedPredictions,
  });

  final RankedPrediction topPrediction;
  final List<RankedPrediction> rankedPredictions;

  bool get isLowConfidence =>
      topPrediction.confidence < PlantCatalog.lowConfidenceThreshold;

  RankedPrediction? get runnerUpPrediction =>
      rankedPredictions.length > 1 ? rankedPredictions[1] : null;

  double get confidenceGap {
    final runnerUp = runnerUpPrediction;
    if (runnerUp == null) {
      return topPrediction.confidence;
    }
    return topPrediction.confidence - runnerUp.confidence;
  }

  bool get isLikelyUnsupported =>
      topPrediction.confidence < PlantCatalog.reviewConfidenceThreshold ||
      confidenceGap < PlantCatalog.reviewConfidenceGapThreshold;

  bool get needsReview => isLowConfidence || isLikelyUnsupported;
}

class PlantClassifier {
  static const String _modelAsset = 'assets/models/plant_classifier.tflite';
  static const String _labelsAsset = 'assets/config/labels.txt';
  static const int _inputSize = 224;

  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> load() async {
    if (_interpreter != null && _labels != null) {
      return;
    }

    final labelsFile = await rootBundle.loadString(_labelsAsset);
    final parsedLabels = labelsFile
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);

    final options = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset(_modelAsset, options: options);
    _labels = parsedLabels;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }

  Future<ClassificationResult> classify(File imageFile) async {
    final interpreter = _interpreter;
    final labels = _labels;

    if (interpreter == null || labels == null) {
      throw StateError('Classifier has not been loaded.');
    }

    final imageBytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) {
      throw StateError('The selected file could not be decoded as an image.');
    }

    final orientedImage = img.bakeOrientation(decodedImage);
    final resizedImage = img.copyResize(
      orientedImage,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.average,
    );

    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(_inputSize, (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    final output = List.generate(
      1,
      (_) => List<double>.filled(labels.length, 0),
    );
    interpreter.run(input, output);

    final rankedPredictions = List.generate(labels.length, (index) {
      return RankedPrediction(
        profile: PlantCatalog.profileForLabel(labels[index]),
        confidence: output.first[index],
      );
    })..sort((a, b) => b.confidence.compareTo(a.confidence));

    return ClassificationResult(
      topPrediction: rankedPredictions.first,
      rankedPredictions: rankedPredictions,
    );
  }
}
