import 'package:flutter/material.dart';

class ProductDetailImage extends StatefulWidget {
  final List<String> images;
  const ProductDetailImage({super.key, required this.images});

  @override
  State<ProductDetailImage> createState() => _ProductDetailImageState();
}

class _ProductDetailImageState extends State<ProductDetailImage> {
  int selectedIndex = 0;
  final PageController _pagecontroller = PageController();

  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool multipleimages = widget.images.length > 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(widget.images[selectedIndex]),
          ),
        ),
        height: 500,
        // width: double.infinity,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pagecontroller,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(widget.images[index]),
                    ),
                  ),
                );
              },
            ),
            if (multipleimages)
              Positioned(
                bottom: 25,
                left: 0,
                right: 0,

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      border: Border.all(color: Colors.black),
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
                              _pagecontroller.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
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
      ),
    );
  }
}
