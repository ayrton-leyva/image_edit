import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageDisplay extends StatefulWidget {
  ImageDisplay({super.key});

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  img.Image? modifiedImage;

  // Load the image and remove the white background
  void _loadImage() async {
    // Load the original image
    ByteData data = await rootBundle.load('assets/0001-relaxation.png');
    List<int> bytes = data.buffer.asUint8List();
    img.Image originalImage = img.decodeImage(Uint8List.fromList(bytes))!;

    // Create a new image with transparency
    modifiedImage = img.Image(
      width: originalImage.width,
      height: originalImage.height,
    );

    for (int y = 0; y < originalImage.height; y++) {
      for (int x = 0; x < originalImage.width; x++) {
        // Get the color of the current pixel
        img.Color pixelColor = originalImage.getPixel(x, y);
        // Extract the individual color channels (RGB)
        int red = pixelColor.r.toInt();
        int green = pixelColor.g.toInt();
        int blue = pixelColor.b.toInt();
        // print('red: $red green: $green blue:$blue');

        // Check if the pixel is white (RGB: 255, 255, 255)
        if (red == 255 && green == 0 && blue == 0) {
          // Make the pixel transparent (set alpha to 0)
          modifiedImage!.setPixel(x, y, img.ColorFloat16.rgba(0, 0, 0, 0));
        } else {
          // Copy the pixel from the original image to the modified image
          modifiedImage!
              .setPixel(x, y, img.ColorFloat16.rgba(255, 255, 255, 0));
        }
      }
    }
    // Update the UI
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Load the image when the widget initializes
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            'Image',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              modifiedImage != null
                  ? Image.memory(
                      // color: Colors.transparent,
                      Uint8List.fromList(
                        img.encodePng(modifiedImage!),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(ImageDisplay());
}
