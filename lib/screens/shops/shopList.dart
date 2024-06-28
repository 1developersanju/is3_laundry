import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/providers/shopProvider.dart';
import 'package:provider/provider.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/model/shopModel.dart';
import '../../helpers/widgets/homeWidget/imageSliders.dart';

class ShopListPage extends StatefulWidget {
  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    var shopProvider = Provider.of<ShopProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Shops",
        isDarkMode: _isDarkMode,
        needActions: true,
        implyBackButton: true,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
      backgroundColor: ColorsRes.canvasColor,
      body: FutureBuilder(
        future: shopProvider.fetchShops(), // Fetch shops from provider
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            return Consumer<ShopProvider>(
              builder: (context, shopProvider, child) {
                List<Shop> shops = shopProvider.shops;

                return ListView.builder(
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShopListItem(
                        shop: shops[index],
                        onBookmarkToggle: () {
                          setState(() {
                            shops[index].toggleBookmark();
                            shopProvider!.updateShop(shops[index]); // Update shop in provider
                          });
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ShopListItem extends StatelessWidget {
  final Shop shop;
  final VoidCallback onBookmarkToggle;

  ShopListItem({required this.shop, required this.onBookmarkToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, shopDetailScreen, arguments: [shop.title, shop.services,int.parse(shop.price)]),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsRes.lightBlue,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8.0,
              right: 8.0,
              child: GestureDetector(
                onTap: onBookmarkToggle,
                child: Icon(
                  shop.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: shop.isBookmarked ? ColorsRes.themeBlue : Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: CachedNetworkImage(
                    imageUrl:  shop.image.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.title.toString(),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: ColorsRes.textBlack,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          shop.location.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: ColorsRes.textBlack,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          ' ₹${shop.price.toString()}/kg',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: ColorsRes.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
