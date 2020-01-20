import 'package:carappsl/Services/auth_service.dart';
import 'package:flutter/material.dart';

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

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password, _contactNo, _VRegistrationNo, _BrandModel, _Year ;


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

  @override
  void initState(){
    _dropdownMenuItem = buildDropDownMenuItem(_brand);
    _selectedBrand = _dropdownMenuItem[0].value;

    _dropdownMenuItemYear = buildDropDownMenuItemYear(_yearS);
    _selectedYear = _dropdownMenuItemYear[0].value;


    super.initState();
  }

  List<DropdownMenuItem<VehicleBrand>> buildDropDownMenuItem(List brands) {
    List<DropdownMenuItem<VehicleBrand>> items = List();
    for (VehicleBrand barnd in brands) {
      items.add(
        DropdownMenuItem(
          value: barnd,
          child: Text(barnd.barnd),
        ),
      );
    }
    return items;
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

  onChangedDropDownItem(VehicleBrand selectedBrand){
    setState(() {
      _selectedBrand = selectedBrand;
      _BrandModel = _selectedBrand.barnd;
    });


  }

  onChangedDropDownItemYear(Year selectedYear){
    setState(() {
      _selectedYear = selectedYear;
      _Year= _selectedYear.year;
    });


  }

  //***********Vehicle Brand List


  _submit() {

    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      //Login the user with firebase using the services
      AuthService.signUpUser(context, _name, _email, _password, _contactNo, _VRegistrationNo, _BrandModel, _Year);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //Ceneter everything

        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.5,
            child: Column(  //Create a column child in cscaffold
              mainAxisAlignment: MainAxisAlignment.center,  //To center the title
              crossAxisAlignment: CrossAxisAlignment.center,  //To center the title'
              children: <Widget>[    //Inside this widget we do all the login screen design

                CircleAvatar(   //Add app logo
                    radius: 50.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/images/logotemp.png')
                ),

                Text('ZoneGram',
                  style: TextStyle(
                      fontSize: 50.0,   //Add style to text******
                      fontFamily: 'Pacifico'  //Need to add this font type to pubspec.yaml --fonts
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

                      Padding( //Vehicle brand model
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),   //Add padding around text field
                        child: DropdownButtonFormField(    // Input label email
                          decoration: InputDecoration(labelText: 'Brand / Model'),
                          value: _selectedBrand,
                          items: _dropdownMenuItem,
                          onChanged: onChangedDropDownItem,

                        ),
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

                      Container(   //Sign up button container
                        width: 250.0,
                        child: FlatButton(    // Login button
                          onPressed: () => Navigator.pop(context),
                          color: Colors.lightBlue,
                          padding: EdgeInsets.all(10.0),
                          child: Text('Back To Login',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
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
