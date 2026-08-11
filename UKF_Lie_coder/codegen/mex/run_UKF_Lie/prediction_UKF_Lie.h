/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * prediction_UKF_Lie.h
 *
 * Code generation for function 'prediction_UKF_Lie'
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
void prediction_UKF_Lie(const emlrtStack *sp, const real_T g0[169],
                        const real_T Pt0[225], const real_T Pqq[225],
                        const real_T Prr[9], const real_T u[6], real_T alpha,
                        real_T beta, real_T kappa, real_T L, real_T dt,
                        real_T g[169], emxArray_real_T *G_t, emxArray_real_T *R,
                        real_T Pt[225]);

/* End of code generation (prediction_UKF_Lie.h) */
