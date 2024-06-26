import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/helpers/widgets/homeWidget/imageSliders.dart';
import 'package:laundry/helpers/widgets/homeWidget/promisesWidget.dart';
import 'package:laundry/model/shopModel.dart';

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

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerticalSliderDemo(),
              SizedBox(height: 20),
              VerticalShopSlider(),
              SizedBox(height: 20),
              Aboutus(),
              SizedBox(height: 20),
              PromisesWidget(),
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

class VerticalShopSlider extends StatefulWidget {
  @override
  _VerticalShopSliderState createState() => _VerticalShopSliderState();
}

class _VerticalShopSliderState extends State<VerticalShopSlider> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 180.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 180.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Stack(
        children: [
          Container(
            color: ColorsRes.themeBlue,
            height: 180,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: shopList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                        onTap: () => Navigator.pushNamed(context,shopDetailScreen,arguments: [shopList[index].title,shopList[index].services]),

                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  
                    width: 120.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              shopList[index].image,
                              fit: BoxFit.cover,
                              width: 100.0,
                              height: 100.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            shopList[index].title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: _scrollLeft,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              onPressed: _scrollRight,
            ),
          ),
                    Positioned(
            top: -10,
            right: 0,
            child: TextButton(
              onPressed: () {
                // Handle the View All button press
                Navigator.pushNamed(context, shopListScreen);
              },
              child: Text(
                "View All",
                style: TextStyle(color: ColorsRes.colorWhite),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
