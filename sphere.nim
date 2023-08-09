import Hittable
import Ray
import vec3
import std/math

type
    Sphere* = ref object of Hittable
        center*: Vec3
        radius*: float
        material*: Material

method hit*(sphere: Sphere, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
    let oc = r.origin - sphere.center
    let a = r.dir.lengthSquared
    let halfB = dot(oc, r.dir)
    let c = oc.lengthSquared - sphere.radius*sphere.radius
    let discriminant = halfB*halfB - a*c
    if discriminant < 0:
        return false
    
    let sqrtD = sqrt(discriminant)
    
    # find nearest root within the range
    var root = (-halfB - sqrtD) / a
    if (root < tMin or root > tMax):
        root = (-halfB + sqrtD) / a
        if (root < tMin or root > tMax):
            return false
    
    rec.t = root
    rec.p = r.at(rec.t)
    let outwardNormal = (rec.p - sphere.center) / sphere.radius 
    rec.setFaceNormal(r, outwardNormal)
    rec.material = sphere.material
    result = true