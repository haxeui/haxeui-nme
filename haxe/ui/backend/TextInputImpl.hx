package haxe.ui.backend;

import nme.events.Event;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFieldType;

class TextInputImpl extends TextDisplayImpl {
    public function new() {
        super();

        textField.addEventListener(Event.CHANGE, onChange);
        textField.addEventListener(Event.SCROLL, onScroll);
    }

    private override function createTextField() {
        var tf:TextField = new TextField();
        tf.type = TextFieldType.INPUT;
        tf.selectable = true;
        tf.mouseEnabled = true;
        tf.autoSize = TextFieldAutoSize.NONE;
        tf.multiline = true;
        tf.wordWrap = true;

        return tf;
    }

    public override function focus() {
        if (textField.stage != null) {
			textField.stage.focus = textField;
		}
    }
    
    public override function blur() {
        if (textField.stage != null) {
			textField.stage.focus = null;
		}
    }
    
    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************
    private override function validateData() {
        super.validateData();
        
        var hscrollValue:Int = Std.int(_inputData.hscrollPos + 1);
        if (textField.scrollH != hscrollValue) {
            textField.scrollH = hscrollValue;
        }

        var vscrollValue:Int = Std.int(_inputData.vscrollPos + 1);
        if (textField.scrollV != vscrollValue) {
            textField.scrollV = vscrollValue;
        }
    }
    
    private override function validateStyle():Bool {
        var measureTextRequired:Bool = super.validateStyle();

        if (textField.displayAsPassword != _inputData.password) {
            textField.displayAsPassword = _inputData.password;
        }

        if (parentComponent.disabled) {
            textField.selectable = false;
        } else {
            textField.selectable = true;
        }
        
        return measureTextRequired;
    }

    private override function validatePosition() {
        textField.x = _left;// - 2 + (PADDING_X / 2);
        textField.y = _top - 1;// - 2 + (PADDING_Y / 2);
    }
    
    private override function measureText() {
        super.measureText();
        _inputData.hscrollMax = _textWidth - _width;
        _inputData.hscrollPageSize = (_width * _inputData.hscrollMax) / _textWidth;
        
        _inputData.vscrollMax = _textHeight - _height;
        _inputData.vscrollPageSize = (_height * _inputData.vscrollMax) / _textHeight;
    }
    
    private function onChange(e) {
        _text = textField.text;
        
        measureText();
        
        if (_inputData.onChangedCallback != null) {
            _inputData.onChangedCallback();
        }
    }
    
    private function onScroll(e) {
        return;
        _inputData.hscrollPos = textField.scrollH;
        _inputData.vscrollPos = textField.scrollV;
        
        if (_inputData.onScrollCallback != null) {
            _inputData.onScrollCallback();
        }
    }
}
