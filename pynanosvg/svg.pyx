from libc.stdlib cimport malloc, free
from cpython.mem cimport PyMem_Malloc, PyMem_Free
cimport svg

import warnings

class SvgInitializationError(RuntimeError):
    """Error raised when the initialization of the SVG fails"""
    pass


cdef class Svg:
    cdef svg.NSVGimage* image
    cdef svg.NSVGrasterizer* rast
    cdef unsigned char* out_image
    def __cinit__(self):
        self.image = NULL
        self.rast = NULL

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
                raise SvgInitializationError(b'Failed to parse the SVG at %s' % file_path)
        else:
            self.image = svg.nsvgParse(<bytes> svg_str, <bytes> units, dpi)
            if not self.image:
                raise SvgInitializationError(b'Failed to create SVG based on the provided text')

    cpdef bytes rasterize(self,int tx, int ty, float scale, int w, int h):
        # for our RGBA image, we allocate 4 bytes per pixel
        self.out_image = <unsigned char*> PyMem_Malloc(w*h*4)
        if not self.out_image:
            raise MemoryError()
        try:
            self.rast = nsvgCreateRasterizer()
            # stride is 4 for RGBA
            svg.nsvgRasterize(self.rast, self.image, tx, ty, scale, self.out_image, w, h, w*4)
            # convert C string to python string to be GC'd so we can free out_image
            return self.out_image
        finally:
            PyMem_Free(self.out_image)



