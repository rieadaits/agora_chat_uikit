import 'package:flutter/material.dart';

class ChatImageLoader {
  static Image loadImage(
    name, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.fill,
    Color? color,
  }) {
    // Try to load from local assets first (for example app), then fallback to package assets
    try {
      return Image.asset(
        "assets/images/$name",
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          // If local asset fails, try package asset
          return Image.asset(
            "assets/images/$name",
            width: width,
            height: height,
            fit: fit,
            package: "agora_chat_uikit",
            color: color,
          );
        },
      );
    } catch (e) {
      // Fallback to package asset
      return Image.asset(
        "assets/images/$name",
        width: width,
        height: height,
        fit: fit,
        package: "agora_chat_uikit",
        color: color,
      );
    }
  }

  static ImageProvider<Object> assetImage(String name) {
    return AssetImage("assets/images/$name", package: "agora_chat_uikit");
  }

  static Widget defaultAvatar({
    double size = 40,
  }) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        color: Colors.grey[200],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
      child: const Icon(Icons.person),
    );
  }
}
