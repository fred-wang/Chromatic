#!/bin/bash

# UNIX tools
SED=sed
GREP=grep

# Paths to Chromium and WebKit sources
CHROMIUMSRC=/home/fred/chromiumsrc/third_party/WebKit
WEBKITSRC=/home/fred/webkit/WebKit/

# Patterns to use as insertion points by sed
FEATURESREF="ENABLE_SVG_FONTS"
COREREF1="page\/BarProp.idl"
COREREF2="rendering\/shapes\/PolygonShape.cpp"

echo 'Copying MathML source...'

# Copy the MathML source
cp -r $WEBKITSRC/Source/WebCore/css/mathml.css $CHROMIUMSRC/Source/core/css/
rm -rf $CHROMIUMSRC/Source/core/mathml/
cp -r $WEBKITSRC/Source/WebCore/mathml/ $CHROMIUMSRC/Source/core/mathml/
rm -f $CHROMIUMSRC/Source/core/mathml/MathMLAllInOne.cpp
rm -rf $CHROMIUMSRC/Source/core/rendering/mathml/
cp -r $WEBKITSRC/Source/WebCore/rendering/mathml/ $CHROMIUMSRC/Source/core/rendering/mathml/

# Modify paths to *.h files
file=$CHROMIUMSRC/Source/core/mathml/MathMLElement.h
$SED -i 's|StyledElement\.h|core/dom/Element\.h|' $file
$SED -i 's|StyledElement|Element|' $file

for f in `ls $CHROMIUMSRC/Source/core/mathml/* $CHROMIUMSRC/Source/core/rendering/mathml/*`; do
    $SED -i 's|RenderFlexibleBox\.h|core/rendering/RenderFlexibleBox\.h|' $f
    $SED -i 's|RenderInline\.h|core/rendering/RenderInline\.h|' $f
    $SED -i 's|RenderObject\.h|core/rendering/RenderObject\.h|' $f
    $SED -i 's|RenderTableCell\.h|core/rendering/RenderTableCell\.h|' $f
    $SED -i 's|RenderTable\.h|core/rendering/RenderTable\.h|' $f
    $SED -i 's|RenderText\.h|core/rendering/RenderText\.h|' $f
    $SED -i 's|RenderView\.h|core/rendering/RenderView\.h|' $f
    $SED -i 's|StyleInheritedData\.h|core/rendering/style/StyleInheritedData\.h|' $f
    $SED -i 's|GraphicsContext\.h|core/platform/graphics/GraphicsContext\.h|' $f
    $SED -i 's|FontSelector\.h|core/platform/graphics/FontSelector\.h|' $f
    $SED -i 's|FontCache\.h|core/platform/graphics/FontCache\.h|' $f
    $SED -i 's|PaintInfo\.h|core/rendering/PaintInfo\.h|' $f
    $SED -i '/GraphicsContext\.h/ a#include "core/platform/graphics/GraphicsContextStateSaver.h"' $f
done

# Add the ENABLE_MATHML flag
file=$CHROMIUMSRC/Source/core/features.gypi
if [ ! "`$GREP ENABLE_MATHML $file`" ]; then
    $SED -i "/$FEATURESREF/ i\      'ENABLE_MATHML=1'," $file
fi

# Add the *.cpp and *.h files to core.gypi
file=$CHROMIUMSRC/Source/core/core.gypi
$SED -i '/mathml/d' $file
for f in `cd $CHROMIUMSRC/Source/core/; ls mathml/*.cpp mathml/*.h | grep -v MathMLAllInOne`; do
        $SED -i "/$COREREF1/ i\            '$f'," $file
done
for f in `cd $CHROMIUMSRC/Source/core/; ls rendering/mathml/*.cpp rendering/mathml/*.h`; do
        $SED -i "/$COREREF2/ i\            '$f'," $file
done

echo 'Copying MathML tests...'

# Copy the MathML tests
rm -rf $CHROMIUMSRC/LayoutTests/mathml/
cp -r $WEBKITSRC/LayoutTests/mathml/ $CHROMIUMSRC/LayoutTests/

# Remove some MathML pixel tests (will be converted to reftests in the future)
rm -f $CHROMIUMSRC/LayoutTests/mathml/presentation/mo-stretch.html
rm -f $CHROMIUMSRC/LayoutTests/mathml/presentation/roots.xhtml
