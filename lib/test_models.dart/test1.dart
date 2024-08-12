class ModelName {
  String? app_key;
  String? app_secret;
  String? access_token;
  orderinfoModel? orderinfo;

  ModelName({
    this.app_key,
    this.app_secret,
    this.access_token,
    this.orderinfo,
  });

  factory ModelName.fromJson(Map<String, dynamic> json) {
    return ModelName(
app_key: json['app_key'] ?? null,
app_secret: json['app_secret'] ?? null,
access_token: json['access_token'] ?? null,
orderinfo: json['orderinfo'] != null ? new orderinfoModel.fromJson(json['orderinfo']) : null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['app_key'] = this.app_key;
      data['app_secret'] = this.app_secret;
      data['access_token'] = this.access_token;
      data['orderinfo'] = this.orderinfo;
      return data;
}
}
class orderinfoModel {
  OrderInfoModel? OrderInfo;
  String? udid;
  String? device_type;

  orderinfoModel({
    this.OrderInfo,
    this.udid,
    this.device_type,
  });

  factory orderinfoModel.fromJson(Map<String, dynamic> json) {
    return orderinfoModel(
OrderInfo: json['OrderInfo'] != null ? new OrderInfoModel.fromJson(json['OrderInfo']) : null,
udid: json['udid'] ?? null,
device_type: json['device_type'] ?? null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['OrderInfo'] = this.OrderInfo;
      data['udid'] = this.udid;
      data['device_type'] = this.device_type;
      return data;
}
}
class OrderInfoModel {
  RestaurantModel? Restaurant;
  CustomerModel? Customer;
  OrderModel? Order;
  OrderItemModel? OrderItem;
  TaxModel? Tax;
  DiscountModel? Discount;

  OrderInfoModel({
    this.Restaurant,
    this.Customer,
    this.Order,
    this.OrderItem,
    this.Tax,
    this.Discount,
  });

  factory OrderInfoModel.fromJson(Map<String, dynamic> json) {
    return OrderInfoModel(
Restaurant: json['Restaurant'] != null ? new RestaurantModel.fromJson(json['Restaurant']) : null,
Customer: json['Customer'] != null ? new CustomerModel.fromJson(json['Customer']) : null,
Order: json['Order'] != null ? new OrderModel.fromJson(json['Order']) : null,
OrderItem: json['OrderItem'] != null ? new OrderItemModel.fromJson(json['OrderItem']) : null,
Tax: json['Tax'] != null ? new TaxModel.fromJson(json['Tax']) : null,
Discount: json['Discount'] != null ? new DiscountModel.fromJson(json['Discount']) : null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['Restaurant'] = this.Restaurant;
      data['Customer'] = this.Customer;
      data['Order'] = this.Order;
      data['OrderItem'] = this.OrderItem;
      data['Tax'] = this.Tax;
      data['Discount'] = this.Discount;
      return data;
}
}
class RestaurantModel {
  detailsModel? details;

  RestaurantModel({
    this.details,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
details: json['details'] != null ? new detailsModel.fromJson(json['details']) : null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['details'] = this.details;
      return data;
}
}
class detailsModel {
  String? res_name;
  String? address;
  String? contact_information;
  String? restID;

  detailsModel({
    this.res_name,
    this.address,
    this.contact_information,
    this.restID,
  });

  factory detailsModel.fromJson(Map<String, dynamic> json) {
    return detailsModel(
res_name: json['res_name'] ?? null,
address: json['address'] ?? null,
contact_information: json['contact_information'] ?? null,
restID: json['restID'] ?? null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['res_name'] = this.res_name;
      data['address'] = this.address;
      data['contact_information'] = this.contact_information;
      data['restID'] = this.restID;
      return data;
}
}
class CustomerModel {
  detailsModel? details;

  CustomerModel({
    this.details,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
details: json['details'] != null ? new detailsModel.fromJson(json['details']) : null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['details'] = this.details;
      return data;
}
}
class OrderModel {
  detailsModel? details;

  OrderModel({
    this.details,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
details: json['details'] != null ? new detailsModel.fromJson(json['details']) : null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['details'] = this.details;
      return data;
}
}
class OrderItemModel {
  List<dynamic>? details;

  OrderItemModel({
    this.details,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
details: json['details'] ?? null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['details'] = this.details;
      return data;
}
}
class TaxModel {
  List<dynamic>? details;

  TaxModel({
    this.details,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
details: json['details'] ?? null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['details'] = this.details;
      return data;
}
}
class DiscountModel {
  List<dynamic>? details;

  DiscountModel({
    this.details,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
details: json['details'] ?? null,
  );
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['details'] = this.details;
      return data;
}
}
