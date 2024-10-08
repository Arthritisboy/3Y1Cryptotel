enum FoodCategory { mostPopular, breakFast, drinks, lunch, dinner }

class FoodItem {
  final String imagePath;
  final String title;
  final String shortDescription;
  final double price;
  final List<FoodCategory> categories;

  FoodItem({
    required this.imagePath,
    required this.title,
    required this.shortDescription,
    required this.price,
    required this.categories,
  });
}
