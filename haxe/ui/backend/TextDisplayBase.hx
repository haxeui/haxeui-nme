package haxe.ui.backend;

import haxe.ui.core.Component;
import haxe.ui.styles.Style;
import nme.Assets;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFieldType;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

class TextDisplayBase {
    public var textField:TextField;
    public var parentComponent:Component;

    private var PADDING_X:Int = 0;
    private var PADDING_Y:Int = 0;

    public function new() {
        textField = createTextField();

        _text = "";
        _multiline = false;
        _wordWrap = false;
    }

    private function createTextField() {
        var tf:TextField = new TextField();
        tf.type = TextFieldType.DYNAMIC;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.autoSize = TextFieldAutoSize.LEFT;
        
        return tf;
    }

    private var _text:String;
    private var _left:Float = 0;
    private var _top:Float = 0;
    private var _width:Float = 0;
    private var _height:Float = 0;
    private var _textWidth:Float = 0;
    private var _textHeight:Float = 0;
    private var _textStyle:Style;
    private var _multiline:Bool = true;
    private var _wordWrap:Bool = false;
    
    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private function validateData() {
        textField.text = _text;
    }

    private function validateStyle():Bool {
        var measureTextRequired:Bool = false;

        var format:TextFormat = textField.getTextFormat();

        if (_textStyle != null) {
            if (format.align != textAlign(_textStyle.textAlign)) {
                format.align = textAlign(_textStyle.textAlign);
            }

            var fontSizeValue = Std.int(_textStyle.fontSize);
            if (format.size != fontSizeValue) {
                format.size = fontSizeValue;

                measureTextRequired = true;
            }

            if (format.font != _textStyle.fontName) {
                if (isEmbeddedFont(_textStyle.fontName) == true) {
                    format.font = Assets.getFont(_textStyle.fontName).fontName;
                } else {
                    format.font = _textStyle.fontName;
                }

                measureTextRequired = true;
            }

            if (format.color != _textStyle.color) {
                format.color = _textStyle.color;
            }
        }

        textField.defaultTextFormat = format;
        textField.setTextFormat(format);

        if (textField.wordWrap != _wordWrap) {
            textField.wordWrap = _wordWrap;

            measureTextRequired = true;
        }

        if (textField.multiline != _multiline) {
            textField.multiline = _multiline;

            measureTextRequired = true;
        }

        return measureTextRequired;
    }

    private function validatePosition() {
        textField.x = _left - 2 + (PADDING_X / 2);
        textField.y = _top - 2 + (PADDING_Y / 2);
    }

    private function validateDisplay() {
        if (textField.width != _width) {
            textField.width = _width;
        }

        if (textField.height != _height) {
            textField.height = _height;
        }
    }

    private function measureText() {
        _textWidth = textField.textWidth + PADDING_X;
        _textHeight = textField.textHeight;
        if (_textHeight == 0) {
            var tmpText:String = textField.text;
            textField.text = "|";
            _textHeight = textField.textHeight;
            textField.text = tmpText;
        }
        _textHeight += PADDING_Y;
    }

    //***********************************************************************************************************
    // Util functions
    //***********************************************************************************************************

    private static inline function isEmbeddedFont(name:String) {
        return (name != "_sans" && name != "_serif" && name != "_typewriter");
    }

    private static function textAlign(s:String):TextFormatAlign {
        switch (s) {
            case "center":
                return TextFormatAlign.CENTER;
            case "right":
                return TextFormatAlign.RIGHT;
            case _:
        }
        return TextFormatAlign.LEFT;
    }
}