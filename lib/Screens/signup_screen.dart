import 'package:carappsl/Screens/test_screen.dart';
import 'package:carappsl/Services/auth_service.dart';
import 'package:carappsl/Services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class SignupScreen extends StatefulWidget {

  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class VehicleBrand{
  String barnd;

  VehicleBrand(this.barnd);

  static List<VehicleBrand> getBrand(){
    return <VehicleBrand>[
      VehicleBrand('Select vehicle brand/Model'),
      VehicleBrand('Toyota Axio'),
      VehicleBrand('Honad Fit'),
    ];
  }

}

class Year{
  String year;

  Year(this.year);

  static List<Year> getYear(){
    return <Year>[
      Year('Select Year'),
      Year('2020'),
      Year('2019'),
      Year('2018'),
      Year('2017'),
    ];
  }

}

class FuelType{
  String fuelT;

  FuelType(this.fuelT);

  static List<FuelType> getFuelType(){
    return <FuelType>[
      FuelType('Select Fuel Type'),
      FuelType('Petrol'),
      FuelType('Diesel'),
      FuelType('Electric'),
      FuelType('Hybrid'),
      FuelType('Gas'),

    ];
  }

}

class Transmission{
  String transmission;

  Transmission(this.transmission);

  static List<Transmission> getTransmissionType(){
    return <Transmission>[
      Transmission('Select Transmission Type'),
      Transmission('Auto'),
      Transmission('Manual'),

    ];
  }

}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password, _contactNo, _VRegistrationNo, _BrandModel, _Year, _fueltt, _tranmissiont ;


  //Contact number validation
  static String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);

  //************Vehicle Brand List
  List<VehicleBrand> _brand = VehicleBrand.getBrand();
  List<DropdownMenuItem<VehicleBrand>> _dropdownMenuItem;
  VehicleBrand _selectedBrand;

  List<Year> _yearS = Year.getYear();
  List<DropdownMenuItem<Year>> _dropdownMenuItemYear;
  Year _selectedYear;

  List<FuelType> _furlT = FuelType.getFuelType();
  List<DropdownMenuItem<FuelType>> _dropdownMenuItemFuel;
  FuelType _selectedFuel;


  List<Transmission> _transmission = Transmission.getTransmissionType();
  List<DropdownMenuItem<Transmission>> _dropdownMenuItemTransmission;
  Transmission _selectedTransmission;

//  final List<String> carBrands = ['dgfdg','dgdfg'];
   List<String> _carBrands = [];

  String _currentcarBrands;
  String _currentcarModel;


  @override
  void initState(){
    _dropdownMenuItemYear = buildDropDownMenuItemYear(_yearS);
    _selectedYear = _dropdownMenuItemYear[0].value;

    _dropdownMenuItemTransmission = buildDropDownMenuItemTransmission(_transmission);
    _selectedTransmission = _dropdownMenuItemTransmission[0].value;

    _dropdownMenuItemFuel = buildDropDownMenuItemFuelType(_furlT);
    _selectedFuel = _dropdownMenuItemFuel[0].value;

    super.initState();
  }

  List<DropdownMenuItem<Year>> buildDropDownMenuItemYear(List brands) {
    List<DropdownMenuItem<Year>> items = List();
    for (Year barnd in brands) {
      items.add(
        DropdownMenuItem(
          value: barnd,
          child: Text(barnd.year),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<FuelType>> buildDropDownMenuItemFuelType(List brands) {
    List<DropdownMenuItem<FuelType>> items = List();
    for (FuelType barnd in brands) {
      items.add(
        DropdownMenuItem(
          value: barnd,
          child: Text(barnd.fuelT),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Transmission>> buildDropDownMenuItemTransmission(List brands) {
    List<DropdownMenuItem<Transmission>> items = List();
    for (Transmission barnd in brands) {
      items.add(
        DropdownMenuItem(
          value: barnd,
          child: Text(barnd.transmission),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> modelsCar(List brands) {
    List<DropdownMenuItem<String>> items = List();
    for (String barnd in brands) {
      items.add(
        DropdownMenuItem(
          value: barnd,
          child: Text(barnd),
        ),
      );
    }
    return items;
  }


  onChangedDropDownItemYear(Year selectedYear){
    setState(() {
      _selectedYear = selectedYear;
      _Year= _selectedYear.year;
    });
  }

  onChangedDropDownItemFuel(FuelType selectedFuel){
    setState(() {
      _selectedFuel = selectedFuel;
      _fueltt= selectedFuel.fuelT;
    });
  }

  onChangedDropDownItemTransmission(Transmission selectedTransmission){
    setState(() {
      _selectedTransmission = selectedTransmission;
      _tranmissiont= selectedTransmission.transmission;
    });
  }

  //***********Vehicle Brand List


  _submit() {

    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _BrandModel = _currentcarBrands+" "+_currentcarModel;
      //Login the user with firebase using the services
      AuthService.signUpUser(context, _name, _email, _password, _contactNo, _VRegistrationNo, _BrandModel, _Year, _fueltt, _tranmissiont, _currentcarBrands, _currentcarModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //Ceneter everything

        body: SingleChildScrollView(

          child: Container(

//            height: MediaQuery.of(context).size.height * 1.6,
            child: Column(//Create a column child in cscaffold

              mainAxisAlignment: MainAxisAlignment.center,  //To center the title
              crossAxisAlignment: CrossAxisAlignment.center,  //To center the title'
              children: <Widget>[    //Inside this widget we do all the login screen design

                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: GFAvatar(  //Add app logo
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      shape: GFAvatarShape.square
                  ),
                ),

                Text('Auto City',
                  style: TextStyle(
                      fontSize: 50.0,   //Add style to text******
                      fontFamily: 'schyler'  //Need to add this font type to pubspec.yaml --fonts
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Padding( //NAme
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: TextFormField(    // Input label email
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (input) => input.trim().isEmpty ? 'Please enter a valid name' : null,
                          onSaved: (input) => _name = input,
                        ),
                      ),

                      Padding(   //Email
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: TextFormField(    // Input label email
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (input) => !input.contains('@') ? 'Please enter a valid email': null,
                          onSaved: (input) => _email = input,
                        ),
                      ),

                      Padding(   //Contact number
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: TextFormField(    // Input label contact
                          decoration: InputDecoration(labelText: 'Contact No'),
                          validator: (input) => !regExp.hasMatch(input) ? 'Please enter a valid mobile mumber': null,
                          onSaved: (input) => _contactNo = input,
                        ),
                      ),

                      Padding( //Vehicle Registration No
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: TextFormField(    // Input label email
                          decoration: InputDecoration(labelText: 'Vehicle Registration No'),
                          validator: (input) => input.trim().isEmpty ? 'Please enter a valid Registration No' : null,
                          onSaved: (input) => _VRegistrationNo = input,
                        ),
                      ),


                      StreamBuilder<QuerySnapshot>(

                        stream: Firestore.instance.collection('cartypes').snapshots(),
                        builder: (context, snapshot){
                          if(!snapshot.hasData){
                            Text('Loading');
                          }
                          else{
                            List<DropdownMenuItem> brandd=[];
                            for(int i=0;i<snapshot.data.documents.length;i++){
                              DocumentSnapshot snap = snapshot.data.documents[i];

                              brandd.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap.documentID,
                                  ),
                                  value: "${snap.documentID}",
                                )
                              );
                            }
                            return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                          child: DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Brand'),
                            // ignore: missing_return, missing_return, missing_return, missing_return, missing_return, missing_return, missing_return, missing_return
                            value: _currentcarBrands,
                            items: brandd,
                            onChanged: (ss){
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _currentcarBrands = ss;
                              });


                            },
                            isExpanded: false,

                          ),
                            );
                          }
                          return null;
                        },
                      ),

                      StreamBuilder<QuerySnapshot>(

                        stream: Firestore.instance.collection('cartypes').snapshots(),
                        builder: (context, snapshot){
                          if(!snapshot.hasData){
                            Text('Loading');
                          }
                          else{
                            List<String> modelsT=[];
                            for(int i=0;i<snapshot.data.documents.length;i++){
                              DocumentSnapshot snap = snapshot.data.documents[i];
                              
                              if(snap.documentID == _currentcarBrands){
                                var ss = snap.data['models'];
                                modelsT = ss.toString().split(",").map((x) => x.trim()).toList();

                              }

                            }

                            if(modelsT != null){
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(labelText: 'Model'),
                                  // ignore: missing_return, missing_return, missing_return, missing_return, missing_return, missing_return, missing_return, missing_return
                                  value: _currentcarModel,
                                  items: modelsCar(modelsT),
                                  onChanged: (ss){
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _currentcarModel = ss;
                                    });
                                  },
                                  isExpanded: false,

                                ),
                              );
                            }
                          }
                          return null;
                        },
                      ),

                      Padding( //Vehicle year
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Year'),
                          value: _selectedYear,
                          items: _dropdownMenuItemYear,
                          onChanged: onChangedDropDownItemYear,

                        ),
                      ),


                      Padding( //Vehicle year
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Fuel Type'),
                          value: _selectedFuel,
                          items: _dropdownMenuItemFuel,
                          onChanged: onChangedDropDownItemFuel,

                        ),
                      ),

                      Padding( //Vehicle year
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Transmission'),
                          value: _selectedTransmission,
                          items: _dropdownMenuItemTransmission,
                          onChanged: onChangedDropDownItemTransmission,

                        ),
                      ),

                      Padding( //Password
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: TextFormField(    // Input label email
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (input) => input.length < 6 ? 'Must be atleast 6 characters' : null,
                          onSaved: (input) => _password = input,
                          obscureText: true,  //character hidden
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Container(   //Login button container
                        width: 250.0,
                        child: FlatButton(    // Login button
                          onPressed: _submit,
                          color: Colors.lightBlue,
                          padding: EdgeInsets.all(10.0),
                          child: Text('Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(   //Sign up button container
                          width: 250.0,
                          child: FlatButton(    // Login button
                            onPressed: () => Navigator.pop(context),
                            color: Colors.lightBlue,
                            padding: EdgeInsets.all(10.0),
                            child: Text('Back To Login',
                              style: TextStyle(color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ),
                      )


                    ],
                  ),
                )

              ],
            ),
          ),
        ),

    );
  }
}
