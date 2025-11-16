import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';  // <-- ADDED
import 'package:wearzy/details_screen/cart_screen.dart';
import 'package:wearzy/details_screen/cloth_screen.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  int selectedTab = 0;

  List<String> categoryIcons = [
    "https://cdn-icons-png.flaticon.com/512/891/891462.png",
    "https://cdn-icons-png.flaticon.com/512/2331/2331970.png",
    "https://cdn-icons-png.flaticon.com/512/992/992700.png",
    "https://cdn-icons-png.flaticon.com/512/892/892458.png",
    "https://cdn-icons-png.flaticon.com/512/892/892469.png",
    "https://cdn-icons-png.flaticon.com/512/892/892449.png",
  ];

  List<String> topPicks = [
    "https://images.unsplash.com/photo-1521334884684-d80222895322?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1520975918319-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=800&q=80",
  ];

  List<String> deals = [
    "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1555685812-4b943f1cb0eb?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1542060748-10c28b62716f?auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80",
  ];

  List imageList = [
    {"id": 1, "image_path": "images/banner wear.jpg"},
    {"id": 2, "image_path": "images/banner shoes.jpg"},
    {"id": 3, "image_path": "images/banner dwn.jpg"},
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  final ImagePicker picker = ImagePicker();

  void showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 160,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(CupertinoIcons.camera, color: Colors.black),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(CupertinoIcons.photo, color: Colors.black),
                title: const Text("Choose From Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget shimmerBox(double h, double w, double r) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 8, left: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by product, brand...',
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: InkWell(
                onTap: () {
                  showImagePickerSheet();
                },
                child: const Icon(
                  CupertinoIcons.camera,
                  color: Colors.black45,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavouriteScreen()));
              },
              child: const Icon(Icons.favorite_border, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.red,
                      child: const Text(
                        '2',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [

          SizedBox(
            height: 100,
            child: isLoading
                ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8),
                child: shimmerBox(65, 65, 50),
              ),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryIcons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[900],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          categoryIcons[index],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ClothScreen()));
                },
                child: CarouselSlider(
                  items: imageList
                      .map(
                        (item) => Image.asset(
                      item["image_path"],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                    ),
                  )
                      .toList(),
                  carouselController: CarouselSliderController(),
                  options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    height: 250,
                    aspectRatio: 2,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          sectionTitle("HAUL HUB"),
          isLoading
              ? shimmerBox(180, double.infinity, 10)
              : bannerTile("https://images.unsplash.com/photo-1592878904946-b3cd8d6a0a5b?auto=format&fit=crop&w=800&q=80"),

          isLoading
              ? shimmerBox(180, double.infinity, 10)
              : bannerTile("https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=800&q=80"),

          sectionTitle("TOP PICKS"),
          isLoading
              ? shimmerHorizontalList()
              : horizontalImageList(topPicks),

          sectionTitle("NEW CATEGORIES"),
          isLoading
              ? shimmerTwoRow()
              : twoImageRow(
            "https://images.unsplash.com/photo-1618354691215-0ff07dc9e033?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=800&q=80",
          ),

          sectionTitle("G.O.A.T DEALS"),
          isLoading
              ? shimmerHorizontalList()
              : horizontalImageList(deals),

          sectionTitle("PICK YOUR FAVES"),
          isLoading
              ? shimmerTwoRow()
              : twoImageRow(
            "https://images.unsplash.com/photo-1593032457861-5c88d19c4581?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1618354690829-1eec7c6f0c1f?auto=format&fit=crop&w=800&q=80",
          ),

          sectionTitle("STEALS UNDER ₹999"),
          isLoading
              ? shimmerHorizontalList()
              : horizontalImageList([
            "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1542060748-10c28b62716f?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80",
          ]),

          sectionTitle("LOVED BY ALL"),
          isLoading
              ? shimmerTwoRow()
              : twoImageRow(
            "https://images.unsplash.com/photo-1618354691026-1ad09d6ef490?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1618354690998-f8d17e73e1c6?auto=format&fit=crop&w=800&q=80",
          ),

          sectionTitle("BEST SELLERS"),
          isLoading
              ? shimmerHorizontalList()
              : horizontalImageList([
            "https://images.unsplash.com/photo-1521334884684-d80222895322?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1555685812-4b943f1cb0eb?auto=format&fit=crop&w=800&q=80",
          ]),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget shimmerHorizontalList() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) =>
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: shimmerBox(120, 120, 10),
            ),
      ),
    );
  }

  Widget shimmerTwoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(child: shimmerBox(160, double.infinity, 10)),
          const SizedBox(width: 10),
          Expanded(child: shimmerBox(160, double.infinity, 10)),
        ],
      ),
    );
  }

  Widget bannerTile(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget horizontalImageList(List<String> imageUrls) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrls[index],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget twoImageRow(String leftImg, String rightImg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(leftImg, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(rightImg, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
