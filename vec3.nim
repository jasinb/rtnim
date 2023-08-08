import std/math
type
    Vec3* = object
        x*: float
        y*: float
        z*: float


proc `+` *(a, b: Vec3): Vec3 =
    Vec3(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)


proc `-` *(v: Vec3): Vec3 =
    Vec3(x: -v.x, y: -v.y, z: -v.z)

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

proc writeColor*(color: Vec3, samplesPerPixel: int) =
    let scale = 1 / samplesPerPixel
    let r = color.x * scale
    let g = color.y * scale
    let b = color.z * scale
    
    echo int(256 * clamp(r, 0.0, 0.999)), ' ', int(256 * clamp(g, 0.0, 0.999)), ' ', int(256 * clamp(b, 0.0, 0.999)), '\n'