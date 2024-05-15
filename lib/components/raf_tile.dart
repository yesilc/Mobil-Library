import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sek/sayfalar/single_shelf_page.dart';

// ignore: must_be_immutable
class RafTile extends StatefulWidget {
  String? rafName;
  void Function(BuildContext)? deleteFunction;
  void Function(BuildContext)? updateFunction;
  RafTile(
      {super.key,
      required this.rafName,
      this.deleteFunction,
      this.updateFunction});

  @override
  State<RafTile> createState() => _RafTileState();
}

class _RafTileState extends State<RafTile> {
  Color _color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: widget.deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            //borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: widget.updateFunction,
            icon: Icons.change_circle_outlined,
            backgroundColor: Colors.blue,
            //borderRadius: BorderRadius.circular(12),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _color = Colors.white;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SingleShelfPage(rafName: widget.rafName!)));
        },
        child: Ink(
          decoration: BoxDecoration(
              color: _color,
              border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey.shade300))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  widget.rafName!,
                  style: const TextStyle(fontSize: 45),
                ),
              ),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}
