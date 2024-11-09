class DatabaseModel {
  final int id;
  final DateTime createdAt;
  final String tile;
  final String details;
  DatabaseModel({
    required this.id,
    required this.createdAt,
    required this.tile,
    required this.details,
  });
}