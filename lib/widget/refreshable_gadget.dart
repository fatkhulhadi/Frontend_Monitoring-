import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefreshableWidget extends StatelessWidget {
  final Future<void> Function() onRefresh; // Function untuk refresh
  final RxBool isLoading;                 // State isLoading dari controller
  final Widget child;                     // Widget untuk ditampilkan setelah data berhasil di-load

  const RefreshableWidget({
    Key? key,
    required this.onRefresh,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return child;
        }
      }),
    );
  }
}
