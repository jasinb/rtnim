import vec3
import ray
import std/math

proc hitSphere(center: Vec3, radius: float, r: Ray): float =
    let oc = r.origin - center
    let a = r.dir.lengthSquared
    let half_b = dot(oc, r.dir)
    let c = oc.lengthSquared - radius*radius
    let discriminant = half_b*half_b - a*c
    if discriminant < 0:
        return -1.0

    result = (-half_b - sqrt(discriminant)) / a

proc rayColor(r: Ray): Vec3 =
    let sphereOrigin = Vec3(x: 0.0, y: 0.0, z: -1.0) 
    var t = hitSphere(sphereOrigin, 0.5, r)
    if t > 0.0:
        let normal = (r.at(t) - sphereOrigin).unit # simply a vector from sphere center to the surface
        return 0.5 * (normal + Vec3(x: 1.0, y: 1.0, z: 1.0))

    let u = r.dir.unit
    t = 0.5 * (u.y + 1.0)
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