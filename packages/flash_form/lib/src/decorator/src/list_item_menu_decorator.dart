import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class ListItemMenuDecorator implements FieldDecorator {
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment rowAlignment;

  const ListItemMenuDecorator({
    this.padding = const EdgeInsets.all(8.0),
    this.rowAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    return Row(
      crossAxisAlignment: rowAlignment,
      children: [
        Expanded(child: fieldWidget),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  title:
                      const Text('Remove', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    flashField.sendEvent(ListItemRemoveEvent(flashField));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一つ上に追加
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Add above'),
                  onTap: () {
                    flashField.sendEvent(ListItemAddEvent(
                      field: flashField,
                      position: InsertPosition.above,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一つ下に追加
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Add below'),
                  onTap: () {
                    flashField.sendEvent(ListItemAddEvent(
                      field: flashField,
                      position: InsertPosition.below,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一つ上に移動
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Move up'),
                  onTap: () {
                    flashField.sendEvent(ListItemMoveEvent(
                      field: flashField,
                      moveType: MoveType.up1,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一つ下に移動
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Move down'),
                  onTap: () {
                    flashField.sendEvent(ListItemMoveEvent(
                      field: flashField,
                      moveType: MoveType.down1,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一番上に移動
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Move to top'),
                  onTap: () {
                    flashField.sendEvent(ListItemMoveEvent(
                      field: flashField,
                      moveType: MoveType.top,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一番下に移動
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Move to bottom'),
                  onTap: () {
                    flashField.sendEvent(ListItemMoveEvent(
                      field: flashField,
                      moveType: MoveType.bottom,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),
            ];
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.close),
        //   onPressed: () {
        //     flashField.sendEvent(ListItemRemoveEvent(flashField));
        //   },
        // ),
      ],
    );
  }
}
