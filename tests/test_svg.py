from svg import NSVGImage

def test_main():
    img = NSVGImage()
    img.parse_file('CC0_button.svg', '96px')
    assert img.width
    assert img.height
    im = img.rasterize(640, 480, 1.0, 0, 0)
    assert im is not None
    assert isinstance(im, bytes)