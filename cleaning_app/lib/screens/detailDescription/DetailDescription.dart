import 'package:flutter/material.dart';
import '../locationDetail/imageBanner.dart';
import 'TextSection.dart';
import '../../models/LocationCleaning.dart';

class DetailDescription extends StatelessWidget {
  final int _locationID;
  final int _cleaningID;

  DetailDescription(this._locationID, this._cleaningID);

  @override
  Widget build(BuildContext context) {

    final cleaning = LocationCleaning.getCleaning(_locationID, _cleaningID);

    return Scaffold(
      appBar: AppBar(
        title: Text(cleaning.name),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageBanner(cleaning.imagePath),
            TextSection(cleaning.name, cleaning.description),
      ]
    )
    );
  }


}
