import vec3
import ray
import std/math

type
    Camera = object
        origin, lowerLeftCorner, horizontal, vertical, u, v, w: Vec3
        lensRadius: float


proc initCamera*(origin, lookAt, up: Vec3, vFov, aspectRatio, aperture, focusDist: float): Camera =
    let theta = degToRad(vFov)
    let h = tan(theta/2)
    let viewportHeight = 2.0 * h
    let viewportWidth = aspectRatio * viewportHeight
    
    result.w = (origin - lookat).unit
    result.u = cross(up, result.w).unit
    result.v = cross(result.w, result.u)

    result.origin = origin
    result.horizontal = focusDist * viewportWidth * result.u
    result.vertical = focusDist * viewportHeight * result.v
    result.lowerLeftCorner = origin - result.horizontal/2.0 - result.vertical/2.0 - focusDist*result.w
    result.lensRadius = aperture / 2

proc getRay*(c: Camera, s, t: float): Ray =
    let rd = c.lensRadius * randVec3UnitDisc()
    let offs = c.u*rd.x + c.v*rd.y
    Ray(origin: c.origin + offs,
        dir: c.lowerLeftCorner + s*c.horizontal + t*c.vertical - c.origin - offs)
