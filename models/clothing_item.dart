class ClothingItem {
  final String id;
  final String name;
  final String category; // เช่น เสื้อ, กางเกง, รองเท้า
  final String colorTone;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.colorTone,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'colorTone': colorTone,
      };

  factory ClothingItem.fromJson(Map<String, dynamic> json) => ClothingItem(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        colorTone: json['colorTone'],
      );
}