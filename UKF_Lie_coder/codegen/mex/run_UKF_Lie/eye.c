/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eye.c
 *
 * Code generation for function 'eye'
 *
 */

/* Include files */
#include "eye.h"
#include "eml_int_forloop_overflow_error.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo uc_emlrtRSI =
    {
        50,    /* lineNo */
        "eye", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\elmat\\eye.m" /* pathName
                                                                          */
};

static emlrtRSInfo vc_emlrtRSI =
    {
        103,   /* lineNo */
        "eye", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\elmat\\eye.m" /* pathName
                                                                          */
};

static emlrtRSInfo wc_emlrtRSI = {
    21,                           /* lineNo */
    "checkAndSaturateExpandSize", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\checkAndSaturateExpandSize.m" /* pathName */
};

static emlrtRTEInfo r_emlrtRTEI = {
    64,                   /* lineNo */
    15,                   /* colNo */
    "assertValidSizeArg", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\assertValidSizeArg.m" /* pName */
};

static emlrtRTEInfo s_emlrtRTEI = {
    58,                   /* lineNo */
    23,                   /* colNo */
    "assertValidSizeArg", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\assertValidSizeArg.m" /* pName */
};

static emlrtRTEInfo yc_emlrtRTEI =
    {
        101,   /* lineNo */
        5,     /* colNo */
        "eye", /* fName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\elmat\\eye.m" /* pName
                                                                          */
};

/* Function Definitions */
void eye(const emlrtStack *sp, real_T varargin_1, emxArray_real_T *b_I)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T d;
  real_T *I_data;
  int32_T k;
  int32_T loop_ub;
  int32_T m;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  st.site = &uc_emlrtRSI;
  b_st.site = &wc_emlrtRSI;
  if (muDoubleScalarIsInf(varargin_1) || (varargin_1 > 2.147483647E+9)) {
    emlrtErrorWithMessageIdR2018a(
        &b_st, &s_emlrtRTEI, "Coder:MATLAB:NonIntegerInput",
        "Coder:MATLAB:NonIntegerInput", 4, 12, MIN_int32_T, 12, MAX_int32_T);
  }
  if (varargin_1 <= 0.0) {
    d = 0.0;
  } else {
    d = varargin_1;
  }
  if (!(d <= 2.147483647E+9)) {
    emlrtErrorWithMessageIdR2018a(&b_st, &r_emlrtRTEI, "Coder:MATLAB:pmaxsize",
                                  "Coder:MATLAB:pmaxsize", 0);
  }
  m = (int32_T)varargin_1;
  loop_ub = b_I->size[0] * b_I->size[1];
  b_I->size[0] = (int32_T)varargin_1;
  b_I->size[1] = (int32_T)varargin_1;
  emxEnsureCapacity_real_T(sp, b_I, loop_ub, &yc_emlrtRTEI);
  I_data = b_I->data;
  loop_ub = (int32_T)varargin_1 * (int32_T)varargin_1;
  for (k = 0; k < loop_ub; k++) {
    I_data[k] = 0.0;
  }
  if ((int32_T)varargin_1 > 0) {
    st.site = &vc_emlrtRSI;
    if ((int32_T)varargin_1 > 2147483646) {
      b_st.site = &hb_emlrtRSI;
      eml_int_forloop_overflow_error(&b_st);
    }
    st.site = &vc_emlrtRSI;
    for (k = 0; k < m; k++) {
      I_data[k + b_I->size[0] * k] = 1.0;
    }
  }
}

/* End of code generation (eye.c) */
