import vec3
import hittable
import ray

type
    Lambertian = ref object of Material
        albedo*: Vec3

method scatter*(mat: Lambertian, rayIn: Ray, rec: HitRecord, attenuation: var Vec3, scattered: var Ray): bool =
    var scatterDir = rec.normal + randUnitVec3()
    if scatterDir.nearZero:
        scatterDir = rec.normal
    scattered = Ray(origin: rec.p, dir: scatterDir)
    attenuation = mat.albedo
    result = true

proc newLambertian*(albedo: Vec3): Lambertian = Lambertian(albedo: albedo)