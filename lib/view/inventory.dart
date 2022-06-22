// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:byabsha/model/inventory_model.dart';
import 'package:byabsha/stub/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getInventorySnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var supplierSnapshot in _allResults) {
        var title = supplierSnapshot['Product Title'].toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(supplierSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getInventorySnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Inventory')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  removeInventoryPopup() {
    String dropDownProduct = _allResults[0]["Product Title"].toString();
    List<String> products = [];

    for (var element in _allResults) {
      products.add(element["Product Title"]);
    }

    returnFullProductSnapshot(String name) {
      for (var element in _allResults) {
        if (element["Product Title"] == name) {
          return element;
        }
      }
    }

    removeInventory(String inventoryID) async {
      // ignore: unused_local_variable
      var a = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Inventory')
          .doc(inventoryID)
          .delete();
    }

    var dropdownProduct = _allResults[0];

    var docItemRef = dropdownProduct.reference;

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.all(8.0),
              title: const Text(
                "Remove Product",
                style: TextStyle(
                    fontFamily: "BreezeSans",
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.start,
              ),
              content: SizedBox(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Select product",
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
                              dropdownProduct =
                                  returnFullProductSnapshot(dropDownProduct);
                              docItemRef = dropdownProduct.reference;
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
                            shadowColor: Colors.white,
                            primary: Colors.white,
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
                            shadowColor: Colors.red,
                            primary: Colors.red,
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
                              Text('Remove product',
                                  style: kH2TextStyle(14.0, Colors.white)),
                            ],
                          ),
                          onPressed: () {
                            removeInventory(docItemRef.id);
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

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Title: ${_resultsList[index].data()["Product Title"].toString()}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: kH2TextStyle(
                              18,
                              const Color.fromARGB(255, 111, 104, 161),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Supplier: ${_resultsList[index].data()["Supplier Name"].toString()}",
                    style: kTableTextStyle.copyWith(
                        fontSize: 18, color: Colors.black),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Items bought: ${_resultsList[index].data()["Items Bought"].toString()}",
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
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        const EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Search Product Name",
                                    fillColor: Colors.white70),
                                onChanged: (value) {},
                              ),
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
                                setState(() {
                                  removeInventoryPopup();
                                });
                              },
                              child: const Text("Remove Product"),
                            ),
                          ],
                        )
                      ],
                    )
                  ]),
            ),
            Expanded(
              child: FutureBuilder(
                future: getInventorySnapshots(),
                builder: ((context, snapshot) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: (4 / 2),
                    ),
                    itemCount: _resultsList.length,
                    itemBuilder: (context, index) {
                      return buildCards(index);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF5138ED),
          onPressed: newInventoryPopup,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  newInventoryPopup() async {
    List<String> products = [];
    List<String> suppliers = [];

    getProductSnapshot() async {
      var data = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Products')
          .get();

      // print(data.docs.length);
      for (var element in data.docs) {
        setState(() {
          products.add(element["Title"]);
        });
      }
      return data;
    }

    getSupplierSnapshot() async {
      var data = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Suppliers')
          .get();
      for (var element in data.docs) {
        setState(() {
          suppliers.add(element["Name"]);
        });
      }
      return data;
    }

    var productSnapshots = await getProductSnapshot();
    var supplierSnapshots = await getSupplierSnapshot();
    String selectedProduct = products[0].toString();
    String selectedSupplier = suppliers[0].toString();

    TextEditingController _priceController = TextEditingController();
    TextEditingController _numberOfItemsController = TextEditingController();

    returnProductReference(String product) {
      for (var element in productSnapshots.docs) {
        if (element["Title"] == product) {
          return element.reference.id;
        }
      }
    }

    returnSupplierReference(String supplier) {
      for (var element in supplierSnapshots.docs) {
        if (element["Name"] == supplier) {
          return element.reference.id;
        }
      }
    }

    createInventoryDocument(InventoryModel inventory) async {
      // ignore: unused_local_variable
      var a = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Inventory')
          .add({
        "Product Title": inventory.productName,
        "Product Reference": inventory.productReference,
        "Supplier Name": inventory.supplierName,
        "Supplier Reference": inventory.supplierReference,
        "Items Bought": inventory.numberOfItems,
        "Price": inventory.price,
      });
    }

    resetTextControllers() {
      _priceController.clear();
      _numberOfItemsController.clear();
    }

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.all(8.0),
              title: const Text(
                "Add new product to inventory",
                style: TextStyle(
                    fontFamily: "BreezeSans",
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.start,
              ),
              content: SizedBox(
                // width: MediaQuery.of(context).size.width - 400,
                // height: MediaQuery.of(context).size.height - 250,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Product",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton(
                          value: selectedProduct,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: products
                              .map((item) => DropdownMenuItem<String>(
                                    child: Text(item),
                                    value: item,
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedProduct = newValue!;
                              print(selectedProduct + " is selected");
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Supplier",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton(
                          value: selectedSupplier,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: suppliers
                              .map((item) => DropdownMenuItem<String>(
                                    child: Text(item),
                                    value: item,
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSupplier = newValue!;
                              print(selectedSupplier + " is selected");
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
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            "Number of items bought",
                            style: kH2TextStyle(12, Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            height: 30,
                            // width: 250,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _numberOfItemsController,
                              style: const TextStyle(
                                  fontFamily: "BreezeSans",
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              // controller: titleController,
                              decoration: kTextFieldDecoration2('Enter Number'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            "Price for each Item",
                            style: kH2TextStyle(12, Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            height: 30,
                            // width: 250,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _priceController,
                              style: const TextStyle(
                                  fontFamily: "BreezeSans",
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              // controller: titleController,
                              decoration: kTextFieldDecoration2('Enter Price'),
                            ),
                          ),
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
                            shadowColor: Colors.white,
                            primary: Colors.white,
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
                            resetTextControllers();
                            Navigator.of(context).pop(true);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // minimumSize: const Size(20, 10),
                            shadowColor: Theme.of(context).primaryColor,
                            primary: Theme.of(context).primaryColor,
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
                              Text('Add product',
                                  style: kH2TextStyle(14.0, Colors.white)),
                            ],
                          ),
                          onPressed: () {
                            InventoryModel newModel = InventoryModel(
                              selectedProduct,
                              returnProductReference(selectedProduct)
                                  .toString(),
                              selectedSupplier,
                              returnSupplierReference(selectedSupplier)
                                  .toString(),
                              int.parse(_numberOfItemsController.text),
                              double.parse(_priceController.text),
                            );
                            createInventoryDocument(newModel);
                            resetTextControllers();
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
}
