class Category {
  int uniqueID;
  String name;
  Category(this.name, this.uniqueID);
}

class ProductCategory {
  int uniqueID;
  String name;
  List<Category> subcategories;

  ProductCategory(this.name, this.uniqueID, this.subcategories);
}
