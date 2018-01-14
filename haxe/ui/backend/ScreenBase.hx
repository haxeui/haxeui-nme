package haxe.ui.backend;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.DialogButton;
import haxe.ui.core.Component;
import haxe.ui.core.KeyboardEvent;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.UIEvent;
import haxe.ui.backend.nme.EventMapper;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;

class ScreenBase {
    private var _mapping:Map<String, UIEvent->Void>;

    public function new() {
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        _mapping = new Map<String, UIEvent->Void>();
        Lib.current.stage.addEventListener(nme.events.Event.RESIZE, onStageResize);
    }

    public var options(default, default):ToolkitOptions;

    public var width(get, null):Float;
    public function get_width():Float {
        return Lib.current.stage.stageWidth / Toolkit.scaleX;
    }

    public var height(get, null):Float;
    public function get_height() {
        return Lib.current.stage.stageHeight / Toolkit.scaleY;
    }

    public var dpi(get, null):Float;
    private function get_dpi():Float {
        return nme.system.Capabilities.screenDPI;
    }

    public var focus(get, set):Component;
    private function get_focus():Component {
        return cast Lib.current.stage.focus;
    }
    private function set_focus(value:Component):Component {
        if (value != null && value.hasTextInput()) {
            Lib.current.stage.focus = value.getTextInput().textField;
        } else {
            Lib.current.stage.focus = value;
        }
        return value;
    }

    public var title(get,set):String;
    private inline function get_title():String {
        #if js
        return js.Browser.document.title;
        #else
        trace("WARNING: this platform doesnt support dynamic titles");
        return "";
        #end
    }
    private inline function set_title(s:String):String {
        #if js
        js.Browser.document.title = s;
        return s;
        #else
        trace("WARNING: this platform doesnt support dynamic titles");
        return "";
        #end
    }

    private var _topLevelComponents:Array<Component> = new Array<Component>();
    public function addComponent(component:Component) {
        component.scaleX = Toolkit.scaleX;
        component.scaleY = Toolkit.scaleY;
        _topLevelComponents.push(component);
        Lib.current.stage.addChild(component);
        onStageResize(null);
    }

    public function removeComponent(component:Component) {
        _topLevelComponents.remove(component);
        Lib.current.stage.removeChild(component);
    }

    private function handleSetComponentIndex(child:Component, index:Int) {
        Lib.current.stage.setChildIndex(child, index);
    }

    private function onStageResize(event:nme.events.Event) {
        for (c in _topLevelComponents) {
            if (c.percentWidth > 0) {
                c.width = (this.width * c.percentWidth) / 100;
            }
            if (c.percentHeight > 0) {
                c.height = (this.height * c.percentHeight) / 100;
            }
        }
    }

    //***********************************************************************************************************
    // Dialogs
    //***********************************************************************************************************
    public function messageDialog(message:String, title:String = null, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function showDialog(content:Component, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function hideDialog(dialog:Dialog):Bool {
        return false;
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private function supportsEvent(type:String):Bool {
        return EventMapper.HAXEUI_TO_NME.get(type) != null;
    }

    private function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    Lib.current.stage.addEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onMouseEvent);
                }

            case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    Lib.current.stage.addEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onKeyEvent);
                }
        }
    }

    private function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:
                _mapping.remove(type);
                Lib.current.stage.removeEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onMouseEvent);

            case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
                _mapping.remove(type);
                Lib.current.stage.removeEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onKeyEvent);
        }
    }

    private function __onMouseEvent(event:nme.events.MouseEvent) {
        var type:String = EventMapper.NME_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _mapping.get(type);
            if (fn != null) {
                var mouseEvent = new MouseEvent(type);
                mouseEvent._originalEvent = event;
                mouseEvent.screenX = event.stageX / Toolkit.scaleX;
                mouseEvent.screenY = event.stageY / Toolkit.scaleY;
                mouseEvent.buttonDown = event.buttonDown;
                fn(mouseEvent);
            }
        }
    }

    private function __onKeyEvent(event:nme.events.KeyboardEvent) {
        var type:String = EventMapper.NME_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _mapping.get(type);
            if (fn != null) {
                var keyboardEvent = new KeyboardEvent(type);
                keyboardEvent._originalEvent = event;
                keyboardEvent.keyCode = event.keyCode;
                keyboardEvent.shiftKey = event.shiftKey;
                fn(keyboardEvent);
            }
        }
    }
}
