import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator",
    home: SICalculator(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SICalculator extends StatelessWidget {
 static var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formKey,
        // color: Colors.blueGrey,
        // margin: EdgeInsets.all(_minimumPadding *2),
        child: ListView(
          children: [
            Expanded(child: MoneyImage()),
            Expanded(child: PrincipalAmount()),
            // Expanded(child: Buttons())
          ],
        ),
      ),
    );
  }
}

class MoneyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      margin: EdgeInsets.all(40.0),
      child: image,
    );
  }
}

class PrincipalAmount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrincipalAmount();
  }
}

class _PrincipalAmount extends State<PrincipalAmount> {



  final _minimumPadding = 5.0;
  String principal = "Principal";
  String rot = "Rate of Interest";
  String duration = "Duration";
  var _currencies = ["Naira", "Dollars", "Pounds", "Others"];
  var _currentItemSelected = " ";

  @override
  void initState() {
    super.initState();
    _currentItemSelected =
        _currencies[0]; //to set the default spinner item as the 1st array item
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  var displayResult = " ";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Container(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(_minimumPadding),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: textStyle,
                controller: principalController,
                validator: (String value){
                  if(value.isEmpty){
                    // ignore: missing_return, missing_return
                    return 'Field cannot be empty';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Principal',
                    hintText: 'Enter Principal Amount e.g. 50000',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
          Padding(
              padding: EdgeInsets.all(_minimumPadding),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: textStyle,
                controller: roiController,
                validator: (String value){
                  if (value.isEmpty){
                    return 'Field cannot be empty';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Rate',
                    hintText: 'Enter Rate of Interest in Percentage',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
          // Padding(padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          // child:
          Padding(
            padding: EdgeInsets.all(_minimumPadding),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: durationController,
                  validator: (String value){
                    if (value.isEmpty){
                      return "Can't be empty";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Duration',
                      hintText: 'Duration in Years',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),

                )),
                Container(
                  width: _minimumPadding * 5,
                ),
                Expanded(
                    child: DropdownButton<String>(
                  items: _currencies.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem));
                  }).toList(),
                  onChanged: (String newValueSelected) {
                    // your code to execute when a menu item is selected from drop down
                    _OnDropDownItemSelected(newValueSelected);
                  },
                  value: _currentItemSelected,
                ))
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        "Calculate",
                        style: textStyle,
                      ),
                      elevation: 6.0,
                      onPressed: () {

                        setState(() {
                          if(SICalculator._formKey.currentState.validate()){
                            this.displayResult = calculateButton();
                          }

                        });
                      })),
              Expanded(
                  child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "Reset",
                        style: textStyle,
                      ),
                      elevation: 6.0,
                      onPressed: () {
                        setState(() {
                          resetButton();
                        });
                      }))
            ],
          ),
          Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: Text(
              this.displayResult,
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }

  void _OnDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String calculateButton() {
    double principal = double.parse(principalController.text);
    double rate = double.parse(roiController.text);
    double duration = double.parse(durationController.text);

    double totalReturnAmount = principal + (principal * rate * duration) / 100;
    String result =
        "After $rate years, your total returns will be $totalReturnAmount on an investment of $principal $_currentItemSelected";

    return result;
  }

  // void calculateButton(BuildContext context) {
  //
  //   // var alertDialog = AlertDialog(
  //   //   title: Text("Calculate Clicked!!"),
  //   //   content: Text("Calculating..."),
  //   // );
  //   // showDialog(
  //   //     context: context, builder: (BuildContext context) => alertDialog);
  // }
  void resetButton() {
    principalController.text = " ";
    roiController.text = " ";
    durationController.text = " ";
    displayResult = " ";
    _currentItemSelected = _currencies[0];
  }

// void resetButton(BuildContext context) {
//   var alertDialog = AlertDialog(
//     title: Text("Reset Clicked!!"),
//     content: Text("Resetting..."),
//   );
//   showDialog(
//       context: context, builder: (BuildContext context) => alertDialog);
// }
}
