package haxe.ui.backend;

import haxe.ui.assets.ImageInfo;
import haxe.ui.core.Component;
import haxe.ui.util.Rectangle;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;

class ImageDisplayBase {
    public var parentComponent:Component;
    public var aspectRatio:Float = 1; // width x height
    public var sprite:Sprite;

    private var _bmp:Bitmap;

    public function new() {
        sprite = new Sprite();
    }

    private var _left:Float = 0;
    private var _top:Float = 0;
    private var _imageWidth:Float = 0;
    private var _imageHeight:Float = 0;
    private var _imageInfo:ImageInfo;
    private var _imageClipRect:Rectangle;

    public function dispose():Void {
        if (_bmp != null) {
            //_bmp.bitmapData.dispose();
            sprite.removeChild(_bmp);
            _bmp = null;
        }
    }

    private inline function containsBitmapDataInfo():Bool {
        return _imageInfo != null && Std.is(_imageInfo.data, BitmapData);
    }

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************
    private function validateData() {
        if (_imageInfo != null) {
            if(containsBitmapDataInfo()) {
                if (_bmp == null) {
                    _bmp = new Bitmap(_imageInfo.data);
                    sprite.addChild(_bmp);
                } else {
                    _bmp.bitmapData = _imageInfo.data;
                }
                _imageWidth = _bmp.width;
                _imageHeight = _bmp.height;

            }
        } else {
            if (_bmp != null && sprite.contains(_bmp) == true) {
                sprite.removeChild(_bmp);
                //_bmp.bitmapData.dispose();
                _bmp = null;
            } else {
                sprite.graphics.clear();
            }

            _imageWidth = 0;
            _imageHeight = 0;
        }
    }

    private function validatePosition() {
        if (sprite.x != _left) {
            sprite.x = _left;
        }

        if (sprite.y != _top) {
            sprite.y = _top;
        }
    }

    private function validateDisplay() {
        if(containsBitmapDataInfo()) {
            var scaleX:Float = _imageWidth / _bmp.bitmapData.width;
            if (_bmp.scaleX != scaleX) {
                _bmp.scaleX = scaleX;
            }

            var scaleY:Float = _imageHeight / _bmp.bitmapData.height;
            if (_bmp.scaleY != scaleY) {
                _bmp.scaleY = scaleY;
            }
        }

        if(_imageClipRect == null) {
            sprite.scrollRect = null;
        } else {
            sprite.scrollRect = new openfl.geom.Rectangle(-_left, -_top, Math.fround(_imageClipRect.width), Math.fround(_imageClipRect.height));
            sprite.x = _imageClipRect.left;
            sprite.y = _imageClipRect.top;
        }
    }
}
