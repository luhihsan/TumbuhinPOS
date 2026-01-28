import '../models/product.dart';

const dummyCategories = <String>[
  'Bubur',
  'Nasi Hainan',
  'Others',
  'Consignment',
  'Beverages',
];

final dummyProducts = <Product>[
  const Product(id: '1', name: 'Bubur Ayam Sukacita', category: 'Bubur', price: 25000),
  const Product(id: '2', name: 'Bubur Polos', category: 'Bubur', price: 15000),
  const Product(id: '3', name: 'Bubur Ayam', category: 'Bubur', price: 20000),
  const Product(id: '4', name: 'Bubur Ayam Merah', category: 'Bubur', price: 20000),
  const Product(id: '5', name: 'Bubur Ayam Manis', category: 'Bubur', price: 20000),
  const Product(id: '6', name: 'Nasi Hainan Polos', category: 'Nasi Hainan', price: 15000),
];
