#ifndef CAKL_QUATERNION_H
#define CAKL_QUATERNION_H

// Define what a quaternion is
typedef struct {
    float w;
    float x;
    float y;
    float z;
} caklQuat;

// Method to find the complex conjugate
caklQuat caklQuatConjugate(caklQuat *q);

// Method to multiply two quaternions
caklQuat caklQuatMultiply(caklQuat *qL, caklQuat *qR);

// Method to multiply two quaternions
caklQuat caklQuatFromAxis(float ax, float ay, float az, float angle);

// Method to convert the quaternion to a string
char *caklQuatString(caklQuat *q, char *buf);

#endif
