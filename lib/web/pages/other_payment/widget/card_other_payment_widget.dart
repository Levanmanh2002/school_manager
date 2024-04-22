import 'package:flutter/material.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';

class CardOtherPayment extends StatelessWidget {
  const CardOtherPayment({
    super.key,
    this.image = '',
    required this.title,
    required this.des,
    required this.address,
    required this.price,
    required this.onTap,
    required this.clearOntap,
  });

  final String image;
  final String title;
  final String des;
  final String address;
  final String price;
  final VoidCallback onTap;
  final VoidCallback clearOntap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: Responsive.isMobile(context) ? 160 : 311,
            padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x143A73C2),
                  blurRadius: 8.0,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Color(0x143A73C2),
                  blurRadius: 8.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
                  child: Image.network(
                    image.isNotEmpty
                        ? image
                        : 'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                    width: Responsive.isMobile(context) ? 64 : 170,
                    height: Responsive.isMobile(context) ? 64 : 170,
                  ),
                ),
                SizedBox(height: Responsive.isMobile(context) ? 12 : 24),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blackColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    des,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: appTheme.blackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      address,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.blackColor),
                      maxLines: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'Giá: $priceđ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: appTheme.primaryColor),
                      maxLines: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: clearOntap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appTheme.textDesColor,
                ),
                child: Icon(Icons.clear, size: 16, color: appTheme.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
