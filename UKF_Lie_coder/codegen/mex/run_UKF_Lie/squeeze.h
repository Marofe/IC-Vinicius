/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * squeeze.h
 *
 * Code generation for function 'squeeze'
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
void b_squeeze(const emlrtStack *sp, const emxArray_real_T *a);

void squeeze(const emlrtStack *sp, const emxArray_real_T *a,
             emxArray_real_T *b);

/* End of code generation (squeeze.h) */
