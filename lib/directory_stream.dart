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
  final FirebaseFirestore firestore;
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
        final listings = snapshot.data.docs;
        List<ListingCard> directory = [];

        for (QueryDocumentSnapshot listing in listings) {
          final businessName = listing.data()['Business'];
          //if the user entered a search term, then only add business that match
          if (search != "" && search != null && businessName != null) {
            //check if the search term appears in the business name or description
            bool nameMatch = businessName
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase());

            bool descMatch = listing.data()['Description']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase());

            bool include = nameMatch || descMatch;
            if (!include)
              break;
          }

          //create and add a card for the business
          final listingCard = ListingCard(
              name: businessName,
              address: listing.data()['Address'],
              img: listing.data()['Img URL'],
              phoneNum: listing.data()['Phone Number'].toString(),
              website: listing.data()['Website'],
              description: listing.data()['Description'],
              cardCategory: category,
              cardId: listing.id);
          directory.add(listingCard);
        }

        //if no businesses match the criteria, tell the user
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
}
