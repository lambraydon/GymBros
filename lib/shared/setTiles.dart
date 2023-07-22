import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymbros/screens/workoutTracker/set.dart';
import 'package:gymbros/shared/constants.dart';

class SetTile extends StatefulWidget {
  final Set set;
  final void Function(bool?)? onCheckBoxChanged;

  const SetTile({Key? key, required this.set, required this.onCheckBoxChanged})
      : super(key: key);

  @override
  State<SetTile> createState() => _SetTileState();
}

class _SetTileState extends State<SetTile> {
  Color buttonColor = Colors.white;
  Color rowColor = backgroundColor;

  // Text Controllers
  TextEditingController weightController = TextEditingController();
  TextEditingController repController = TextEditingController();

  // Focusnodes for each text controller
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _repFocusNode = FocusNode();

  @override
  void initState() {
    if (widget.set.isCompleted) {
      changeButtonColor();
      weightController.text = widget.set.weight.toString();
      repController.text = widget.set.reps.toString();
    }

    super.initState();
  }

  @override
  void dispose() {
    weightController.dispose();
    repController.dispose();
    _weightFocusNode.dispose();
    _repFocusNode.dispose();
    super.dispose();
  }

  // Change textfield colors upon checking off set
  void changeButtonColor() {
    buttonColor = Colors.greenAccent;
    rowColor = Colors.greenAccent;
  }

  // Change textfield colors to original upon unchecking set
  void originalButtonColor() {
    buttonColor = Colors.white;
    rowColor = backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus Textfield
        _weightFocusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: 48,
        color: rowColor,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 44,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.set.index.toString(),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 80,
                child: Text(
                  "-",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24,
                width: 80,
                child: TextField(
                  controller: weightController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  focusNode: _weightFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 10.0,
                    ),
                    filled: true,
                    fillColor: buttonColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: widget.set.weight.toString(),
                    hintStyle: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () {
                    weightController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: weightController.value.text.length,
                    );
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        widget.set.isCompleted = false;
                        originalButtonColor();
                      });
                    } else {
                      widget.set.weight = double.parse(value);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 24,
                width: 80,
                child: TextField(
                  controller: repController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  focusNode: _repFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 10.0,
                    ),
                    filled: true,
                    fillColor: buttonColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: widget.set.reps.toString(),
                    hintStyle: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onTap: () {
                    repController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: repController.value.text.length,
                    );
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        widget.set.isCompleted = false;
                        originalButtonColor();
                      });
                    } else {
                      widget.set.reps = int.parse(value);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 32,
                width: 32,
                child: Checkbox(
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  value: widget.set.isCompleted,
                  onChanged: (value) {
                    _weightFocusNode.unfocus();
                    _repFocusNode.unfocus();

                    if (value == true) {
                      setState(() {
                        changeButtonColor();
                      });
                    } else {
                      originalButtonColor();
                    }

                    if (weightController.text.isEmpty) {
                      setState(() {
                        weightController.text = widget.set.weight.toString();
                      });
                    }

                    if (repController.text.isEmpty) {
                      setState(() {
                        repController.text = widget.set.reps.toString();
                      });
                    }

                    widget.onCheckBoxChanged!(value);
                    print(
                        "weight: ${widget.set.weight} reps: ${widget.set.reps}");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
