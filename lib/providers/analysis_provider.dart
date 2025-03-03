import 'dart:io';
import 'package:flutter/foundation.dart';

class MonetizationIdea {
  final String title;
  final String description;
  final String type;
  final double estimatedValue;
  final List<String> steps;

  MonetizationIdea({
    required this.title,
    required this.description,
    required this.type,
    required this.estimatedValue,
    required this.steps,
  });
}

class AnalysisProvider with ChangeNotifier {
  bool _isAnalyzing = false;
  String? _error;
  List<MonetizationIdea> _ideas = [];

  bool get isAnalyzing => _isAnalyzing;
  String? get error => _error;
  List<MonetizationIdea> get ideas => _ideas;

  Future<void> analyzeImage(File imageFile) async {
    try {
      _isAnalyzing = true;
      _error = null;
      _ideas = [];
      notifyListeners();

      // TODO: Implement actual API calls to Vision API and GPT
      await Future.delayed(const Duration(seconds: 3));

      // Mock response for now
      _ideas = [
        MonetizationIdea(
          title: 'Sell on Marketplace',
          description: 'List this item on popular marketplaces',
          type: 'Quick Sale',
          estimatedValue: 150.0,
          steps: [
            'Take high-quality photos',
            'Research market prices',
            'Create compelling listing',
            'Handle shipping safely',
          ],
        ),
        MonetizationIdea(
          title: 'Start a Rental Business',
          description: 'Rent out similar items for passive income',
          type: 'Business',
          estimatedValue: 500.0,
          steps: [
            'Source similar items',
            'Set up booking system',
            'Create rental agreements',
            'Handle maintenance',
          ],
        ),
      ];

      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to analyze image: $e';
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  void reset() {
    _isAnalyzing = false;
    _error = null;
    _ideas = [];
    notifyListeners();
  }
}
