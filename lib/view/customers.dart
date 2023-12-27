import 'package:byabsha/model/customer_model.dart';
import 'package:byabsha/stub/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
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
    resultsLoaded = getCustomerStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var customerSnapshot in _allResults) {
        var title = customerSnapshot['Name'].toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(customerSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getCustomerStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Customers')
        .get();
    setState(() {
      _allResults = data.docs;
    });

    searchResultsList();
    return "complete";
  }

  removeCustomerPopup() {
    String dropDownProduct = _allResults[0]["Name"].toString();
    List<String> products = [];

    for (var element in _allResults) {
      products.add(element["Name"]);
    }

    returnFullProductSnapshot(String product) {
      for (var element in _allResults) {
        if (element["Name"] == product) {
          return element;
        }
      }
    }

    removeProduct(String customerID) async {
      // ignore: unused_local_variable
      var a = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.user.uid)
          .collection('Customers')
          .doc(customerID)
          .delete();
    }

    var dropdownProductSnapshot = _allResults[0];
    var docItemRef = dropdownProductSnapshot.reference;

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
                "Remove customer",
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
                          "Select Customer                  ",
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
                              Text('Remove customer',
                                  style: kH2TextStyle(14.0, Colors.white)),
                            ],
                          ),
                          onPressed: () {
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

  createCustomerDocument(CustomerModel customer) async {
    // ignore: unused_local_variable
    var a = await FirebaseFirestore.instance
        .collection('User')
        .doc(widget.user.uid)
        .collection('Customers')
        .add({
      "Name": customer.name,
      "Initial": customer.initial,
      "Email": customer.email,
      "Profession": customer.profession,
      "Birthday": customer.date,
      "Mobile No": customer.mobile,
      "Flat No": customer.flatNo,
      "House No": customer.houseNo,
      "Road No": customer.roadNo,
      "Area": customer.area,
      "City No": customer.city,
      "Country No": customer.country,
      "Post Code": customer.post,
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
                Row(
                  children: <Widget>[
                    Text(
                      "Profession: ${_resultsList[index].data()["Profession"].toString()}",
                      style: kS2TextStyle.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Birthday: ${_resultsList[index].data()["Birthday"].toString()}",
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
                            "• Flat No: ${_resultsList[index].data()["Flat No"].toString()}",
                            style: kS2TextStyle.copyWith(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "• Road No: ${_resultsList[index].data()["Road No"].toString()}",
                            style: kS2TextStyle.copyWith(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "• Area: ${_resultsList[index].data()["Area"].toString()}",
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
                              "• City: ${_resultsList[index].data()["City No"].toString()}",
                              style: kS2TextStyle.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "• Country No: ${_resultsList[index].data()["Country No"].toString()}",
                              style: kS2TextStyle.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ]),
                    )
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
    DateTime date = DateTime.now();
    TextEditingController dateCtl = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController initialController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController professionController = TextEditingController();
    TextEditingController mobileNoController = TextEditingController();
    TextEditingController flatNoController = TextEditingController();
    TextEditingController houseNoController = TextEditingController();
    TextEditingController roadNoController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController countryController = TextEditingController();
    TextEditingController postCodeController = TextEditingController();

    void resetTextEditingControllers() {
      nameController.clear();
      initialController.clear();
      emailController.clear();
      professionController.clear();
      dateCtl.clear();
      mobileNoController.clear();
      flatNoController.clear();
      houseNoController.clear();
      roadNoController.clear();
      areaController.clear();
      cityController.clear();
      countryController.clear();
      postCodeController.clear();
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
                            // TextButton(
                            //   onPressed: () {
                            //     // returnEditPopup();
                            //   },
                            //   child: const Text("Edit/Modify"),
                            // ),
                            // TextButton(
                            //   onPressed: () {},
                            //   child:
                            //       const Text("Add Product"),
                            // ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  removeCustomerPopup();
                                });
                              },
                              child: const Text("Remove Customer"),
                            ),
                          ],
                        )
                      ],
                    )
                  ]),
            ),
            Expanded(
              child: FutureBuilder(
                future: getCustomerStreamSnapshots(),
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
                        "Add new customer",
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
                                              'Enter name of the customer'),
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
                                              'Enter initial of the customer'),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "Profession",
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
                                          controller: professionController,
                                          style: const TextStyle(
                                              fontFamily: "BreezeSans",
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          // controller: titleController,
                                          decoration: kTextFieldDecoration2(
                                              'Enter profession of the customer'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "Birthday",
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
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: dateCtl,
                                          decoration: kTextFieldDecoration2(
                                              "Select Date"),
                                          onTap: () async {
                                            await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1920),
                                              lastDate: date,
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                dateCtl.text =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDate);
                                              }
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "Address",
                                        style: kH2TextStyle(12, Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: DottedBorder(
                                        dashPattern: const [1, 0],
                                        // dashPattern: [10, 5],
                                        strokeWidth: 1,
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(12),
                                        padding: const EdgeInsets.all(10),
                                        // color: Color.fromARGB(255, 192, 191, 197),
                                        color: Colors.grey,
                                        child: SizedBox(
                                          // height: 100,
                                          width: 250,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        "Flat",
                                                        style: kH2TextStyle(
                                                            12, Colors.black),
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
                                                          controller:
                                                              flatNoController,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "BreezeSans",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          // controller: titleController,
                                                          decoration:
                                                              kTextFieldDecoration2(
                                                                  'Flat No'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        "House",
                                                        style: kH2TextStyle(
                                                            12, Colors.black),
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
                                                          controller:
                                                              houseNoController,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "BreezeSans",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          // controller: titleController,
                                                          decoration:
                                                              kTextFieldDecoration2(
                                                                  'House No'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        "Road",
                                                        style: kH2TextStyle(
                                                            12, Colors.black),
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
                                                          controller:
                                                              roadNoController,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "BreezeSans",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          // controller: titleController,
                                                          decoration:
                                                              kTextFieldDecoration2(
                                                                  'Road No'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        "Area",
                                                        style: kH2TextStyle(
                                                            12, Colors.black),
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
                                                          controller:
                                                              areaController,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "BreezeSans",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          // controller: titleController,
                                                          decoration:
                                                              kTextFieldDecoration2(
                                                                  'Area'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        "City",
                                                        style: kH2TextStyle(
                                                            12, Colors.black),
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
                                                          controller:
                                                              cityController,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "BreezeSans",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          // controller: titleController,
                                                          decoration:
                                                              kTextFieldDecoration2(
                                                                  'City'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        "Country",
                                                        style: kH2TextStyle(
                                                            12, Colors.black),
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
                                                          controller:
                                                              countryController,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "BreezeSans",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          // controller: titleController,
                                                          decoration:
                                                              kTextFieldDecoration2(
                                                                  'Country'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        "Post",
                                                        style: kH2TextStyle(
                                                            12, Colors.black),
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
                                                          controller:
                                                              postCodeController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "BreezeSans",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          // controller: titleController,
                                                          decoration:
                                                              kTextFieldDecoration2(
                                                                  'Post Code'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
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
                                          Text('Add Customer',
                                              style: kH2TextStyle(
                                                  14.0, Colors.white)),
                                        ],
                                      ),
                                      onPressed: () {
                                        CustomerModel newCustomer =
                                            CustomerModel(
                                                nameController.text,
                                                initialController.text,
                                                emailController.text,
                                                professionController.text,
                                                dateCtl.text,
                                                mobileNoController.text,
                                                flatNoController.text,
                                                houseNoController.text,
                                                roadNoController.text,
                                                areaController.text,
                                                cityController.text,
                                                countryController.text,
                                                postCodeController.text);
                                        createCustomerDocument(newCustomer);
                                        resetTextEditingControllers();
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
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
