library auto_search;

import 'package:flutter/material.dart';

typedef OnTap = void Function(int index);

///Class for adding AutoSearchInput to your project
class AutoSearchInput extends StatefulWidget {
  final TextEditingController controller;

  ///List of data that can be searched through for the results
  final List<String> data;

  ///The max number of elements to be displayed when the TextField is clicked
  final int maxElementsToDisplay;

  ///The color of text which actually appears in the results for which the text
  ///is typed
  final Color? selectedTextColor;

  ///The color of text which actually appears in the results for the
  ///remaining text
  final Color? unSelectedTextColor;

  ///Color of the border when the TextField is enabled
  final Color? enabledBorderColor;

  ///Color of the border when the TextField is disabled
  final Color? disabledBorderColor;

  ///Color of the border when the TextField is being interated with
  final Color? focusedBorderColor;

  ///Color of the cursor
  final Color? cursorColor;

  ///Border Radius of the TextField and the resultant elements
  final double borderRadius;

  ///Font Size for both the text in the TextField and the results
  final double fontSize;

  ///Height of a single item in the resultant list
  final double singleItemHeight;

  ///Number of items to be shown when the TextField is tapped
  final int itemsShownAtStart;

  ///Hint text to show inside the TextField
  final String hintText;

  ///Boolean to set autoCorrect
  final bool autoCorrect;

  ///Boolean to set whether the TextField is enabled
  final bool enabled;

  ///onSubmitted function
  final Function(String)? onSubmitted;

  ///Function to call when a certain item is clicked
  /// Takes in a paramter of the item which was clicked
  final OnTap onItemTap;

  ///onEditingComplete function
  final Function()? onEditingComplete;

  const AutoSearchInput({
    super.key,
    required this.controller,
    required this.data,
    required this.maxElementsToDisplay,
    required this.onItemTap,
    this.selectedTextColor,
    this.unSelectedTextColor,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.focusedBorderColor,
    this.cursorColor,
    this.borderRadius = 10.0,
    this.fontSize = 20.0,
    this.singleItemHeight = 40.0,
    this.itemsShownAtStart = 10,
    this.hintText = 'Enter a name',
    this.autoCorrect = true,
    this.enabled = true,
    this.onSubmitted,
    this.onEditingComplete,
  });

  @override
  State<AutoSearchInput> createState() => _AutoSearchInputState();
}

class _AutoSearchInputState extends State<AutoSearchInput> {
  List<String> results = [];
  bool isItemClicked = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        results = widget.data
            .where(
              (element) => element
                  .toLowerCase()
                  .startsWith(widget.controller.text.toLowerCase()),
            )
            .toList();
        if (results.length > widget.maxElementsToDisplay) {
          results = results.sublist(0, widget.maxElementsToDisplay);
        }
      });
    });

    _focusNode.addListener(() {
      setState(() {
        isItemClicked = !_focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Widget _getRichText(String result) {
    return RichText(
      text: widget.controller.text.isNotEmpty
          ? TextSpan(
              children: [
                if (widget.controller.text.isNotEmpty)
                  TextSpan(
                    text: result.substring(0, widget.controller.text.length),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.selectedTextColor ?? Colors.black,
                    ),
                  ),
                TextSpan(
                  text: result.substring(
                      widget.controller.text.length, result.length),
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: widget.unSelectedTextColor ?? Colors.grey[400],
                  ),
                )
              ],
            )
          : TextSpan(
              text: result,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.unSelectedTextColor ?? Colors.grey[400],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _focusNode,
          autocorrect: widget.autoCorrect,
          enabled: widget.enabled,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.all(10.0),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.disabledBorderColor ?? Colors.grey[200] as Color,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.enabledBorderColor ?? Colors.grey[200] as Color,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? Colors.grey[200] as Color,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.borderRadius),
                topRight: Radius.circular(widget.borderRadius),
              ),
            ),
          ),
          style: TextStyle(
            fontSize: widget.fontSize,
          ),
          cursorColor: widget.cursorColor ?? Colors.grey[600],
        ),
        if (_focusNode.hasFocus)
          SizedBox(
            height: widget.itemsShownAtStart * widget.singleItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return Container(
                  height: widget.singleItemHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300] as Color),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        index == (results.length - 1)
                            ? widget.borderRadius
                            : 0.0,
                      ),
                      bottomRight: Radius.circular(
                        index == (results.length - 1)
                            ? widget.borderRadius
                            : 0.0,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Feedback.forTap(context);
                      String value = results[index];
                      widget.onItemTap(widget.data.indexOf(value));
                      widget.controller.text = "";
                      _focusNode.unfocus();
                      setState(() {
                        isItemClicked = !isItemClicked;
                      });
                    },
                    child: _getRichText(results[index]),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
