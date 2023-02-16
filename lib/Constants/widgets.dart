import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  Buttons(
    this.icon,
    this.onpressed,
    this.text,
    this.color,
  );

  IconData icon;
  String text;
  Function() onpressed;
  Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        minimumSize: MaterialStateProperty.all(
          const Size(50, 50),
        ),
        side: MaterialStatePropertyAll(BorderSide(color: color)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: onpressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black54,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

Row resultFooter() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "POWERED BY : ",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
          ),
          SizedBox(
            width: 10,
          ),
          Image(
            width: 120,
            image: AssetImage(
              "images/brl_logo.png",
            ),
          ),
          SizedBox(
            height: 50.0,
          )
        ],
      ),
    ],
  );
}

TextSpan sData(String text) {
  return TextSpan(
    text: text,
    style: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20.0,
    ),
  );
}
