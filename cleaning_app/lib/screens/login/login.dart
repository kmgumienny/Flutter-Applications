import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/Name.dart';



class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreen();
  }
}

class FormScreen extends State<Login> {

  var _name;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _getNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Enter Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }
        _name = value;
        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NameModel>(
        builder: (BuildContext context, Widget child, NameModel model)
    {
      return Scaffold(
          appBar: AppBar(
            title: Text('Login Here'),
          ),
          body: Container(
            margin: EdgeInsets.all(24),
            child: Form(
                key: _formKey,
                child: ListView(
                children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network('https://media.giphy.com/media/3DnDRfZe2ubQc/giphy.gif'),
                    SizedBox(height: 100),
                    _getNameField(),
                    SizedBox(height: 100,),
                    RaisedButton(
                        child: Text(
                          'Submit', style: TextStyle(color: Colors.blue),),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          model.updateName(_name);
                          _onLocationTap(context, 'hi');
                        }
                    )
                  ],

                ),
                ]
                )
            ),
          )
      );
    }
    );
  }

  _onLocationTap(BuildContext context, String locationID) {
    Navigator.pushNamed(context, '/location',
        arguments: {"name": _name});
  }
}