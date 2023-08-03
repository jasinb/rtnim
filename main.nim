const image_width = 512
const image_height = 256

echo "P3\n", image_width, ' ', image_height, "\n255"

for j in countdown(image_height - 1, 0):
    stderr.writeLine("Progress: ", 100.0 * (1.0 - j / image_height), '\r')
    for i in 0 ..< image_width:
        let r = i / (image_width - 1)
        let g = j / (image_height - 1)
        let b = 0.25

        let ir = int(r * 255.999)
        let ig = int(g * 255.999)
        let ib = int(b * 255.999)

        echo ir, ' ', ig, ' ', ib, '\n'