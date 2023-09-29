#!mainFile "../main.opy"

#!define isAimingAtSphere(start_position, direction, sphere_center, sphere_radius)\
    (distance(start_position, sphere_center) * sinDeg(angleBetweenVectors(direction, directionTowards(start_position, sphere_center))) <= sphere_radius)
    
#!define findSphereHit(start_position, direction, sphere_center, sphere_radius)\
    eventPlayer.lsi_o = start_position\
    eventPlayer.lsi_u = direction\
    eventPlayer.lsi_c = sphere_center\
    eventPlayer.lsi_r = sphere_radius\
    findLineSphereIntersection()

# lsi stands for line-sphere intersection
# see https://en.wikipedia.org/wiki/Line%E2%80%93sphere_intersection for derivation
playervar lsi_o # start position (line origin)
playervar lsi_c # sphere center
playervar lsi_r # sphere radius
playervar lsi_u # unit vector from start to end
playervar lsi_d # distance at which line intersects the sphere
playervar lsi_nabla # upside down triangle symbol in the wiki
playervar lsi_i # indexing variable for this file
playervar lsi_x # points of intersection

subroutine findLineSphereIntersection

def findLineSphereIntersection():
    @Name "[hit_detection.opy]: findLineSphereIntersection()"

    eventPlayer.lsi_nabla = (abs(dotProduct(eventPlayer.lsi_u, (eventPlayer.lsi_o - eventPlayer.lsi_c)))**2) - (distance(eventPlayer.lsi_o, eventPlayer.lsi_c)**2 - eventPlayer.lsi_r**2)

    if eventPlayer.lsi_nabla > 0: # line goes through sphere
        eventPlayer.lsi_d = [-(dotProduct(eventPlayer.lsi_u, (eventPlayer.lsi_o - eventPlayer.lsi_c))) - sqrt(eventPlayer.lsi_nabla), \
                             -(dotProduct(eventPlayer.lsi_u, (eventPlayer.lsi_o - eventPlayer.lsi_c))) + sqrt(eventPlayer.lsi_nabla), ]
    elif eventPlayer.lsi_nabla == 0: # line tangent to sphere
        eventPlayer.lsi_d = [-(dotProduct(eventPlayer.lsi_u, (eventPlayer.lsi_o - eventPlayer.lsi_c)))]
    elif eventPlayer.lsi_nabla < 0: # no intersection/solution
        eventPlayer.lsi_d = []
    else:
        eventPlayer.lsi_d = []

    eventPlayer.lsi_x = []
    for eventPlayer.lsi_i in range(len(eventPlayer.lsi_d)):
        if eventPlayer.lsi_d[eventPlayer.lsi_i] >= 0:
            eventPlayer.lsi_x.append(eventPlayer.lsi_o + eventPlayer.lsi_d[eventPlayer.lsi_i] * eventPlayer.lsi_u)
