import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/providers/shopProvider.dart';
import 'package:provider/provider.dart';

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
    var shopProvider = Provider.of<ShopProvider>(context);

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Stack(
        children: [
          Container(
            color: Colors.blue, // Replace with your desired background color
            height: 180,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: shopProvider.shops.length,
              itemBuilder: (context, index) {
                var shop = shopProvider.shops[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, shopDetailScreen, arguments: [shop.title, shop.services,int.parse(shop.price)]);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 120.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                             imageUrl:  shop.image,
                              fit: BoxFit.cover,
                              width: 100.0,
                              height: 100.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            shop.title,
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
            left: -10,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: _scrollLeft,
            ),
          ),
          Positioned(
            right: -10,
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
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
