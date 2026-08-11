/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eig.c
 *
 * Code generation for function 'eig'
 *
 */

/* Include files */
#include "eig.h"
#include "anyNonFinite.h"
#include "eml_int_forloop_overflow_error.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"
#include "warning.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo ib_emlrtRSI = {
    81,    /* lineNo */
    "eig", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pathName
                                                                       */
};

static emlrtRSInfo jb_emlrtRSI = {
    127,   /* lineNo */
    "eig", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pathName
                                                                       */
};

static emlrtRSInfo kb_emlrtRSI = {
    135,   /* lineNo */
    "eig", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pathName
                                                                       */
};

static emlrtRSInfo lb_emlrtRSI = {
    143,   /* lineNo */
    "eig", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pathName
                                                                       */
};

static emlrtRSInfo pb_emlrtRSI = {
    13,                     /* lineNo */
    "eigHermitianStandard", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigHerm"
    "itianStandard.m" /* pathName */
};

static emlrtRSInfo qb_emlrtRSI = {
    40,                     /* lineNo */
    "eigHermitianStandard", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigHerm"
    "itianStandard.m" /* pathName */
};

static emlrtRSInfo rb_emlrtRSI = {
    8,         /* lineNo */
    "xsyheev", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xsyheev.m" /* pathName */
};

static emlrtRSInfo sb_emlrtRSI = {
    62,              /* lineNo */
    "ceval_xsyheev", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xsyheev.m" /* pathName */
};

static emlrtRSInfo vb_emlrtRSI = {
    10,                         /* lineNo */
    "eigSkewHermitianStandard", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigSkew"
    "HermitianStandard.m" /* pathName */
};

static emlrtRSInfo wb_emlrtRSI = {
    19,                             /* lineNo */
    "eigRealSkewSymmetricStandard", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigReal"
    "SkewSymmetricStandard.m" /* pathName */
};

static emlrtRSInfo xb_emlrtRSI = {
    35,      /* lineNo */
    "schur", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\schur.m" /* pathName
                                                                         */
};

static emlrtRSInfo yb_emlrtRSI = {
    43,      /* lineNo */
    "schur", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\schur.m" /* pathName
                                                                         */
};

static emlrtRSInfo ac_emlrtRSI = {
    52,      /* lineNo */
    "schur", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\schur.m" /* pathName
                                                                         */
};

static emlrtRSInfo bc_emlrtRSI = {
    54,      /* lineNo */
    "schur", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\schur.m" /* pathName
                                                                         */
};

static emlrtRSInfo cc_emlrtRSI = {
    83,      /* lineNo */
    "schur", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\schur.m" /* pathName
                                                                         */
};

static emlrtRSInfo dc_emlrtRSI = {
    48,     /* lineNo */
    "triu", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\elmat\\triu.m" /* pathName
                                                                       */
};

static emlrtRSInfo ec_emlrtRSI = {
    47,     /* lineNo */
    "triu", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\elmat\\triu.m" /* pathName
                                                                       */
};

static emlrtRSInfo fc_emlrtRSI = {
    15,       /* lineNo */
    "xgehrd", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgehrd.m" /* pathName */
};

static emlrtRSInfo gc_emlrtRSI = {
    85,             /* lineNo */
    "ceval_xgehrd", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgehrd.m" /* pathName */
};

static emlrtRSInfo hc_emlrtRSI = {
    28,       /* lineNo */
    "xhseqr", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xhseqr.m" /* pathName */
};

static emlrtRSInfo ic_emlrtRSI = {
    128,            /* lineNo */
    "ceval_xhseqr", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xhseqr.m" /* pathName */
};

static emlrtRSInfo jc_emlrtRSI = {
    34,            /* lineNo */
    "eigStandard", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigStan"
    "dard.m" /* pathName */
};

static emlrtRSInfo kc_emlrtRSI = {
    45,            /* lineNo */
    "eigStandard", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigStan"
    "dard.m" /* pathName */
};

static emlrtRSInfo lc_emlrtRSI = {
    42,      /* lineNo */
    "xgeev", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pathName */
};

static emlrtRSInfo mc_emlrtRSI = {
    164,           /* lineNo */
    "ceval_xgeev", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pathName */
};

static emlrtRSInfo nc_emlrtRSI = {
    159,           /* lineNo */
    "ceval_xgeev", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pathName */
};

static emlrtRTEInfo n_emlrtRTEI = {
    18,      /* lineNo */
    23,      /* colNo */
    "schur", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\schur.m" /* pName
                                                                         */
};

static emlrtRTEInfo q_emlrtRTEI = {
    50,    /* lineNo */
    27,    /* colNo */
    "eig", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pName
                                                                       */
};

static emlrtRTEInfo bc_emlrtRTEI = {
    66,    /* lineNo */
    24,    /* colNo */
    "eig", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pName
                                                                       */
};

static emlrtRTEInfo cc_emlrtRTEI = {
    98,    /* lineNo */
    9,     /* colNo */
    "eig", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pName
                                                                       */
};

static emlrtRTEInfo dc_emlrtRTEI = {
    22,        /* lineNo */
    37,        /* colNo */
    "xsyheev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xsyheev.m" /* pName */
};

static emlrtRTEInfo ec_emlrtRTEI = {
    19,                             /* lineNo */
    19,                             /* colNo */
    "eigRealSkewSymmetricStandard", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigReal"
    "SkewSymmetricStandard.m" /* pName */
};

static emlrtRTEInfo fc_emlrtRTEI = {
    42,      /* lineNo */
    37,      /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo gc_emlrtRTEI = {
    48,        /* lineNo */
    20,        /* colNo */
    "xsyheev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xsyheev.m" /* pName */
};

static emlrtRTEInfo hc_emlrtRTEI = {
    99,      /* lineNo */
    24,      /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo ic_emlrtRTEI = {
    102,     /* lineNo */
    21,      /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo jc_emlrtRTEI = {
    131,     /* lineNo */
    29,      /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo kc_emlrtRTEI = {
    19,                             /* lineNo */
    9,                              /* colNo */
    "eigRealSkewSymmetricStandard", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigReal"
    "SkewSymmetricStandard.m" /* pName */
};

static emlrtRTEInfo lc_emlrtRTEI = {
    127,   /* lineNo */
    9,     /* colNo */
    "eig", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\eig.m" /* pName
                                                                       */
};

static emlrtRTEInfo mc_emlrtRTEI = {
    132,     /* lineNo */
    29,      /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo nc_emlrtRTEI = {
    76,       /* lineNo */
    22,       /* colNo */
    "xgehrd", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgehrd.m" /* pName */
};

static emlrtRTEInfo oc_emlrtRTEI = {
    111,      /* lineNo */
    29,       /* colNo */
    "xhseqr", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xhseqr.m" /* pName */
};

static emlrtRTEInfo pc_emlrtRTEI = {
    108,                            /* lineNo */
    24,                             /* colNo */
    "eigRealSkewSymmetricStandard", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\private\\eigReal"
    "SkewSymmetricStandard.m" /* pName */
};

static emlrtRTEInfo qc_emlrtRTEI = {
    86,       /* lineNo */
    9,        /* colNo */
    "xgehrd", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgehrd.m" /* pName */
};

static emlrtRTEInfo rc_emlrtRTEI = {
    112,      /* lineNo */
    29,       /* colNo */
    "xhseqr", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xhseqr.m" /* pName */
};

static emlrtRTEInfo sc_emlrtRTEI = {
    129,      /* lineNo */
    9,        /* colNo */
    "xhseqr", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xhseqr.m" /* pName */
};

static emlrtRTEInfo tc_emlrtRTEI = {
    99,      /* lineNo */
    1,       /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo uc_emlrtRTEI = {
    131,     /* lineNo */
    5,       /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo vc_emlrtRTEI = {
    132,     /* lineNo */
    5,       /* colNo */
    "xgeev", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgeev.m" /* pName */
};

static emlrtRTEInfo wc_emlrtRTEI = {
    111,      /* lineNo */
    9,        /* colNo */
    "xhseqr", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xhseqr.m" /* pName */
};

static emlrtRTEInfo xc_emlrtRTEI = {
    112,      /* lineNo */
    9,        /* colNo */
    "xhseqr", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xhseqr.m" /* pName */
};

/* Function Definitions */
void eig(const emlrtStack *sp, const emxArray_real_T *A, emxArray_creal_T *V)
{
  static const char_T b_fname[14] = {'L', 'A', 'P', 'A', 'C', 'K', 'E',
                                     '_', 'd', 'g', 'e', 'h', 'r', 'd'};
  static const char_T c_fname[14] = {'L', 'A', 'P', 'A', 'C', 'K', 'E',
                                     '_', 'd', 'g', 'e', 'e', 'v', 'x'};
  static const char_T d_fname[14] = {'L', 'A', 'P', 'A', 'C', 'K', 'E',
                                     '_', 'd', 'h', 's', 'e', 'q', 'r'};
  static const char_T fname[13] = {'L', 'A', 'P', 'A', 'C', 'K', 'E',
                                   '_', 'd', 's', 'y', 'e', 'v'};
  ptrdiff_t ihi_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack st;
  emxArray_real_T *T;
  emxArray_real_T *scale;
  emxArray_real_T *wi;
  emxArray_real_T *wr;
  creal_T *V_data;
  const real_T *A_data;
  real_T abnrm;
  real_T lambda;
  real_T rconde;
  real_T rcondv;
  real_T vright;
  real_T *T_data;
  real_T *scale_data;
  real_T *wi_data;
  real_T *wimag_data;
  int32_T i;
  int32_T istart;
  int32_T j;
  int32_T m;
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
  A_data = A->data;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  if (A->size[0] != A->size[1]) {
    emlrtErrorWithMessageIdR2018a(sp, &q_emlrtRTEI,
                                  "MATLAB:eig:inputMustBeSquareStandard",
                                  "MATLAB:eig:inputMustBeSquareStandard", 0);
  }
  istart = A->size[0];
  m = V->size[0];
  V->size[0] = A->size[0];
  emxEnsureCapacity_creal_T(sp, V, m, &bc_emlrtRTEI);
  if ((A->size[0] != 0) && (A->size[1] != 0)) {
    st.site = &ib_emlrtRSI;
    if (anyNonFinite(&st, A)) {
      m = V->size[0];
      V->size[0] = A->size[0];
      emxEnsureCapacity_creal_T(sp, V, m, &cc_emlrtRTEI);
      V_data = V->data;
      for (j = 0; j < istart; j++) {
        V_data[j].re = rtNaN;
        V_data[j].im = 0.0;
      }
    } else {
      int32_T exitg1;
      boolean_T exitg2;
      boolean_T p;
      p = (A->size[0] == A->size[1]);
      if (p) {
        m = 0;
        exitg2 = false;
        while (!exitg2 && (m <= A->size[1] - 1)) {
          istart = 0;
          do {
            exitg1 = 0;
            if (istart <= m) {
              if (!(A_data[istart + A->size[0] * m] ==
                    A_data[m + A->size[0] * istart])) {
                p = false;
                exitg1 = 1;
              } else {
                istart++;
              }
            } else {
              m++;
              exitg1 = 2;
            }
          } while (exitg1 == 0);
          if (exitg1 == 1) {
            exitg2 = true;
          }
        }
      }
      emxInit_real_T(sp, &scale, 1, &tc_emlrtRTEI);
      emxInit_real_T(sp, &T, 2, &kc_emlrtRTEI);
      if (p) {
        st.site = &jb_emlrtRSI;
        b_st.site = &pb_emlrtRSI;
        c_st.site = &rb_emlrtRSI;
        m = T->size[0] * T->size[1];
        T->size[0] = A->size[0];
        T->size[1] = A->size[1];
        emxEnsureCapacity_real_T(&c_st, T, m, &dc_emlrtRTEI);
        T_data = T->data;
        m = A->size[0] * A->size[1];
        for (j = 0; j < m; j++) {
          T_data[j] = A_data[j];
        }
        n_t = (ptrdiff_t)A->size[0];
        m = scale->size[0];
        scale->size[0] = A->size[0];
        emxEnsureCapacity_real_T(&c_st, scale, m, &gc_emlrtRTEI);
        scale_data = scale->data;
        n_t =
            LAPACKE_dsyev(102, 'N', 'L', n_t, &T_data[0], n_t, &scale_data[0]);
        d_st.site = &sb_emlrtRSI;
        if ((int32_T)n_t < 0) {
          if ((int32_T)n_t == -1010) {
            emlrtErrorWithMessageIdR2018a(&d_st, &o_emlrtRTEI, "MATLAB:nomem",
                                          "MATLAB:nomem", 0);
          } else {
            emlrtErrorWithMessageIdR2018a(
                &d_st, &p_emlrtRTEI, "Coder:toolbox:LAPACKCallErrorInfo",
                "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 13, &fname[0], 12,
                (int32_T)n_t);
          }
        }
        istart = scale->size[0];
        m = V->size[0];
        V->size[0] = scale->size[0];
        emxEnsureCapacity_creal_T(&st, V, m, &lc_emlrtRTEI);
        V_data = V->data;
        for (j = 0; j < istart; j++) {
          V_data[j].re = scale_data[j];
          V_data[j].im = 0.0;
        }
        if (((int32_T)n_t != 0) && !emlrtSetWarningFlag(&st)) {
          b_st.site = &qb_emlrtRSI;
          warning(&b_st);
        }
      } else {
        p = (A->size[0] == A->size[1]);
        if (p) {
          m = 0;
          exitg2 = false;
          while (!exitg2 && (m <= A->size[1] - 1)) {
            istart = 0;
            do {
              exitg1 = 0;
              if (istart <= m) {
                if (!(A_data[istart + A->size[0] * m] ==
                      -A_data[m + A->size[0] * istart])) {
                  p = false;
                  exitg1 = 1;
                } else {
                  istart++;
                }
              } else {
                m++;
                exitg1 = 2;
              }
            } while (exitg1 == 0);
            if (exitg1 == 1) {
              exitg2 = true;
            }
          }
        }
        if (p) {
          st.site = &kb_emlrtRSI;
          b_st.site = &vb_emlrtRSI;
          c_st.site = &wb_emlrtRSI;
          m = T->size[0] * T->size[1];
          T->size[0] = A->size[0];
          T->size[1] = A->size[1];
          emxEnsureCapacity_real_T(&c_st, T, m, &ec_emlrtRTEI);
          T_data = T->data;
          m = A->size[0] * A->size[1];
          for (j = 0; j < m; j++) {
            T_data[j] = A_data[j];
          }
          if (T->size[0] != T->size[1]) {
            emlrtErrorWithMessageIdR2018a(&c_st, &n_emlrtRTEI,
                                          "Coder:MATLAB:square",
                                          "Coder:MATLAB:square", 0);
          }
          d_st.site = &xb_emlrtRSI;
          if (anyNonFinite(&d_st, T)) {
            uint32_T unnamed_idx_0;
            uint32_T unnamed_idx_1;
            unnamed_idx_0 = (uint32_T)T->size[0];
            unnamed_idx_1 = (uint32_T)T->size[1];
            m = T->size[0] * T->size[1];
            T->size[0] = (int32_T)unnamed_idx_0;
            T->size[1] = (int32_T)unnamed_idx_1;
            emxEnsureCapacity_real_T(&c_st, T, m, &kc_emlrtRTEI);
            T_data = T->data;
            m = (int32_T)unnamed_idx_0 * (int32_T)unnamed_idx_1;
            for (j = 0; j < m; j++) {
              T_data[j] = rtNaN;
            }
            d_st.site = &yb_emlrtRSI;
            m = (int32_T)unnamed_idx_0;
            if ((int32_T)unnamed_idx_0 > 1) {
              int32_T jend;
              istart = 2;
              if ((int32_T)unnamed_idx_0 - 2 < (int32_T)unnamed_idx_1 - 1) {
                jend = (int32_T)unnamed_idx_0 - 1;
              } else {
                jend = (int32_T)unnamed_idx_1;
              }
              e_st.site = &ec_emlrtRSI;
              e_st.site = &ec_emlrtRSI;
              for (j = 0; j < jend; j++) {
                e_st.site = &dc_emlrtRSI;
                if ((istart <= (int32_T)unnamed_idx_0) &&
                    ((int32_T)unnamed_idx_0 > 2147483646)) {
                  f_st.site = &hb_emlrtRSI;
                  eml_int_forloop_overflow_error(&f_st);
                }
                for (i = istart; i <= m; i++) {
                  T_data[(i + T->size[0] * j) - 1] = 0.0;
                }
                istart++;
              }
            }
          } else {
            int32_T jend;
            d_st.site = &ac_emlrtRSI;
            e_st.site = &fc_emlrtRSI;
            m = scale->size[0];
            scale->size[0] = T->size[0] - 1;
            emxEnsureCapacity_real_T(&e_st, scale, m, &nc_emlrtRTEI);
            scale_data = scale->data;
            if (T->size[0] > 1) {
              n_t = LAPACKE_dgehrd(102, (ptrdiff_t)T->size[0], (ptrdiff_t)1,
                                   (ptrdiff_t)T->size[0], &T_data[0],
                                   (ptrdiff_t)T->size[0], &scale_data[0]);
              f_st.site = &gc_emlrtRSI;
              if ((int32_T)n_t != 0) {
                p = true;
                if ((int32_T)n_t != -5) {
                  if ((int32_T)n_t == -1010) {
                    emlrtErrorWithMessageIdR2018a(
                        &f_st, &o_emlrtRTEI, "MATLAB:nomem", "MATLAB:nomem", 0);
                  } else {
                    emlrtErrorWithMessageIdR2018a(
                        &f_st, &p_emlrtRTEI,
                        "Coder:toolbox:LAPACKCallErrorInfo",
                        "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14,
                        &b_fname[0], 12, (int32_T)n_t);
                  }
                }
              } else {
                p = false;
              }
              if (p) {
                istart = T->size[0];
                jend = T->size[1];
                m = T->size[0] * T->size[1];
                T->size[0] = istart;
                T->size[1] = jend;
                emxEnsureCapacity_real_T(&e_st, T, m, &qc_emlrtRTEI);
                T_data = T->data;
                istart *= jend;
                for (j = 0; j < istart; j++) {
                  T_data[j] = rtNaN;
                }
              }
            }
            d_st.site = &bc_emlrtRSI;
            e_st.site = &hc_emlrtRSI;
            lambda = 0.0;
            n_t = (ptrdiff_t)T->size[0];
            emxInit_real_T(&e_st, &wr, 2, &wc_emlrtRTEI);
            m = wr->size[0] * wr->size[1];
            wr->size[0] = 1;
            wr->size[1] = T->size[0];
            emxEnsureCapacity_real_T(&e_st, wr, m, &oc_emlrtRTEI);
            scale_data = wr->data;
            emxInit_real_T(&e_st, &wi, 2, &xc_emlrtRTEI);
            m = wi->size[0] * wi->size[1];
            wi->size[0] = 1;
            wi->size[1] = T->size[0];
            emxEnsureCapacity_real_T(&e_st, wi, m, &rc_emlrtRTEI);
            wi_data = wi->data;
            n_t = LAPACKE_dhseqr(102, 'S', 'N', n_t, (ptrdiff_t)1,
                                 (ptrdiff_t)T->size[0], &T_data[0], n_t,
                                 &scale_data[0], &wi_data[0], &lambda,
                                 (ptrdiff_t)T->size[0]);
            emxFree_real_T(&e_st, &wi);
            emxFree_real_T(&e_st, &wr);
            f_st.site = &ic_emlrtRSI;
            if ((int32_T)n_t < 0) {
              boolean_T b_p;
              p = true;
              b_p = false;
              if ((int32_T)n_t == -7) {
                b_p = true;
              } else if ((int32_T)n_t == -11) {
                b_p = true;
              }
              if (!b_p) {
                if ((int32_T)n_t == -1010) {
                  emlrtErrorWithMessageIdR2018a(
                      &f_st, &o_emlrtRTEI, "MATLAB:nomem", "MATLAB:nomem", 0);
                } else {
                  emlrtErrorWithMessageIdR2018a(
                      &f_st, &p_emlrtRTEI, "Coder:toolbox:LAPACKCallErrorInfo",
                      "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14,
                      &d_fname[0], 12, (int32_T)n_t);
                }
              }
            } else {
              p = false;
            }
            if (p) {
              istart = T->size[0];
              jend = T->size[1];
              m = T->size[0] * T->size[1];
              T->size[0] = istart;
              T->size[1] = jend;
              emxEnsureCapacity_real_T(&e_st, T, m, &sc_emlrtRTEI);
              T_data = T->data;
              istart *= jend;
              for (j = 0; j < istart; j++) {
                T_data[j] = rtNaN;
              }
            }
            if (((int32_T)n_t != 0) && !emlrtSetWarningFlag(&c_st)) {
              d_st.site = &cc_emlrtRSI;
              b_warning(&d_st);
            }
          }
          istart = T->size[0];
          m = V->size[0];
          V->size[0] = T->size[0];
          emxEnsureCapacity_creal_T(&b_st, V, m, &pc_emlrtRTEI);
          V_data = V->data;
          m = 1;
          do {
            exitg1 = 0;
            if (m <= istart) {
              boolean_T guard1;
              guard1 = false;
              if (m != istart) {
                lambda = T_data[m + T->size[0] * (m - 1)];
                if (lambda != 0.0) {
                  lambda = muDoubleScalarAbs(lambda);
                  V_data[m - 1].re = 0.0;
                  V_data[m - 1].im = lambda;
                  V_data[m].re = 0.0;
                  V_data[m].im = -lambda;
                  m += 2;
                } else {
                  guard1 = true;
                }
              } else {
                guard1 = true;
              }
              if (guard1) {
                V_data[m - 1].re = 0.0;
                V_data[m - 1].im = 0.0;
                m++;
              }
            } else {
              exitg1 = 1;
            }
          } while (exitg1 == 0);
        } else {
          int32_T jend;
          st.site = &lb_emlrtRSI;
          b_st.site = &jc_emlrtRSI;
          c_st.site = &lc_emlrtRSI;
          istart = T->size[0] * T->size[1];
          T->size[0] = A->size[0];
          jend = A->size[1];
          T->size[1] = A->size[1];
          emxEnsureCapacity_real_T(&c_st, T, istart, &fc_emlrtRTEI);
          T_data = T->data;
          m = A->size[0] * A->size[1];
          for (j = 0; j < m; j++) {
            T_data[j] = A_data[j];
          }
          istart = scale->size[0];
          scale->size[0] = A->size[1];
          emxEnsureCapacity_real_T(&c_st, scale, istart, &hc_emlrtRTEI);
          scale_data = scale->data;
          istart = V->size[0];
          V->size[0] = A->size[1];
          emxEnsureCapacity_creal_T(&c_st, V, istart, &ic_emlrtRTEI);
          V_data = V->data;
          emxInit_real_T(&c_st, &wr, 1, &uc_emlrtRTEI);
          istart = wr->size[0];
          wr->size[0] = A->size[1];
          emxEnsureCapacity_real_T(&c_st, wr, istart, &jc_emlrtRTEI);
          wi_data = wr->data;
          emxInit_real_T(&c_st, &wi, 1, &vc_emlrtRTEI);
          istart = wi->size[0];
          wi->size[0] = A->size[1];
          emxEnsureCapacity_real_T(&c_st, wi, istart, &mc_emlrtRTEI);
          wimag_data = wi->data;
          n_t = LAPACKE_dgeevx(102, 'B', 'N', 'N', 'N', (ptrdiff_t)A->size[1],
                               &T_data[0], (ptrdiff_t)A->size[0], &wi_data[0],
                               &wimag_data[0], &lambda, (ptrdiff_t)1, &vright,
                               (ptrdiff_t)1, &n_t, &ihi_t, &scale_data[0],
                               &abnrm, &rconde, &rcondv);
          d_st.site = &nc_emlrtRSI;
          if ((int32_T)n_t < 0) {
            if ((int32_T)n_t == -1010) {
              emlrtErrorWithMessageIdR2018a(&d_st, &o_emlrtRTEI, "MATLAB:nomem",
                                            "MATLAB:nomem", 0);
            } else {
              emlrtErrorWithMessageIdR2018a(
                  &d_st, &p_emlrtRTEI, "Coder:toolbox:LAPACKCallErrorInfo",
                  "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, &c_fname[0],
                  12, (int32_T)n_t);
            }
          }
          d_st.site = &mc_emlrtRSI;
          if (A->size[1] > 2147483646) {
            e_st.site = &hb_emlrtRSI;
            eml_int_forloop_overflow_error(&e_st);
          }
          d_st.site = &mc_emlrtRSI;
          for (j = 0; j < jend; j++) {
            V_data[j].re = wi_data[j];
            V_data[j].im = wimag_data[j];
          }
          emxFree_real_T(&c_st, &wi);
          emxFree_real_T(&c_st, &wr);
          if (((int32_T)n_t != 0) && !emlrtSetWarningFlag(&st)) {
            b_st.site = &kc_emlrtRSI;
            warning(&b_st);
          }
        }
      }
      emxFree_real_T(sp, &T);
      emxFree_real_T(sp, &scale);
    }
  }
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

/* End of code generation (eig.c) */
