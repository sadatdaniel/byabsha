// ignore_for_file: avoid_print, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:convert';
// import 'dart:html';

import 'package:byabsha/model/customer_model.dart';
import 'package:byabsha/model/order_model.dart';
import 'package:byabsha/model/to_product.dart';
import 'package:byabsha/stub/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:multi_split_view/multi_split_view.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var customerSnapshot;

  Future<QuerySnapshot<Object?>> getCustomerStreamSnapshots() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Customers')
        .get();
    setState(() {
      customerSnapshot = data;
    });
    return data;
  }

  int _priceCount = 0;
  int _numberOfItemsCount = 0;
  // String _result = '';
  final List<Map<String, dynamic>> _priceValues = [];
  final List<Map<String, dynamic>> _numberOfItemsValues = [];
  double totalPrice = 0;
  @override
  void initState() {
    super.initState();
    // getCustomerStreamSnapshots();
  }

  @override
  Widget build(BuildContext context) {
    buildTextRows(
        var productDetails,
        String paymentType,
        String customerName,
        String orderDate,
        String additionalNote,
        String approximateDelivery,
        bool isDelivered,
        String orderRef) {
      // print("Printing rowwwws");

      List<DataRow> tableRows = [];

      var productList = ProductList.fromJson(productDetails);
      // print(productList.products[0].numberOfItem);
      // print("Printing rowwwws");

      for (var element in productList.products) {
        tableRows.add(
          DataRow(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            cells: [
              DataCell(
                Text(
                  element.productName.toString(),
                  style: kS2TextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  element.productPrice.toString(),
                  style: kS2TextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  element.numberOfItem.toString(),
                  style: kS2TextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  "${int.parse(element.productPrice!) * int.parse(element.numberOfItem!)}",
                  style: kS2TextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        );

        totalPrice = totalPrice +
            (double.parse(element.productPrice!) *
                double.parse(element.numberOfItem!));
      }

      // print(rows);
      return tableRows;
    }

    orderCard(streamSnapshot, CustomerModel currentCustomer) {
      String productDetails = streamSnapshot['Product Details'];
      // print(streamSnapshot["Castomer Name"]);
      String paymentType = streamSnapshot['Payment Type'];
      String customerName = streamSnapshot['Castomer Name'];
      String orderDate = streamSnapshot['Order Date'];
      String additionalNote = streamSnapshot['Additional Note'];
      String approximateDelivery = streamSnapshot['Approximate Delivery'];
      bool isDelivered = streamSnapshot['isDeliverd'];
      String orderRef = streamSnapshot.reference.id;
      // print(customerSnapshot == null
      //     ? ""
      //     : customerSnapshot.docs[0]["Name"].toString());

      final decoded = json.decode(productDetails);
      // print("DECODED JSON FROM ORDER CARD");
      // print(decoded);

      // returnSpecificCustomer(String customerName) {
      //   if (customerSnapshot.docs != null) {
      //     for (int i = 0; i < customerSnapshot.docs.length(); i++) {
      //       if (customerSnapshot.docs[i]["Name"] == customerName) {
      //         CustomerModel customer = CustomerModel(
      //             customerSnapshot.docs[i]["Name"],
      //             customerSnapshot.docs[i]["Initial"],
      //             customerSnapshot.docs[i]["Email"],
      //             customerSnapshot.docs[i]["Profession"],
      //             customerSnapshot.docs[i]["Birthday"],
      //             customerSnapshot.docs[i]["Mobile No"],
      //             customerSnapshot.docs[i]["Flat No"],
      //             customerSnapshot.docs[i]["House No"],
      //             customerSnapshot.docs[i]["Road No"],
      //             customerSnapshot.docs[i]["Area"],
      //             customerSnapshot.docs[i]["City No"],
      //             customerSnapshot.docs[i]["Country No"],
      //             customerSnapshot.docs[i]["Post Code"]);

      //         return customer;
      //       }
      //     }
      //   }
      // }

      // CustomerModel? currentCustomer =
      //     returnSpecificCustomer(streamSnapshot["Castomer Name"]);

      return Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              // Card(
              //   child: SizedBox(
              //     height: 200,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         children: buildTextRows(
              //             decoded,
              //             paymentType,
              //             customerName,
              //             orderDate,
              //             addtionalNote,
              //             approximateDelivery,
              //             isDelivered,
              //             orderRef),
              //       ),
              //     ),
              //   ),
              // ),
              Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            elevation: 2,
            margin: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Order Details",
                              style: kH2TextStyle(
                                18,
                                const Color.fromARGB(255, 111, 104, 161),
                              ),
                            ),
                          ),
                          // const Spacer(),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Text(
                          //       "Initial: ${_resultsList[index].data()["Initial"].toString()}",
                          //       style: kTableTextStyle.copyWith(
                          //           fontSize: 18, color: Colors.black),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DataTable(
                        border: TableBorder.all(
                            width: 0.4,
                            borderRadius: BorderRadius.circular(10)),
                        // showBottomBorder: true,

                        columns: [
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                "Product Name",
                                style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                "Number of Items",
                                style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                "Price of Item",
                                style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                "Total",
                                style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ),
                        ],
                        rows: buildTextRows(
                            decoded,
                            paymentType,
                            customerName,
                            orderDate,
                            additionalNote,
                            approximateDelivery,
                            isDelivered,
                            orderRef),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "Order Date: $orderDate",
                                style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "Approximate Delivery: $approximateDelivery",
                                style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "Additional Notes: $additionalNote",
                                style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 20),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Flexible(
                      //         child: Text(
                      //           "Total Price: $totalPrice \$",
                      //           style: kS2TextStyle.copyWith(
                      //               color: Colors.black,
                      //               fontSize: 18,
                      //               fontWeight: FontWeight.bold,
                      //               overflow: TextOverflow.fade),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                  trailing: const SizedBox(),
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "To",
                          style: kS2TextStyle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• Name: ${currentCustomer.name.toString()}",
                                  style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "• Initial: ${currentCustomer.initial..toString()}",
                                  style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "• Mobile No: ${currentCustomer.mobile.toString()}",
                                  style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• Profession: ${currentCustomer.profession.toString()}",
                                    style: kS2TextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "• Birthday: ${currentCustomer.date.toString()}",
                                    style: kS2TextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  )
                                ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Shipping Address",
                          style: kS2TextStyle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• Flat No: ${currentCustomer.flatNo.toString()}",
                                  style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "• Road No: ${currentCustomer.roadNo.toString()}",
                                  style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "• Area: ${currentCustomer.area.toString()}",
                                  style: kS2TextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• City: ${currentCustomer.city.toString()}",
                                    style: kS2TextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "• Country: ${currentCustomer.country.toString()}",
                                    style: kS2TextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextButton(
                            child: const Text(
                              "Is Delivered?",
                            ),
                            onPressed: () {
                              // print(orderRef);
                              changeDeliveryStutusOrder(orderRef);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextButton(
                            child: const Text(
                              "Remove Order",
                            ),
                            onPressed: () {
                              // print(orderRef);
                              deleteOrder(orderRef);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextButton(
                            child: const Text(
                              "Print Receipt",
                            ),
                            onPressed: () {
                              // print(orderRef);
                              deleteOrder(orderRef);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ));
    }

    CustomerModel? returnSpecificCustomer(
        String customerName, AsyncSnapshot<QuerySnapshot> customerSnapshot) {
      for (int i = 0; i < customerSnapshot.data!.docs.length; i++) {
        if (customerSnapshot.data!.docs[i]["Name"] == customerName) {
          CustomerModel customer = CustomerModel(
              customerSnapshot.data!.docs[i]["Name"],
              customerSnapshot.data!.docs[i]["Initial"],
              customerSnapshot.data!.docs[i]["Email"],
              customerSnapshot.data!.docs[i]["Profession"],
              customerSnapshot.data!.docs[i]["Birthday"],
              customerSnapshot.data!.docs[i]["Mobile No"],
              customerSnapshot.data!.docs[i]["Flat No"],
              customerSnapshot.data!.docs[i]["House No"],
              customerSnapshot.data!.docs[i]["Road No"],
              customerSnapshot.data!.docs[i]["Area"],
              customerSnapshot.data!.docs[i]["City No"],
              customerSnapshot.data!.docs[i]["Country No"],
              customerSnapshot.data!.docs[i]["Post Code"]);

          return customer;
        }
      }
      return null;
    }

    List<Widget> orderLists = [
      // ignore: avoid_unnecessary_containers
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(widget.user.uid)
            .collection('Customers')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> customerSnapshot) {
          return !customerSnapshot.hasData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc(widget.user.uid)
                      .collection('Orders')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                    return !orderSnapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: orderSnapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              // print(customerSnapshot);
                              if (orderSnapshot.data?.docs[index]
                                      ["isDeliverd"] ==
                                  false) {
                                //getSpecific user
                                //

                                CustomerModel? userModel =
                                    returnSpecificCustomer(
                                        orderSnapshot.data?.docs[index]
                                            ["Castomer Name"],
                                        customerSnapshot);

                                return orderCard(
                                    orderSnapshot.data?.docs[index],
                                    userModel!);
                              } else {
                                return Container();
                              }
                            },
                          );
                  },
                );
        },
      ),

      // getOrderSnapshot() async {
      //   var data = await FirebaseFirestore.instance
      //       .collection('User')
      //       .doc(widget.user.uid)
      //       .collection('Orders')
      //       .get();

      //   return data;
      // }

      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(widget.user.uid)
            .collection('Customers')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> customerSnapshot) {
          return !customerSnapshot.hasData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc(widget.user.uid)
                      .collection('Orders')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                    return !orderSnapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: orderSnapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              // print(customerSnapshot);
                              if (orderSnapshot.data?.docs[index]
                                      ["isDeliverd"] ==
                                  true) {
                                //getSpecific user
                                //

                                CustomerModel? userModel =
                                    returnSpecificCustomer(
                                        orderSnapshot.data?.docs[index]
                                            ["Castomer Name"],
                                        customerSnapshot);

                                return orderCard(
                                    orderSnapshot.data?.docs[index],
                                    userModel!);
                              } else {
                                return Container();
                              }
                            },
                          );
                  },
                );
        },
      ),
    ];

    MultiSplitView multiSplitView = MultiSplitView(
        children: orderLists,
        dividerBuilder:
            (axis, index, resizable, dragging, highlighted, themeData) {
          return Container(
            color: dragging ? Colors.grey[300] : Colors.grey[100],
            child: Icon(
              Icons.drag_indicator,
              color: highlighted ? Colors.grey[600] : Colors.grey[400],
            ),
          );
        });
    // print("Printing from LIstviwer");
    // print(customerSnapshot);
    MultiSplitViewTheme theme = MultiSplitViewTheme(
      child: multiSplitView,
      data: MultiSplitViewThemeData(dividerThickness: 24),
    );
    return Expanded(
      child: Scaffold(
        body: Column(
          children: [Expanded(child: theme)],
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
    getInventorySnapshot() async {
      var data = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Inventory')
          .get();
      // print(data.docs.length);
      return data.docs;
    }

    // getCustomerSnapshot() async {
    //   var data = await FirebaseFirestore.instance
    //       .collection('User')
    //       .doc(widget.user.uid)
    //       .collection('Customers')
    //       .get();
    //   // print(data.docs.length);
    //   return data.docs;
    // }

    var _inventorySnapshot = await getInventorySnapshot();

    List _selectedProducts = [];
    final CarouselController _controller = CarouselController();
    List<String> customers = [];
    TextEditingController _additionalNotesController = TextEditingController();
    TextEditingController sellingDate = TextEditingController();
    TextEditingController approxDeliveryDate = TextEditingController();
    DateTime _date = DateTime.now();

    void resetTextControllers() {
      approxDeliveryDate.clear();
      sellingDate.clear();
      _additionalNotesController.clear();
    }

    getCustomerSnapshot() async {
      var data = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Customers')
          .get();
      for (var element in data.docs) {
        setState(() {
          customers.add(element["Name"]);
        });
      }
      return data;
    }

    createOrderDocument(OrderModel order) async {
      var a = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Orders')
          .add({
        "Product Details": order.productDetails,
        "Castomer Name": order.castomerName,
        "Payment Type": order.paymentType,
        "Order Date": order.orderDate,
        "Approximate Delivery": order.approximateDeliveryDate,
        "Additional Note": order.additionalNote,
        "isDeliverd": order.isDeliverd
      });
    }

    var customerSnapshots = await getCustomerSnapshot();
    String selectedCustomer = customers[0].toString();
    // String selectedProduct = products[0].toString();

    List<String> paymentTypes = ['Cash on Delivery', 'Credit Card', 'Bkash'];
    String selectedPaymentType = paymentTypes[0];

    // Map<String, dynamic>? selectedCustomerSnapshot;

    bool _isSecondPage = false;

    // returnSupplierReference(String supplier) {
    //   for (var element in customerSnapshots.docs) {
    //     if (element["Name"] == supplier) {
    //       return element.reference.id;
    //     }
    //   }
    // }

    _onPriceUpdate(int index, String val) async {
      int foundKey = -1;
      for (var map in _priceValues) {
        if (map.containsKey("id")) {
          if (map["id"] == index) {
            foundKey = index;
            break;
          }
        }
      }
      if (-1 != foundKey) {
        _priceValues.removeWhere((map) {
          return map["id"] == foundKey;
        });
      }
      Map<String, dynamic> json = {
        "id": index,
        "value": val,
      };
      _priceValues.add(json);
    }

    _priceRow(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price of ${_selectedProducts[index]["Product Title"]}:',
            style: kH2TextStyle(12, Colors.black),
          ),
          const SizedBox(width: 30),
          Flexible(
            child: SizedBox(
              height: 30,
              // width: 200,
              child: TextFormField(
                decoration: kTextFieldDecoration2("Add price of the product")
                    .copyWith(
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10)),
                onChanged: (val) {
                  _onPriceUpdate(index, val);
                },
              ),
            ),
          ),
        ],
      );
    }

/////////////////////////////////
    ///
    ///

    _onNumberOfItemsUpdate(int index, String val) async {
      int foundKey = -1;
      for (var map in _numberOfItemsValues) {
        if (map.containsKey("id")) {
          if (map["id"] == index) {
            foundKey = index;
            break;
          }
        }
      }
      if (-1 != foundKey) {
        _numberOfItemsValues.removeWhere((map) {
          return map["id"] == foundKey;
        });
      }
      Map<String, dynamic> json = {
        "id": index,
        "value": val,
      };
      _numberOfItemsValues.add(json);
    }

    _numberOfItemsRow(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Number of ${_selectedProducts[index]["Product Title"]}:',
            style: kH2TextStyle(12, Colors.black),
          ),
          const SizedBox(width: 30),
          Flexible(
            child: SizedBox(
              height: 30,
              // width: 200,
              child: TextFormField(
                decoration: kTextFieldDecoration2("Add number of items")
                    .copyWith(
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10)),
                onChanged: (val) {
                  _onNumberOfItemsUpdate(index, val);
                },
              ),
            ),
          ),
        ],
      );
    }

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            _priceCount = _selectedProducts.length;
            _numberOfItemsCount = _selectedProducts.length;

            final List<Widget> orderPages = [
              ListView.builder(
                shrinkWrap: true,
                itemCount: _inventorySnapshot.length,
                itemBuilder: (context, index) {
                  return Material(
                    child: Container(
                      color:
                          _selectedProducts.contains(_inventorySnapshot[index])
                              ? const Color.fromARGB(221, 206, 167, 243)
                              : null,
                      child: ListTile(
                        // selectedTileColor: ,

                        title: Text(_inventorySnapshot[index]["Product Title"]),
                        trailing: _selectedProducts
                                .contains(_inventorySnapshot[index])
                            ? const Icon(Icons.done)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedProducts
                                    .contains(_inventorySnapshot[index])
                                ? _selectedProducts
                                    .remove(_inventorySnapshot[index])
                                : _selectedProducts
                                    .add(_inventorySnapshot[index]);
                          });

                          print(_selectedProducts
                              .contains(_inventorySnapshot[index]));

                          print(_selectedProducts);
                        },
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _priceCount,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _priceRow(index),
                          );
                        }),
                      ),
                      // const SizedBox(
                      //   height: 50,
                      // ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _numberOfItemsCount,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: _numberOfItemsRow(index),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 1,
                        width: 300,
                        color: const Color.fromARGB(255, 223, 223, 223),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select Customer",
                            style: kH2TextStyle(12, Colors.black),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton(
                            value: selectedCustomer,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: customers
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCustomer = newValue!;
                                // returnProductSnapshot(
                                //         returnProductReference(
                                //             selectedProduct))
                                //     .then((value) {
                                //   selectedCustomerSnapshot =
                                //       value.data();

                                // }
                                // );

                                print(selectedCustomer + " is selected");
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Type",
                            style: kH2TextStyle(12, Colors.black),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton(
                            value: selectedPaymentType,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: paymentTypes
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPaymentType = newValue!;
                                print(selectedPaymentType + " is selected");
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              "Order date",
                              style: kH2TextStyle(12, Colors.black),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              // width: 250,
                              child: TextFormField(
                                readOnly: true,
                                controller: sellingDate,
                                decoration: kTextFieldDecoration2("Select Date")
                                    .copyWith(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, top: 10, bottom: 10)),
                                onTap: () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1920),
                                    lastDate: _date,
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      sellingDate.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(selectedDate);
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter date.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              "Approaximate delivary date",
                              style: kH2TextStyle(12, Colors.black),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              // width: 250,
                              child: TextFormField(
                                readOnly: true,
                                controller: approxDeliveryDate,
                                decoration: kTextFieldDecoration2(
                                        "Approximate delivary date")
                                    .copyWith(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, top: 10, bottom: 10)),
                                onTap: () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        _date.add(const Duration(days: 30)),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      approxDeliveryDate.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(selectedDate);
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter date.';
                                  }
                                  return null;
                                },
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
                              "Additional Notes",
                              style: kH2TextStyle(12, Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 2,
                            child: SizedBox(
                              // height: 100,
                              // width: 250,
                              child: TextField(
                                // keyboardType: TextInputType.number,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                // expands: true,
                                controller: _additionalNotesController,
                                style: const TextStyle(
                                    fontFamily: "BreezeSans",
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                // controller: titleController,
                                decoration: kTextFieldDecoration2(
                                        'Add additional notes')
                                    .copyWith(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, top: 10, bottom: 10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // Center(
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: _numberOfItemsCount,
              //     itemBuilder: ((context, index) {
              //       return _numberOfItemsRow(index);
              //     }),
              //   ),
              // ),
              // Container(
              //   color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              //       .withOpacity(1.0),

              // order date, approaximate delivery, shipping address, payment type, additional details
              // ),
            ];

            return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.all(8.0),
              title: const Text(
                "New order",
                style: TextStyle(
                    fontFamily: "BreezeSans",
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.start,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width - 800,
                height: MediaQuery.of(context).size.height - 180,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Text("Select products"),
                      // ),
                      CarouselSlider(
                        items: orderPages,
                        options: CarouselOptions(
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          // enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          // height: 200

                          height: MediaQuery.of(context).size.height - 250,
                          viewportFraction: 1.0,
                        ),
                        carouselController: _controller,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              _controller.previousPage();
                              setState(() {
                                _isSecondPage = false;
                              });
                            },
                            child: const Text('back'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          // TextButton(
                          //     onPressed: () async {
                          //       setState(
                          //         () {
                          //           _count++;
                          //         },
                          //       );
                          //     },
                          //     child: const Text("Add new form")),
                          if (!_isSecondPage)
                            ElevatedButton(
                              onPressed: (_selectedProducts.isNotEmpty)
                                  ? () {
                                      _controller.nextPage();
                                      setState(() {
                                        _isSecondPage = true;
                                      });
                                    }
                                  : null,
                              child: const Text('forward'),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (_isSecondPage)
                            ElevatedButton(
                              onPressed: () async {
                                // var _priceOfItemsArray =
                                //     _priceValues.map((item) => item['value']);
                                // var _numberOfItemsArray = _numberOfItemsValues
                                //     .map((item) => item['value']);

                                // var _products =
                                //     _selectedProducts.map((product) {
                                //   var _product = {
                                //     "Product Name": product["Product Title"],
                                //     "Product Price":
                                //         _priceOfItemsArray.elementAt(
                                //             _selectedProducts.indexOf(product)),
                                //     "Number of Item":
                                //         _numberOfItemsArray.elementAt(
                                //             _selectedProducts.indexOf(product))
                                //   };
                                //   return _product;
                                // });

                                // print(_products);

                                var _priceOfItemsArray =
                                    _priceValues.map((item) => item['value']);
                                var _numberOfItemsArray = _numberOfItemsValues
                                    .map((item) => item['value']);

                                var _products =
                                    _selectedProducts.map((product) {
                                  var _product = {
                                    '"Product Name"':
                                        '"${product["Product Title"]}"',
                                    '"Product Price"':
                                        '"${_priceOfItemsArray.elementAt(_selectedProducts.indexOf(product))}"',
                                    '"Number of Item"':
                                        '"${_numberOfItemsArray.elementAt(_selectedProducts.indexOf(product))}"'
                                  };
                                  return _product;
                                });

                                // print(_products);
                                // print('${_products.toList()}');

                                // var cool =
                                //     _products.toString().replaceAll("(", "[");
                                // cool = cool.substring(0, cool.length - 1);

                                // cool = cool + "]";

                                // print(cool);

                                var cool = _products.toList();
                                final decoded = json.decode(cool.toString());
                                var productList = ProductList.fromJson(decoded);

                                int availableItems;
                                int howManyNeedtoBuy;
                                List<bool> isEveryProductAvailable = [];

                                int howManyAvailable(String productName) {
                                  int itemNumber = 0;

                                  for (var element in _inventorySnapshot) {
                                    if (element["Product Title"] ==
                                        productName) {
                                      print(
                                          "Found value called ${element["Product Title"]}");
                                      print(
                                          "Found value called ${element["Items Bought"]}");
                                      itemNumber = element["Items Bought"];
                                    }
                                  }
                                  return itemNumber;
                                }

                                removeNumberOfProducts(
                                    String productName, int howMany) async {
                                  int itemNumber = 0;

                                  for (var element in _inventorySnapshot) {
                                    if (element["Product Title"] ==
                                        productName) {
                                      itemNumber = element["Items Bought"];

                                      var a = await FirebaseFirestore.instance
                                          .collection('User')
                                          .doc(widget.user.uid)
                                          .collection('Inventory')
                                          .doc(element.reference.id)
                                          .update({
                                        "Items Bought": itemNumber - howMany,
                                      });
                                    }
                                  }
                                  // return itemNumber;
                                }

                                confirmedDelation() {
                                  for (var element in productList.products) {
                                    removeNumberOfProducts(
                                        element.productName.toString(),
                                        int.parse(
                                            element.numberOfItem.toString()));
                                  }
                                }

                                // _inventorySnapshot

                                for (int i = 0;
                                    i < productList.products.length;
                                    i++) {
                                  String productName = productList
                                      .products[i].productName
                                      .toString();

                                  availableItems =
                                      howManyAvailable(productName);

                                  howManyNeedtoBuy = int.parse(productList
                                      .products[i].numberOfItem
                                      .toString());

                                  if (availableItems < howManyNeedtoBuy) {
                                    var snackBar = SnackBar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 222, 110, 110),
                                        content: Text(
                                          "${productList.products[i].productName.toString()} only available $availableItems items",
                                          style: kH4TextStyle,
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);

                                    isEveryProductAvailable.add(false);
                                  } else {
                                    // isEveryProductAvailable[i] = true;
                                    isEveryProductAvailable.add(true);
                                  }

                                  print("PRINTING AVAILABEL ITEMS");
                                  print(availableItems);
                                }

                                // Step 3

                                print(selectedCustomer);
                                print(selectedPaymentType);
                                print(sellingDate.text);
                                print(approxDeliveryDate.text);
                                print(_additionalNotesController.text);

                                // OrderModel newOrder = OrderModel(
                                //     cool.toString(),
                                //     selectedCustomer,
                                //     selectedPaymentType,
                                //     sellingDate.text,
                                //     approxDeliveryDate.text,
                                //     _additionalNotesController.text);

                                // createOrderDocument(newOrder);

                                // resetTextControllers();
                                // Navigator.of(context).pop(true);

                                if (!isEveryProductAvailable.contains(false)) {
                                  print(isEveryProductAvailable);
                                  print("everything is true, very cool");

                                  OrderModel newOrder = OrderModel(
                                      cool.toString(),
                                      selectedCustomer,
                                      selectedPaymentType,
                                      sellingDate.text,
                                      approxDeliveryDate.text,
                                      _additionalNotesController.text);

                                  createOrderDocument(newOrder);

                                  resetTextControllers();
                                  Navigator.of(context).pop(true);
                                  confirmedDelation();
                                } else {
                                  print(isEveryProductAvailable);
                                  print("everything is not true, very uncool");
                                }
                              },
                              child: const Text('Add order'),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  changeDeliveryStutusOrder(String orderRef) async {
    var a = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Orders')
        .doc(orderRef)
        .update({"isDeliverd": true});
  }

  deleteOrder(String orderRef) async {
    var a = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Orders')
        .doc(orderRef)
        .delete();
  }
}
