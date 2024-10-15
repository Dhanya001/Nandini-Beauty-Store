import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nandini_beauty_store/Homescreen/AdminDashboard.dart';
import 'package:nandini_beauty_store/Modeles/AddProducts.dart';
import 'package:nandini_beauty_store/Modeles/EditProducts.dart';
import 'package:nandini_beauty_store/Others/BottomNavigation.dart';
import 'package:nandini_beauty_store/auth/UserLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  List _filteredProducts = [];
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> _sliderimages = [];
  List _products = [];
  List<bool> _selectedImages = [];
  List<String> _productImages = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
    _checkLoginStatus();
    _getProducts();
    _getSliderImages();
  }

  Future<void> _getSliderImages() async {
    final storageRef = FirebaseStorage.instance.ref('slider_images');
    final listResult = await storageRef.listAll();

    setState(() {
      _sliderimages = [];
      _selectedImages = List<bool>.filled(listResult.items.length, false);
    });

    for (var item in listResult.items) {
      final url = await item.getDownloadURL();
      setState(() {
        _sliderimages.add(url);
      });
    }
  }

  Future<void> _uploadImageToSliderFolder() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref('slider_images');
      final uploadTask = storageRef.child('image_${DateTime.now().millisecondsSinceEpoch}.jpg').putFile(file);
      await uploadTask.whenComplete(() async {
        final url = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          _sliderimages.add(url);
          _selectedImages.add(false); // Add a new boolean value
        });
      });
    }
  }

  Future<void> _deleteSliderImages() async {
    try {
      // Loop through the slider images list
      for (int i = _sliderimages.length - 1; i >= 0; i--) {
        if (_selectedImages[i]) {
          // Get the full image URL and extract the file name from the URL
          final imageUrl = _sliderimages[i];

          // Extract the image name from the URL (handle both '/' and query parameters)
          final fileName = imageUrl.split('slider_images%2F').last.split('?').first;

          // Create a reference to the image using the proper file name
          final storageRef = FirebaseStorage.instance.ref('slider_images').child(fileName);

          // Delete the image from Firebase Storage
          await storageRef.delete();

          // Remove the image from the list and update the state
          setState(() {
            _sliderimages.removeAt(i);
            _selectedImages.removeAt(i);
          });
        }
      }
      print('Images deleted successfully');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _isAdmin = prefs.getBool('isAdmin') ?? false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserLoginPage()),
    );
  }

  Future<void> _getProducts() async {
    await _firestore.collection('products').get().then((value) {
      setState(() {
        _products = value.docs;
        _productImages = [];
      });
      for (var product in _products) {
        final storageRef = FirebaseStorage.instance.ref('Images/${product['image']}');
        storageRef.getDownloadURL().then((url) {
          setState(() {
            _productImages.add(url);
          });
        });
      }
    });
  }
  Future<void> _deleteProduct(Map<String, dynamic> product) async {
    try {
      // Deleting the product from Firestore
      await _firestore.collection('products').doc(product['id']).delete();

      // Updating the UI by removing the product from the _products list
      setState(() {
        _products.remove(product);
      });

      print('Product deleted successfully');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }



  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
        break;
      case 2:
      // You can add navigation logic for other pages here.
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Please login to view product details"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserLoginPage()),
              );
            },
            child: Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFF1694),
        title: Text(
          "Nandini Beauty Store",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  if (_isLoggedIn) {
                    _logout();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserLoginPage()),
                    );
                  }
                },
                icon: Icon(
                  _isLoggedIn ? Icons.logout : Icons.person,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFdcb7b4),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Mansi Beauty Store',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                items: _sliderimages.asMap().entries.map((entry) {
                  int index = entry.key;
                  String url = entry.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImages[index] = !_selectedImages[index];
                      });
                    },
                    child: Hero(
                      tag: 'sliderImage_$index', // Ensure unique tag for each image
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: _selectedImages[index] ? Border.all(color: Colors.red, width: 3) : null,
                        ),
                        child: Image.network(url),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
              ),
              _isAdmin
                  ? Positioned(
                bottom: 5,
                right: 5,
                child: FloatingActionButton(
                  onPressed: () {
                    // Upload image to Firebase Storage and add to _sliderimages list
                    _uploadImageToSliderFolder();
                  },
                  child: Icon(Icons.add),
                ),
              )
                  : Container(),
              _isAdmin
                  ? Positioned(
                top: 5,
                right: 5,
                child: FloatingActionButton(
                  onPressed: () {
                    // Delete selected slider images
                    _deleteSliderImages();
                  },
                  child: Icon(Icons.delete),
                ),
              )
                  : Container(),
            ],
          ),
          SizedBox(height: 12),
          _isAdmin
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage(
                    refreshHomePage: _getProducts,
                  )),
                );
              },
              child: Icon(Icons.add),
            ),
          )
              : Container(),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    if (_isAdmin) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Product Options"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditProductPage(product: _products[index],
                                  refreshHomePage: (){
                                    setState(() {
                                      _getProducts();
                                    });
                                  },)),
                                );
                              },
                              child: Text("Edit"),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteProduct(_products[index]); // Call the delete method
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text("Delete"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey, width: 2.0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: _productImages.length > index
                                  ? Image.network(_productImages[index])
                                  : CircularProgressIndicator(),
                            ),
                            Text(
                              _products[index]['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              ' ₹${_products[index]['price'].toString()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}