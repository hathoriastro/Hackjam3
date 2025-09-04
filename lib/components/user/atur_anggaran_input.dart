import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hackjamraion/components/colors.dart';

class AturAnggaranInput extends StatefulWidget {
  final String path;
  final String title;
  final TextEditingController controller;

  const AturAnggaranInput({
    super.key, 
    required this.title, 
    required this.path,
    required this.controller,
    });

  @override
  State<AturAnggaranInput> createState() => _AturAnggaranInputState();
}

class _AturAnggaranInputState extends State<AturAnggaranInput> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final TextEditingController _inputController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: width * 0.9,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          border: BoxBorder.all(color: Color(0xFFD0D0D0)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(widget.path, width: 40, height: 40),
                  SizedBox(width: 4),
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/anggaran/idr_input.svg',
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: width * 0.25,
                    height: 30,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                      controller: widget.controller,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
