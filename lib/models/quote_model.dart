class QuoteModel {
  final String id;
  final String quote;
  final String author;
  final String year;
  final String category;
  final String? createdAt;
  final String? updatedAt;

  QuoteModel({
    required this.id,
    required this.quote,
    required this.author,
    required this.year,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      // Support both '_id' from MongoDB and standard 'id'
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      quote: json['quote']?.toString() ?? '',
      author: json['author']?.toString() ?? 'Unknown',
      year: json['year']?.toString() ?? 'Unknown',
      category: json['category']?.toString() ?? 'General',
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': quote,
      'author': author,
      'year': year,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // To facilitate caching easily
  QuoteModel copyWith({
    String? id,
    String? quote,
    String? author,
    String? year,
    String? category,
    String? createdAt,
    String? updatedAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      quote: quote ?? this.quote,
      author: author ?? this.author,
      year: year ?? this.year,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
