import vec3
import ray

type
    Camera = object
        origin, lowerLeftCorner, horizontal, vertical: Vec3


proc initCamera*(): Camera =
    const aspectRatio = 16.0 / 9.0
    const viewportHeight = 2.0
    const viewportWidth = aspectRatio * viewportHeight
    const focalLength = 1.0

    result.origin = Vec3(x: 0.0, y: 0.0, z: 0.0)
    result.horizontal = Vec3(x: viewportWidth, y: 0.0, z: 0.0)
    result.vertical = Vec3(x: 0.0, y: viewportHeight, z: 0.0)
    result.lowerLeftCorner = result.origin - result.horizontal / 2.0 - result.vertical / 2.0 - Vec3(x: 0.0, y: 0.0, z: focalLength)

proc getRay*(camera: Camera, u, v: float): Ray =
    Ray(origin: camera.origin, dir: camera.lowerLeftCorner + u*camera.horizontal + v*camera.vertical)
