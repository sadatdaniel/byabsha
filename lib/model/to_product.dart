class ProductList {
  final List<ToProduct> products;

  ProductList({
    required this.products,
  });

  factory ProductList.fromJson(List<dynamic> parsedJson) {
    List<ToProduct> products = <ToProduct>[];
    products = parsedJson.map((i) => ToProduct.fromJson(i)).toList();
    return ProductList(products: products);
  }
}

class ToProduct {
  final String? productName;
  final String? productPrice;
  final String? numberOfItem;

  ToProduct({
    this.productName,
    this.productPrice,
    this.numberOfItem,
  });

  factory ToProduct.fromJson(Map<String, dynamic> json) {
    return ToProduct(
      productName: json['Product Name'].toString(),
      productPrice: json['Product Price'].toString(),
      numberOfItem: json['Number of Item'].toString(),
    );
  }
}
