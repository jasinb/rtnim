import vec3
import ray
import std/math

type
    Camera = object
        origin, lowerLeftCorner, horizontal, vertical: Vec3


proc initCamera*(origin, lookAt, up: Vec3, vFov, aspectRatio: float): Camera =
    let theta = degToRad(vFov)
    let h = tan(theta/2)
    let viewportHeight = 2.0 * h
    let viewportWidth = aspectRatio * viewportHeight
    
    let w = (origin - lookat).unit
    let u = cross(up, w).unit
    let v = cross(w, u)

    result.origin = origin
    result.horizontal = viewportWidth * u
    result.vertical = viewportHeight * v
    result.lowerLeftCorner = origin - result.horizontal/2.0 - result.vertical/2.0 - w

proc getRay*(c: Camera, s, t: float): Ray =
    Ray(origin: c.origin,
        dir: c.lowerLeftCorner + s*c.horizontal + t*c.vertical - c.origin)
