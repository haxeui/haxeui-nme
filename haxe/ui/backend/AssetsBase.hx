package haxe.ui.backend;

import haxe.ui.assets.FontInfo;
import haxe.ui.assets.ImageInfo;
import haxe.ui.util.ByteConverter;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Loader;
import nme.events.Event;
import nme.utils.ByteArray;

class AssetsBase {
    public function new() {

    }

    private function getTextDelegate(resourceId:String):String {
        if (Assets.exists(resourceId) == true) {
            return Assets.getText(resourceId);
        }
        return null;
    }

    private function getImageInternal(resourceId:String, callback:ImageInfo->Void):Void {
        if (Assets.exists(resourceId) == true) {
            var bmpData:BitmapData = Assets.getBitmapData(resourceId);
            var imageInfo:ImageInfo = {
                data: bmpData,
                width: bmpData.width,
                height: bmpData.height
            }
            callback(imageInfo);
        } else {
            callback(null);
        }
    }

    private function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        var ba:ByteArray = ByteConverter.fromHaxeBytes(bytes);
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e) {
            if (loader.content != null) {
                var bmpData = cast(loader.content, Bitmap).bitmapData;
                var imageInfo:ImageInfo = {
                    data: bmpData,
                    width: bmpData.width,
                    height: bmpData.height
                }
                callback(resourceId, imageInfo);
            }
        });
        loader.loadBytes(ba);

    }

    private function getFontInternal(resourceId:String, callback:FontInfo->Void):Void {
        var fontInfo = null;
        if (isEmbeddedFont(resourceId) == true) {
            fontInfo = {
                data: Assets.getFont(resourceId).fontName
            }
        } else {
            fontInfo = {
                data: resourceId
            }
        }
        callback(fontInfo);
    }

    private function getFontFromHaxeResource(resourceId:String, callback:String->FontInfo->Void) {
        callback(resourceId, null);
    }
    
    //***********************************************************************************************************
    // Util functions
    //***********************************************************************************************************

    private static inline function isEmbeddedFont(name:String) {
        return (name != "_sans" && name != "_serif" && name != "_typewriter");
    }
}
