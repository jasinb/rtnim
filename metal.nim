import vec3
import hittable
import ray

type
    Metal = ref object of Material
        albedo: Vec3
        fuzz: float

method scatter*(mat: Metal, rayIn: Ray, rec: HitRecord, attenuation: var Vec3, scattered: var Ray): bool =
    var reflected = reflect(rayIn.dir.unit, rec.normal)
    scattered = Ray(origin: rec.p, dir: reflected + mat.fuzz * randVec3UnitSphere())
    attenuation = mat.albedo
    result = scattered.dir.dot(rec.normal) > 0.0

proc newMetal*(albedo: Vec3, fuzz: float): Metal = Metal(albedo: albedo, fuzz: clamp(fuzz, 0.0, 1.0))