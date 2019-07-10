package haxe.ui.backend;

import haxe.ui.backend.nme.EventMapper;
import haxe.ui.backend.nme.FilterConverter;
import haxe.ui.backend.nme.NMEStyleHelper;
import haxe.ui.core.Component;
import haxe.ui.core.ImageDisplay;
import haxe.ui.core.Screen;
import haxe.ui.core.TextDisplay;
import haxe.ui.core.TextInput;
import haxe.ui.events.KeyboardEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.geom.Rectangle;
import haxe.ui.styles.Style;
import nme.display.Sprite;
import nme.events.Event;
import nme.filters.DropShadowFilter;

class ComponentImpl extends ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;

    public function new() {
        super();
        tabChildren = false;
        #if flash
        focusRect = false;
        #end
        _eventMap = new Map<String, UIEvent->Void>();

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event) {
        recursiveReady();
    }

    private function recursiveReady() {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        var component:Component = cast(this, Component);
        var isReady = component.isReady;
        component.ready();
        if (isReady == false) {
            component.syncComponentValidation();
        }
        for (child in component.childComponents) {
            child.recursiveReady();
        }
    }

    private override function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (left != null) {
            this.x = Math.fround(left);
        }
        if (top != null) {
            this.y = Math.fround(top);
        }
    }

    public var styleable:Bool = true;
    private override function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        if (width == null || height == null || width <= 0 || height <= 0) {
            return;
        }

        if (styleable == true) {
            NMEStyleHelper.paintStyleSection(graphics, style, Math.fround(width), Math.fround(height));
        }
    }

    private override function handleClipRect(value:Rectangle):Void {
        if (value == null) {
            this.scrollRect = null;
        } else {
            this.scrollRect = new nme.geom.Rectangle(Math.fround(value.left),
                                                        Math.fround(value.top),
                                                        Math.fround(value.width),
                                                        Math.fround(value.height));
        }
    }

    //***********************************************************************************************************
    // Text related
    //***********************************************************************************************************
    public override function createTextDisplay(text:String = null):TextDisplay {
        if (_textDisplay == null) {
            super.createTextDisplay(text);
            addChild(_textDisplay.textField);
        }
        
        return _textDisplay;
    }

    public override function createTextInput(text:String = null):TextInput {
        if (_textInput == null) {
            super.createTextInput(text);
            addChild(_textInput.textField);
        }
        return _textInput;
    }

    //***********************************************************************************************************
    // Image related
    //***********************************************************************************************************
    public override function createImageDisplay():ImageDisplay {
        if (_imageDisplay == null) {
            super.createImageDisplay();
            addChild(_imageDisplay.sprite);
        }
        return _imageDisplay;
    }

    public override function removeImageDisplay():Void {
        if (_imageDisplay != null) {
            if (contains(_imageDisplay.sprite) == true) {
                removeChild(_imageDisplay.sprite);
            }
            _imageDisplay.dispose();
            _imageDisplay = null;
        }
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    private override function handleAddComponent(child:Component):Component {
        addChild(child);
        return child;
    }

    private override function handleAddComponentAt(child:Component, index:Int):Component {
        addChildAt(child, index);
        return child;
    }

    private override function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        if (contains(child)) {
            removeChild(child);
        }
        return child;
    }

    private override function handleRemoveComponentAt(index:Int, dispose:Bool = true):Component {
        removeChildAt(index);
        return null;
    }

    private override function handleSetComponentIndex(child:Component, index:Int) {
        setChildIndex(child, index);
    }

    private override function applyStyle(style:Style) {
        var useHandCursor = false;
        if (style.cursor != null && style.cursor == "pointer") {
            useHandCursor = true;
        }

        this.buttonMode = useHandCursor;
        this.useHandCursor = useHandCursor;
        for (n in 0...this.numChildren) {
            var c = this.getChildAt(n);
            if (Std.is(c, Sprite)) {
                cast(c, Sprite).buttonMode = useHandCursor;
                cast(c, Sprite).useHandCursor = useHandCursor;
            }
        }

        if (style.filter != null && style.filter.length > 0) {
            trace(">>>>>>>> GOT FILTER");
            var array = [];
            for (fa in style.filter) {
                var f = FilterConverter.convertFilter(fa);
                if (f != null) {
                    array.push(f);
                }
            }
            this.filters = array;
        } else {
            this.filters = null;
        }

        if (style.hidden != null) {
            this.visible = !style.hidden;
        }

        if (style.opacity != null) {
            this.alpha = style.opacity;
        }
    }

    #if flash @:setter(visible) #else override #end
    private function set_visible(value:Bool): #if flash Void #else Bool #end {
        #if flash
        super.visible = value;
        #else
        var v = super.set_visible(value);
        #end
        cast(this, Component).hidden = !value;
        #if !flash return v; #end
    }
    
    private override function handleVisibility(show:Bool):Void {
        if (show != this.visible) {
            this.visible = show;
        }
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.MOUSE_WHEEL
                | MouseEvent.CLICK | MouseEvent.RIGHT_CLICK
                | MouseEvent.RIGHT_MOUSE_DOWN | MouseEvent.RIGHT_MOUSE_UP:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onMouseEvent);
                }
			
			case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
				if (_eventMap.exists(type) == false) {
					_eventMap.set(type, listener);
					addEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onKeyboardEvent);
				}
				
            case UIEvent.CHANGE:
                if (_eventMap.exists(UIEvent.CHANGE) == false) {
                    if (hasTextInput() == true) {
                        _eventMap.set(UIEvent.CHANGE, listener);
                        getTextInput().textField.addEventListener(Event.CHANGE, __onTextInputChange);
                    }
                }
        }
    }

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.MOUSE_WHEEL
                | MouseEvent.CLICK | MouseEvent.RIGHT_CLICK
                | MouseEvent.RIGHT_MOUSE_DOWN | MouseEvent.RIGHT_MOUSE_UP:
                _eventMap.remove(type);
                removeEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onMouseEvent);

			case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
				_eventMap.remove(type);
                removeEventListener(EventMapper.HAXEUI_TO_NME.get(type), __onKeyboardEvent);
				
            case UIEvent.CHANGE:
                _eventMap.remove(type);
                if (hasTextInput() == true) {
                    getTextInput().textField.removeEventListener(Event.CHANGE, __onTextInputChange);
                }
        }

    }

    //***********************************************************************************************************
    // Event handlers
    //***********************************************************************************************************
    private function __onMouseEvent(event:nme.events.MouseEvent) {
        var type:String = EventMapper.NME_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _eventMap.get(type);
            if (fn != null) {
                var mouseEvent = new MouseEvent(type);
                mouseEvent._originalEvent = event;
                mouseEvent.screenX = event.stageX / Toolkit.scaleX;
                mouseEvent.screenY = event.stageY / Toolkit.scaleY;
                mouseEvent.buttonDown = event.buttonDown;
                mouseEvent.delta = event.delta;
                mouseEvent.ctrlKey = event.ctrlKey;
                mouseEvent.shiftKey = event.shiftKey;
                fn(mouseEvent);
            }
        }
    }
	
	private function __onKeyboardEvent(event:nme.events.KeyboardEvent) {
        var type:String = EventMapper.NME_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _eventMap.get(type);
            if (fn != null) {
                var keyboardEvent = new KeyboardEvent(type);
                keyboardEvent._originalEvent = event;
                keyboardEvent.keyCode = event.keyCode;
				keyboardEvent.altKey = event.altKey;
				keyboardEvent.ctrlKey = event.ctrlKey;
				keyboardEvent.shiftKey = event.shiftKey;
                fn(keyboardEvent);
            }
        }
    }

    private function __onTextInputChange(event:Event) {
        var fn:UIEvent->Void = _eventMap.get(UIEvent.CHANGE);
        if (fn != null) {
            fn(new UIEvent(UIEvent.CHANGE));
        }
    }
}