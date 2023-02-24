import 'package:flutter/material.dart';

import '../size.dart';

class ToolBoxBtn extends StatefulWidget {
  ToolBoxBtn({Key? key, required this.optionBtnHeigth, required this.optionBtnWidth}) : super (key: key);
  final double optionBtnHeigth;
  final double optionBtnWidth;
  @override
  _ToolBoxBtnState createState() => new _ToolBoxBtnState();

}
class _ToolBoxBtnState extends State<ToolBoxBtn> {
  @override
  Widget build(BuildContext context) {
    final AppSize appSize = AppSize(context);
    final optionBtnHeigth =  widget.optionBtnHeigth ;
    final optionBtnWidth = widget.optionBtnWidth;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
      ),
      height: optionBtnHeigth,
      width: optionBtnWidth,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                ),
                height: optionBtnHeigth*.5,
                width: optionBtnWidth*.5,
                child: Column(
                  children: [
                    SizedBox(
                        height: optionBtnHeigth *.3,
                        child:Image.network("https://cdn-icons-png.flaticon.com/512/27/27176.png", fit: BoxFit.fill)
                    ),
                    Text('Activité')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                ),
                height: optionBtnHeigth*.5,
                width: optionBtnWidth*.5,
                child: Column(
                  children: [
                    SizedBox(
                        height: optionBtnHeigth *.3,
                        child:Image.network("https://static.thenounproject.com/png/4612037-200.png", fit: BoxFit.fill)
                    ),
                    Text('Public')
                  ],
                ),
              )
            ],
          ),
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
              height: optionBtnHeigth*.5 ,
              width: optionBtnWidth,
              child: Center(child: const Text ('GOOOOOO'))
          )
        ],
      ),
    );
  }
}