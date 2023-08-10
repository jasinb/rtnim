import std/math
import std/random
type
    Vec3* = object
        x*: float
        y*: float
        z*: float


proc initVec3*(x = 0.0, y = 0.0, z = 0.0): Vec3 =
    Vec3(x: x, y: y, z: z)

proc zeroVec3*(): Vec3 =
    initVec3()

proc `+` *(a, b: Vec3): Vec3 =
    Vec3(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)

proc `-` *(v: Vec3): Vec3 =
    Vec3(x: -v.x, y: -v.y, z: -v.z)

proc `-` *(a, b: Vec3): Vec3 =
    Vec3(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)

proc `*` *(v: Vec3, t: float): Vec3 =
    Vec3(x: v.x * t, y: v.y * t, z: v.z * t)

# component wise multiplication
proc `*` *(a: Vec3, b: Vec3): Vec3 =
    Vec3(x: a.x * b.x, y: a.y * b.y, z: a.z * b.z)

proc `*` *(t: float, v: Vec3): Vec3 =
    v * t

proc `/` *(v: Vec3, t: float): Vec3 =
    v * (1 / t);

proc dot*(a: Vec3, b: Vec3): float =
    a.x*b.x + a.y*b.y + a.z*b.z

proc cross*(u, v: Vec3): Vec3 =
    initVec3(
        u.y*v.z - u.z*v.y,
        u.z*v.x - u.x*v.z,
        u.x*v.y - u.y*v.x)

proc lengthSquared* (v: Vec3): float =
    v.dot v

proc length* (v: Vec3): float =
    sqrt(v.lengthSquared)

proc unit* (v: Vec3): Vec3 =
    v / v.length;

proc writeColor*(color: Vec3, samplesPerPixel: int) =
    let scale = 1 / samplesPerPixel
    # gamma = 2.0
    let r = sqrt(color.x * scale)
    let g = sqrt(color.y * scale)
    let b = sqrt(color.z * scale)

    echo int(256 * clamp(r, 0.0, 0.999)), ' ', int(256 * clamp(g, 0.0, 0.999)), ' ', int(256 * clamp(b, 0.0, 0.999)), '\n'

proc randVec3*(mn = -1.0, mx = 1.0): Vec3 =
    let k = mx - mn
    result = initVec3(mn + k*rand(1.0), mn + k*rand(1.0), mn + k*rand(1.0))

proc randVec3UnitSphere*(): Vec3 =
    while true:
        let v = randVec3()
        if v.lengthSquared < 1.0:
            return v

proc randVec3UnitDisc*(): Vec3 =
    while true:
        var v = randVec3()
        v.z = 0.0
        if v.lengthSquared < 1.0:
            return v

proc randUnitVec3*(): Vec3 =
    randVec3UnitSphere().unit

proc randHemisphere*(normal: Vec3): Vec3 =
    result = randVec3UnitSphere()
    if result.dot(normal) < 0.0:
        return -result

proc nearZero*(v: Vec3): bool =
    const epsilon = 1e-8
    abs(v.x) < epsilon and abs(v.y) < epsilon and abs(v.z) < epsilon

proc reflect*(v, n: Vec3): Vec3 =
    v - 2.0*dot(v, n)*n

proc refract*(v, n: Vec3, etaiOverEtat: float): Vec3 =
    let cosTheta = min(dot(-v, n), 1.0)
    let rOutPerpendicular = etaiOverEtat * (v + cosTheta*n)
    let rOutParallel = -sqrt(abs(1.0 - rOutPerpendicular.lengthSquared)) * n
    result = rOutPerpendicular + rOutParallel