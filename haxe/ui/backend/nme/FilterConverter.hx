package haxe.ui.backend.nme;

import haxe.ui.filters.Filter;
import nme.filters.BitmapFilter;
import nme.filters.BlurFilter;
import nme.filters.DropShadowFilter;

class FilterConverter {
    public static function convertFilter(input:Filter):BitmapFilter {
        if (input == null) {
            return null;
        }
        var output:BitmapFilter = null;
        if ((input is haxe.ui.filters.DropShadow)) {
            var inputDropShadow:haxe.ui.filters.DropShadow = cast(input, haxe.ui.filters.DropShadow);
            output = new DropShadowFilter(inputDropShadow.distance + 1,
                                          inputDropShadow.angle,
                                          inputDropShadow.color,
                                          inputDropShadow.alpha * 2,
                                          inputDropShadow.blurX,
                                          inputDropShadow.blurY,
                                          inputDropShadow.strength,
                                          inputDropShadow.quality,
                                          inputDropShadow.inner);
                                            
            if (inputDropShadow.inner == true) {
                cast(output, DropShadowFilter).distance += 1;
            }
        } else if ((input is haxe.ui.filters.Blur)) {
            var inputBlur:haxe.ui.filters.Blur = cast(input, haxe.ui.filters.Blur);
            output = new BlurFilter(inputBlur.amount, inputBlur.amount);
        }
        return output;
    }
}