import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:intl/intl.dart';

class AnggaranCard extends StatefulWidget {
  final String path;
  final Color indicatorColor;
  final int numBelow;
  final int numUpper;
  final String title;

  const AnggaranCard({
    super.key,
    required this.title,
    required this.path,
    required this.indicatorColor,
    required this.numUpper,
    required this.numBelow,
  });

  @override
  State<AnggaranCard> createState() => _AnggaranCardState();
}

class _AnggaranCardState extends State<AnggaranCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.numUpper == 0) {
      return SizedBox.shrink(); // jangan render apapun
    }
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    double indicatiorWidth = width * 0.8;

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: width * 0.9,
        height: height * 0.19,
        decoration: BoxDecoration(
          color: Colors.white,
          border: BoxBorder.all(color: Color(0xFFD0D0D0)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(widget.path, width: 40, height: 40),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Rp 5000 per hari',
                        style: TextStyle(color: darkGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    width: indicatiorWidth,
                    height: 20,
                    decoration: BoxDecoration(
                      color: grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    width: indicatiorWidth * widget.numBelow / widget.numUpper,
                    height: 20,
                    decoration: BoxDecoration(
                      color: widget.indicatorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 13, top: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Rp ${NumberFormat("#,###,###", "id_ID").format(widget.numBelow)}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Rp ${NumberFormat("#,###,###", "id_ID").format(widget.numUpper)}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              (widget.numBelow / (widget.numUpper + 1)) >= 0.8
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            size: 14,
                            color: Colors.red,
                          ),
                          SizedBox(width: 3),
                          Text(
                            "Ups! Pengeluaranmu sudah lewat budget.",
                            style: TextStyle(color: darkGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: Colors.green,
                          ),
                          SizedBox(width: 3),
                          Text(
                            "Budget kamu masih terkendali",
                            style: TextStyle(color: darkGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
