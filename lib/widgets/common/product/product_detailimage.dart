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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(widget.images[selectedIndex]),
          ),
        ),
        height: isSmallScreen ? screenHeight * 0.5 : screenHeight * 0.6,
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
                bottom: isSmallScreen ? 15 : 25,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: isSmallScreen ? 10 : 14,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
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
                              margin: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 3 : 5,
                              ),
                              padding: EdgeInsets.all(isSmallScreen ? 1 : 2),
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
                                width: isSmallScreen ? 40 : 50,
                                height: isSmallScreen ? 40 : 50,
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
