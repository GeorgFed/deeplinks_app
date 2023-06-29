import 'package:deeplinks_app/domain/items_repository.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String? itemId;

  const ItemDetailsScreen({super.key, this.itemId});

  @override
  Widget build(BuildContext context) {
    final items = ItemsRepository.getItems();
    final item = items.firstWhere(
      (element) => element.id == itemId,
      orElse: () => items.first,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Информация о товаре')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Item Details Screen'),
            Text('ID: ${item.id}'),
            Text('Title: ${item.title}'),
            Text('Description: ${item.description}'),
          ],
        ),
      ),
    );
  }
}
