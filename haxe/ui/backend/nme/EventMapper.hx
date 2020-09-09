package haxe.ui.backend.nme;

class EventMapper {
    public static var HAXEUI_TO_NME:Map<String, String> = [
        haxe.ui.events.MouseEvent.MOUSE_MOVE => nme.events.MouseEvent.MOUSE_MOVE,
        haxe.ui.events.MouseEvent.MOUSE_OVER => nme.events.MouseEvent.MOUSE_OVER,
        haxe.ui.events.MouseEvent.MOUSE_OUT => nme.events.MouseEvent.MOUSE_OUT,
        haxe.ui.events.MouseEvent.MOUSE_DOWN => nme.events.MouseEvent.MOUSE_DOWN,
        haxe.ui.events.MouseEvent.MOUSE_UP => nme.events.MouseEvent.MOUSE_UP,
        haxe.ui.events.MouseEvent.MOUSE_WHEEL => nme.events.MouseEvent.MOUSE_WHEEL,
        haxe.ui.events.MouseEvent.CLICK => nme.events.MouseEvent.CLICK,
		haxe.ui.events.MouseEvent.DBL_CLICK => nme.events.MouseEvent.DOUBLE_CLICK,
        haxe.ui.events.MouseEvent.RIGHT_CLICK => nme.events.MouseEvent.RIGHT_CLICK,
        haxe.ui.events.MouseEvent.RIGHT_MOUSE_DOWN => nme.events.MouseEvent.RIGHT_MOUSE_DOWN,
        haxe.ui.events.MouseEvent.RIGHT_MOUSE_UP => nme.events.MouseEvent.RIGHT_MOUSE_UP,

        haxe.ui.events.KeyboardEvent.KEY_DOWN => nme.events.KeyboardEvent.KEY_DOWN,
        haxe.ui.events.KeyboardEvent.KEY_UP => nme.events.KeyboardEvent.KEY_UP
    ];

    public static var NME_TO_HAXEUI:Map<String, String> = [
        nme.events.MouseEvent.MOUSE_MOVE => haxe.ui.events.MouseEvent.MOUSE_MOVE,
        nme.events.MouseEvent.MOUSE_OVER => haxe.ui.events.MouseEvent.MOUSE_OVER,
        nme.events.MouseEvent.MOUSE_OUT => haxe.ui.events.MouseEvent.MOUSE_OUT,
        nme.events.MouseEvent.MOUSE_DOWN => haxe.ui.events.MouseEvent.MOUSE_DOWN,
        nme.events.MouseEvent.MOUSE_UP => haxe.ui.events.MouseEvent.MOUSE_UP,
        nme.events.MouseEvent.MOUSE_WHEEL => haxe.ui.events.MouseEvent.MOUSE_WHEEL,
        nme.events.MouseEvent.CLICK => haxe.ui.events.MouseEvent.CLICK,
		nme.events.MouseEvent.DOUBLE_CLICK => haxe.ui.events.MouseEvent.DBL_CLICK,
        nme.events.MouseEvent.RIGHT_CLICK => haxe.ui.events.MouseEvent.RIGHT_CLICK,
        nme.events.MouseEvent.RIGHT_MOUSE_DOWN => haxe.ui.events.MouseEvent.RIGHT_MOUSE_DOWN,
        nme.events.MouseEvent.RIGHT_MOUSE_UP => haxe.ui.events.MouseEvent.RIGHT_MOUSE_UP,

        nme.events.KeyboardEvent.KEY_DOWN => haxe.ui.events.KeyboardEvent.KEY_DOWN,
        nme.events.KeyboardEvent.KEY_UP => haxe.ui.events.KeyboardEvent.KEY_UP
    ];
}