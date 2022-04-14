import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thefirstone/resources/api.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({Key? key}) : super(key: key);

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Nearby Doctors",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            // Image.asset(
            //   'assets/Doctor-placeholder-image.jpg',
            //   height: 100,
            //   fit: BoxFit.cover,
            // ),
            Expanded(
              child: StreamBuilder(
                stream: API.doctorsList(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.5,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/Doctor-placeholder-image.jpg',
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]['name'],
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]
                                                ['qualification'],
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Theme.of(context).accentColor,
                                              child: const Icon(
                                                Icons.call,
                                                color: Color(0xFFBF828A),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          InkWell(
                                            onTap: () {},
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Theme.of(context).accentColor,
                                              child: const Icon(
                                                Icons.location_pin,
                                                color: Color(0xFFBF828A),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFBF828A)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
