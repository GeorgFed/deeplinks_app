import 'models/item.dart';

class ItemsRepository {
  static const List<Item> items = [
    Item(id: '1', title: 'Item 1', description: 'Description of Item 1'),
    Item(id: '2', title: 'Item 2', description: 'Description of Item 2'),
    Item(id: '3', title: 'Item 3', description: 'Description of Item 3'),
    Item(id: '4', title: 'Item 4', description: 'Description of Item 4'),
    Item(id: '5', title: 'Item 5', description: 'Description of Item 5'),
  ];

  static List<Item> getItems() => items;
}
