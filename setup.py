from distutils.core import setup, Extension
from Cython.Build import cythonize
ext = [Extension('svg', sources=['pynanosvg/svg.pyx'], include_dirs=['nanosvg/src/', 'pynanosvg/'])]

setup(
    name="pynanosvg",
    version="0.0.1",
    description="Wrapper around nanosvg",
    author="Ethan Smith",
    license="MIT",
    ext_modules=cythonize(ext),
)

