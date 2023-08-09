import vec3
import hittable
import ray

type
    Metal = ref object of Material
        albedo*: Vec3

method scatter*(mat: Metal, rayIn: Ray, rec: HitRecord, attenuation: var Vec3, scattered: var Ray): bool =
    var reflected = reflect(rayIn.dir.unit, rec.normal)
    scattered = Ray(origin: rec.p, dir: reflected)
    attenuation = mat.albedo
    result = scattered.dir.dot(rec.normal) > 0.0

proc newMetal*(albedo: Vec3): Metal = Metal(albedo: albedo)