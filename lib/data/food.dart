class Food {
  final String chefName;
  final String chefImageUrl;
  final String menuName;
  final String ingredients;
  final String foodImageUrl;
  bool isFavorite;
  late List<String> searchkeywords;

  Food({
    required this.menuName,
    required this.chefName,
    required this.chefImageUrl,
    required this.ingredients,
    required this.foodImageUrl,
    required this.isFavorite,
  });

  factory Food.fromJson(Map<String, dynamic> foodMap) {
    return Food(
      menuName: foodMap['menu_name'] ?? '',
      chefName: foodMap['chef']?['name'] ?? '',
      chefImageUrl: foodMap['chef']?['image_url'] ?? '',
      ingredients: foodMap['ingredients'] ?? '',
      foodImageUrl: foodMap['image_url'] ?? '',
      isFavorite: foodMap['is_favorite'] ?? false,
    );
  }

  void clickLike() {
    isFavorite = !isFavorite;
  }
}
