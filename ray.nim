import vec3

type
    Ray* = object
        origin*: Vec3
        dir*: Vec3

proc at* (r: Ray, t: float): Vec3 =
    result = r.origin + r.dir * t
