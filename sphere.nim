import Hittable
import Ray
import vec3
import std/math

type
    Sphere* = ref object of Hittable
        center*: Vec3
        radius*: float

method hit*(sphere: Sphere, r: Ray, t_min, t_max: float, rec: var HitRecord): bool =
    let oc = r.origin - sphere.center
    let a = r.dir.lengthSquared
    let half_b = dot(oc, r.dir)
    let c = oc.lengthSquared - sphere.radius*sphere.radius
    let discriminant = half_b*half_b - a*c
    if discriminant < 0:
        return false
    
    let sqrtd = sqrt(discriminant)
    
    # find nearest root within the range
    var root = (-half_b - sqrtd) / a
    if (root < t_min or root > t_max):
        root = (-half_b + sqrtd) / a
        if (root < t_min or root > t_max):
            return false
    
    rec.t = root
    rec.p = r.at(rec.t)
    let outward_normal = (rec.p - sphere.center) / sphere.radius 
    rec.set_face_normal(r, outward_normal)
    result = true