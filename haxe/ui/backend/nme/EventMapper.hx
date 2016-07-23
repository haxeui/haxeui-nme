package haxe.ui.backend.nme;

class EventMapper {
    public static var HAXEUI_TO_OPENFL:Map<String, String> = [
        haxe.ui.core.MouseEvent.MOUSE_MOVE => nme.events.MouseEvent.MOUSE_MOVE,
        haxe.ui.core.MouseEvent.MOUSE_OVER => nme.events.MouseEvent.MOUSE_OVER,
        haxe.ui.core.MouseEvent.MOUSE_OUT => nme.events.MouseEvent.MOUSE_OUT,
        haxe.ui.core.MouseEvent.MOUSE_DOWN => nme.events.MouseEvent.MOUSE_DOWN,
        haxe.ui.core.MouseEvent.MOUSE_UP => nme.events.MouseEvent.MOUSE_UP,
        haxe.ui.core.MouseEvent.MOUSE_WHEEL => nme.events.MouseEvent.MOUSE_WHEEL,
        haxe.ui.core.MouseEvent.CLICK => nme.events.MouseEvent.CLICK,

        haxe.ui.core.KeyboardEvent.KEY_DOWN => nme.events.KeyboardEvent.KEY_DOWN,
        haxe.ui.core.KeyboardEvent.KEY_UP => nme.events.KeyboardEvent.KEY_UP
    ];

    public static var OPENFL_TO_HAXEUI:Map<String, String> = [
        nme.events.MouseEvent.MOUSE_MOVE => haxe.ui.core.MouseEvent.MOUSE_MOVE,
        nme.events.MouseEvent.MOUSE_OVER => haxe.ui.core.MouseEvent.MOUSE_OVER,
        nme.events.MouseEvent.MOUSE_OUT => haxe.ui.core.MouseEvent.MOUSE_OUT,
        nme.events.MouseEvent.MOUSE_DOWN => haxe.ui.core.MouseEvent.MOUSE_DOWN,
        nme.events.MouseEvent.MOUSE_UP => haxe.ui.core.MouseEvent.MOUSE_UP,
        nme.events.MouseEvent.MOUSE_WHEEL => haxe.ui.core.MouseEvent.MOUSE_WHEEL,
        nme.events.MouseEvent.CLICK => haxe.ui.core.MouseEvent.CLICK,

        nme.events.KeyboardEvent.KEY_DOWN => haxe.ui.core.KeyboardEvent.KEY_DOWN,
        nme.events.KeyboardEvent.KEY_UP => haxe.ui.core.KeyboardEvent.KEY_UP
    ];
}