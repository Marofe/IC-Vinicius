/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chol.c
 *
 * Code generation for function 'chol'
 *
 */

/* Include files */
#include "chol.h"
#include "eml_int_forloop_overflow_error.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_types.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo bb_emlrtRSI = {
    84,     /* lineNo */
    "chol", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\chol.m" /* pathName
                                                                           */
};

static emlrtRSInfo cb_emlrtRSI = {
    100,    /* lineNo */
    "chol", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\chol.m" /* pathName
                                                                           */
};

static emlrtRSInfo db_emlrtRSI = {
    101,    /* lineNo */
    "chol", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\chol.m" /* pathName
                                                                           */
};

static emlrtRSInfo eb_emlrtRSI = {
    79,             /* lineNo */
    "ceval_xpotrf", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xpotrf.m" /* pathName */
};

static emlrtRSInfo fb_emlrtRSI = {
    13,       /* lineNo */
    "xpotrf", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xpotrf.m" /* pathName */
};

static emlrtRTEInfo bb_emlrtRTEI = {
    56,     /* lineNo */
    23,     /* colNo */
    "chol", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\chol.m" /* pName
                                                                           */
};

static emlrtRTEInfo cb_emlrtRTEI = {
    109,    /* lineNo */
    27,     /* colNo */
    "chol", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\chol.m" /* pName
                                                                           */
};

static const char_T cv1[19] = {'L', 'A', 'P', 'A', 'C', 'K', 'E', '_', 'd', 'p',
                               'o', 't', 'r', 'f', '_', 'w', 'o', 'r', 'k'};

/* Function Definitions */
void b_chol(const emlrtStack *sp, emxArray_real_T *A)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T *A_data;
  int32_T i;
  int32_T j;
  int32_T mrows;
  int32_T ncols;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  A_data = A->data;
  mrows = A->size[0];
  ncols = A->size[1];
  if (A->size[0] != A->size[1]) {
    emlrtErrorWithMessageIdR2018a(sp, &bb_emlrtRTEI, "MATLAB:square",
                                  "MATLAB:square", 0);
  }
  mrows = muIntScalarMin_sint32(mrows, ncols);
  if (mrows != 0) {
    ptrdiff_t info_t;
    st.site = &bb_emlrtRSI;
    b_st.site = &fb_emlrtRSI;
    info_t = LAPACKE_dpotrf_work(102, 'U', (ptrdiff_t)mrows, &A_data[0],
                                 (ptrdiff_t)A->size[0]);
    c_st.site = &eb_emlrtRSI;
    if ((int32_T)info_t < 0) {
      if ((int32_T)info_t == -1010) {
        emlrtErrorWithMessageIdR2018a(&c_st, &o_emlrtRTEI, "MATLAB:nomem",
                                      "MATLAB:nomem", 0);
      } else {
        emlrtErrorWithMessageIdR2018a(&c_st, &p_emlrtRTEI,
                                      "Coder:toolbox:LAPACKCallErrorInfo",
                                      "Coder:toolbox:LAPACKCallErrorInfo", 5, 4,
                                      19, &cv1[0], 12, (int32_T)info_t);
      }
    }
    if ((int32_T)info_t != 0) {
      mrows = (int32_T)info_t - 1;
    }
    st.site = &cb_emlrtRSI;
    st.site = &cb_emlrtRSI;
    for (j = 0; j <= mrows - 2; j++) {
      st.site = &db_emlrtRSI;
      if ((j + 2 <= mrows) && (mrows > 2147483646)) {
        b_st.site = &hb_emlrtRSI;
        eml_int_forloop_overflow_error(&b_st);
      }
      for (i = j + 2; i <= mrows; i++) {
        A_data[(i + A->size[0] * j) - 1] = 0.0;
      }
    }
    if ((int32_T)info_t != 0) {
      emlrtErrorWithMessageIdR2018a(sp, &cb_emlrtRTEI, "MATLAB:posdef",
                                    "MATLAB:posdef", 0);
    }
  }
}

int32_T chol(const emlrtStack *sp, emxArray_real_T *A, int32_T *jmax)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T *A_data;
  int32_T flag;
  int32_T i;
  int32_T j;
  int32_T mrows;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  A_data = A->data;
  mrows = A->size[0];
  flag = A->size[1];
  if (A->size[0] != A->size[1]) {
    emlrtErrorWithMessageIdR2018a(sp, &bb_emlrtRTEI, "MATLAB:square",
                                  "MATLAB:square", 0);
  }
  mrows = muIntScalarMin_sint32(mrows, flag);
  *jmax = 0;
  flag = 0;
  if (mrows != 0) {
    ptrdiff_t info_t;
    st.site = &bb_emlrtRSI;
    b_st.site = &fb_emlrtRSI;
    info_t = LAPACKE_dpotrf_work(102, 'U', (ptrdiff_t)mrows, &A_data[0],
                                 (ptrdiff_t)A->size[0]);
    c_st.site = &eb_emlrtRSI;
    if ((int32_T)info_t < 0) {
      if ((int32_T)info_t == -1010) {
        emlrtErrorWithMessageIdR2018a(&c_st, &o_emlrtRTEI, "MATLAB:nomem",
                                      "MATLAB:nomem", 0);
      } else {
        emlrtErrorWithMessageIdR2018a(&c_st, &p_emlrtRTEI,
                                      "Coder:toolbox:LAPACKCallErrorInfo",
                                      "Coder:toolbox:LAPACKCallErrorInfo", 5, 4,
                                      19, &cv1[0], 12, (int32_T)info_t);
      }
    }
    flag = (int32_T)info_t;
    if ((int32_T)info_t == 0) {
      *jmax = mrows;
    } else {
      *jmax = (int32_T)info_t - 1;
    }
    st.site = &cb_emlrtRSI;
    st.site = &cb_emlrtRSI;
    for (j = 0; j <= *jmax - 2; j++) {
      st.site = &db_emlrtRSI;
      if ((j + 2 <= *jmax) && (*jmax > 2147483646)) {
        b_st.site = &hb_emlrtRSI;
        eml_int_forloop_overflow_error(&b_st);
      }
      for (i = j + 2; i <= *jmax; i++) {
        A_data[(i + A->size[0] * j) - 1] = 0.0;
      }
    }
  }
  return flag;
}

/* End of code generation (chol.c) */
