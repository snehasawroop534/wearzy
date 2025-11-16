import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final accent = Colors.teal.shade300;
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0F), // near black
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
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search by product, brand...',
              hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.favorite_border, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
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
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Swag Storm Spotted",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),

              _SectionHeader(
                title: "Barcino",
                subtitle: "#Tops",
                followText: "+ Follow",
              ),
              const SizedBox(height: 8),
              _HorizontalBrandThumbnails(
                images: const [
                  "https://images.unsplash.com/photo-1520975918319-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80",
                  "https://images.unsplash.com/photo-1581235720704-06d3acfcb36d?auto=format&fit=crop&w=800&q=80",
                  "https://images.unsplash.com/photo-1520975663890-ec1c5f9b5b66?auto=format&fit=crop&w=800&q=80",
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_right_alt, color: Colors.white),
                  label: const Text(
                    "View All",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.network(
                      "https://images.unsplash.com/photo-1592878904946-b3cd8d6a0a5b?auto=format&fit=crop&w=1600&q=80",
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.15)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "GRAB THE LATEST DROP",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "UP TO 40% OFF",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              _SectionTitle(title: "Street-Chic Carnival"),
              const SizedBox(height: 10),
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _BrandCard(
                      brand: "BURGER BAE",
                      tag: "#tees #baggy",
                      imageUrl:
                      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80",
                    ),
                    _BrandCard(
                      brand: "LA CHIC",
                      tag: "#dress #vibes",
                      imageUrl:
                      "https://images.unsplash.com/photo-1549989476-7f3b2f9d0b0b?auto=format&fit=crop&w=800&q=80",
                    ),
                    _BrandCard(
                      brand: "OUTZID",
                      tag: "#GetReady",
                      imageUrl:
                      "https://images.unsplash.com/photo-1520975918299-7a6fdc1a7b8d?auto=format&fit=crop&w=800&q=80",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _SectionTitle(title: "Hep & Hype Haul"),
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _BrandCard(
                      brand: "Quiero",
                      tag: "#trendy #Fashion",
                      imageUrl:
                      "https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=800&q=80",
                    ),
                    _BrandCard(
                      brand: "NOMADE",
                      tag: "#Floral",
                      imageUrl:
                      "https://images.unsplash.com/photo-1503342217505-b0a15d6a6c21?auto=format&fit=crop&w=800&q=80",
                    ),
                    _BrandCard(
                      brand: "UZERO",
                      tag: "#Street",
                      imageUrl:
                      "https://images.unsplash.com/photo-1472417583565-62e7bdeda490?auto=format&fit=crop&w=800&q=80",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _ThumbCard(
                      label: "ACCESSORIES",
                      imageUrl:
                      "https://images.unsplash.com/photo-1573497491208-6b1acb260507?auto=format&fit=crop&w=800&q=80",
                    ),
                    _ThumbCard(
                      label: "SLOW & ELEVATED",
                      imageUrl:
                      "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=800&q=80",
                    ),
                    _ThumbCard(
                      label: "FAB FOOT FORWARD",
                      imageUrl:
                      "https://images.unsplash.com/photo-1600180758890-6c9e7d70f0a2?auto=format&fit=crop&w=800&q=80",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              _SectionTitle(title: "Hot Right Now"),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _TallCard(
                      title: "KOREAN STREET",
                      subtitle: "Cargos & Bodycons by IZf",
                      imageUrl:
                      "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80",
                    ),
                    _TallCard(
                      title: "STATEMENT DRESSES",
                      subtitle: "Dresses & more by OUTCAST",
                      imageUrl:
                      "https://images.unsplash.com/photo-1520975681917-8b2f6c2f4b3d?auto=format&fit=crop&w=900&q=80",
                    ),
                    _TallCard(
                      title: "RETRO GROOVE",
                      subtitle: "Trackpants & Co-ords",
                      imageUrl:
                      "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?auto=format&fit=crop&w=900&q=80",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                "Explore by Lit Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _CategoryTile(
                title: "Street Wear",
                subtitle: "Y2k Nostalgia",
                imageUrl:
                "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=900&q=80",
              ),
              _CategoryTile(
                title: "Resort",
                subtitle: "Vacay Timeee",
                imageUrl:
                "https://images.unsplash.com/photo-1503342452485-86f7f7f0f8b7?auto=format&fit=crop&w=900&q=80",
              ),
              _CategoryTile(
                title: "Party Wear",
                subtitle: "Saturday Night Plans",
                imageUrl:
                "https://images.unsplash.com/photo-1520975694126-0ea5f7f9b1f7?auto=format&fit=crop&w=900&q=80",
              ),
              _CategoryTile(
                title: "Office Wear",
                subtitle: "9 to 5 Shenanigans",
                imageUrl:
                "https://images.unsplash.com/photo-1544739313-6d2c5f2cfb3a?auto=format&fit=crop&w=900&q=80",
              ),
              _CategoryTile(
                title: "Casual Wear",
                subtitle: "Everyday Styles",
                imageUrl:
                "https://images.unsplash.com/photo-1531123414780-f1f6f3e85f79?auto=format&fit=crop&w=900&q=80",
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffc9857c)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "View All Themes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String followText;
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.followText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?auto=format&fit=crop&w=200&q=80",
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
        Text(followText, style: const TextStyle(color: Colors.redAccent)),
      ],
    );
  }
}

class _HorizontalBrandThumbnails extends StatelessWidget {
  final List<String> images;
  const _HorizontalBrandThumbnails({required this.images});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: images
          .map(
            (img) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            height: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(img, fit: BoxFit.cover),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final String brand;
  final String tag;
  final String imageUrl;
  const _BrandCard({
    required this.brand,
    required this.tag,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, height: 140, width: 150, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(brand, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(tag, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ThumbCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  const _ThumbCard({required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, height: 80, width: 160, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TallCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  const _TallCard({required this.title, required this.subtitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, height: 180, width: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  const _CategoryTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF101011),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Image.network(imageUrl, width: 110, height: 90, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
