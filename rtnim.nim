import vec3
import ray
import sphere
import hittable
import camera
import std/random
import std/times
import lambertian

let mat = newLambertian(albedo = Vec3(x: 0.6, y: 0.5, z: 0.4))
let mat2 = newLambertian(albedo = Vec3(x: 0.4, y: 0.5, z: 0.6))


let smallSphere = Sphere(center: Vec3(x: 0.0, y: 0.0, z: -1.0), radius: 0.5, material: mat2)
let largeSphere = Sphere(center: Vec3(x: 0.0, y: -100.5, z: -1.0), radius: 100, material: mat)

var hitList: HittableList = HittableList(objects: @[])
hitList.add(smallSphere)
hitList.add(largeSphere)

var rayCount = 0

proc rayColor(r: Ray, world: Hittable, depth: int): Vec3 =
    rayCount = rayCount + 1
    if depth <= 0:
        return zeroVec3()

    var rec: HitRecord
    if world.hit(r, 0.001, Inf, rec):
        var scattered: Ray
        var attenuation: Vec3
        if rec.material.scatter(r, rec, attenuation, scattered):
            return attenuation * rayColor(scattered, hitList, depth-1)
    
        return zeroVec3()

    # no hit, background gradient
    let u = r.dir.unit
    let t = 0.5 * (u.y + 1.0)
    result = (1.0 - t) * Vec3(x: 1.0, y: 1.0, z: 1.0) + t * Vec3(x: 0.5, y: 0.7, z: 1.0)    

const imageWidth = 400
const aspectRatio = 16 / 9
const imageHeight = int(imageWidth / aspectRatio)
const samplesPerPixel = 100
const maxBounces = 50

let cam = initCamera()

echo "P3\n", imageWidth, ' ', imageHeight, "\n255"

let startTime = cpuTime()

for j in countdown(imageHeight - 1, 0):
    if j mod 20 == 0:
        stderr.writeLine("Progress: ", 100.0 * (1.0 - j / imageHeight), '\r')
    for i in 0 ..< imageWidth:
        var color = Vec3(x: 0.0, y: 0.0, z: 0.0)
        for s in 0 ..< samplesPerPixel:
            let u = (float(i) + rand(1.0)) / (imageWidth - 1)
            let v = (float(j) + rand(1.0)) / (imageHeight - 1)

            let r = cam.getRay(u, v)
            color = color + r.rayColor(hitList, maxBounces)
        
        color.writeColor(samplesPerPixel)

let elapsedTime = cpuTime() - startTime
stderr.writeline("Traced ", rayCount, " rays in ", elapsedTime, " seconds")
stderr.writeLine("Time per ray: ", 1000_000.0 * elapsedTime / float(rayCount), " us")