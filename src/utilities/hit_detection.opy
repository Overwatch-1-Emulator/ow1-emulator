#!mainFile "../main.opy"

# lsi stands for line-sphere intersection
# see https://en.wikipedia.org/wiki/Line%E2%80%93sphere_intersection for derivation
playervar hit_detection_pvar
#!defineMember _lsi_o hit_detection_pvar[0]
#!defineMember _lsi_c hit_detection_pvar[1]
#!defineMember _lsi_r hit_detection_pvar[2]
#!defineMember _lsi_u hit_detection_pvar[3]
#!defineMember _lsi_d hit_detection_pvar[4]
#!defineMember _lsi_nabla hit_detection_pvar[5]
#!defineMember _lsi_x hit_detection_pvar[6]
playervar lsi_i
# playervar _lsi_o # start position (line origin)
# playervar _lsi_c # sphere center
# playervar _lsi_r # sphere radius
# playervar _lsi_u # unit vector from start to end
# playervar _lsi_d # distance at which line intersects the sphere
# playervar _lsi_nabla # upside down triangle symbol in the wiki
# playervar _lsi_x # points of intersection
# playervar lsi_i # indexing variable for this file

#!define isAimingAtSphere(start_position, direction, sphere_center, sphere_radius)\
    (distance(start_position, sphere_center) * sinDeg(angleBetweenVectors(direction, directionTowards(start_position, sphere_center))) <= sphere_radius)
    
#!define findSphereHit(start_position, direction, sphere_center, sphere_radius)\
    eventPlayer._lsi_o = start_position\
    eventPlayer._lsi_u = direction\
    eventPlayer._lsi_c = sphere_center\
    eventPlayer._lsi_r = sphere_radius\
    findLineSphereIntersection()

subroutine findLineSphereIntersection

def findLineSphereIntersection():
    @Name "[utilities/hit_detection.opy]: findLineSphereIntersection()"

    eventPlayer._lsi_nabla = (abs(dotProduct(eventPlayer._lsi_u, (eventPlayer._lsi_o - eventPlayer._lsi_c)))**2) - (distance(eventPlayer._lsi_o, eventPlayer._lsi_c)**2 - eventPlayer._lsi_r**2)

    if eventPlayer._lsi_nabla > 0: # line goes through sphere
        eventPlayer._lsi_d = [-(dotProduct(eventPlayer._lsi_u, (eventPlayer._lsi_o - eventPlayer._lsi_c))) - sqrt(eventPlayer._lsi_nabla), \
                             -(dotProduct(eventPlayer._lsi_u, (eventPlayer._lsi_o - eventPlayer._lsi_c))) + sqrt(eventPlayer._lsi_nabla), ]
    elif eventPlayer._lsi_nabla == 0: # line tangent to sphere
        eventPlayer._lsi_d = [-(dotProduct(eventPlayer._lsi_u, (eventPlayer._lsi_o - eventPlayer._lsi_c)))]
    elif eventPlayer._lsi_nabla < 0: # no intersection/solution
        eventPlayer._lsi_d = []
    else:
        eventPlayer._lsi_d = []

    eventPlayer._lsi_x = []
    for eventPlayer.lsi_i in range(len(eventPlayer._lsi_d)):
        if eventPlayer._lsi_d[eventPlayer.lsi_i] >= 0:
            eventPlayer._lsi_x.append(eventPlayer._lsi_o + eventPlayer._lsi_d[eventPlayer.lsi_i] * eventPlayer._lsi_u)
