import 'package:byabsha/stub/constants.dart';
import 'package:byabsha/view/customers.dart';
import 'package:byabsha/view/dashboard.dart';
import 'package:byabsha/view/login.dart';
import 'package:byabsha/view/orders.dart';
import 'package:byabsha/view/products.dart';
import 'package:byabsha/view/inventory.dart';
import 'package:byabsha/view/suppliers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Section { dashboard, products, customers, inventory, orders, suppliers }

class ViewPort extends StatefulWidget {
  const ViewPort({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ViewPort> createState() => _ViewPortState();
}

class _ViewPortState extends State<ViewPort> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut().then(
      (value) async {
        return await FirebaseAuth.instance.signOut().then(
              (value) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              ),
            );
      },
    );
  }

  Section? _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedSection = Section.dashboard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BYABSHA",
          style: TextStyle(
            fontFamily: "BreezeSans",
            fontSize: 20,
            color: Colors.white
          ),
        ),
        // automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.transparent,
        actions: [
          TextButton(
              onPressed: () {
                _signOut();
              },
              child: Text(
                "Logout",
                style: kH2TextStyle(16, Colors.white),
              ))
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 200,
            // color: Color.fromARGB(255, 218, 215, 238),
            // color: Colors.red,
            child: Column(children: [
              ListTile(
                hoverColor: const Color.fromARGB(255, 152, 143, 206),
                selectedTileColor: _selectedSection == Section.dashboard
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 152, 143, 206),
                // tileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.dashboard,
                  color: _selectedSection == Section.dashboard
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  "Dashboard",
                  style: TextStyle(
                      fontFamily: "BreezeSans",
                      fontSize: 15,
                      color: _selectedSection == Section.dashboard
                          ? Colors.white
                          : Colors.black),
                ),
                selected: _selectedSection == Section.dashboard,
                onTap: () {
                  setState(() {
                    _selectedSection = Section.dashboard;
                  });
                },
              ),
              ListTile(
                hoverColor: const Color.fromARGB(255, 152, 143, 206),

                selectedTileColor: _selectedSection == Section.orders
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 152, 143, 206),
                // tileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.local_shipping_outlined,
                  color: _selectedSection == Section.orders
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  "Orders",
                  style: TextStyle(
                      fontFamily: "BreezeSans",
                      fontSize: 15,
                      color: _selectedSection == Section.orders
                          ? Colors.white
                          : Colors.black),
                ),
                selected: _selectedSection == Section.orders,
                onTap: () {
                  setState(() {
                    _selectedSection = Section.orders;
                  });
                },
              ),
              ListTile(
                hoverColor: const Color.fromARGB(255, 152, 143, 206),

                selectedTileColor: _selectedSection == Section.inventory
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 152, 143, 206),
                // tileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.production_quantity_limits,
                  color: _selectedSection == Section.inventory
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  "Inventory",
                  style: TextStyle(
                      fontFamily: "BreezeSans",
                      fontSize: 15,
                      color: _selectedSection == Section.inventory
                          ? Colors.white
                          : Colors.black),
                ),
                selected: _selectedSection == Section.inventory,
                onTap: () {
                  setState(() {
                    _selectedSection = Section.inventory;
                  });
                },
              ),
              ListTile(
                hoverColor: const Color.fromARGB(255, 152, 143, 206),
                selectedTileColor: _selectedSection == Section.products
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 152, 143, 206),
                // tileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.inventory,
                  color: _selectedSection == Section.products
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  "Products",
                  style: TextStyle(
                      fontFamily: "BreezeSans",
                      fontSize: 15,
                      color: _selectedSection == Section.products
                          ? Colors.white
                          : Colors.black),
                ),
                selected: _selectedSection == Section.products,
                onTap: () {
                  setState(() {
                    _selectedSection = Section.products;
                  });
                },
              ),
              ListTile(
                hoverColor: const Color.fromARGB(255, 152, 143, 206),
                selectedTileColor: _selectedSection == Section.customers
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 152, 143, 206),
                // tileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.person,
                  color: _selectedSection == Section.customers
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  "Customers",
                  style: TextStyle(
                      fontFamily: "BreezeSans",
                      fontSize: 15,
                      color: _selectedSection == Section.customers
                          ? Colors.white
                          : Colors.black),
                ),
                selected: _selectedSection == Section.customers,
                onTap: () {
                  setState(() {
                    _selectedSection = Section.customers;
                  });
                },
              ),
              ListTile(
                hoverColor: const Color.fromARGB(255, 152, 143, 206),
                selectedTileColor: _selectedSection == Section.customers
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 152, 143, 206),
                // tileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.cases_outlined,
                  color: _selectedSection == Section.suppliers
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  "Suppliers",
                  style: TextStyle(
                      fontFamily: "BreezeSans",
                      fontSize: 15,
                      color: _selectedSection == Section.suppliers
                          ? Colors.white
                          : Colors.black),
                ),
                selected: _selectedSection == Section.suppliers,
                onTap: () {
                  setState(() {
                    _selectedSection = Section.suppliers;
                  });
                },
              ),
            ]),
          ),
          if (_selectedSection == Section.products)
            ProductsPage(
              key: widget.key,
              user: widget.user,
            ),
          if (_selectedSection == Section.dashboard)
            DashBoard(user: widget.user),
          if (_selectedSection == Section.inventory)
            Inventory(user: widget.user),
          if (_selectedSection == Section.customers)
            Customers(user: widget.user),
          if (_selectedSection == Section.orders) Orders(user: widget.user),
          if (_selectedSection == Section.suppliers)
            Suppliers(user: widget.user)
        ],
      ),
    );
  }
}
