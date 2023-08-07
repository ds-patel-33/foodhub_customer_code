class UserNotification {
  String? notificationMessage;
  String? addedOn;
  String? orderId;
  String? restaurantId;

  UserNotification(
      {this.notificationMessage,
      this.addedOn,
      this.orderId,
      this.restaurantId});

  UserNotification.fromJson(Map<String, dynamic> json) {
    notificationMessage = json['notification_message'];
    addedOn = json['added_on'];
    orderId = json['order_id'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_message'] = this.notificationMessage;
    data['added_on'] = this.addedOn;
    data['order_id'] = this.orderId;
    data['restaurant_id'] = this.restaurantId;
    return data;
  }
}
