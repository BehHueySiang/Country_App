import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'country.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Country Information Searching App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class Countrygrid extends StatefulWidget {
  final Country curcountry;
  const Countrygrid({Key? key, required this.curcountry}): super(key: key);

  @override
  State<Countrygrid> createState() => _Countrygrid();

}

class _Countrygrid extends State<Countrygrid> {
        
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[Container(
          padding:  const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Currency", style: TextStyle(fontWeight: FontWeight.w500)),
            const Icon(Icons.attach_money, size: 64,),
            Text(widget.curcountry.currency)
          ],),
          color: Colors.white,
        ),
        Container(
          padding:  const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Capital", style: TextStyle(fontWeight: FontWeight.w500)),
            const Icon(Icons.location_city, size: 64,),
            Text(widget.curcountry.capital)
          ],),
          color: Colors.white,
        ),
        Container(
          padding:  const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("GDP", style: TextStyle(fontWeight: FontWeight.w500)),
            const Icon(Icons.auto_graph, size: 64,),
            Text(widget.curcountry.gdp.toString())
          ],),
          color: Colors.white,
        ),
        Container(
          padding:  const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Population", style: TextStyle(fontWeight: FontWeight.w500),),
            const Icon(Icons.people_outline_outlined, size: 64,),
            Text(widget.curcountry.population.toString())
          ],),
          color: Colors.white,
        ),
      ]  
    );
  }  
}

class _MyHomePageState extends State<MyHomePage> {
 TextEditingController textEditingController = TextEditingController();
  var desc="No record", gdp = 0.0, population= 0.0, capital = "Kuala Lumpur", iso2 = "MY", flagUrl = "", currency = "No Record", name = "No Record";
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
  
        title: Text(widget.title),
      ),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Country Information Application",style: TextStyle(fontWeight: FontWeight.bold),),
             SizedBox(
                        height: 50.0,
                        width: 300.0,
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: "Please Insert Country Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),       
             ElevatedButton(onPressed: _FindCountry, child: const Text("Search")),
             if (flagUrl.isNotEmpty) Image.network(flagUrl,height: 50, width: 65),
             Text(desc),
             Expanded (child: Countrygrid(curcountry: curcountry,),),   
          ],  
        ),
      ),
    );
  }

  Future<void>_FindCountry() async{
    ProgressDialog progressDialog = ProgressDialog(context, title: const Text("Searching....."), message: const Text("Progress"));
       progressDialog.show();
    
    var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=${textEditingController.text}');
   try {
    var response = await http.get(url, headers: {'X-Api-Key' : 'Fo0nZdCjTA08YPw3F8/EGw==jt1g9xKXZ1SLTSlg' });
    var rescode = response.statusCode;
    if (rescode == 200) {  
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      if (parsedJson.length == 0){
        setState(() {
          desc =  "Country not found";
          flagUrl = " ";
          curcountry = Country("No Record", 0.0, 0.0, "No Record", "No Record", "", "No Record", "No Record");
          progressDialog.dismiss();
            Fluttertoast.showToast(
              msg: "Search Unsuccessful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0,
              backgroundColor: Colors.red);
        });
      }
      else if (parsedJson[0]['name'].toLowerCase() == textEditingController.text.toLowerCase()) {
            setState(() {
            gdp = parsedJson[0]['gdp'];
            population = parsedJson[0]['population'];
            capital = parsedJson[0]['capital'];
            name = parsedJson[0]['name'];
            iso2 = parsedJson[0]['iso2'];
            desc = "$name";
            currency = parsedJson[0]['currency']['name'];
            curcountry =Country(desc, gdp, population, capital, iso2, flagUrl, currency, name);
            flagUrl = 'https://flagsapi.com/$iso2/flat/64.png'; 
            progressDialog.dismiss();
            Fluttertoast.showToast(
              msg: "Search successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0,
              backgroundColor: Colors.amber);
          
            }
          );
      } else{
            setState(() {
              desc = "Country not found";
              flagUrl = '';
              curcountry = Country("No Record", 0.0, 0.0, "No Record","No Record","","No Record", "No Record");
              progressDialog.dismiss();
            Fluttertoast.showToast(msg: "Search unsuccessfully",toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, fontSize: 16.0, backgroundColor: Colors.red);});}
      }else{
            setState(() {
              desc = "Country not found";
              flagUrl = '';
              curcountry = Country("No Record", 0.0, 0.0, "No Record","No Record","","No Record", "No Record");
              progressDialog.dismiss();
            Fluttertoast.showToast(msg: "Search unsuccessfully",toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, fontSize: 16.0, backgroundColor: Colors.red);
      });
      }
      
  } on Exception catch (_) {
    progressDialog.dismiss();
    Fluttertoast.showToast(
      msg: "Country Not Found!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );}
  }
  }