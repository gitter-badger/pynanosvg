from libc.stdlib cimport malloc, free
cimport svg

import warnings

class SvgInitializationError(RuntimeError):
    """Error raised when the initialization of the SVG fails"""
    pass


cdef class Svg:
    cdef svg.NSVGimage* image
    cdef svg.NSVGrasterizer* rast
    def __cinit__(self):
        self.image = NULL

    def __dealloc__(self):
        # remove the rasterizer and image to not leak memory
        svg.nsvgDelete(self.image)
        svg.nsvgDeleteRasterizer(self.rast)
        if not self.image and not self.rast:
            return
        warnings.warn("Memory leak via Svg")

    def __init__(self, file_path=None, svg_str=None, units='px', dpi=96):
        if file_path:
            self.image = svg.nsvgParseFromFile(file_path, units, dpi)
            if not self.image:
                raise SvgInitializationError('Failed to parse the SVG at {}'.format(file_path))
        else:
            self.image = svg.nsvgParse(svg_str, units, dpi)
            if not self.image:
                raise SvgInitializationError('Failed to create SVG based on the provided text')

    cdef bytes rasterize(self,int tx, int ty, float scale, unsigned char* dst, int w, int h):
        # for our RGBA image, we allocate 4 bytes per pixel
        cdef unsigned char* out_image = <unsigned char*> malloc(w*h*4)
        # stride is 4 for RGBA
        svg.nsvgRasterize(self.rast, self.image, tx, ty, scale, out_image, w, h, w*4)
        # convert C string to python string to be GC'd so we can free out_image
        ret = <bytes> out_image
        free(out_image)
        return ret




