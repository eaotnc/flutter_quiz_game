import 'package:flutter/material.dart';

class CategoryModel extends ChangeNotifier {
  String _selectedCategory = '';
  String _categoryImageUrl = '';
  String _difficulty = '';

  String get selectedCategory => _selectedCategory;
  String get categoryImageUrl => _categoryImageUrl;
  String get difficulty => _difficulty;

  void setSelectedCategory(String category, imageUrl) {
    _selectedCategory = category;
    _categoryImageUrl = imageUrl;
    notifyListeners();
  }

  void setDifficulty(String difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }
}
