 import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:laundry/helpers/colorRes.dart';
// import 'package:laundry/helpers/widgets/customAppbar.dart';
// import 'package:laundry/model/orderModel.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({Key? key}) : super(key: key);

//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> {
//   @override
//   Widget build(BuildContext context) {
//     final today = DateTime.now();
//     final yesterday = today.subtract(const Duration(days: 1));
//     final lastWeek = today.subtract(const Duration(days: 7));
//   bool _isDarkMode = false;

//     final todayOrders = orders
//         .where((order) =>
//             order.date.day == today.day &&
//             order.date.month == today.month &&
//             order.date.year == today.year)
//         .toList();

//     final yesterdayOrders = orders
//         .where((order) =>
//             order.date.day == yesterday.day &&
//             order.date.month == yesterday.month &&
//             order.date.year == yesterday.year)
//         .toList();

//     final lastWeekOrders = orders
//         .where((order) =>
//             order.date.isBefore(today) && order.date.isAfter(lastWeek))
//         .toList();

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "Orders",
//     isDarkMode: _isDarkMode,
//     needActions: true,
//     implyBackButton: true,
//     onDarkModeChanged: (value) {
//       setState(() {
//         _isDarkMode = value;
//       });
//     },
//   ),
//   backgroundColor: ColorsRes.canvasColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             if (todayOrders.isNotEmpty) ...[
//               const Text('Today',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               ...todayOrders.map((order) => OrderCard(order: order)).toList(),
//             ],
//             if (yesterdayOrders.isNotEmpty) ...[
//               const SizedBox(height: 20),
//               const Text('Yesterday',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               ...yesterdayOrders
//                   .map((order) => OrderCard(order: order))
//                   .toList(),
//             ],
//             if (lastWeekOrders.isNotEmpty) ...[
//               const SizedBox(height: 20),
//               const Text('Last week',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               ...lastWeekOrders
//                   .map((order) => OrderCard(order: order))
//                   .toList(),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final Order order;

//   const OrderCard({Key? key, required this.order}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white30,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Image.asset('assets/laundry.png', width: 50, height: 50),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(order.serviceType,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       Text(order.location,
//                           style: const TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//                 Image.asset('assets/van.png',),
//               ],
//             ),
//             Row(
//               children: [
                
//                   Expanded(
//                     child:(order.status.isNotEmpty)? Text(
//                       order.status,
//                       style: TextStyle(
//                           color: ColorsRes.themeTextBlue,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w300),
//                     ):const Text(" "),
//                   ),
//                 Text('₹${order.price}',
//                     style:
//                         const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}