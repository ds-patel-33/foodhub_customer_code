class OrderModel {
  String? orderId;
  String? restaurantId;
  String? userId;
  int? orderStatus;
  double? orderPrice;
  String? deliveryAddress;
  int? hole;
  int? deliveryType;
  int? paymentMethod;
  bool? stripPaymentStatus;
  String? stripPaymentId;
  String? stripPaymentMethodId;
  String? orderNotes;
  double? tip;
  double? salesTax;
  double? deliveryCharge;
  int? numberOfItems;
  int? orderQuantity;
  String? orderCancelledReason;
  String? orderDate;
  String? orderTime;
  String? addedOn;

  OrderModel(
      {this.orderId,
      this.restaurantId,
      this.userId,
      this.orderDate,
      this.orderTime,
      this.addedOn,
      this.deliveryType,
      this.orderPrice,
      this.paymentMethod,
      this.deliveryAddress,
      this.hole,
      this.orderStatus,
      this.orderNotes,
      this.tip,
      this.salesTax,
      this.deliveryCharge,
      this.numberOfItems,
      this.orderQuantity,
      this.stripPaymentStatus,
      this.stripPaymentId,
      this.stripPaymentMethodId,
      this.orderCancelledReason});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    restaurantId = json['restaurant_id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    orderTime = json['order_time'];
    addedOn = json['added_on'];
    deliveryAddress = json['delivery_address'];
    deliveryType = json['delivery_type'];
    orderStatus = json['order_status'];
    orderPrice = json['order_price'];
    paymentMethod = json['payment_method'];
    stripPaymentId = json['strip_payment_id'];
    stripPaymentStatus = json['strip_payment_status'];
    stripPaymentMethodId = json['strip_payment_method_id'];
    hole = json['hole'];
    orderNotes = json['order_notes'];
    tip = json['tip'];
    salesTax = json['sales_tax'];
    deliveryCharge = json['delivery_charge'];
    numberOfItems = json['number_of_items'];
    orderQuantity = json['order_quantity'];
    orderCancelledReason = json['order_cancelled_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['restaurant_id'] = this.restaurantId;
    data['user_id'] = this.userId;
    data['order_date'] = this.orderDate;
    data['order_time'] = this.orderTime;
    data['added_on'] = this.addedOn;
    data['delivery_type'] = this.deliveryType;
    data['delivery_address'] = this.deliveryAddress;
    data['order_status'] = this.orderStatus;
    data['order_price'] = this.orderPrice;
    data['payment_method'] = this.paymentMethod;
    data['hole'] = this.hole;
    data['order_notes'] = this.orderNotes;
    data['tip'] = this.tip;
    data['strip_payment_id'] = this.stripPaymentId;
    data['strip_payment_method_id'] = this.stripPaymentMethodId;
    data['strip_payment_status'] = this.stripPaymentStatus;
    data['sales_tax'] = this.salesTax;
    data['delivery_charge'] = this.deliveryCharge;
    data['number_of_items'] = this.numberOfItems;
    data['order_quantity'] = this.orderQuantity;
    data['order_cancelled_reason'] = this.orderCancelledReason;
    return data;
  }
}
