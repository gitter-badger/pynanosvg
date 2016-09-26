from setuptools import setup, Extension
from Cython.Build import cythonize

ext = [Extension('svg', sources=['svg.pyx'], include_dirs=['nanosvg/src/'])]

setup(
    name="cysvg",
    ext_modules=cythonize(ext),
    install_requires=['Cython']
)
