import ray
import vec3

type
    HitRecord* = object
        p*, normal*: Vec3
        t*: float
        frontFace: bool

    Hittable* = ref object of RootObj
    HittableList* = ref object of Hittable
        objects*: seq[Hittable]

proc setFaceNormal*(rec: var HitRecord, ray: Ray, outwardNormal: Vec3) =
    rec.frontFace = ray.dir.dot(outwardNormal) < 0.0
    rec.normal = if rec.frontFace: outwardNormal else: -outwardNormal

method hit*(h: Hittable, r: Ray, tMin, tMax: float, rec: var HitRecord): bool {. base .} =
    quit "Should be overridden!"

proc add* (hittableList: HittableList, obj: Hittable) =
    hittableList.objects.add(obj)

proc clear*(hittableList: HittableList) =
    hittableList.objects = @[]

method hit*(hittableList: HittableList, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
    var tmp: HitRecord
    var hitAnything = false
    var closestSoFar = tMax

    for obj in hittableList.objects:
        if obj.hit(r, tMin, closestSoFar, tmp):
            hitAnything = true
            closestSoFar = tmp.t
            rec = tmp

    result = hitAnything

