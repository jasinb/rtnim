import vec3
import hittable
import ray
import std/math
import std/random

type
    Dielectric = ref object of Material
        ir: float

proc reflectance(cosine, refIdx: float): float =
    # Shlick's approximation
    let r0 = (1.0-refIdx) / (1+refIdx)
    let r1 = r0*r0
    r1 + (1-r1)*pow(1-cosine,5.0)

method scatter*(mat: Dielectric, rayIn: Ray, rec: HitRecord, attenuation: var Vec3, scattered: var Ray): bool =
    attenuation = initVec3(1.0, 1.0, 1.0)
    let refractionRatio = if rec.frontFace: (1.0 / mat.ir) else: mat.ir
    let unitDir = rayIn.dir.unit
    let cosTheta = min(dot(-unitDir, rec.normal), 1.0)
    let sinTheta = sqrt(1.0 - cosTheta*cosTheta)

    let cannotRefract = refractionRatio * sinTheta > 1.0
    let dir = if cannotRefract or reflectance(cosTheta, refractionRatio) > rand(1.0): reflect(unitDir, rec.normal) else: refract(unitDir, rec.normal, refractionRatio)

    scattered = Ray(origin: rec.p, dir: dir)
    result = true


proc newDielectric*(ir: float): Dielectric = Dielectric(ir: ir)