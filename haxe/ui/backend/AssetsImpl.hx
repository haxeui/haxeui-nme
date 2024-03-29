package haxe.ui.backend;

import haxe.io.Bytes;
import haxe.io.Path;
import haxe.ui.assets.FontInfo;
import haxe.ui.assets.ImageInfo;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Loader;
import nme.events.Event;
import nme.text.Font;
import nme.text.FontStyle;
import nme.text.FontType;
import nme.utils.ByteArray;

class AssetsImpl extends AssetsBase {
    private override function getTextDelegate(resourceId:String):String {
        if (Assets.exists(resourceId) == true) {
            return Assets.getText(resourceId);
        } else if (Resource.listNames().indexOf(resourceId) != -1) {
            return Resource.getString(resourceId);
        }
        return null;
    }

    private override function getImageInternal(resourceId:String, callback:ImageInfo->Void):Void {
        var imageInfo:ImageInfo = null;
        if (Assets.exists(resourceId) == true) {
            if(Path.extension(resourceId).toLowerCase() == "svg") {
                #if svg
                var content:String = Assets.getText(resourceId);
                var svg = new format.SVG(content);
                imageInfo = {
                    data: svg,
                    width: Std.int(svg.data.width),
                    height: Std.int(svg.data.height)
                };
                #else
                trace("WARNING: SVG not supported");
                #end
            }
            else {
                var bmpData:BitmapData = Assets.getBitmapData(resourceId);
                imageInfo = {
                    data: bmpData,
                    width: bmpData.width,
                    height: bmpData.height
                }
            }
        }

        callback(imageInfo);
    }

    private override function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        var imageInfo:ImageInfo = null;
        if (Path.extension(resourceId).toLowerCase() == "svg") {
            #if svg
            var svgContent = Resource.getString(resourceId);
            var svg = new format.SVG(svgContent);
            imageInfo = {
                svg: svg,
                width: Std.int(svg.data.width),
                height: Std.int(svg.data.height)
            }
            #else
            trace("WARNING: SVG not supported");
            #end

            callback(resourceId, imageInfo);
            return;
        }

        var bytes = Resource.getBytes(resourceId);
        imageFromBytes(bytes, function(imageInfo) {
            callback(resourceId, imageInfo);
        });
    }

    public override function imageFromBytes(bytes:Bytes, callback:ImageInfo->Void):Void {
        var ba:ByteArray = ByteArray.fromBytes(bytes);
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e) {
            if (loader.content != null) {
                var bmpData = cast(loader.content, Bitmap).bitmapData;
                var imageInfo:ImageInfo = {
                    data: bmpData,
                    width: bmpData.width,
                    height: bmpData.height
                }

                callback(imageInfo);
            }
        }, false, 0, true);
        loader.contentLoaderInfo.addEventListener("ioError", function(e) {
            trace(e);
            callback(null);
        }, false, 0, true);
        loader.loadBytes(ba);
    }
    
    private override function getFontInternal(resourceId:String, callback:FontInfo->Void):Void {
        var fontInfo = null;
        if (isEmbeddedFont(resourceId) == true) {
            if (Assets.exists(resourceId)) {
                fontInfo = {
                    data: Assets.getFont(resourceId).fontName
                }
            } else if (Resource.listNames().indexOf(resourceId) != -1) {
                getFontFromHaxeResource(resourceId, function(r, info) {
                    callback(info);
                });
            } else {
                fontInfo = {
                    data: resourceId
                }
            }
        } else {
            fontInfo = {
                data: resourceId
            }
        }
        callback(fontInfo);
    }

    private override function getFontFromHaxeResource(resourceId:String, callback:String->FontInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        if (bytes == null) {
            callback(resourceId, null);
            return;
        }
        
        var font = new Font("", FontStyle.REGULAR, FontType.EMBEDDED, resourceId, resourceId);
        var ba = ByteArray.fromBytes(bytes);
        var fontData = Font.loadBytes(ba);
        Font.registerFontData(font, ba);
        var fontInfo = {
            data: font.fontName
        }
        callback(resourceId, fontInfo);
    }
    
    //***********************************************************************************************************
    // Util functions
    //***********************************************************************************************************

    private static inline function isEmbeddedFont(name:String) {
        return (name != "_sans" && name != "_serif" && name != "_typewriter");
    }
}
