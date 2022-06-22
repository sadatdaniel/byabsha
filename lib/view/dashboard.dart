// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_const

import 'package:byabsha/stub/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:intl/intl.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    // MultiSplitViewController _controller1 =
    //     MultiSplitViewController(areas: Area.weights([0.1]));
    // MultiSplitViewController _controller2 =
    //     MultiSplitViewController(areas: Area.weights([0.1]));
    // MultiSplitViewController _controller3 =
    //     MultiSplitViewController(areas: Area.weights([0.1]));

    // Widget monthlySummary = Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(30),
    //   ),
    //   elevation: 2,
    //   child: Container(
    //     height: 120.0,
    //     width: 120.0,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(30),
    //       image: DecorationImage(
    //         image: AssetImage('images/chart.png'),
    //         fit: BoxFit.cover,
    //       ),
    //       shape: BoxShape.rectangle,
    //     ),
    //     child: Container(
    //       // color: Color.fromARGB(197, 89, 18, 204),
    //       child: Padding(
    //         padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
    //         child: Text("What happend this month"),
    //       ),
    //     ),
    //   ),
    // );
    // Widget productPerformanceCard = Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(30),
    //   ),
    //   elevation: 2,
    //   child: Container(
    //     height: 120.0,
    //     width: 120.0,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(30),
    //       image: DecorationImage(
    //         image: AssetImage('images/chart.png'),
    //         fit: BoxFit.cover,
    //       ),
    //       shape: BoxShape.rectangle,
    //     ),
    //     child: Container(
    //       // color: Color.fromARGB(197, 89, 18, 204),
    //       child: Padding(
    //         padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
    //         child: Text("Product Performance"),
    //       ),
    //     ),
    //   ),
    // );

    DateTime todaysDate = DateTime.now();
    todaysDate = DateFormat('dd-MM-yyyy').parse(todaysDate.toString());

    Widget pendingOpList = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      // elevation: 2,
      // color: Colors.white,
      color: const Color.fromARGB(255, 233, 240, 239),
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: [
                  const Flexible(
                    child: Text(
                      "Pending orders",
                      style: kH1TextStyle,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(widget.user.uid)
                          .collection('Orders')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                        if (orderSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (orderSnapshot.connectionState ==
                                ConnectionState.active ||
                            orderSnapshot.connectionState ==
                                ConnectionState.done) {
                          if (orderSnapshot.hasError) {
                            return const Text('Error');
                          } else if (orderSnapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: orderSnapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                // print(customerSnapshot);
                                if (orderSnapshot.data?.docs[index]
                                        ["isDeliverd"] ==
                                    false) {
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      elevation: 3,
                                      child: Container(
                                        height: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Icon(
                                                  Icons.error,
                                                  size: 50,
                                                  color: (todaysDate
                                                              .difference(DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .parse(orderSnapshot
                                                                          .data
                                                                          ?.docs[index]
                                                                      [
                                                                      "Approximate Delivery"]))
                                                              .inDays) <
                                                          3
                                                      ? const Color.fromARGB(
                                                          255, 240, 138, 86)
                                                      : const Color.fromARGB(
                                                          255, 88, 173, 92),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Approximate Delivery: ${orderSnapshot.data?.docs[index]["Approximate Delivery"]}",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "Order Date: ${orderSnapshot.data?.docs[index]["Order Date"]}"),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                } else {
                                  return Container();
                                }
                              },
                            );
                          } else {
                            return const Center(child: Text('Empty data'));
                          }
                        } else {
                          return Text(
                              'State: ${orderSnapshot.connectionState}');
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
    );
    Widget refillList = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      // elevation: 2,
      // color: Colors.white,
      color: const Color.fromARGB(255, 233, 240, 239),
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: const [
                  Flexible(
                    child: Text(
                      "Urgent Product Refill",
                      style: kH1TextStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(widget.user.uid)
                          .collection('Inventory')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> inventorySnapshot) {
                        return !inventorySnapshot.hasData
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: inventorySnapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  // print(customerSnapshot);
                                  if (inventorySnapshot.data?.docs[index]
                                          ["Items Bought"] <
                                      10) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      elevation: 3,
                                      child: SizedBox(
                                          height: 100,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 100,
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 50,
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "The Item '${inventorySnapshot.data?.docs[index]["Product Title"]}' is critically low"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "Only ${inventorySnapshot.data?.docs[index]["Items Bought"]} are available"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: const [
                                                          Text(
                                                              "Order to avoid item shortage"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ))),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              );
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
    );
    MultiSplitView multiSplitView =
        MultiSplitView(axis: Axis.vertical, children: [
      // MultiSplitView(children: [monthlySummary, productPerformanceCard]),
      MultiSplitView(children: [pendingOpList, refillList])
    ], initialAreas: [
      Area(weight: 0.4),
      // Area(weight: 0.1),
      // Area(weight: 0.7)
    ]);
    // print("Printing from LIstviwer");
    // print(customerSnapshot);
    MultiSplitViewTheme theme = MultiSplitViewTheme(
      child: multiSplitView,
      data: MultiSplitViewThemeData(dividerThickness: 24),
    );
    // final orientation = MediaQuery.of(context).orientation;
    return Expanded(
      child: Scaffold(
        // backgroundColor: Color.fromARGB(35, 216, 246, 243),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [Expanded(child: theme)],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: const Color(0xFF5138ED),
        //   onPressed: newInventoryPopup,
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
