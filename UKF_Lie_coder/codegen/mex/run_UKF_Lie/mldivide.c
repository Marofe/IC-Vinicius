/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mldivide.c
 *
 * Code generation for function 'mldivide'
 *
 */

/* Include files */
#include "mldivide.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "warning.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include <stddef.h>
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo ke_emlrtRSI = {
    20,         /* lineNo */
    "mldivide", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\ops\\mldivide.m" /* pathName
                                                                         */
};

static emlrtRSInfo le_emlrtRSI = {
    42,      /* lineNo */
    "mldiv", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\ops\\mldivide.m" /* pathName
                                                                         */
};

static emlrtRSInfo
    me_emlrtRSI =
        {
            67,        /* lineNo */
            "lusolve", /* fcnName */
            "C:\\Program "
            "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
            "internal\\lusolve.m" /* pathName */
};

static emlrtRSInfo
    ne_emlrtRSI =
        {
            109,          /* lineNo */
            "lusolveNxN", /* fcnName */
            "C:\\Program "
            "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
            "internal\\lusolve.m" /* pathName */
};

static emlrtRSInfo
    oe_emlrtRSI =
        {
            112,          /* lineNo */
            "lusolveNxN", /* fcnName */
            "C:\\Program "
            "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
            "internal\\lusolve.m" /* pathName */
};

static emlrtRSInfo
    pe_emlrtRSI =
        {
            124,          /* lineNo */
            "InvAtimesX", /* fcnName */
            "C:\\Program "
            "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
            "internal\\lusolve.m" /* pathName */
};

static emlrtRSInfo qe_emlrtRSI = {
    19,        /* lineNo */
    "xgetrfs", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgetrfs.m" /* pathName */
};

static emlrtRSInfo re_emlrtRSI = {
    108,      /* lineNo */
    "cmldiv", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgetrfs.m" /* pathName */
};

static emlrtRSInfo
    se_emlrtRSI =
        {
            90,              /* lineNo */
            "warn_singular", /* fcnName */
            "C:\\Program "
            "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
            "internal\\lusolve.m" /* pathName */
};

static emlrtRSInfo
    lf_emlrtRSI =
        {
            61,        /* lineNo */
            "lusolve", /* fcnName */
            "C:\\Program "
            "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
            "internal\\lusolve.m" /* pathName */
};

static emlrtRSInfo
    mf_emlrtRSI =
        {
            293,          /* lineNo */
            "lusolve3x3", /* fcnName */
            "C:\\Program "
            "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
            "internal\\lusolve.m" /* pathName */
};

/* Function Definitions */
void b_mldivide(const emlrtStack *sp, const real_T A[169], real_T B[169])
{
  ptrdiff_t IPIV[13];
  ptrdiff_t INFO;
  ptrdiff_t LDA;
  ptrdiff_t N;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack st;
  real_T b_A[169];
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  g_st.prev = &f_st;
  g_st.tls = f_st.tls;
  st.site = &ke_emlrtRSI;
  b_st.site = &le_emlrtRSI;
  c_st.site = &me_emlrtRSI;
  d_st.site = &ne_emlrtRSI;
  e_st.site = &pe_emlrtRSI;
  f_st.site = &qe_emlrtRSI;
  memcpy(&b_A[0], &A[0], 169U * sizeof(real_T));
  N = (ptrdiff_t)13;
  LDA = (ptrdiff_t)13;
  INFO = LAPACKE_dgetrf_work(102, N, N, &b_A[0], LDA, &IPIV[0]);
  g_st.site = &re_emlrtRSI;
  if ((int32_T)INFO < 0) {
    if ((int32_T)INFO == -1010) {
      emlrtErrorWithMessageIdR2018a(&g_st, &o_emlrtRTEI, "MATLAB:nomem",
                                    "MATLAB:nomem", 0);
    } else {
      emlrtErrorWithMessageIdR2018a(&g_st, &p_emlrtRTEI,
                                    "Coder:toolbox:LAPACKCallErrorInfo",
                                    "Coder:toolbox:LAPACKCallErrorInfo", 5, 4,
                                    19, &cv[0], 12, (int32_T)INFO);
    }
  }
  LAPACKE_dgetrs_work(102, 'N', N, (ptrdiff_t)13, &b_A[0], LDA, &IPIV[0], &B[0],
                      (ptrdiff_t)13);
  if ((int32_T)INFO > 0) {
    d_st.site = &oe_emlrtRSI;
    if (!emlrtSetWarningFlag(&d_st)) {
      e_st.site = &se_emlrtRSI;
      c_warning(&e_st);
    }
  }
}

void mldivide(const emlrtStack *sp, const real_T A[9], const real_T B[45],
              real_T Y[45])
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack st;
  real_T b_A[9];
  real_T a21;
  real_T maxval;
  int32_T k;
  int32_T r1;
  int32_T r2;
  int32_T r3;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  st.site = &ke_emlrtRSI;
  b_st.site = &le_emlrtRSI;
  c_st.site = &lf_emlrtRSI;
  memcpy(&b_A[0], &A[0], 9U * sizeof(real_T));
  r1 = 0;
  r2 = 1;
  r3 = 2;
  maxval = muDoubleScalarAbs(A[0]);
  a21 = muDoubleScalarAbs(A[1]);
  if (a21 > maxval) {
    maxval = a21;
    r1 = 1;
    r2 = 0;
  }
  if (muDoubleScalarAbs(A[2]) > maxval) {
    r1 = 2;
    r2 = 1;
    r3 = 0;
  }
  b_A[r2] = A[r2] / A[r1];
  b_A[r3] /= b_A[r1];
  b_A[r2 + 3] -= b_A[r2] * b_A[r1 + 3];
  b_A[r3 + 3] -= b_A[r3] * b_A[r1 + 3];
  b_A[r2 + 6] -= b_A[r2] * b_A[r1 + 6];
  b_A[r3 + 6] -= b_A[r3] * b_A[r1 + 6];
  if (muDoubleScalarAbs(b_A[r3 + 3]) > muDoubleScalarAbs(b_A[r2 + 3])) {
    int32_T rtemp;
    rtemp = r2;
    r2 = r3;
    r3 = rtemp;
  }
  b_A[r3 + 3] /= b_A[r2 + 3];
  b_A[r3 + 6] -= b_A[r3 + 3] * b_A[r2 + 6];
  if ((b_A[r1] == 0.0) || (b_A[r2 + 3] == 0.0) || (b_A[r3 + 6] == 0.0)) {
    d_st.site = &mf_emlrtRSI;
    if (!emlrtSetWarningFlag(&d_st)) {
      e_st.site = &se_emlrtRSI;
      c_warning(&e_st);
    }
  }
  for (k = 0; k < 15; k++) {
    real_T d;
    maxval = B[r1 + 3 * k];
    a21 = B[r2 + 3 * k] - maxval * b_A[r2];
    d = ((B[r3 + 3 * k] - maxval * b_A[r3]) - a21 * b_A[r3 + 3]) / b_A[r3 + 6];
    Y[3 * k + 2] = d;
    maxval -= d * b_A[r1 + 6];
    a21 -= d * b_A[r2 + 6];
    a21 /= b_A[r2 + 3];
    Y[3 * k + 1] = a21;
    maxval -= a21 * b_A[r1 + 3];
    maxval /= b_A[r1];
    Y[3 * k] = maxval;
  }
}

/* End of code generation (mldivide.c) */
