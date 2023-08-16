import vec3
import ray
import sphere
import hittable
import camera
import std/random
import std/times
import lambertian
import metal
import dielectric

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
            return attenuation * rayColor(scattered, world, depth-1)
    
        return zeroVec3()

    # no hit, background gradient
    let u = r.dir.unit
    let t = 0.5 * (u.y + 1.0)
    result = (1.0 - t) * Vec3(x: 1.0, y: 1.0, z: 1.0) + t * Vec3(x: 0.5, y: 0.7, z: 1.0)    

var world: HittableList = HittableList(objects: @[])

let groundMat = newLambertian(initVec3(0.5, 0.5, 0.5))
world.add(Sphere(center: initVec3(0, -1000, 0), radius: 1000.0, material: groundMat))

for a in -11 ..< 11:
    for b in -11 ..< 11:
        let chooseMat = rand(1.0)
        let center = initVec3(float(a) + 0.9*rand(1.0), 0.2, float(b) + 0.9*rand(1.0))

        if ((center - initVec3(4.0, 0.2, 0.0)).length > 0.9):
            if chooseMat < 0.8:
                # diffuse
                let albedo = randVec3(0.0, 1.0) * randVec3(0.0, 1.0)
                let mat = newLambertian(albedo)
                world.add(Sphere(center: center, radius: 0.2, material: mat))
            elif chooseMat < 0.95:
                # metal
                let albedo = randVec3(0.5, 1.0)
                let fuzz = rand(0.5)
                let mat = newMetal(albedo, fuzz)
                world.add(Sphere(center: center, radius: 0.2, material: mat))
            else:
                # glass
                let mat = newDielectric(1.5)
                world.add(Sphere(center: center, radius: 0.2, material: mat))

let mat1 = newDielectric(1.5)
world.add(Sphere(center: Vec3(x:  0.0, y: 1.0, z: 0.0), radius:  1.0, material: mat1))
let mat2 = newLambertian(initVec3(0.4, 0.2, 0.1))
world.add(Sphere(center: Vec3(x: -4.0, y: 1.0, z: 0.0), radius:  1.0, material: mat2))
let mat3 = newMetal(initVec3(0.7, 0.6, 0.5), 0.0)
world.add(Sphere(center: Vec3(x:  4.0, y: 1.0, z: 0.0), radius:  1.0, material: mat3))

let camOrigin = initVec3(13.0, 2.0, 3.0)
let camLookAt = initVec3(0.0, 0.0, 0.0)
let camUp = initVec3(0.0, 1.0, 0.0)
let camFov = 20.0
const aspectRatio = 16 / 9
let defocusAngle = 0.6
let distToFocus = 10.0

let cam = initCamera(camOrigin, camLookAt, camUp, camFov, aspectRatio, defocusAngle, distToFocus)

const imageWidth = 1200
const imageHeight = int(imageWidth / aspectRatio)
const samplesPerPixel = 200
const maxBounces = 50


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
            color = color + r.rayColor(world, maxBounces)
        
        color.writeColor(samplesPerPixel)

let elapsedTime = cpuTime() - startTime
stderr.writeline("Traced ", rayCount, " rays in ", elapsedTime, " seconds")
stderr.writeLine("Time per ray: ", 1000_000.0 * elapsedTime / float(rayCount), " us")