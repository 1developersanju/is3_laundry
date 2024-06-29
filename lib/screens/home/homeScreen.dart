import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/helpers/widgets/homeWidget/imageSliders.dart';
import 'package:laundry/helpers/widgets/homeWidget/promisesWidget.dart';
import 'package:laundry/model/shopModel.dart';
import 'package:laundry/screens/home/shopSlider.dart';

import '../../helpers/widgets/homeWidget/aboutus.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false; // Track the current mode, default is light mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
    isDarkMode: _isDarkMode,
    needActions: true,
    onDarkModeChanged: (value) {
      setState(() {
        _isDarkMode = value;
      });
    },
  ),
backgroundColor: ColorsRes.canvasColor,
      body: SingleChildScrollView(
        child: Container(
          color: ColorsRes.canvasColor,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerticalSliderDemo(),
              const SizedBox(height: 20),
              VerticalShopSlider(),
              const SizedBox(height: 20),
              const Aboutus(),
              const SizedBox(height: 20),
              const PromisesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}


class VerticalSliderDemo extends StatefulWidget {
  @override
  State<VerticalSliderDemo> createState() => _VerticalSliderDemoState();
}

class _VerticalSliderDemoState extends State<VerticalSliderDemo> {
  int _current = 0;

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: imageSliders,
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : ColorsRes.themeBlue)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}

