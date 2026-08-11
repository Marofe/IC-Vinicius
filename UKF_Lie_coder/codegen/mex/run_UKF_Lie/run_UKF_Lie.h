/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * run_UKF_Lie.h
 *
 * Code generation for function 'run_UKF_Lie'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "run_UKF_Lie_types.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
emlrtCTX emlrtGetRootTLSGlobal(void);

void emlrtLockerFunction(EmlrtLockeeFunction aLockee, emlrtConstCTX aTLS,
                         void *aData);

real_T run_UKF_Lie(run_UKF_LieStackData *SD, const emlrtStack *sp, real_T N,
                   const real_T b_time[229272], const real_T gps_time[1136],
                   real_T hx[38746968], real_T trP[229272], real_T P[51586200],
                   const real_T Pqq[225], const real_T Prr[9],
                   const real_T u[1375632], real_T alpha, real_T beta,
                   real_T kappa, real_T L, const real_T Cen[9],
                   const real_T y[3408], const real_T leverarm[3], real_T M,
                   real_T euler[687816], const struct0_T *ref);

/* End of code generation (run_UKF_Lie.h) */
