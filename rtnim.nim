import vec3
import ray
import sphere
import hittable
import camera
import std/random


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
const samplesPerPixel = 100

let cam = initCamera()

echo "P3\n", imageWidth, ' ', imageHeight, "\n255"

for j in countdown(imageHeight - 1, 0):
    if j mod 10 == 0:
        stderr.writeLine("Progress: ", 100.0 * (1.0 - j / imageHeight), '\r')
    for i in 0 ..< imageWidth:
        var color = Vec3(x: 0.0, y: 0.0, z: 0.0)
        for s in 0 ..< samplesPerPixel:
            let u = (float(i) + rand(1.0)) / (imageWidth - 1)
            let v = (float(j) + rand(1.0)) / (imageHeight - 1)

            let r = cam.getRay(u, v)
            color = color + r.rayColor(hitList)
        
        color.writeColor(samplesPerPixel)