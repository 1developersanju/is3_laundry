import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


final List<String> imgList = [
  'https://plus.unsplash.com/premium_vector-1682303735385-f3ab879660ec?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bGF1bmRyeSUyMHNlcnZpY2V8ZW58MHx8MHx8fDA%3D',
  'https://img.freepik.com/free-photo/closeup-photo-fashionable-clothes-hangers-shop_627829-6026.jpg?t=st=1718988365~exp=1718991965~hmac=96c0f64fcf08cee3dff8c3191f19eaf93d86a824bdbcc4401ec66e55910521f5&w=826',
  'https://img.freepik.com/free-vector/laundry-dry-cleaning-concept-illustration_114360-7391.jpg?t=st=1718988428~exp=1718992028~hmac=aa308bcd53f6fbe995141e0ca49ac64c9300bfc9af3abdc2c0af1f26ae2ff160&w=826',
  'https://img.freepik.com/free-photo/cheerful-girl-with-cozy-knitted-sweaters-hands-happily-looking-camera-blue-background_574295-2507.jpg?t=st=1718988397~exp=1718991997~hmac=4d2d6bd4faf3575545eab27949065a66c221c525de7d8fefb07b2589e3eba4a7&w=826',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(imageUrl: item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

