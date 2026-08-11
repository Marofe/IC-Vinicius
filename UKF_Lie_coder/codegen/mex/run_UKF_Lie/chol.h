/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chol.h
 *
 * Code generation for function 'chol'
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
void b_chol(const emlrtStack *sp, emxArray_real_T *A);

int32_T chol(const emlrtStack *sp, emxArray_real_T *A, int32_T *jmax);

/* End of code generation (chol.h) */
