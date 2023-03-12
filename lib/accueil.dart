/*
 *  main.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 28.12.2020.
 */

import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:untitled2/utils/variables.dart';
import 'package:untitled2/widget/sliderView.dart';


class MyAppA extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppA> {
  RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  @override
  void initState() {

    super.initState();

    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: radio_name,
      url: radio_player_link,
      imagePath: radio_logo,
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body:
        SliderDrawer(
          key: _key,
          appBar: SliderAppBar(
              appBarColor: Colors.white,
              title: Text(radio_name,
                  style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),


          slideDirection: SlideDirection.RIGHT_TO_LEFT,
          slider: SliderView(),
          child:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: _radioPlayer.getArtworkImage(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    Image artwork;
                    if (snapshot.hasData) {
                      artwork = snapshot.data;
                    } else {
                      artwork = Image.asset(
                        radio_logo,
                        fit: BoxFit.cover,
                      );
                    }
                    return Container(
                      height: 180,
                      width: 180,
                      child: ClipRRect(
                        child: artwork,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  metadata?[0] ?? 'Metadata',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  metadata?[1] ?? '',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
          },
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
        ),
      ),
    );
  }
}