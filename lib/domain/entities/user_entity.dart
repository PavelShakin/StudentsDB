class User {
  final int id;
  final String fullName;
  final String group;
  final String phoneNumber;

  User({required this.id,
    required this.fullName,
    required this.group,
    required this.phoneNumber});

  User.fromMap(Map<String, dynamic> item)
      :
        id = item["id"],
        fullName = item["fullName"],
        group = item["group"],
        phoneNumber = item["phoneNumber"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'group': group,
      'phoneNumber': phoneNumber
    };
  }
}
