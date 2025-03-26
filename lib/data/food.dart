class Food {
  final String country;
  final String chefName;
  final String chefImageUrl;
  final String menuName;
  final String ingredients;
  final String foodImageUrl;
  bool isFavorite;
  
  Food({
    required this.menuName,
    required this.country,
    required this.chefName,
    required this.chefImageUrl,
    required this.ingredients,
    required this.foodImageUrl,
    required this.isFavorite,
  });

  factory Food.fromJson(Map<String, dynamic> foodMap, String country) {
    return Food(
      menuName: foodMap['menu_name'] ?? '',
      country: country,
      chefName: foodMap['chef']?['name'] ?? '',
      chefImageUrl: foodMap['chef']?['image_url'] ?? '',
      ingredients: foodMap['ingredients'] ?? '',
      foodImageUrl: foodMap['image_url'] ?? '',
      isFavorite: foodMap['is_favorite'],
    );
  }

  void clickLike() {
    isFavorite = !isFavorite;
  }
}
