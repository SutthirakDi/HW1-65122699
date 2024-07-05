import 'dart:io';

class MenuItem {
  String name;
  double price;
  String category;

  MenuItem(this.name, this.price, this.category);

  @override
  String toString() =>
      'MenuItem{name: $name, price: $price, category: $category}';
}

class Order {
  String orderId;
  int tableNumber;
  List<MenuItem> items = [];
  bool isCompleted = false;

  Order(this.orderId, this.tableNumber);

  void addItem(MenuItem item) => items.add(item);
  void removeItem(MenuItem item) => items.remove(item);
  void completeOrder() => isCompleted = true;

  @override
  String toString() =>
      'Order{orderId: $orderId, tableNumber: $tableNumber, items: $items, isCompleted: $isCompleted}';
}

class Restaurant {
  List<MenuItem> menu = [];
  List<Order> orders = [];
  Map<int, bool> tables = {};

  void addMenuItem(MenuItem item) => menu.add(item);
  void removeMenuItem(MenuItem item) => menu.remove(item);
  void placeOrder(Order order) => orders.add(order);

  void completeOrder(String orderId) {
    var order = orders.firstWhere((order) => order.orderId == orderId,
        orElse: () => Order('', 0));
    if (order.orderId.isNotEmpty) {
      order.completeOrder();
      print('Order $orderId completed.');
    } else {
      print('Order $orderId not found.');
    }
  }

  MenuItem getMenuItem(String name) =>
      menu.firstWhere((item) => item.name == name,
          orElse: () => MenuItem('', 0.0, ''));

  Order getOrder(String orderId) =>
      orders.firstWhere((order) => order.orderId == orderId,
          orElse: () => Order('', 0));

  @override
  String toString() =>
      'Restaurant{menu: $menu, orders: $orders, tables: $tables}';
}

void main() {
  var restaurant = Restaurant();

  while (true) {
    print('''
    ______________[ Restaurant ]______________
    1. Menu Item
    2. Order
    3. Search
    Q. Exit
    ''');
    stdout.write('Please enter your choice (1-3 or Q): ');
    var choice = stdin.readLineSync() ?? '';

    if (choice.toUpperCase() == 'Q') break;

    switch (choice) {
      case '1':
        manageMenu(restaurant);
        break;
      case '2':
        manageOrder(restaurant);
        break;
      case '3':
        searchMenu(restaurant);
        break;
      default:
        print('Invalid choice, please try again.');
    }
  }
}

void manageMenu(Restaurant restaurant) {
  while (true) {
    print('''
    ______________[ Menu ]______________
    1. Add
    2. Order
    3. Search
    0. Back
    ''');
    stdout.write('Please enter your choice (1-3 or 0): ');
    var choice = stdin.readLineSync() ?? '';

    if (choice == '0') break;

    switch (choice) {
      case '1':
        addMenuItem(restaurant);
        break;
      case '2':
        manageOrder(restaurant);
        break;
      case '3':
        searchMenu(restaurant);
        break;
      default:
        print('Invalid choice, please try again.');
    }
  }
}

void addMenuItem(Restaurant restaurant) {
  print('Add new menu item');
  stdout.write('Name: ');
  var name = stdin.readLineSync() ?? '';
  stdout.write('Price: ');
  var priceInput = stdin.readLineSync() ?? '0.0';
  var price = double.tryParse(priceInput) ?? 0.0;
  stdout.write('Category (M=Main course, D=Dessert, W=Drink): ');
  var category = stdin.readLineSync() ?? '';

  if (name.isNotEmpty && category.isNotEmpty) {
    var newItem = MenuItem(name, price, category);
    restaurant.addMenuItem(newItem);
    print('Add name = [$name]\n  price = [$price]\n  Category = [$category]');
    stdout.write('Press Y to confirm: ');
    var confirm = stdin.readLineSync() ?? '';
    if (confirm.toUpperCase() == 'Y') {
      print('Menu item added successfully.');
    } else {
      print('Operation cancelled.');
    }
  } else {
    print('Invalid input. Please try again.');
  }
}

void manageOrder(Restaurant restaurant) {
  print('Manage Orders');
  while (true) {
    print('''
    1. Create new order
    2. Complete order
    0. Back
    ''');
    stdout.write('Please enter your choice (1-2 or 0): ');
    var choice = stdin.readLineSync() ?? '';

    if (choice == '0') break;

    switch (choice) {
      case '1':
        createOrder(restaurant);
        break;
      case '2':
        completeOrder(restaurant);
        break;
      default:
        print('Invalid choice, please try again.');
    }
  }
}

void createOrder(Restaurant restaurant) {
  stdout.write('Enter table number: ');
  var tableNumberInput = stdin.readLineSync() ?? '0';
  var tableNumber = int.tryParse(tableNumberInput) ?? 0;
  stdout.write('Enter order ID: ');
  var orderId = stdin.readLineSync() ?? '';

  if (orderId.isNotEmpty) {
    var newOrder = Order(orderId, tableNumber);
    while (true) {
      print('''
      1. Add item to order
      2. Remove item from order
      3. Finish creating order
      0. Back
      Please enter your choice (1-3 or 0):
      ''');
      var choice = stdin.readLineSync() ?? '';

      if (choice == '0' || choice == '3') {
        restaurant.placeOrder(newOrder);
        print('Order created successfully.');
        break;
      }

      switch (choice) {
        case '1':
          stdout.write('Enter item name to add: ');
          var itemName = stdin.readLineSync() ?? '';
          var item = restaurant.getMenuItem(itemName);
          if (item.name.isNotEmpty) {
            newOrder.addItem(item);
            print('Item added to order.');
          } else {
            print('Item not found.');
          }
          break;
        case '2':
          stdout.write('Enter item name to remove: ');
          var itemName = stdin.readLineSync() ?? '';
          var item = restaurant.getMenuItem(itemName);
          if (item.name.isNotEmpty) {
            newOrder.removeItem(item);
            print('Item removed from order.');
          } else {
            print('Item not found.');
          }
          break;
        default:
          print('Invalid choice, please try again.');
      }
    }
  } else {
    print('Invalid input. Please try again.');
  }
}

void completeOrder(Restaurant restaurant) {
  print('Complete Order');
  stdout.write('Enter order ID to complete: ');
  var orderId = stdin.readLineSync() ?? '';

  if (orderId.isNotEmpty) {
    restaurant.completeOrder(orderId);
  } else {
    print('Invalid input. Please try again.');
  }
}

void searchMenu(Restaurant restaurant) {
  print('Search Menu');
  stdout.write('Enter item name to search: ');
  var itemName = stdin.readLineSync() ?? '';
  var item = restaurant.getMenuItem(itemName);
  if (item.name.isNotEmpty) {
    print('Item found: $item');
  } else {
    print('Item not found.');
  }
}
