import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  var bodyy;
  var global;
  var pcountry ;
  List mycountries;
  String _value = 'TotalConfirmed';
  final List<DropdownMenuItem> option =  [ DropdownMenuItem(child: Text("Infected"), value: 'TotalConfirmed'),DropdownMenuItem(child: Text("Recovered"),  value: 'TotalRecovered',),DropdownMenuItem(  child: Text("Death"),  value: 'TotalDeaths')];
  final List<DropdownMenuItem> items = [
    DropdownMenuItem(
      child: Text("Nigeria"),
      value: 'Nigeria',
    ),
    DropdownMenuItem(
      child: Text("Afghanistan"),
      value: 'Afghanistan',
    )
  ];
  String selectedValue = 'Nigeria';
  List<String> item = ['a','b', 'c', 'd', 'e', 'f', 'g'];

  Future getResult() async{
   http.Response response = await http.get(
      Uri.encodeFull('https://api.covid19api.com/summary'),
      headers: {
         "Content-type": "application/json",
      },

   );
  var body = json.decode(response.body);

  setState(() {
    isloading = false;
    bodyy = body;
    mycountries = body['Countries'];
    global = body['Global'];
    pcountry = body['Countries'].where((country) => country['Country'] == selectedValue);
    pcountry = pcountry.toList()[0];
    mycountries.sort((a, b) => (b['TotalConfirmed']).compareTo(a['TotalConfirmed']));
    mycountries.forEach((element) {
     items.add(DropdownMenuItem(
            child: Text(element['Country']),
            value: element['Country'],
          ));
   });
  });
 }



   @override
  void initState() {
    getResult();
    super.initState();
  }

  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[50],
      body: isloading ? Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              greetings(),
              globalStat(context),
              countriesStat(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget globalStat(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
      ),
      child:  Center(
        child: Wrap(
          children: [
              cont(Icon(Icons.language,color: Colors.blueGrey[800],), "Total Infected", global['TotalConfirmed'] ?? 0, context, Colors.deepPurple),
              cont(Icon(Icons.sentiment_satisfied,color: Colors.blueGrey[800]), "Recovered", global['TotalRecovered']?? 0, context, Colors.green),
              cont(Icon(Icons.local_hospital, color: Colors.blueGrey[800]), "Death",  global['TotalDeaths']?? 0, context, Colors.red),
              cont(Icon(Icons.healing,color: Colors.blueGrey[800]), "Active Cases", global['TotalConfirmed']-global['TotalRecovered'], context, Colors.blue),
          ],
        ),
      )
    );
  }

  Widget countriesStat(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top:20, left:10, right:10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Statistics per Country",
           style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 17,)),
           country(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Country Report",
               style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 17,)),
               DropdownButton(
              elevation: 10,
              value: _value,
              items: option,
              onChanged: (value) {
                setState(() {
                  _value = value;
                  mycountries.sort((a, b) => (b[_value]).compareTo(a[_value]));
                });
              }),
            ],
          ),
           countryReport(),

        ],
      ),
    );
  }

  Widget drop(){
    return SearchableDropdown.single(
        items: items,
        hint: selectedValue,
        searchHint: "Select one",
        onChanged: (val) {
          setState(() {
            print(val);
            selectedValue = val;
            pcountry = bodyy['Countries'].where((country) => country['Country'] == selectedValue);
            pcountry = pcountry.toList()[0];
          });
          
          print(selectedValue);
        },
        isExpanded: true,
      );
  }

  Widget countryReport(){
    return Column(
      children:mycountries.map((item) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          InkWell(
            onTap: (){
              setState(() {
                selectedValue = item['Country'];
                pcountry = bodyy['Countries'].where((country) => country['Country'] == selectedValue);
                pcountry = pcountry.toList()[0];
              });
            },
            child: Text(item['Country'],style: TextStyle(color: Colors.grey, fontSize: 17,fontWeight: FontWeight.bold))),
          Text(item[_value].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        )
      )).toList().cast<Widget>(),
    );
    
  }

  Widget country(){
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(15),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.only(left:15, right:15, bottom:15),
        alignment: Alignment.center,
        width: double.infinity,
        child: Column(
          children: [
            drop(),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top:10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Infected", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text(pcountry['TotalConfirmed'].toString()??'0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Recovered",style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5,),
                      Text(pcountry['TotalRecovered'].toString()??'0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Death",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5,),
                      Text(pcountry['TotalDeaths'].toString()??'0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget greetings(){
    return Container(
      alignment: Alignment.bottomLeft,
      height: 80,
      padding: EdgeInsets.only(left: 10),
      child: Wrap(
        children: [
          Text("COVID-19 Dashboard",
          style: TextStyle(fontSize: 25, color: Colors.blueGrey, fontWeight: FontWeight.bold),),
          SizedBox(height: 5,),
          Text("Wear a mask.Save lives.", 
          style: TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget cont(Icon icon, String title, int value, context, Color color){
    return Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
        margin: EdgeInsets.symmetric(horizontal:10, vertical:5),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width/2 - 50,
        height: MediaQuery.of(context).size.height * 0.15 - 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          icon,
          SizedBox(height: 5,),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold,),),
          SizedBox(height: 5,),
          Text(value.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
        ],),
      ),
    );
  }
}
