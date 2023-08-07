class Restaurant {
  String? restaurantId;
  String? restaurantEmail;
  String? restaurantPassword;
  String? restaurantName;
  String? restaurantManagerName;
  String? restaurantPhoneNumber;
  String? restaurantImage;
  String? restaurantAddress;
  String? restaurantState;
  String? restaurantCity;
  double? restaurantLat;
  double? restaurantLng;
  String? addedOn;
  String? deviceToken;
  bool? restaurantSetupDone;
  bool? restaurantOpen;

  Restaurant(
      {this.restaurantEmail,
      this.restaurantPassword,
      this.restaurantName,
      this.restaurantManagerName,
      this.restaurantPhoneNumber,
      this.restaurantImage,
      this.restaurantAddress,
      this.restaurantState,
      this.restaurantCity,
      this.restaurantLat,
      this.restaurantId,
      this.restaurantLng,
      this.addedOn,
      this.restaurantSetupDone,
      this.deviceToken,
      this.restaurantOpen});

  Restaurant.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantEmail = json['restaurant_email'];
    restaurantPassword = json['restaurant_password'];
    restaurantName = json['restaurant_name'];
    restaurantManagerName = json['restaurant_manager_name'];
    restaurantPhoneNumber = json['restaurant_phone_number'];
    restaurantImage = json['restaurant_image'];
    restaurantAddress = json['restaurant_address'];
    restaurantState = json['restaurant_state'];
    restaurantCity = json['restaurant_city'];
    restaurantLat = json['restaurant_lat'];
    restaurantLng = json['restaurant_lng'];
    addedOn = json['added_on'];
    deviceToken = json['device_token'];
    restaurantSetupDone = json['restaurant_setup_done'];
    restaurantOpen = json['restaurant_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_email'] = this.restaurantEmail;
    data['restaurant_password'] = this.restaurantPassword;
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_manager_name'] = this.restaurantManagerName;
    data['restaurant_phone_number'] = this.restaurantPhoneNumber;
    data['restaurant_image'] = this.restaurantImage;
    data['restaurant_address'] = this.restaurantAddress;
    data['restaurant_state'] = this.restaurantState;
    data['restaurant_city'] = this.restaurantCity;
    data['restaurant_lat'] = this.restaurantLat;
    data['restaurant_lng'] = this.restaurantLng;
    data['added_on'] = this.addedOn;
    data['device_token'] = this.deviceToken;
    data['restaurant_setup_done'] = this.restaurantSetupDone;
    data['restaurant_open'] = this.restaurantOpen;
    return data;
  }
}
