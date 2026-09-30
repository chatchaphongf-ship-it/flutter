class UserProfile {
  final double height;
  final double weight;
  final String skinTone;

  UserProfile({
    required this.height,
    required this.weight,
    required this.skinTone,
  });

  Map<String, dynamic> toJson() => {
        'height': height,
        'weight': weight,
        'skinTone': skinTone,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        height: json['height'],
        weight: json['weight'],
        skinTone: json['skinTone'],
      );
}