import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './Pokemon.dart';
import './pokemon-detail.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pokemon App',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  var url="https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  fetchData() async{
    var res= await http.get(url);
    var decodedJson= jsonDecode(res.body);
    pokeHub= PokeHub.fromJson(decodedJson);
    setState(() {});
  } 

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0; 
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Pokemon"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub==null? Center(
        child: CircularProgressIndicator(),
      )
      : GridView.count(
        crossAxisCount: 2,
        children: pokeHub.pokemon.map((poke)=>
        Padding(
          padding: EdgeInsets.all(2.0),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=>PokeDetail(pokemon: poke)
              ));
            },
            child: Hero(
              tag: poke.img,
              child: pokemonCard(poke),
            ),
          ),
        ),
        ).toList(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: fetchData,
        tooltip: 'Increment',
        child: new Icon(Icons.refresh),
      ),
    );
  }

  Widget pokemonCard(Pokemon poke){
    return Card(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:NetworkImage(poke.img),
              )
            ),
          ),
            Text(
            poke.name,
            style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          ),
        ]
      ),
  );
  }

}
