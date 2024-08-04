import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/main_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;
  // var _isLoading = false;
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(
  //     Duration.zero,
  //     () {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //     .then(
  //         (value) {
  //           setState(() {
  //             _isLoading = false;
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _ordersFuture = getOrders();
  }

  Future getOrders() async {
    return Provider.of<Orders>(context, listen: false).getOrderfromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    print("orderbuild");
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Buyurtmalar"),
      ),
      body:
          // _isLoading
          //     ?
          //     :
          FutureBuilder(
        future: _ordersFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error == null) {
              return Consumer<Orders>(
                builder: (context, orders, child) {
                  return orders.items.isEmpty
                      ? Center(
                          child: Text("Buyurtmalar mavjud emas"),
                        )
                      : ListView.builder(
                          itemCount: orders.items.length,
                          itemBuilder: (context, index) {
                            final order = orders.items[index];
                            return OrderItem(order: order);
                          },
                        );
                },
              );
            } else {
              return Center(
                child: Text("Xatolik yuz berdi"),
              );
            }
          }
        },
      ),
    );
  }
}
