class Carts {
  String name;
  String imageUrl;
  String uuid;

  Carts({
    required this.name,
    required this.imageUrl,
    required this.uuid,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": imageUrl,
    "uuid": uuid,
  };
}