class UserModel {
  String? userId;
  String? userName;
  String? userPhoneNumber;
  String? addedOn;
  String? userEmail;
  String? userMemberId;
  String? userPassword;
  String? userImage;
  String? userAddress;
  String? deviceToken;

  UserModel(
      {this.userName,
      this.userPhoneNumber,
      this.addedOn,
      this.userId,
      this.userEmail,
      this.userAddress,
      this.userMemberId,
      this.userPassword,
      this.deviceToken,
      this.userImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userPhoneNumber = json['user_phone_number'];
    addedOn = json['added_on'];
    userEmail = json['user_email'];
    userAddress = json['user_address'];
    userMemberId = json['user_member_id'];
    userPassword = json['user_password'];
    userImage = json['user_image'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_phone_number'] = this.userPhoneNumber;
    data['added_on'] = this.addedOn;
    data['user_email'] = this.userEmail;
    data['user_address'] = this.userAddress;
    data['user_member_id'] = this.userMemberId;
    data['user_password'] = this.userPassword;
    data['user_image'] = this.userImage;
    data['device_token'] = this.deviceToken;
    return data;
  }
}
