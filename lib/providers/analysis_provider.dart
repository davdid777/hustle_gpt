import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AnalysisProvider with ChangeNotifier {
  bool _isAnalyzing = false;
  String _result = '';
  List<String> _moneyMakingIdeas = [];

  bool get isAnalyzing => _isAnalyzing;
  String get result => _result;
  List<String> get moneyMakingIdeas => _moneyMakingIdeas;

  Future<void> analyzeImage(File imageFile) async {
    try {
      _isAnalyzing = true;
      _result = '';
      _moneyMakingIdeas = [];
      notifyListeners();

      // TODO: Implement actual API call to Vision API and GPT
      // This is a mock response for now
      await Future.delayed(const Duration(seconds: 2));

      _result = 'Image analyzed successfully';
      _moneyMakingIdeas = [
        'Sell this item on eBay for quick cash',
        'Start a rental service for similar items',
        'Create a tutorial video about this item',
        'Use it for a subscription box business',
      ];

      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      _isAnalyzing = false;
      _result = 'Error analyzing image: $e';
      notifyListeners();
    }
  }

  void reset() {
    _isAnalyzing = false;
    _result = '';
    _moneyMakingIdeas = [];
    notifyListeners();
  }
}
