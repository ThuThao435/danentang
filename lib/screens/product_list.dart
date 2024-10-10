import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: data.containsKey('imageUrl') && data['imageUrl'] != null
                  ? Image.network(data['imageUrl'], width: 50, height: 50)
                  : Icon(Icons.image_not_supported),
              title: Text(data['name']),
              subtitle: Text(data['type']),
              trailing: Text('${data['\price']}'),
              onTap: () {
                // Implement edit functionality here
              },
              onLongPress: () {
                deleteProduct(doc.id);
              },
            );
          }).toList(),
        );
      },
    );
  }
}