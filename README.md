## hxMinicraft
Haxe port of Notch's LD22 game.

Original available [here](http://ludumdare.com/compo/ludum-dare-22/?action=preview&uid=398).

I got lazy, so it depends on OpenFL and HaxeFlixel for rendering, keyboard, etc. It should be fairly easy to remove these if they're not available - rendering is to a simple array of pixels.

#### Why?

Ported for fun & learning intermittently over ~7 days. Not a perfect port - I have added extra classes and used hacks to reconcile differences between Haxe and Java.

The rendering system is interesting, resembling an older games system. It is explained quite well  [here](http://www.mrspeaker.net/2011/12/30/colorising-sprites-1/).

#### Known Issues

- No sound. I didn't consider it especially important, though it would be trivial to add.
- Only tested on flash target. Throws runtime errors on neko.
- Maps are generated twice, which is unnecessary (& slow). This appears to be a problem with the original Java version also.
