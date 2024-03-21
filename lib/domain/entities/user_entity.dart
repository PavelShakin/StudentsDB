class User {
  final int? id;
  final String fullName;
  final String userGroup;
  final String phoneNumber;

  User({this.id,
    required this.fullName,
    required this.userGroup,
    required this.phoneNumber});

  User.fromMap(Map<String, dynamic> item)
      :
        id = item["id"],
        fullName = item["fullName"],
        userGroup = item["userGroup"],
        phoneNumber = item["phoneNumber"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'userGroup': userGroup,
      'phoneNumber': phoneNumber
    };
  }
}
