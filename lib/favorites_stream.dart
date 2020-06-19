import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cards/listing_card.dart';

class FavoritesStream extends StatelessWidget {
  FavoritesStream(
      {@required this.firestore, @required this.category, @required this.uid});
  final Firestore firestore;
  final String category;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('users')
          .document(uid)
          .collection(category == null ? 'error' : ('fav$category'))
          .orderBy('Business')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot == null ||
            snapshot.data.documents.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'You currently have no selected Favorite $category businesses.\n Tap the heart icon on a business\' card to add to your favorites! ',
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        final listings = snapshot.data.documents;
        List<ListingCard> directory = [];

        for (var listing in listings) {
          final businessName = listing.data['Business'];
          final address = listing.data['Address'];
          final number = listing.data['Phone Number'].toString();
          final imgUrl = listing.data['Img URL'];
          final website = listing.data['Website'];
          final description = listing.data['Description'];
          final id = listing.documentID;

          final listingCard = ListingCard(
              name: businessName,
              address: address,
              img: imgUrl,
              phoneNum: number,
              website: website,
              description: description,
              cardCategory: category,
              cardId: id);
          directory.add(listingCard);
        }
        return Expanded(
          child: Scrollbar(
            controller: ScrollController(),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: directory,
            ),
          ),
        );
      },
    );
  }
}
