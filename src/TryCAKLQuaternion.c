#include <stdio.h>
#include <math.h>
#include "caklquaternion.h"

int main(void){
    caklQuat q = caklQuatFromAxis(1/sqrt(3),1/sqrt(3),1/sqrt(3),M_PI);
    caklQuat q_c;
    q_c = caklQuatConjugate(&q);
    char buf[30];
    printf("The original quaternion is %s\n",caklQuatString(&q, buf));
    printf("The conjugated quaternion is %s\n",caklQuatString(&q_c, buf));
    caklQuat mult = caklQuatMultiply(&q, &q_c);
    printf("The product is %s\n",caklQuatString(&mult, buf));
}
