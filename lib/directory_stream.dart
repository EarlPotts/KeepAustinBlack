import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cards/listing_card.dart';
import 'main_screens/main_feed.dart';

class DirectoryStream extends StatelessWidget {
  DirectoryStream(
      {@required this.firestore,
      @required this.category,
      @required this.type,
      @required this.uid,
      @required this.search});
  final Firestore firestore;
  final String category, type, uid, search;

  @override
  Widget build(BuildContext context) {
    //setting the correct stream based on the type of stream
    Stream<QuerySnapshot> stream;
    switch (type) {
      case 'favorites':
        stream = firestore
            .collection('users')
            .document(uid)
            .collection(category == null ? 'error' : ('fav$category'))
            .orderBy('Business')
            .snapshots();
        break;
      default:
        stream = firestore
            .collection(category == null ? 'error' : category)
            .orderBy('Business')
            .snapshots();
    }
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          if (type == 'favorites') {
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
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
        }
        final listings = snapshot.data.documents;
        List<ListingCard> directory = [];

        for (var listing in listings) {
          final businessName = listing.data['Business'];
          if (search != "" && search != null && businessName != null) {
            bool include = businessName
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase());
            print('Name: $businessName Search terms: $search');
            if (!include) break;
          }
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

        if (directory.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'No businesses match your search criteria.',
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
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
