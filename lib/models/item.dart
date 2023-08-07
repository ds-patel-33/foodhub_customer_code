class Item {
  String? itemId;
  String? itemImage;
  String? itemName;
  double? itemPrice;
  int? itemQuantity;
  String? itemDescription;
  String? categoryId;
  String? restaurantId;
  bool itemAvailableInStock = true;
  int? itemType;
  bool itemShowInPopular = false;
  String? addedOn;

  Item(
      {this.itemId,
      this.itemName,
      this.itemImage,
      this.itemPrice,
      this.itemQuantity,
      this.itemDescription,
      this.categoryId,
      this.itemType,
      this.restaurantId,
      this.itemAvailableInStock = true,
      this.itemShowInPopular = false,
      this.addedOn});

  Item.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemId = json['item_id'];
    itemImage = json['item_image'];
    itemType = json['item_type'];
    categoryId = json['category_id'];
    restaurantId = json['restaurant_id'];
    itemPrice = json['item_price'];
    itemQuantity = json['item_quantity'];
    itemDescription = json['item_description'];
    itemAvailableInStock = json['item_available_in_stock'];
    itemShowInPopular = json['item_show_in_popular'];
    addedOn = json['added_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_name'] = this.itemName;
    data['item_id'] = this.itemId;
    data['item_type'] = this.itemType;
    data['item_image'] = this.itemImage;
    data['category_id'] = this.categoryId;
    data['restaurant_id'] = this.restaurantId;
    data['item_price'] = this.itemPrice;
    data['item_quantity'] = this.itemQuantity;
    data['item_description'] = this.itemDescription;
    data['category_id'] = this.categoryId;
    data['item_available_in_stock'] = this.itemAvailableInStock;
    data['item_show_in_popular'] = this.itemShowInPopular;
    data['added_on'] = this.addedOn;
    return data;
  }
}
