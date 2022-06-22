class ProductModel {
  String title;
  String altTitle;
  String shortDescription;
  String description;
  String category;
  String unit;
  String brand;
  int netWeight;
  String attributes;
  //Must CHANGE TO FLOAT LATER
  int buyingPrice;
  int sellingPrice;
  int salePrice;
  int discountPrice;
  int vat;

  ProductModel(
      this.title,
      this.altTitle,
      this.shortDescription,
      this.description,
      this.category,
      this.unit,
      this.brand,
      this.netWeight,
      this.attributes,
      this.buyingPrice,
      this.sellingPrice,
      this.salePrice,
      this.discountPrice,
      this.vat);
}
