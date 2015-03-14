// Define quaternions and the operations that we can perform on them

#include <stdio.h>
#include <math.h>
#include "caklquaternion.h"

// Method to conjugate a quaternion
caklQuat caklQuatConjugate(caklQuat *q){
    caklQuat qConj;
    qConj.w = q->w;
    qConj.x = -q->x;
    qConj.y = -q->y;
    qConj.z = -q->z;
    return qConj;
}

// Method to multiply two quaternions
caklQuat caklQuatMultiply(caklQuat *qL, caklQuat *qR){
    caklQuat qProd;
    qProd.w = qL->w*qR->w - qL->x*qR->x - qL->y*qR->y - qL->z*qR->z;
    qProd.x = qL->w*qR->x + qL->x*qR->w + qL->y*qR->z - qL->z*qR->y;
    qProd.y = qL->w*qR->y + qL->y*qR->w + qL->z*qR->x - qL->x*qR->z;
    qProd.z = qL->w*qR->z + qL->z*qR->w + qL->x*qR->y - qL->y*qR->x;
    return qProd;
}

// Method to create a quaternion from an axis and angle
caklQuat caklQuatFromAxis(float ax, float ay, float az, float angle){
    float sina = sin(angle/2);
    caklQuat q = {.w=cos(angle/2), .x=ax*sina, .y=ay*sina, .z=az*sina};
    return q;
}

// Method to convert a quaternion to a string
char *caklQuatString(caklQuat *q, char *buf){
    sprintf(buf, "(%6.4f, %6.4f, %6.4f, %6.4f)", q->w, q->x, q->y, q->z);
    return buf;
}
