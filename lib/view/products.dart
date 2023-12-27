// ignore_for_file: avoid_print

import 'package:byabsha/model/product_model.dart';
import 'package:byabsha/stub/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Category {
  all,
  dryFoods,
  toiletries,
  consumerFoods,
  grocery,
  cosmetics,
  mensClothing,
  womensClothing,
  kidsClothing
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offset;
  Category? _selectedCategory;
  // late FocusNode searchFieldFocusNode;
  final TextEditingController _searchController = TextEditingController();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    offset = Tween<Offset>(
            begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(animationController);
    //     .animate(
    //   CurvedAnimation(
    //     parent: animationController,
    //     curve: Curves.elasticOut,
    //   ),
    // );
    animationController.forward();
    _selectedCategory = Category.all;

    // searchFieldFocusNode = FocusNode();
    // searchFieldFocusNode.addListener(() {
    //   print('focusNode updated: hasFocus: ${searchFieldFocusNode.hasFocus}');
    // });

    _searchController.addListener(_onSearchChanged);
    _isSearchModeTitle = true;
    // print(isSearchByBrand);
  }

  // void setFocusTextField() {
  //   FocusScope.of(context).requestFocus(searchFieldFocusNode);
  // }

  // void unFocusSearchField() {
  //   searchController.clear();
  //   FocusScope.of(context).unfocus();
  // }

  @override
  dispose() {
    animationController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getProductStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      if (_isSearchModeTitle) {
        for (var productSnapshot in _allResults) {
          var title = productSnapshot['Title'].toLowerCase();

          if (title.contains(_searchController.text.toLowerCase())) {
            showResults.add(productSnapshot);
            print(showResults);
          }
        }
      }
      if (!_isSearchModeTitle) {
        for (var productSnapshot in _allResults) {
          var title = productSnapshot['Brand Name'].toLowerCase();

          if (title.contains(_searchController.text.toLowerCase())) {
            showResults.add(productSnapshot);
          }
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getProductStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Products')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  createProductDocument(ProductModel product) async {
    // ignore: unused_local_variable
    var a = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Products')
        .add({
      "Title": product.title,
      "Alternate Title": product.altTitle,
      "Brand Name": product.brand,
      "Category": product.category,
      "Description": product.description,
      "Discount": {
        "Applicable": true,
        "Discount Amount/Percentage": product.discountPrice
      },
      "Unit Type": product.unit,
      "Vat": product.vat,
      "Attribute": product.attributes,
      "Net weight": product.netWeight,
      "Price": {
        "Buying Price": product.buyingPrice,
        "Selling Price": product.sellingPrice,
        "Sale Price": product.salePrice
      }
    });
    // if (a.size > 0) {

    // }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController altTitleController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController netWeightController = TextEditingController();
  TextEditingController attributesController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController vatController = TextEditingController();

  TextEditingController searchController = TextEditingController();

  void resetTextEditingControllers() {
    titleController.clear();
    altTitleController.clear();
    shortDescriptionController.clear();
    descriptionController.clear();
    brandNameController.clear();
    netWeightController.clear();
    attributesController.clear();
    buyingPriceController.clear();
    sellingPriceController.clear();
    salePriceController.clear();
    discountController.clear();
    vatController.clear();
  }

  bool _isSearchModeTitle = true;

  removeProductPopup() {
    String dropDownProduct = _allResults[0]["Title"].toString();
    List<String> products = [];

    for (var element in _allResults) {
      // print(element["Title"]);
      products.add(element["Title"]);
    }

    returnFullProductSnapshot(String product) {
      for (var element in _allResults) {
        if (element["Title"] == product) {
          return element;
        }
      }
    }

    removeProduct(String productID) async {
      // ignore: unused_local_variable
      var a = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Products')
          .doc(productID)
          .delete();
    }

    var dropdownProductSnapshot = _allResults[0];
    print(dropdownProductSnapshot["Title"]);
    var docItemRef = dropdownProductSnapshot.reference;
    print(docItemRef);

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // Future.delayed(Duration(seconds: 1000), () {
          //   Navigator.of(context).pop(true);
          // });
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.all(8.0),
              title: const Text(
                "Remove product",
                style: TextStyle(
                    fontFamily: "BreezeSans",
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.start,
              ),
              content: SizedBox(
                // width: MediaQuery.of(context).size.width - 400,
                // height: MediaQuery.of(context).size.height - 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Select Product                  ",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                          // Initial Value
                          value: dropDownProduct,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: products.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: kH2TextStyle(12, Colors.black),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownProduct = newValue!;
                              dropdownProductSnapshot =
                                  returnFullProductSnapshot(dropDownProduct);
                              docItemRef = dropdownProductSnapshot.reference;
                              print(dropdownProductSnapshot);
                              print(
                                  "${dropdownProductSnapshot["Title"]} is selected");
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // minimumSize: const Size(20, 10),
                            shadowColor: Colors.white, backgroundColor: Colors.white,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 100, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Cancel',
                                  style: kH2TextStyle(14.0, Colors.black)),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // minimumSize: const Size(20, 10),
                            shadowColor: Colors.red, backgroundColor: Colors.red,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 100, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                  color: Colors.red, width: 1.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text('Delete product',
                                  style: kH2TextStyle(14.0, Colors.white)),
                            ],
                          ),
                          onPressed: () {
                            print('${docItemRef.id} is deleted');
                            removeProduct(docItemRef.id);
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  returnEditPopup() {
    var categories = [
      'Consumer Foods',
      'Dry Foods',
      'Grocery',
      'Cosmetics',
      'Toiletries',
      "Men's Clothing",
      "Women's Clothing",
      "Kid's Clothing",
    ];

    List<String> products = [];

    for (var element in _allResults) {
      // print(element["Title"]);
      products.add(element["Title"]);
    }

    var units = [
      'piece',
      'gram',
      'kilogram',
      'Millilitre',
      'litre',
    ];

    String dropdownvalueCategories = _allResults[0]["Category"];
    String dropdownvalueUnits = _allResults[0]["Unit Type"];
    String dropDownProduct = _allResults[0]["Title"].toString();

    returnFullProductSnapshot(String product) {
      for (var element in _allResults) {
        if (element["Title"] == product) {
          return element;
        }
      }
    }

    var dropdownProductSnapshot = _allResults[0];
    print(dropdownProductSnapshot["Title"]);
    var docItemRef = dropdownProductSnapshot.reference;
    print(docItemRef);

    TextEditingController editTitleController =
        TextEditingController(text: dropdownProductSnapshot["Title"]);
    TextEditingController editAltTitleController =
        TextEditingController(text: dropdownProductSnapshot["Alternate Title"]);
    TextEditingController editShortDescriptionController =
        TextEditingController(text: dropdownProductSnapshot["Alternate Title"]);
    TextEditingController editDescriptionController =
        TextEditingController(text: dropdownProductSnapshot["Description"]);
    TextEditingController editBrandNameController =
        TextEditingController(text: dropdownProductSnapshot["Brand Name"]);
    TextEditingController editNetWeightController = TextEditingController(
        text: dropdownProductSnapshot["Net weight"].toString());
    TextEditingController editAttributesController =
        TextEditingController(text: dropdownProductSnapshot["Attribute"]);
    TextEditingController editBuyingPriceController = TextEditingController(
        text: dropdownProductSnapshot["Price"]["Buying Price"].toString());
    TextEditingController editSellingPriceController = TextEditingController(
        text: dropdownProductSnapshot["Price"]["Selling Price"].toString());
    TextEditingController editSalePriceController = TextEditingController(
        text: dropdownProductSnapshot["Price"]["Sale Price"].toString());
    TextEditingController editDiscountController = TextEditingController(
        text: dropdownProductSnapshot["Discount"]["Discount Amount/Percentage"]
            .toString());
    TextEditingController editVatController =
        TextEditingController(text: dropdownProductSnapshot["Vat"].toString());

    void resetEditControllers() {
      editTitleController.clear();
      editAltTitleController.clear();
      editShortDescriptionController.clear();
      editDescriptionController.clear();
      editBrandNameController.clear();
      editNetWeightController.clear();
      editAttributesController.clear();
      editBuyingPriceController.clear();
      editSellingPriceController.clear();
      editSalePriceController.clear();
      editDiscountController.clear();
      editVatController.clear();
    }

    void showDetailsOfSnapshot(snapshot) {
      print(docItemRef);
      print("HERE IS THE REFERENCE 285");
      editTitleController.text = snapshot['Title'];
      editAltTitleController.text = snapshot['Alternate Title'];
      editShortDescriptionController.text = snapshot['Alternate Title'];
      editDescriptionController.text = snapshot['Description'];
      editBrandNameController.text = snapshot['Brand Name'];
      editNetWeightController.text = snapshot['Net weight'].toString();
      editAttributesController.text = snapshot['Attribute'];
      editBuyingPriceController.text =
          snapshot['Price']['Buying Price'].toString();
      editSellingPriceController.text =
          snapshot['Price']['Selling Price'].toString();
      editSalePriceController.text = snapshot['Price']['Sale Price'].toString();
      editDiscountController.text =
          snapshot['Discount']['Discount Amount/Percentage'].toString();
      editVatController.text = snapshot['Vat'].toString();
    }

    editExistingProduct(ProductModel product) async {
      // ignore: unused_local_variable
      var a = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Products')
          .doc('${docItemRef.id}')
          .update({
        "Title": product.title,
        "Alternate Title": product.altTitle,
        "Brand Name": product.brand,
        "Category": product.category,
        "Description": product.description,
        "Discount": {
          "Applicable": true,
          "Discount Amount/Percentage": product.discountPrice
        },
        "Unit Type": product.unit,
        "Vat": product.vat,
        "Attribute": product.attributes,
        "Net weight": product.netWeight,
        "Price": {
          "Buying Price": product.buyingPrice,
          "Selling Price": product.sellingPrice,
          "Sale Price": product.salePrice
        }
      });
      // if (a.size > 0) {

      // }
    }

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // Future.delayed(Duration(seconds: 1000), () {
          //   Navigator.of(context).pop(true);
          // });
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.all(8.0),
              title: const Text(
                "Edit existing products",
                style: TextStyle(
                    fontFamily: "BreezeSans",
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.start,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width - 400,
                height: MediaQuery.of(context).size.height - 200,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Select Product                  ",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                          // Initial Value
                          value: dropDownProduct,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: products.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: kH2TextStyle(12, Colors.black),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownProduct = newValue!;
                              dropdownProductSnapshot =
                                  returnFullProductSnapshot(dropDownProduct);
                              docItemRef = dropdownProductSnapshot.reference;
                              print(dropdownProductSnapshot);

                              showDetailsOfSnapshot(dropdownProductSnapshot);
                              print(
                                  "${dropdownProductSnapshot["Title"]} is selected");
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Title                                    ",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 30,
                          width: 300,
                          child: TextField(
                            style: const TextStyle(
                                fontFamily: "BreezeSans",
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            controller: editTitleController,
                            decoration: kTextFieldDecoration2(
                                'Enter title of the product'),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Alternative Title           ",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 30,
                          width: 300,
                          child: TextField(
                            style: const TextStyle(
                                fontFamily: "BreezeSans",
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            controller: editAltTitleController,
                            decoration: kTextFieldDecoration2(
                                'Enter alternate title of the product'),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Short Description        ",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 30,
                          width: 300,
                          child: TextField(
                            style: const TextStyle(
                                fontFamily: "BreezeSans",
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            controller: editShortDescriptionController,
                            decoration: kTextFieldDecoration2(
                                'Enter short description'),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Description                    ",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 30,
                          width: 300,
                          child: TextField(
                            style: const TextStyle(
                                fontFamily: "BreezeSans",
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            controller: editDescriptionController,
                            decoration:
                                kTextFieldDecoration2('Enter description'),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Container(
                    //   height: 0.5,
                    //   width: 300,
                    //   color: Colors.grey,
                    // ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Expanded(
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                "Category                              ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton(
                                // Initial Value
                                value: dropdownvalueCategories,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: categories.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: kH2TextStyle(12, Colors.black),
                                    ),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalueCategories = newValue!;
                                    print("$dropdownvalueCategories is selected");
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Unit                                        ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton(
                                // Initial Value
                                value: dropdownvalueUnits,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: units.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: kH2TextStyle(12, Colors.black),
                                    ),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalueUnits = newValue!;
                                    print("$dropdownvalueUnits is selected");
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Brand Name             ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 200,
                                child: TextField(
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editBrandNameController,
                                  decoration:
                                      kTextFieldDecoration2('E.g. Pantene'),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Netweight                ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editNetWeightController,
                                  decoration: kTextFieldDecoration2('O'),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Attributes                ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editAttributesController,
                                  decoration: kTextFieldDecoration2('E.g. Red'),
                                ),
                              )
                            ],
                          ),
                        ]),
                      ),
                      // Container(
                      //   height: 100,
                      //   width: 0.5,
                      //   color: Colors.grey,
                      // ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                "Buying Price                ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editBuyingPriceController,
                                  decoration: kTextFieldDecoration2('0'),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Selling Price               ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editSellingPriceController,
                                  decoration: kTextFieldDecoration2('0'),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Sale Price                    ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editSalePriceController,
                                  decoration: kTextFieldDecoration2('0'),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Discount                      ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editDiscountController,
                                  decoration: kTextFieldDecoration2('0'),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "VAT(%)                         ",
                                style: kH2TextStyle(12, Colors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontFamily: "BreezeSans",
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller: editVatController,
                                  decoration: kTextFieldDecoration2('0'),
                                ),
                              )
                            ],
                          ),
                        ]),
                      ),
                    ]),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // minimumSize: const Size(20, 10),
                            shadowColor: Colors.white, backgroundColor: Colors.white,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 100, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Cancel',
                                  style: kH2TextStyle(14.0, Colors.black)),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            resetEditControllers();
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // minimumSize: const Size(20, 10),
                            shadowColor: Theme.of(context).primaryColor, backgroundColor: Theme.of(context).primaryColor,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 100, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text('Save changes',
                                  style: kH2TextStyle(14.0, Colors.white)),
                            ],
                          ),
                          onPressed: () {
                            ProductModel editProduct = ProductModel(
                                editTitleController.text,
                                editAltTitleController.text,
                                editShortDescriptionController.text,
                                editDescriptionController.text,
                                dropdownvalueCategories,
                                dropdownvalueUnits,
                                editBrandNameController.text,
                                int.parse(editNetWeightController.text),
                                editAttributesController.text,
                                int.parse(editBuyingPriceController.text),
                                int.parse(editSellingPriceController.text),
                                int.parse(editSalePriceController.text),
                                int.parse(editDiscountController.text),
                                int.parse(editVatController.text));
                            editExistingProduct(editProduct);
                            resetEditControllers();
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  buildCards(int index) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      elevation: 2,
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Product Name: ${_resultsList[index].data()["Title"].toString()}",
                          style: kH2TextStyle(
                            18,
                            const Color.fromARGB(255, 111, 104, 161),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Brand Name: ${_resultsList[index].data()["Brand Name"].toString()}",
                          style: kTableTextStyle.copyWith(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Description: ${_resultsList[index].data()["Description"].toString()}",
                      style: kS2TextStyle.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const SizedBox(),
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• Unit Type: ${_resultsList[index].data()["Unit Type"].toString()}",
                          style: kS2TextStyle.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "• Net weight: ${_resultsList[index].data()["Net weight"].toString()}",
                          style: kS2TextStyle.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "• VAT: ${_resultsList[index].data()["Vat"].toString()}",
                          style: kS2TextStyle.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Selling price: ${_resultsList[index].data()["Price"]["Selling Price"].toString()}",
                            style: kS2TextStyle.copyWith(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "• Sale price: ${_resultsList[index].data()["Price"]["Sale Price"].toString()}",
                            style: kS2TextStyle.copyWith(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: Row(
          children: [
            SlideTransition(
              position: offset,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: 200,
                  // color: Color.fromARGB(255, 227, 227, 227),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 238, 238, 238)),
                  child: Column(children: [
                    // ListTile(
                    //   // contentPadding: EdgeInsets.all(0),
                    //   // dense: true,
                    //   hoverColor: const Color.fromARGB(255, 152, 143, 206),
                    //   selectedTileColor: _selectedCategory == Category.search
                    //       ? Theme.of(context).primaryColor
                    //       : const Color.fromARGB(255, 152, 143, 206),
                    //   // tileColor: Theme.of(context).primaryColor,
                    //   leading: Icon(
                    //     Icons.search,
                    //     color: _selectedCategory == Category.search
                    //         ? Colors.white
                    //         : Colors.black,
                    //   ),
                    //   title: SizedBox(
                    //     width: 150.0,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: <Widget>[
                    //         Expanded(
                    //           flex: 3,
                    //           child: TextField(
                    //             style: TextStyle(color: Colors.white),
                    //             controller: searchController,
                    //             // readOnly: true,

                    //             focusNode: searchFieldFocusNode,
                    //             onTap: () {
                    //               FocusScope.of(context)
                    //                   .requestFocus(searchFieldFocusNode);
                    //               setState(() {
                    //                 _selectedCategory = Category.search;
                    //               });
                    //             },
                    //             textAlign: TextAlign.start,
                    //             decoration: InputDecoration.collapsed(
                    //                 hintStyle: TextStyle(
                    //                     fontFamily: "BreezeSans",
                    //                     fontSize: 15,
                    //                     color:
                    //                         _selectedCategory == Category.search
                    //                             ? Colors.white
                    //                             : Colors.black),
                    //                 hintText: 'Search'),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   selected: _selectedCategory == Category.search,
                    //   onTap: () {
                    //     setState(() {
                    //       setFocusTextField();
                    //       _selectedCategory = Category.search;
                    //     });
                    //   },
                    // ),
                    Container(
                      color: _selectedCategory == Category.all
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor: _selectedCategory == Category.all
                        //     ? Theme.of(context).primaryColor
                        //     : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.align_horizontal_left_outlined,
                          color: _selectedCategory == Category.all
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Show all",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.all
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.all,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.all;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.consumerFoods
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor:
                        //     _selectedCategory == Category.consumerFoods
                        //         ? Color.fromARGB(255, 91, 83, 140)
                        //         : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.emoji_food_beverage_outlined,
                          color: _selectedCategory == Category.consumerFoods
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Consumer Foods",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.consumerFoods
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.consumerFoods,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.consumerFoods;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.dryFoods
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor:
                        //     _selectedCategory == Category.consumerFoods
                        //         ? Color.fromARGB(255, 91, 83, 140)
                        //         : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.emoji_food_beverage_outlined,
                          color: _selectedCategory == Category.dryFoods
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Dry Foods",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.dryFoods
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.dryFoods,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.dryFoods;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.grocery
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor: _selectedCategory == Category.grocery
                        //     ? Theme.of(context).primaryColor
                        //     : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.shopping_basket_outlined,
                          color: _selectedCategory == Category.grocery
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Grocery",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.grocery
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.grocery,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.grocery;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.cosmetics
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor: _selectedCategory == Category.cosmetics
                        //     ? Theme.of(context).primaryColor
                        //     : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.face_retouching_natural_outlined,
                          color: _selectedCategory == Category.cosmetics
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Cosmetics",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.cosmetics
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.cosmetics,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.cosmetics;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.toiletries
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor: _selectedCategory == Category.toiletries
                        //     ? Theme.of(context).primaryColor
                        //     : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.cleaning_services_outlined,
                          color: _selectedCategory == Category.toiletries
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Toiletries",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.toiletries
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.toiletries,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.toiletries;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.mensClothing
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor:
                        //     _selectedCategory == Category.mensClothing
                        //         ? Theme.of(context).primaryColor
                        //         : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.man_outlined,
                          color: _selectedCategory == Category.mensClothing
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Men's Clothing",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.mensClothing
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.mensClothing,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.mensClothing;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.womensClothing
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor:
                        //     _selectedCategory == Category.womensClothing
                        //         ? Theme.of(context).primaryColor
                        //         : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.female_outlined,
                          color: _selectedCategory == Category.womensClothing
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Women's Clothing",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color:
                                  _selectedCategory == Category.womensClothing
                                      ? Colors.white
                                      : Colors.black),
                        ),
                        selected: _selectedCategory == Category.womensClothing,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.womensClothing;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: _selectedCategory == Category.kidsClothing
                          ? const Color.fromARGB(255, 125, 114, 186)
                          : null,
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 152, 143, 206),
                        // selectedTileColor:
                        //     _selectedCategory == Category.kidsClothing
                        //         ? Theme.of(context).primaryColor
                        //         : const Color.fromARGB(255, 152, 143, 206),
                        // tileColor: Theme.of(context).primaryColor,
                        leading: Icon(
                          Icons.sports_kabaddi_outlined,
                          color: _selectedCategory == Category.kidsClothing
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Kid's Clothing",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 15,
                              color: _selectedCategory == Category.kidsClothing
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _selectedCategory == Category.kidsClothing,
                        onTap: () {
                          setState(() {
                            // unFocusSearchField();
                            _selectedCategory = Category.kidsClothing;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            // height: 56,
                            // color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              height: 30,
                                              child: TextField(
                                                controller: _searchController,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    filled: true,
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.grey[800]),
                                                    hintText:
                                                        _isSearchModeTitle ==
                                                                false
                                                            ? "Search Brand"
                                                            : "Search Title",
                                                    fillColor: Colors.white70),
                                                onChanged: (value) {},
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (_isSearchModeTitle) {
                                                  setState(() {
                                                    _isSearchModeTitle = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _isSearchModeTitle = true;
                                                  });
                                                }

                                                if (_isSearchModeTitle) {
                                                  print("search mode is title");
                                                } else {
                                                  print("search mode is brand");
                                                }
                                              },
                                              child: _isSearchModeTitle
                                                  ? const Text(
                                                      "Search by Brand")
                                                  : const Text(
                                                      "Search by Title"),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                returnEditPopup();
                                              },
                                              child: const Text("Edit/Modify"),
                                            ),
                                            // TextButton(
                                            //   onPressed: () {},
                                            //   child:
                                            //       const Text("Add Product"),
                                            // ),
                                            TextButton(
                                              onPressed: () {
                                                removeProductPopup();
                                              },
                                              child:
                                                  const Text("Remove Product"),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: _resultsList == []
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : FutureBuilder(
                              future: getProductStreamSnapshots(),
                              builder: ((context, snapshot) {
                                return ListView.builder(
                                  itemCount: _resultsList.length,
                                  itemBuilder: (context, index) {
                                    // var checkingMessage =
                                    //     streamSnapshot.data!.docs[index];
                                    // print(checkingMessage['Category']);

                                    // var category =
                                    //     streamSnapshot.data!.docs[index];

                                    if (_selectedCategory == Category.all) {
                                      // return Container(
                                      //   padding: const EdgeInsets.all(8),
                                      //   child: Text(_resultsList[index]
                                      //       .data()["Title"]
                                      //       .toString()),
                                      // );

                                      return buildCards(index);
                                    }

                                    if (_selectedCategory ==
                                            Category.consumerFoods &&
                                        _resultsList[index]['Category'] ==
                                            "Consumer Foods") {
                                      return buildCards(index);
                                    }
                                    if (_selectedCategory ==
                                            Category.dryFoods &&
                                        _resultsList[index]['Category'] ==
                                            "Dry Foods") {
                                      return buildCards(index);
                                    }
                                    if (_selectedCategory == Category.grocery &&
                                        _resultsList[index]['Category'] ==
                                            "Grocery") {
                                      return buildCards(index);
                                    }

                                    if (_selectedCategory ==
                                            Category.cosmetics &&
                                        _resultsList[index]['Category'] ==
                                            "Cosmetics") {
                                      return buildCards(index);
                                    }

                                    if (_selectedCategory ==
                                            Category.toiletries &&
                                        _resultsList[index]['Category'] ==
                                            "Toiletries") {
                                      return buildCards(index);
                                    }

                                    if (_selectedCategory ==
                                            Category.mensClothing &&
                                        _resultsList[index]['Category'] ==
                                            "Men's Clothing") {
                                      return buildCards(index);
                                    }

                                    if (_selectedCategory ==
                                            Category.womensClothing &&
                                        _resultsList[index]['Category'] ==
                                            "Women's Clothing") {
                                      return buildCards(index);
                                    }

                                    if (_selectedCategory ==
                                            Category.kidsClothing &&
                                        _resultsList[index]['Category'] ==
                                            "Kid's Clothing") {
                                      return buildCards(index);
                                    } else {
                                      return Container();
                                    }
                                  },
                                );
                              }),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF5138ED),
            child: const Icon(Icons.add,
                color: Colors.white),
            onPressed: () async {
              // _showProductForm(context);
              var categories = [
                'Consumer Foods',
                'Dry Foods',
                'Grocery',
                'Cosmetics',
                'Toiletries',
                "Men's Clothing",
                "Women's Clothing",
                "Kid's Clothing",
              ];

              // var Cosmetics = [
              //   'Shampoo',
              //   'Baby Shampoo',
              //   'Soap',
              //   'Baby Soap',
              //   'Handwash',
              //   "Facewash",
              //   "Hair Products",
              //   "Hair Oil",
              //   "Body Lotion",
              //   "Baby Lotion",
              // ];

              var units = [
                'piece',
                'gram',
                'kilogram',
                'Millilitre',
                'litre',
              ];

              String dropdownvalueCategories = 'Consumer Foods';
              String dropdownvalueUnits = 'piece';

              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // Future.delayed(Duration(seconds: 1000), () {
                    //   Navigator.of(context).pop(true);
                    // });
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        scrollable: true,
                        insetPadding: const EdgeInsets.all(8.0),
                        title: const Text(
                          "Add new product",
                          style: TextStyle(
                              fontFamily: "BreezeSans",
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.start,
                        ),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width - 400,
                          height: MediaQuery.of(context).size.height - 250,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Title                                    ",
                                    style: kH2TextStyle(12, Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 300,
                                    child: TextField(
                                      style: const TextStyle(
                                          fontFamily: "BreezeSans",
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      controller: titleController,
                                      decoration: kTextFieldDecoration2(
                                          'Enter title of the product'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Alternative Title           ",
                                    style: kH2TextStyle(12, Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 300,
                                    child: TextField(
                                      style: const TextStyle(
                                          fontFamily: "BreezeSans",
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      controller: altTitleController,
                                      decoration: kTextFieldDecoration2(
                                          'Enter alternate title of the product'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Short Description        ",
                                    style: kH2TextStyle(12, Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 300,
                                    child: TextField(
                                      style: const TextStyle(
                                          fontFamily: "BreezeSans",
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      controller: shortDescriptionController,
                                      decoration: kTextFieldDecoration2(
                                          'Enter short description'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Description                    ",
                                    style: kH2TextStyle(12, Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 300,
                                    child: TextField(
                                      style: const TextStyle(
                                          fontFamily: "BreezeSans",
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      controller: descriptionController,
                                      decoration: kTextFieldDecoration2(
                                          'Enter description'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              // Container(
                              //   height: 0.5,
                              //   width: 300,
                              //   color: Colors.grey,
                              // ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(children: [
                                Expanded(
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Category                              ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(width: 10),
                                        DropdownButton(
                                          // Initial Value
                                          value: dropdownvalueCategories,

                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items
                                          items: categories.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                style: kH2TextStyle(
                                                    12, Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalueCategories =
                                                  newValue!;
                                              print("$dropdownvalueCategories is selected");
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Unit                                        ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(width: 10),
                                        DropdownButton(
                                          // Initial Value
                                          value: dropdownvalueUnits,

                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items
                                          items: units.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                style: kH2TextStyle(
                                                    12, Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalueUnits = newValue!;
                                              print("$dropdownvalueUnits is selected");
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Brand Name             ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 200,
                                          child: TextField(
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: brandNameController,
                                            decoration: kTextFieldDecoration2(
                                                'E.g. Pantene'),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Netweight                ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: netWeightController,
                                            decoration:
                                                kTextFieldDecoration2('O'),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Attributes                ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextField(
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: attributesController,
                                            decoration: kTextFieldDecoration2(
                                                'E.g. Red'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                                ),
                                // Container(
                                //   height: 100,
                                //   width: 0.5,
                                //   color: Colors.grey,
                                // ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Buying Price                ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: buyingPriceController,
                                            decoration:
                                                kTextFieldDecoration2('0'),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Selling Price               ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: sellingPriceController,
                                            decoration:
                                                kTextFieldDecoration2('0'),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Sale Price                    ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: salePriceController,
                                            decoration:
                                                kTextFieldDecoration2('0'),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Discount                      ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: discountController,
                                            decoration:
                                                kTextFieldDecoration2('0'),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "VAT(%)                         ",
                                          style: kH2TextStyle(12, Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontFamily: "BreezeSans",
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            controller: vatController,
                                            decoration:
                                                kTextFieldDecoration2('0'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                                ),
                              ]),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      // minimumSize: const Size(20, 10),
                                      shadowColor: Colors.white, backgroundColor: Colors.white,
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 100, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Cancel',
                                            style: kH2TextStyle(
                                                14.0, Colors.black)),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                      resetTextEditingControllers();
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      // minimumSize: const Size(20, 10),
                                      shadowColor:
                                          Theme.of(context).primaryColor, backgroundColor: Theme.of(context).primaryColor,
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 100, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('Add product',
                                            style: kH2TextStyle(
                                                14.0, Colors.white)),
                                      ],
                                    ),
                                    onPressed: () {
                                      ProductModel newProduct = ProductModel(
                                          titleController.text,
                                          altTitleController.text,
                                          shortDescriptionController.text,
                                          descriptionController.text,
                                          dropdownvalueCategories,
                                          dropdownvalueUnits,
                                          brandNameController.text,
                                          int.parse(netWeightController.text),
                                          attributesController.text,
                                          int.parse(buyingPriceController.text),
                                          int.parse(
                                              sellingPriceController.text),
                                          int.parse(salePriceController.text),
                                          int.parse(discountController.text),
                                          int.parse(vatController.text));
                                      createProductDocument(newProduct);
                                      resetTextEditingControllers();
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  });
            }),
      ),
    );
  }
}
