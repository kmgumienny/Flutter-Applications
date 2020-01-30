import 'package:flutter/material.dart';
import '../locationDetail/imageBanner.dart';
import 'TextSection.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/Name.dart';
import '../../models/LocationCleaning.dart';
import 'package:intl/intl.dart';


class DetailDescription extends StatefulWidget{
  final int _location_ID;
  final int _cleaningID;
  const DetailDescription(this._location_ID, this._cleaningID);
  @override
  State<StatefulWidget> createState(){
    return Description();
  }
}


class Description extends State<DetailDescription> {
  var _complete_list = [];
  @override
  Widget build(BuildContext context) {
    final cleaning = LocationCleaning.getCleaning(widget._location_ID, widget._cleaningID);
    return ScopedModelDescendant<NameModel>(
        builder: (BuildContext context, Widget child, NameModel model) {
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
                    Container(
                        margin: EdgeInsets.all(10.0),
                        child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                var now = DateFormat.yMMMd("en_US").format(DateTime.now());

                                _complete_list.add("Completed on " + now + " by " + '${model.name}');
                              });
                            },
                            child: Text('Complete?'))),
                    Column(
                        children: _complete_list
                            .map((element) => Card(
                          child: Column(
                            children: <Widget>[
                              Text(element)
                            ],
                          ),
                        ))
                            .toList()),
                  ]
              )
          );
        }
        );
    }

}
