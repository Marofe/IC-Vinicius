/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * anyNonFinite.c
 *
 * Code generation for function 'anyNonFinite'
 *
 */

/* Include files */
#include "anyNonFinite.h"
#include "eml_int_forloop_overflow_error.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_types.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo gb_emlrtRSI = {
    29,                                     /* lineNo */
    "eml_int_forloop_num_iterations_check", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_"
    "num_iterations_check.m" /* pathName */
};

static emlrtRSInfo mb_emlrtRSI = {
    29,             /* lineNo */
    "anyNonFinite", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\anyNonFinite."
    "m" /* pathName */
};

static emlrtRSInfo nb_emlrtRSI =
    {
        45,          /* lineNo */
        "vAllOrAny", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
        "internal\\vAllOrAny.m" /* pathName */
};

static emlrtRSInfo ob_emlrtRSI =
    {
        121,                  /* lineNo */
        "flatVectorAllOrAny", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
        "internal\\vAllOrAny.m" /* pathName */
};

/* Function Definitions */
boolean_T anyNonFinite(const emlrtStack *sp, const emxArray_real_T *x)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  const real_T *x_data;
  int32_T k;
  int32_T nx;
  boolean_T p;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  x_data = x->data;
  st.site = &mb_emlrtRSI;
  b_st.site = &nb_emlrtRSI;
  nx = x->size[0] * x->size[1];
  p = true;
  c_st.site = &ob_emlrtRSI;
  if (nx > 2147483646) {
    d_st.site = &hb_emlrtRSI;
    eml_int_forloop_overflow_error(&d_st);
  }
  c_st.site = &ob_emlrtRSI;
  if (nx <= MIN_int32_T) {
    d_st.site = &gb_emlrtRSI;
    eml_int_forloop_overflow_error(&d_st);
  }
  for (k = 0; k < nx; k++) {
    if (!p ||
        (muDoubleScalarIsInf(x_data[k]) || muDoubleScalarIsNaN(x_data[k]))) {
      p = false;
    }
  }
  return !p;
}

/* End of code generation (anyNonFinite.c) */
