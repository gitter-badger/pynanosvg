# pynanosvg

A work in progress wrapping of [nanosvg](https://github.com/memononen/nanosvg) using Cython.
The implementation of NSVGImage class is thanks to @rezrov.

This program is licensed under the MIT license. (See LICENSE for the text)

##Usage

Usage is very simple:

```Python
from svg import NSVGImage

img = NSVGImage()
# parse the svg at 96 dpi, dpi is 'dots per inch', the units can be 'px', 'pt', 'pc' 'mm', 'cm', or 'in'
img.parse_file('/path/to/svg', '96px')
# rasterize the svg to an image that is 1.0 scaled and of size 640x480
img_bytes = img.rasterize(640, 480)
# from here, you can load the bytes into, eg a PIL Image, or perhaps Pygame's image?
```

## Tests

Tests are located in the `tests` directory. To run them from the `tests` directory, just run `pytest`. (You may need to install pynanosvg first)
