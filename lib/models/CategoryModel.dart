import 'package:flutter/material.dart';

class CategoryModel extends ChangeNotifier {
  String _selectedCategory = '';
  String _categoryImageUrl = '';

  String get selectedCategory => _selectedCategory;
  String get categoryImageUrl => _categoryImageUrl;

  void setSelectedCategory(String category, imageUrl) {
    _selectedCategory = category;
    _categoryImageUrl = imageUrl;
    notifyListeners();
  }
}
