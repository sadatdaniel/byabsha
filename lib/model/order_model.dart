class OrderModel {
  String productDetails;
  String castomerName;
  String paymentType;
  String orderDate;
  String approximateDeliveryDate;
  String additionalNote;
  bool isDeliverd;

  OrderModel(this.productDetails, this.castomerName, this.paymentType,
      this.orderDate, this.approximateDeliveryDate, this.additionalNote,
      {this.isDeliverd = false});
}
