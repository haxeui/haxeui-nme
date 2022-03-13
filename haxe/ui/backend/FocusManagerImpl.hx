package haxe.ui.backend;

import haxe.ui.core.Component;
import nme.Lib;

class FocusManagerImpl extends FocusManagerBase {
    private override function applyFocus(c:Component) {
        super.applyFocus(c);
        if (c != null && c.hasTextInput()) {
            Lib.current.stage.focus = c.getTextInput().textField;
        } else {
            Lib.current.stage.focus = c;
        }
    }
    
    private override function unapplyFocus(c:Component) {
        super.unapplyFocus(c);
        Lib.current.stage.focus = null;
    }
}