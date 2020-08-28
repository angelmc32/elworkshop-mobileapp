import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<List<Job>> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://elworkshop.herokuapp.com/api/jobs/all"),
        headers: {"Accept": "application/json"});

    var responseJson = json.decode(response.body);

    return (responseJson['jobs'] as List).map((p) => Job.fromJson(p)).toList();
  }

  @override
  void initState() {
    super.initState();
    var data = getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('El Workshop'),
        elevation: 1.0,
      ),
      body: new Container(
        child: new RefreshIndicator(
          onRefresh: _autoRefresh,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new FutureBuilder<List<Job>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Job> jobs = snapshot.data;
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: jobs
                          .map((job) => new Column(
                                children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(height: 80.0),
                                    items: ['Trabajador: ${job.userFirstName} ${job.userLastName} ', Image.network(job.userPicture),'Chamba: ${job.jobName}','Descripción: ${job.jobDescription}','Precio por hora: ${(job.jobRate/22).toStringAsFixed(2)} USD'].map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                              width: MediaQuery.of(context).size.width,
                                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.indigoAccent
                                              ),
                                              child: Text('$i', style: TextStyle(fontSize: 16.0),)
                                          );
                                        },
                                      );
                                    }).toList(),
                                  )
                                ],
                              ))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return snapshot.error;
                  }
                  return new Center(
                    child: new Column(
                      children: <Widget>[
                        new Padding(padding: new EdgeInsets.all(50.0)),
                        new CircularProgressIndicator(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Job {
  final String userFirstName;
  final String userLastName;
  final String jobID;
  final String userPhone;
  final String userPicture;
  final String jobName;
  final String jobDescription;
  final int jobRate;

  Job(
      {this.userFirstName,
        this.userLastName,
      this.userPhone,
      this.jobID,
      this.userPicture,
      this.jobName,
      this.jobDescription,
      this.jobRate});

  factory Job.fromJson(Map<String, dynamic> json) {
    return new Job(
      userFirstName: json['user']['first_name'].toString(),
      userLastName: json['user']['last_name'].toString(),
      jobID: json['jobID'].toString(),
      userPhone: json['userPhone'].toString(),
      userPicture: json['user']['profile_picture'].toString(),
      jobName: json['category'].toString(),
      jobDescription: json['description'].toString(),
      jobRate: json['hourly_rate'],
    );
  }
}

Future<Null> _autoRefresh() async{
  print('Obteniendo información...');

}