import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:keepaustinblack/containers/my_list_tile.dart';

class ListingCard extends StatefulWidget {
  final String name;
  final String address;
  final String img;
  final String phoneNum;
  final String website;
  final String description;
  final String cardCategory;
  final String cardId;

  ListingCard(
      {@required this.name,
      this.address,
      this.img,
      this.phoneNum,
      this.website,
      this.description,
      this.cardCategory,
      this.cardId});

  @override
  _ListingCardState createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard>
    with AutomaticKeepAliveClientMixin {
  bool liked = false;
  String uid;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  bool get wantKeepAlive => true;

  Future<String> getUid() async {
    if ((await auth.currentUser()) != null) {
      uid = (await auth.currentUser()).uid;
      return uid;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    getIsLiked();
  }

  void getIsLiked() async {
    String currUid = await getUid();
    DocumentReference newFavorite = Firestore.instance
        .collection('users')
        .document(currUid)
        .collection('fav${widget.cardCategory}')
        .document(widget.cardId);

    final data = await newFavorite.get();
    final String mapString = data.data.toString();
    bool result = mapString != null && mapString != "" && mapString != 'null';
    if (this.mounted) {
      setState(() {
        liked = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasNum = widget.phoneNum != null && widget.phoneNum != "";
    bool hasSite = widget.website != null && widget.website != "";
    bool hasImage = widget.img != null && widget.img != "";
    bool hasAddress = widget.address != null && widget.address != "";
    bool hasDescription =
        widget.description != null && widget.description != "";
    getIsLiked();

    return Container(
      child: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      LikeButton(
                        isLiked: liked,
                        onTap: onFavButtonTapped,
                        size: 30,
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.deepOrange : Colors.grey,
                            size: 30,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (hasDescription)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 15,
                      ),
                    ),
                  ),
                if (hasAddress)
                  ContactButton(
                    text: widget.address,
                    onPressed: () {
                      MapsLauncher.launchQuery(widget.address);
                    },
                    icon: Icons.location_on,
                    maxLines: 2,
                  ),
                if (hasNum)
                  ContactButton(
                    onPressed: () {
                      launch('tel://2141234567');
                    },
                    text: widget.phoneNum,
                    icon: FontAwesomeIcons.phone,
                    maxLines: 1,
                  ),
                if (hasSite)
                  ContactButton(
                    text: widget.website,
                    icon: Icons.language,
                    onPressed: () {
                      launch(widget.website);
                    },
                    maxLines: 1,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onFavButtonTapped(bool isLiked) async {
    final firestore = Firestore.instance;
    final auth = FirebaseAuth.instance;
    final String uid = (await auth.currentUser()).uid;
    DocumentReference newFavorite = firestore
        .collection('users')
        .document(uid)
        .collection('fav${widget.cardCategory}')
        .document(widget.cardId);
    DocumentReference businessReference =
        firestore.collection(widget.cardCategory).document(widget.cardId);

    //code to add business to the current user's favorites list
    final info = await businessReference.get();
    if (!isLiked) {
      newFavorite.setData(info.data);
    }
    //code to remove business from the current user's favorites list
    else {
      newFavorite.delete();
    }
    setState(() {
      liked = !isLiked;
    });
    return liked;
  }
}

class ContactButton extends StatelessWidget {
  const ContactButton(
      {Key key, @required this.onPressed, this.icon, this.text, this.maxLines})
      : super(key: key);

  final Function onPressed;
  final IconData icon;
  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: MyListTile(
        leading: icon,
        title: text,
      ),
    );
  }
}
