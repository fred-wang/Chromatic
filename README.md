Chromatic
=========

The goal of the Chromatic project is to re-enable MathML in Chrome and more generally to add MathML support to all Blink-based browsers. Because of some divergences between the WebKit and Blink code bases, importing the WebKit MathML code to Blink is not straightforward and the Chromatic project aims at making this easier via appropriate patches or scripts. An intermediary goal might be to maintain a temporary Chromium fork with math support in order to allow Blink users to benefit from native MathML rendering.

WARNING: This repository contains experimental stuff that I wrote when I tried something one day of Summer 2013. This is not usable yet!

* Upstream bug entry: [Enabling support for MathML](https://code.google.com/p/chromium/issues/detail?id=152430).
* chromatic.svg: a [Klein bottle](https://en.wikipedia.org/wiki/Klein_bottle)-shaped version of the Chromium logo.
* depot_tools/: scripts to help importing WebKit's MathML code into Chrome.
* patches/: patches for the [Chromium source](http://dev.chromium.org/developers/how-tos/get-the-code) to enable MathML.

