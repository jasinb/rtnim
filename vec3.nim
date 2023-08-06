import std/math
type
    Vec3* = object
        x*: float
        y*: float
        z*: float


proc `+` *(a, b: Vec3): Vec3 =
    Vec3(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)

proc `-` *(a, b: Vec3): Vec3 =
    Vec3(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)

proc `*` *(v: Vec3, t: float): Vec3 =
    Vec3(x: v.x * t, y: v.y * t, z: v.z * t)

proc `*` *(t: float, v: Vec3): Vec3 =
    v * t

proc `/` *(v: Vec3, t: float): Vec3 =
    v * (1 / t);

proc dot*(a: Vec3, b: Vec3): float =
    a.x*b.x + a.y*b.y + a.z*b.z

proc lengthSquared* (v: Vec3): float =
    v.dot v

proc length* (v: Vec3): float =
    sqrt(v.lengthSquared)

proc unit* (v: Vec3): Vec3 =
    v / v.length;

proc writeColor*(v: Vec3) =
    echo int(v.x * 255.999), ' ', int(v.y * 255.999), ' ', int(v.z * 255.999), '\n'
