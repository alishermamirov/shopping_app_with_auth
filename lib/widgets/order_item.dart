import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expandItem = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text("\$${widget.order.totalprice.toString()}"),
            subtitle:
                Text(DateFormat("dd/MMMM/y, HH:mm").format(widget.order.date)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expandItem = !_expandItem;
                });
              },
              icon: Icon(_expandItem ? Icons.expand_less : Icons.expand_more),
            ),
          ),
        ),
        _expandItem
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: min(widget.order.products.length * 30 + 50, 100),
                child: ListView.builder(
                  itemExtent: 26,
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.order.products[index];
                    return ListTile(
                      title: Text(product.title),
                      trailing: Text(
                          "${product.quantity}x  \$${product.price.toString()}"),
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
