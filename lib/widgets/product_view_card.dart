import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var cardDetails;

  ProductCard({Key? key, @required cardDetails}) : super(key: key);

  // ProductCard(this.cardDetails);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      elevation: 2,
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: _buildTitle(),
          trailing: const SizedBox(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text("Herzlich Willkommen"),
                  Spacer(),
                  Icon(Icons.check),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text("Das Kursmenu"),
                  Spacer(),
                  Icon(Icons.check),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(cardDetails["Tittle"].toString()),
          ],
        ),
        Text(cardDetails["Brand Name"].toString()),
        Row(
          children: <Widget>[
            Text(cardDetails["Description"].toString()),
            Text(cardDetails["Price"]["Selling Price"].toString())
          ],
        ),
      ],
    );
  }
}
