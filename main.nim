import vec3
import ray

proc hitSphere(center: Vec3, radius: float, r: Ray): bool =
    let oc = r.origin - center
    let a = dot(r.dir, r.dir)
    let b = 2.0 * dot(oc, r.dir)
    let c = dot(oc, oc) - radius*radius
    let discriminant = b*b - 4.0*a*c
    result = discriminant > 0

proc rayColor(r: Ray): Vec3 =
    if (hitSphere(Vec3(x: 0.0, y: 0.0, z: -1.0), 0.5, r)):
        return Vec3(x: 1.0, y: 0.0, z: 0.0)
    let u = r.dir.unit
    let t = 0.5 * u.y + 1.0
    result = (1.0 - t) * Vec3(x: 1.0, y: 1.0, z: 1.0) + t * Vec3(x: 0.5, y: 0.7, z: 1.0)
    

const image_width = 400

const aspect_ratio = 16 / 9
const image_height = int(image_width / aspect_ratio)

const viewport_height = 2.0
const viewport_width = viewport_height * aspect_ratio
const focal_length = 1.0

const origin = Vec3(x: 0.0, y: 0.0, z: 0.0)
const horizontal = Vec3(x: viewport_width, y: 0.0, z: 0.0)
const vertical = Vec3(x: 0.0, y: viewport_height, z: 0.0)
const lower_left_corner = origin - horizontal/2 - vertical/2 - Vec3(x: 0.0, y: 0.0, z: focal_length)

echo "P3\n", image_width, ' ', image_height, "\n255"

for j in countdown(image_height - 1, 0):
    if j mod 10 == 0:
        stderr.writeLine("Progress: ", 100.0 * (1.0 - j / image_height), '\r')
    for i in 0 ..< image_width:
        let u = i / (image_width - 1)
        let v = j / (image_height - 1)

        let r = Ray(origin: origin, dir: lower_left_corner + u*horizontal + v*vertical - origin)
        let c = r.rayColor
        c.writeColor