import 'package:flutter/material.dart';
import '../locationDetail/imageBanner.dart';
import 'TextSection.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/Name.dart';
import '../../models/LocationCleaning.dart';
import 'package:intl/intl.dart';
import '../../models/Cleaner.dart';
import 'package:sqflite/sqflite.dart';
import '../../utils/database.dart';

class DetailDescription extends StatefulWidget{
  final int _location_ID;
  final int _cleaningID;
  final String _name;
  const DetailDescription(this._location_ID, this._cleaningID, this._name);
  @override
  State<StatefulWidget> createState(){
    return Description();
  }
}


class Description extends State<DetailDescription> {
  List<Cleaner> cleanerList;
  var count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  String name;

  @override
  Widget build(BuildContext context) {
    final cleaning = LocationCleaning.getCleaning(widget._location_ID, widget._cleaningID);

    if (cleanerList == null) {
      cleanerList = List<Cleaner>();
      updateCleanerList();
    }

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
                                name = '${model.name}';
                                saveCleaning(name);
                              }
                              );
                            },
                            child: Text('Complete?'))),
                          new Expanded(
                            child: getCleaningListView(),),

//                    ListView(
//                        children: cleanerList
//                            .map((element) => Card(
//                          child: Column(
//                            children: <Widget>[
//                              Text(element)
//                            ],
//                          ),
//                        ))
//                            .toList()),
                  ]
              )
          );
        }
        );
    }

  void updateCleanerList(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Cleaner>> cleanerListFuture = databaseHelper.getCleanerList();
      cleanerListFuture.then((cleanerList) {
        setState(() {
          this.cleanerList = cleanerList;
          this.count = cleanerList.length;
//            for (int i = 0; i < count; i++){
//              print(cleanerList[i]);
//            }
        });
      });
    });
  }

  ListView getCleaningListView() {


    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
//    if (count == 0)
//      return Text;
//    else {
      for (int i = 0; i < count; i++) {
        databaseHelper.deleteCleaning(i);
      }
//    }
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              title: Text(this.cleanerList[position].cleaningComp, style: titleStyle,),
          ),
        );
      },
    );
  }

  void saveCleaning(String username) async {

    int result;
    var now = DateFormat.yMMMd("en_US").format(DateTime.now());
    String cleaning = "Completed on " + now + " by " + username;
    Cleaner newCleaning = Cleaner(username, cleaning);
    result = await databaseHelper.insertCleaning(newCleaning);


    if (result == 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Cleaning not saved."),
        content: Text("There was an error saving the cleaning."),
      );
      showDialog(
          context: context,
          builder: (_) => alertDialog
      );
    }
    updateCleanerList();

  }

}
