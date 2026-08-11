/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SigmaPointsLie.h
 *
 * Code generation for function 'SigmaPointsLie'
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
void SigmaPointsLie(const emlrtStack *sp, const emxArray_real_T *Eta,
                    real_T alpha, real_T beta, real_T kappa,
                    const real_T P_t[225], const real_T Pqq[225],
                    const real_T Prr[9], real_T L, emxArray_real_T *Xi,
                    emxArray_real_T *Wm, emxArray_real_T *Wc);

/* End of code generation (SigmaPointsLie.h) */
