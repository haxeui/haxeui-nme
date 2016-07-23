package haxe.ui.backend;

import haxe.ui.backend.TextDisplayBase;
import nme.text.TextFieldType;
import nme.text.TextFieldAutoSize;

class TextInputBase extends TextDisplayBase {
    public function new() {
        super();
        type = TextFieldType.INPUT;
        selectable = true;
        mouseEnabled = true;
        autoSize = TextFieldAutoSize.NONE;
        //PADDING_Y = 2;
    }
}
