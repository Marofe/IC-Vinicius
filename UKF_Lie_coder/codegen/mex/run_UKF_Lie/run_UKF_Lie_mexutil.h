/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * run_UKF_Lie_mexutil.h
 *
 * Code generation for function 'run_UKF_Lie_mexutil'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                          const emlrtMsgIdentifier *parentId);

real_T eb_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                           const emlrtMsgIdentifier *msgId);

real_T emlrt_marshallIn(const emlrtStack *sp,
                        const mxArray *a__output_of_feval_,
                        const char_T *identifier);

const mxArray *emlrt_marshallOut(const real_T u);

/* End of code generation (run_UKF_Lie_mexutil.h) */
