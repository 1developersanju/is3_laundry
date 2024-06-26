import 'package:flutter/material.dart';

class Shop {
  final String image;
  final String title;
  final String price;
  final String location;
  final List services;
  bool isBookmarked;

  Shop({
    required this.image,
    required this.title,
    required this.price,
    required this.location,
    required this.services,
    this.isBookmarked = false,
  });

  void toggleBookmark() {
    isBookmarked = !isBookmarked;
  }
}


final List<Shop> shopList = [
  Shop(
    image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRg0cwi40ZMYFIv6pK2l7c7DZm0I7FjW5d1PDLamC2uvK_IDdsb',
    title: 'Drops Laundry',
    price: '60',
    location: 'Saravanampatti',
        services: ['Washing','Ironing','Washing & Ironing','Dry cleaning']

  ),
  Shop(
    image:
        'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcROt4DVfDL3vUl1KSdHaxE3rymMLpIdoKwtQnA1emIH8V_bye3y',
    title: 'Peacock Laundry',
    price: '70',
    location: 'Saravanampatti',
    services: ['Washing','Ironing','Washing & Ironing']
  ),
  Shop(
    image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBmhjPmLsn6bs3zuvuqLzg4fIrIfhyLnA3B9E5L9qVa0Nh2VdQ',
    title: 'Tumbledry',
    price: '65',
    location: 'Saravanampatti',
        services: ['Washing','Ironing','Washing & Ironing']

  ),
  Shop(
    image:
        'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQ9GT9H8TZs00UmOehHfZFE8y6lyvVCMAz4bPAvDmPJCivir1Is',
    title: 'Fabrico',
    price: '69',
    location: 'Saravanampatti',
        services: ['Washing','Ironing','Washing & Ironing']

  ),
];
