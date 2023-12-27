import 'package:byabsha/model/supplier_model.dart';
import 'package:byabsha/stub/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Suppliers extends StatefulWidget {
  const Suppliers({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Suppliers> createState() => _SuppliersState();
}

class _SuppliersState extends State<Suppliers> {
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
    resultsLoaded = getSupplierStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var supplierSnapshot in _allResults) {
        var title = supplierSnapshot['Name'].toLowerCase();
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

  getSupplierStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Suppliers')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  removeSupplierPopup() {
    String dropDownSupplier = _allResults[0]["Name"].toString();
    List<String> suppliers = [];

    for (var element in _allResults) {
      suppliers.add(element["Name"]);
    }

    returnFullProductSnapshot(String supplier) {
      for (var element in _allResults) {
        if (element["Name"] == supplier) {
          return element;
        }
      }
    }

    removeSupplier(String supplierID) async {
      // ignore: unused_local_variable
      var a = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Suppliers')
          .doc(supplierID)
          .delete();
    }

    var dropdownSupplierSnapshot = _allResults[0];

    var docItemRef = dropdownSupplierSnapshot.reference;

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.all(8.0),
              title: const Text(
                "Remove supplier",
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
                          "Select supplier ",
                          style: kH2TextStyle(12, Colors.black),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                          // Initial Value
                          value: dropDownSupplier,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: suppliers.map((String items) {
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
                              dropDownSupplier = newValue!;
                              dropdownSupplierSnapshot =
                                  returnFullProductSnapshot(dropDownSupplier);
                              docItemRef = dropdownSupplierSnapshot.reference;
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
                              Text('Remove supplier',
                                  style: kH2TextStyle(14.0, Colors.white)),
                            ],
                          ),
                          onPressed: () {
                            removeSupplier(docItemRef.id);
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

  createCustomerDocument(SupplierModel supplier) async {
    // ignore: unused_local_variable
    var a = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Suppliers')
        .add({
      "Name": supplier.name,
      "Initial": supplier.initial,
      "Email": supplier.email,
      "Mobile No": supplier.mobile,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${_resultsList[index].data()["Name"].toString()}",
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
                  "Initial: ${_resultsList[index].data()["Initial"].toString()}",
                  style: kTableTextStyle.copyWith(
                      fontSize: 18, color: Colors.black),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Mobile no: ${_resultsList[index].data()["Mobile No"].toString()}",
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

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController initialController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController mobileNoController = TextEditingController();

    void resetTextEditingControllers() {
      nameController.clear();
      initialController.clear();
      emailController.clear();
      mobileNoController.clear();
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
                                    hintText: "Search Name",
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
                                  removeSupplierPopup();
                                });
                              },
                              child: const Text("Remove Supplier"),
                            ),
                          ],
                        )
                      ],
                    )
                  ]),
            ),
            Expanded(
              child: FutureBuilder(
                future: getSupplierStreamSnapshots(),
                builder: ((context, snapshot) {
                  return ListView.builder(
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
          child: const Icon(Icons.add,
              color: Colors.white),
          onPressed: () async {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                // Future.delayed(Duration(seconds: 1000), () {
                //   Navigator.of(context).pop(true);
                // });
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      scrollable: true,
                      insetPadding: const EdgeInsets.all(8.0),
                      title: const Text(
                        "Add new supplier",
                        style: TextStyle(
                            fontFamily: "BreezeSans",
                            fontSize: 20,
                            fontWeight: FontWeight.w900),
                        textAlign: TextAlign.start,
                      ),
                      content: SizedBox(
                          // width: MediaQuery.of(context).size.width - 400,
                          // height: MediaQuery.of(context).size.height - 250,

                          child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "Name",
                                        style: kH2TextStyle(12, Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: SizedBox(
                                        height: 30,
                                        // width: 250,
                                        child: TextField(
                                          controller: nameController,
                                          style: const TextStyle(
                                              fontFamily: "BreezeSans",
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          // controller: titleController,
                                          decoration: kTextFieldDecoration2(
                                              'Enter name of the supplier'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //rest of the things
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "Initial",
                                        style: kH2TextStyle(12, Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: SizedBox(
                                        height: 30,
                                        // width: 250,
                                        child: TextField(
                                          controller: initialController,
                                          style: const TextStyle(
                                              fontFamily: "BreezeSans",
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          // controller: titleController,
                                          decoration: kTextFieldDecoration2(
                                              'Enter initial of the supplier'),
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
                                        "Email",
                                        style: kH2TextStyle(12, Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: SizedBox(
                                        height: 30,
                                        // width: 250,
                                        child: TextField(
                                          controller: emailController,
                                          style: const TextStyle(
                                              fontFamily: "BreezeSans",
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          // controller: titleController,
                                          decoration: kTextFieldDecoration2(
                                              'Enter email of the customer'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "Mobile",
                                        style: kH2TextStyle(12, Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: SizedBox(
                                        height: 30,
                                        // width: 250,
                                        child: TextField(
                                          controller: mobileNoController,
                                          style: const TextStyle(
                                              fontFamily: "BreezeSans",
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          // controller: titleController,
                                          decoration: kTextFieldDecoration2(
                                              'Enter mobile number of the customer'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
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
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                        resetTextEditingControllers();
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shadowColor:
                                            Theme.of(context).primaryColor, backgroundColor: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                          Text('Add Supplier',
                                              style: kH2TextStyle(
                                                  14.0, Colors.white)),
                                        ],
                                      ),
                                      onPressed: () {
                                        SupplierModel newSupplier =
                                            SupplierModel(
                                          nameController.text,
                                          initialController.text,
                                          emailController.text,
                                          mobileNoController.text,
                                        );
                                        createCustomerDocument(newSupplier);
                                        resetTextEditingControllers();
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      )),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
