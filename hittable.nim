import ray
import vec3

type
    Hittable* = ref object of RootObj

    HitRecord* = object
        p*, normal*: Vec3
        t*: float
        frontFace: bool

method hit*(h: Hittable, r: Ray, tMin, tMax: float, rec: var HitRecord): bool {. base .} =
    quit "Should be overridden!"

proc setFaceNormal*(rec: var HitRecord, ray: Ray, outwardNormal: Vec3) =
    rec.frontFace = ray.dir.dot(outwardNormal) < 0.0
    rec.normal = if rec.frontFace: outwardNormal else: -outwardNormal
