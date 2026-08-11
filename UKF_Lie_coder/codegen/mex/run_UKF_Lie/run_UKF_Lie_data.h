/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * run_UKF_Lie_data.h
 *
 * Code generation for function 'run_UKF_Lie_data'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include "omp.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern const volatile char_T *emlrtBreakCheckR2012bFlagVar;
extern emlrtContext emlrtContextGlobal;
extern emlrtRSInfo hb_emlrtRSI;
extern emlrtRSInfo tb_emlrtRSI;
extern emlrtRSInfo ub_emlrtRSI;
extern emlrtRSInfo bd_emlrtRSI;
extern emlrtRSInfo xd_emlrtRSI;
extern emlrtRSInfo ge_emlrtRSI;
extern emlrtRSInfo ve_emlrtRSI;
extern emlrtRSInfo we_emlrtRSI;
extern emlrtRSInfo nf_emlrtRSI;
extern omp_lock_t emlrtLockGlobal;
extern omp_nest_lock_t run_UKF_Lie_nestLockGlobal;
extern emlrtRTEInfo emlrtRTEI;
extern emlrtRTEInfo b_emlrtRTEI;
extern emlrtRTEInfo c_emlrtRTEI;
extern emlrtRTEInfo i_emlrtRTEI;
extern emlrtRTEInfo o_emlrtRTEI;
extern emlrtRTEInfo p_emlrtRTEI;
extern emlrtRTEInfo y_emlrtRTEI;
extern emlrtRTEInfo ob_emlrtRTEI;
extern emlrtRTEInfo pb_emlrtRTEI;
extern const int8_T iv[9];
extern const char_T cv[19];

/* End of code generation (run_UKF_Lie_data.h) */
