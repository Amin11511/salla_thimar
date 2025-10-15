import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> productImages;

  const ProductImageCarousel({
    super.key,
    required this.productImages,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.3,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: widget.productImages.length > 1,
            autoPlay: widget.productImages.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.productImages.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(Assets.images.tomato.path);
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.productImages.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Colors.green
                      : Colors.white.withOpacity(0.6),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}