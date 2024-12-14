import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String businessName;
  final String name;
  final String price;
  final String desc;
  final int quantity;
  final String image;
  const ProductCard(
      {super.key,
      required this.businessName,
      required this.name,
      required this.price,
      required this.desc,
      required this.quantity,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.amberAccent,
      ),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: SizedBox(
              height: 100,
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, object, trace) {
                  return const Center(
                    child: Text('No image Found'),
                  );
                },
              ),
            ),
          ),
          Text(
            businessName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Colors.grey[600],
          ),
          Text(
            'Product: $name',
            style:
                const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Price: GHc$price',
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Description: $desc',
            style:
                const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Quantity: ${quantity.toString()}',
            style:
                const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
