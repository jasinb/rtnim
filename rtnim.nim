import vec3
import ray
import std/math
import sphere
import hittable


let smallSphere = Sphere(center: Vec3(x: 0.0, y: 0.0, z: -1.0), radius: 0.5)
let largeSphere = Sphere(center: Vec3(x: 0.0, y: -100.5, z: -1.0), radius: 100)

var hitList: HittableList = HittableList(objects: @[])

hitList.clear()
hitList.add(smallSphere)
hitList.add(largeSphere)

proc rayColor(r: Ray, world: Hittable): Vec3 =
    var hitRecord: HitRecord
    if world.hit(r, 0, Inf, hitRecord):
        return 0.5 * (hitRecord.normal + Vec3(x: 1.0, y: 1.0, z: 1.0))

    let u = r.dir.unit
    let t = 0.5 * (u.y + 1.0)
    result = (1.0 - t) * Vec3(x: 1.0, y: 1.0, z: 1.0) + t * Vec3(x: 0.5, y: 0.7, z: 1.0)    

const imageWidth = 400

const aspectRatio = 16 / 9
const imageHeight = int(imageWidth / aspectRatio)

const viewportHeight = 2.0
const viewportWidth = viewportHeight * aspectRatio
const focalLength = 1.0

const origin = Vec3(x: 0.0, y: 0.0, z: 0.0)
const horizontal = Vec3(x: viewportWidth, y: 0.0, z: 0.0)
const vertical = Vec3(x: 0.0, y: viewportHeight, z: 0.0)
const lowerLeftCorner = origin - horizontal/2 - vertical/2 - Vec3(x: 0.0, y: 0.0, z: focalLength)

echo "P3\n", imageWidth, ' ', imageHeight, "\n255"

for j in countdown(imageHeight - 1, 0):
    if j mod 10 == 0:
        stderr.writeLine("Progress: ", 100.0 * (1.0 - j / imageHeight), '\r')
    for i in 0 ..< imageWidth:
        let u = i / (imageWidth - 1)
        let v = j / (imageHeight - 1)

        let r = Ray(origin: origin, dir: lowerLeftCorner + u*horizontal + v*vertical - origin)
        let c = r.rayColor(hitList)
        c.writeColor