import 'package:flutter/material.dart';

class ProductDetailImage extends StatefulWidget {
  final List<String> images;
  const ProductDetailImage({super.key, required this.images});

  @override
  State<ProductDetailImage> createState() => _ProductDetailImageState();
}

class _ProductDetailImageState extends State<ProductDetailImage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final bool MultipleImages = widget.images.length > 1;
    return Container(
      decoration: BoxDecoration(
        // color: Colors.red[100],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.images[selectedIndex]),
        ),
      ),
      height: 500,
      // width: double.infinity,
      child: Stack(
        children: [
          if (MultipleImages)
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6), // 80% opacity

                    borderRadius: BorderRadius.circular(10),
                  ),
                  // width: double.infinity,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,

                    padding: EdgeInsets.all(6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.images.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },

                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    selectedIndex == index
                                        ? Colors.black
                                        : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Image.network(
                              widget.images[index],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
