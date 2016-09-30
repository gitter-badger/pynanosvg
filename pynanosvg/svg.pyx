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

    def __init__(self):
        pass

    cpdef void parse(self, file_path=None, svg_str=None, units=b'px', dpi=96):
        if file_path:
            self.image = svg.nsvgParseFromFile(<bytes> file_path, <bytes> units, dpi)
            if not self.image:
                raise SvgInitializationError(b'Failed to parse the SVG at {}'.format(file_path))
        else:
            self.image = svg.nsvgParse(<bytes> svg_str, <bytes> units, dpi)
            if not self.image:
                raise SvgInitializationError(b'Failed to create SVG based on the provided text')

    cpdef bytes rasterize(self,int tx, int ty, float scale, int w, int h):
        # for our RGBA image, we allocate 4 bytes per pixel
        cdef unsigned char* out_image = <unsigned char*> malloc(w*h*4)
        # stride is 4 for RGBA
        svg.nsvgRasterize(self.rast, self.image, tx, ty, scale, out_image, w, h, w*4)
        # convert C string to python string to be GC'd so we can free out_image
        ret = <bytes> out_image
        free(out_image)
        return ret




