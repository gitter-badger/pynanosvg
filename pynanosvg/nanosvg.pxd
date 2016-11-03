# this is a work around to get the NANOSVG_IMPLEMENTATION to be defined
cdef extern from 'defines.h':
    cdef int NANOSVG_IMPLEMENTATION
    cdef int NANOSVGRAST_IMPLEMENTATION

cdef extern from 'nanosvg.h':

    cdef enum NSVGpaintType:
        NSVG_PAINT_NONE
        NSVG_PAINT_COLOR
        NSVG_PAINT_LINEAR_GRADIENT
        NSVG_PAINT_RADIAL_GRADIENT

    cdef enum NSVGspreadType:
        NSVG_SPREAD_PAD
        NSVG_SPREAD_REFLECT
        NSVG_SPREAD_REPEAT

    cdef enum NSVGlineJoin:
        NSVG_JOIN_MITER
        NSVG_JOIN_ROUND
        NSVG_JOIN_BEVEL

    cdef enum NSVGlineCap:
        NSVG_CAP_BUTT
        NSVG_CAP_ROUND
        NSVG_CAP_SQUARE

    cdef enum NSVGfillRule:
        NSVG_FILLRULE_NONZERO
        NSVG_FILLRULE_EVENODD

    cdef enum NSVGflags:
        NSVG_FLAGS_VISIBLE

    cdef struct NSVGgradientStop:
        unsigned int color
        float offset

    cdef struct NSVGgradient:
        float xform[6]
        char spread
        float fx
        float fy
        int nstops
        NSVGgradientStop stops[1]

    # a union in NSVGpaint
    cdef union __NSVGpaint_:
        unsigned int color
        NSVGgradient *gradient


    cdef struct NSVGpaint:
        char type

    cdef struct NSVGpath:
        float *pts
        int npts
        char closed
        float bounds[4]
        NSVGpath *next

    cdef struct NSVGshape:
        char id[64]
        NSVGpaint fill
        NSVGpaint stroke
        float opacity
        float strokeWidth
        float strokeDashOffset
        float strokeDashArray[8]
        char strokeDashCount
        char strokeLineJoin
        char strokeLineCap
        char fillRule
        unsigned char flags
        float bounds[4]
        NSVGpath *paths
        NSVGshape *next

    cdef struct NSVGimage:
        float width
        float height
        NSVGshape *shapes

    NSVGimage *nsvgParseFromFile(const char *filename, const char *units, float dpi)

    NSVGimage *nsvgParse(char *input, const char *units, float dpi)

    void nsvgDelete(NSVGimage *image)


cdef extern from 'nanosvgrast.h':
    cdef struct NSVGedge:
        pass
        
    cdef struct NSVGpoint:
        pass
        
    cdef struct NSVGactiveEdge:
        pass
    
    cdef struct NSVGmemPage:
        pass
        
    cdef struct NSVGrasterizer:
        float px, py
        float tessTol
        float distTol

        NSVGedge* edges
        int nedges
        int cedges

        NSVGpoint* points
        int npoints
        int cpoints

        NSVGpoint* points2
        int npoints2
        int cpoints2
    
        NSVGactiveEdge* freelist
        NSVGmemPage* pages
        NSVGmemPage* curpage
    
        unsigned char* scanline
        int cscanline
    
        unsigned char* bitmap
        int width, height, stride


    NSVGrasterizer* nsvgCreateRasterizer()

    void nsvgRasterize(NSVGrasterizer* r,
                   NSVGimage* image, float tx, float ty, float scale,
                   unsigned char* dst, int w, int h, int stride)

    void nsvgDeleteRasterizer(NSVGrasterizer*)