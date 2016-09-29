from setuptools import setup, Extension
from Cython.Build import cythonize
ext = [Extension('svg', sources=['src/svg.pyx'], include_dirs=['nanosvg/src/'], libraries=['svg'], extra_objects=['svg.obj'])]

setup(
    name="pynanosvg",
    version="0.0.1",
    description="Wrapper around nanosvg",
    author="Ethan Smith",
    license="MIT",
    ext_modules=cythonize(ext),
    install_requires=['Cython']
)

