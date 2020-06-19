import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cards/listing_card.dart';
import 'main_screens/main_feed.dart';

class DirectoryStream extends StatelessWidget {
  DirectoryStream({
    @required this.firestore,
    @required this.category,
  });
  final Firestore firestore;
  final String category;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection(category == null ? 'error' : category)
          .orderBy('Business')
          .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
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

          double long = listing.data['longitude'];
          double lat = listing.data['latitude'];

          if (long == null || lat == null) {}
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

        //directory.sort(listingComparator);
        return Expanded(
          child: Scrollbar(
            controller: ScrollController(),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: directory,
            ),
          ),
        );
      }),
    );
  }

  int listingComparator(ListingCard a, ListingCard b) {
    //if no location data, rely on alphabetical
    if (MainFeed.location == null) {
      return a.name.compareTo(b.name);
    } else {
      Map<String, double> distancesMap = MainFeed.distances;
      while (distancesMap[a.name] != null && distancesMap[b.name] != null) {}
      ;
      return (distancesMap[a.name] - distancesMap[b.name]).toInt();
    }
  }
}
