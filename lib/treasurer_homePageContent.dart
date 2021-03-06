import 'package:flutter/material.dart';
import 'reusable_components/reusable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'treasurer_notice_board.dart';
import 'treasurer_queryToRWA.dart';
import 'collections.dart';

class TreasurerHomePageContent extends StatefulWidget {
  final communityName;
  final phoneNumber;
  final gmailId;

  TreasurerHomePageContent(
      {this.communityName, this.phoneNumber, this.gmailId});

  @override
  _TreasurerHomePageContentState createState() =>
      _TreasurerHomePageContentState();
}

class _TreasurerHomePageContentState extends State<TreasurerHomePageContent> {
  final _firestore = FirebaseFirestore.instance;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  String getInitials(String fullName) {
    List<String> splits = fullName.split(' ');

    return fullName.substring(0, splits[0].length);
  }

  Future<Map<String, dynamic>> getUsersDocumentData() async {
    DocumentReference documentRef;

    if (widget.gmailId == null) {
      documentRef = _firestore
          .collection('treasurers')
          .doc(widget.communityName)
          .collection('data')
          .doc(widget.phoneNumber);
    } else {
      documentRef = _firestore
          .collection('treasurers')
          .doc(widget.communityName)
          .collection('data')
          .doc(widget.gmailId);
    }

    Map<String, dynamic> data;

    await documentRef.get().then((snapshot) {
      data = snapshot.data();
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xFF546048),
          height: 150,
        ),
        ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          children: [
            Container(
              height: 50,
              child: FutureBuilder<Map<String, dynamic>>(
                future: getUsersDocumentData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      '${greeting()}! ${getInitials(snapshot.data['name'])}\nHow can I help you?',
                      textScaleFactor: 1.5,
                    );
                  } else {
                    return Text(
                      'Loading...',
                      textScaleFactor: 1.5,
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 16,
              cardTitle: 'Notice Board',
              cardDescription:
                  'View the latest notices and Issue new ones from the RWA.',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TreasurerNoticeBoard(
                        communityName: widget.communityName,
                        phoneNumber: widget.phoneNumber,
                        gmailId: widget.gmailId,
                      ),
                    ),
                  );
                });
              },
            ),
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 9,
              cardTitle: 'Collections',
              cardDescription:
                  'View abd Update un/approved fee status from the RWA',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Collections(),
                    ),
                  );
                });
              },
            ),
            ReusableCard(
              cardColor: Colors.black,
              imageNo: 1,
              cardTitle: 'Query to the RWA',
              cardDescription:
                  'Resolve your query directly with the RWA staff.',
              onTapCard: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TreasurerQueryToRWA(
                        communityName: widget.communityName,
                        phoneNumber: widget.phoneNumber,
                        gmailId: widget.gmailId,
                      ),
                    ),
                  );
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 160),
              width: 200,
              height: 200,
              child: Image.asset('images/13.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'of, for and by the ',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'residents',
                  style: TextStyle(fontSize: 30, color: Colors.white70),
                ),
                Text(
                  ' welfare association',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
