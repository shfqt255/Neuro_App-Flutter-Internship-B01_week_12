class ReviewModel {
  final String id;
  final String userid;
  double ratings;
  final String comment;
  int helpfulvotes;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userid,
    required this.ratings,
    required this.comment,
    required this.helpfulvotes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userid': userid,
      'ratings': ratings,
      'comment': comment,
      'helpfulvotes': helpfulvotes,
      'createdAt': createdAt.toString(),
    };
  }

  factory ReviewModel.fromMap(String id, Map<String, dynamic> data) {
    return ReviewModel(
      id: id,
      userid: data['userid'],
      ratings: data['ratings'],
      comment: data['comment'],
      helpfulvotes: (data['helpfulvotes'] is int) ? data['helpfulvotes'] : int.tryParse(data['helpfulvotes'].toString()) ?? 0,
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
