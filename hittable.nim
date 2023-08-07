import ray
import vec3

type
    Hittable* = ref object of RootObj

    HitRecord* = object
        p*, normal*: Vec3
        t*: float
        front_face: bool

method hit*(h: Hittable, r: Ray, t_min, t_max: float, rec: var HitRecord): bool {. base .} =
    quit "Should be overridden!"

proc setFaceNormal*(rec: var HitRecord, ray: Ray, outward_normal: Vec3) =
    rec.front_face = ray.dir.dot(outward_normal) < 0.0
    rec.normal = if rec.front_face: outward_normal else: -outward_normal
