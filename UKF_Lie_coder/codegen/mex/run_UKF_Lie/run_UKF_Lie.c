/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * run_UKF_Lie.c
 *
 * Code generation for function 'run_UKF_Lie'
 *
 */

/* Include files */
#include "run_UKF_Lie.h"
#include "diag.h"
#include "evaluateStateRMSE.h"
#include "exp_multiSE23T6.h"
#include "log_multiSE23T6.h"
#include "lu.h"
#include "mldivide.h"
#include "mtimes.h"
#include "norm.h"
#include "prediction_UKF_Lie.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_mexutil.h"
#include "run_UKF_Lie_types.h"
#include "squeeze.h"
#include "sumMatrixIncludeNaN.h"
#include "blas.h"
#include "mwmathutil.h"
#include "omp.h"
#include <emmintrin.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = {
    8,                                           /* lineNo */
    "run_UKF_Lie",                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo b_emlrtRSI = {
    11,                                          /* lineNo */
    "run_UKF_Lie",                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo c_emlrtRSI = {
    18,                                          /* lineNo */
    "run_UKF_Lie",                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo d_emlrtRSI = {
    20,                                          /* lineNo */
    "run_UKF_Lie",                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo e_emlrtRSI = {
    21,                                          /* lineNo */
    "run_UKF_Lie",                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo f_emlrtRSI = {
    24,                                          /* lineNo */
    "run_UKF_Lie",                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo xe_emlrtRSI = {
    13,                                                     /* lineNo */
    "Update_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo ye_emlrtRSI = {
    16,                                                     /* lineNo */
    "Update_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo af_emlrtRSI = {
    26,                                                     /* lineNo */
    "Update_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo bf_emlrtRSI = {
    28,                                                     /* lineNo */
    "Update_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo cf_emlrtRSI = {
    34,                                                     /* lineNo */
    "Update_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo df_emlrtRSI = {
    37,                                                     /* lineNo */
    "Update_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo ef_emlrtRSI = {
    40,                                                     /* lineNo */
    "Update_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo ff_emlrtRSI = {
    9,                                                    /* lineNo */
    "media_nula_h",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_h.m" /* pathName */
};

static emlrtRSInfo gf_emlrtRSI = {
    6,                                                    /* lineNo */
    "covariancias",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pathName */
};

static emlrtRSInfo hf_emlrtRSI = {
    9,                                                    /* lineNo */
    "covariancias",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pathName */
};

static emlrtRSInfo if_emlrtRSI = {
    11,                                                   /* lineNo */
    "covariancias",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pathName */
};

static emlrtRSInfo jf_emlrtRSI = {
    13,                                                   /* lineNo */
    "covariancias",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pathName */
};

static emlrtRSInfo kf_emlrtRSI = {
    14,                                                   /* lineNo */
    "covariancias",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pathName */
};

static emlrtRSInfo of_emlrtRSI = {
    38,        /* lineNo */
    "fprintf", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\iofun\\fprintf.m" /* pathName
                                                                          */
};

static emlrtMCInfo d_emlrtMCI = {
    66,        /* lineNo */
    18,        /* colNo */
    "fprintf", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\iofun\\fprintf.m" /* pName
                                                                          */
};

static emlrtDCInfo g_emlrtDCI = {
    5,                                            /* lineNo */
    9,                                            /* colNo */
    "run_UKF_Lie",                                /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m", /* pName */
    3                                             /* checkKind */
};

static emlrtRTEInfo u_emlrtRTEI = {
    5,                                           /* lineNo */
    7,                                           /* colNo */
    "run_UKF_Lie",                               /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pName */
};

static emlrtBCInfo m_emlrtBCI = {
    1,                                            /* iFirst */
    1136,                                         /* iLast */
    10,                                           /* lineNo */
    30,                                           /* colNo */
    "gps_time",                                   /* aName */
    "run_UKF_Lie",                                /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m", /* pName */
    0                                             /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = {
    1,                                            /* iFirst */
    229272,                                       /* iLast */
    11,                                           /* lineNo */
    56,                                           /* colNo */
    "hx",                                         /* aName */
    "run_UKF_Lie",                                /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m", /* pName */
    0                                             /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = {
    1,                                            /* iFirst */
    229272,                                       /* iLast */
    16,                                           /* lineNo */
    14,                                           /* colNo */
    "P",                                          /* aName */
    "run_UKF_Lie",                                /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m", /* pName */
    0                                             /* checkKind */
};

static emlrtDCInfo h_emlrtDCI = {
    15,                                                      /* lineNo */
    30,                                                      /* colNo */
    "Update_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m", /* pName */
    4                                                        /* checkKind */
};

static emlrtDCInfo i_emlrtDCI = {
    15,                                                      /* lineNo */
    30,                                                      /* colNo */
    "Update_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m", /* pName */
    1                                                        /* checkKind */
};

static emlrtDCInfo j_emlrtDCI = {
    19,                                                      /* lineNo */
    13,                                                      /* colNo */
    "Update_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m", /* pName */
    1                                                        /* checkKind */
};

static emlrtRTEInfo v_emlrtRTEI = {
    20,                                                     /* lineNo */
    7,                                                      /* colNo */
    "Update_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pName */
};

static emlrtBCInfo p_emlrtBCI = {
    -1,                                                      /* iFirst */
    -1,                                                      /* iLast */
    21,                                                      /* lineNo */
    19,                                                      /* colNo */
    "G",                                                     /* aName */
    "Update_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m", /* pName */
    0                                                        /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = {
    -1,                                                      /* iFirst */
    -1,                                                      /* iLast */
    23,                                                      /* lineNo */
    39,                                                      /* colNo */
    "R",                                                     /* aName */
    "Update_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m", /* pName */
    0                                                        /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = {
    -1,                                                      /* iFirst */
    -1,                                                      /* iLast */
    23,                                                      /* lineNo */
    11,                                                      /* colNo */
    "Y",                                                     /* aName */
    "Update_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m", /* pName */
    0                                                        /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = {
    -1,                                                    /* iFirst */
    -1,                                                    /* iLast */
    3,                                                     /* lineNo */
    9,                                                     /* colNo */
    "H",                                                   /* aName */
    "media_nula_h",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_h.m", /* pName */
    0                                                      /* checkKind */
};

static emlrtRTEInfo w_emlrtRTEI = {
    8,                                                    /* lineNo */
    12,                                                   /* colNo */
    "media_nula_h",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_h.m" /* pName */
};

static emlrtBCInfo t_emlrtBCI = {
    -1,                                                    /* iFirst */
    -1,                                                    /* iLast */
    9,                                                     /* lineNo */
    45,                                                    /* colNo */
    "H",                                                   /* aName */
    "media_nula_h",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_h.m", /* pName */
    0                                                      /* checkKind */
};

static emlrtDCInfo k_emlrtDCI = {
    7,                                                     /* lineNo */
    14,                                                    /* colNo */
    "covariancias",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m", /* pName */
    1                                                      /* checkKind */
};

static emlrtRTEInfo x_emlrtRTEI = {
    10,                                                   /* lineNo */
    7,                                                    /* colNo */
    "covariancias",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pName */
};

static emlrtBCInfo u_emlrtBCI = {
    -1,                                                    /* iFirst */
    -1,                                                    /* iLast */
    11,                                                    /* lineNo */
    48,                                                    /* colNo */
    "G",                                                   /* aName */
    "covariancias",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m", /* pName */
    0                                                      /* checkKind */
};

static emlrtRTEInfo ab_emlrtRTEI = {
    13,               /* lineNo */
    13,               /* colNo */
    "toLogicalCheck", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\toLogicalCheck.m" /* pName */
};

static emlrtBCInfo v_emlrtBCI = {
    1,                                            /* iFirst */
    229272,                                       /* iLast */
    8,                                            /* lineNo */
    28,                                           /* colNo */
    "P",                                          /* aName */
    "run_UKF_Lie",                                /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m", /* pName */
    3                                             /* checkKind */
};

static emlrtBCInfo w_emlrtBCI = {
    1,                                            /* iFirst */
    229272,                                       /* iLast */
    6,                                            /* lineNo */
    13,                                           /* colNo */
    "time",                                       /* aName */
    "run_UKF_Lie",                                /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m", /* pName */
    0                                             /* checkKind */
};

static emlrtBCInfo x_emlrtBCI = {
    1,                                            /* iFirst */
    229272,                                       /* iLast */
    6,                                            /* lineNo */
    23,                                           /* colNo */
    "time",                                       /* aName */
    "run_UKF_Lie",                                /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m", /* pName */
    0                                             /* checkKind */
};

static emlrtBCInfo y_emlrtBCI = {
    -1,                                                    /* iFirst */
    -1,                                                    /* iLast */
    9,                                                     /* lineNo */
    33,                                                    /* colNo */
    "W",                                                   /* aName */
    "media_nula_h",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_h.m", /* pName */
    0                                                      /* checkKind */
};

static emlrtBCInfo ab_emlrtBCI = {
    -1,                                                    /* iFirst */
    -1,                                                    /* iLast */
    11,                                                    /* lineNo */
    12,                                                    /* colNo */
    "epsg",                                                /* aName */
    "covariancias",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m", /* pName */
    0                                                      /* checkKind */
};

static emlrtRTEInfo ed_emlrtRTEI = {
    15,                                                     /* lineNo */
    1,                                                      /* colNo */
    "Update_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo fd_emlrtRTEI = {
    16,                                                     /* lineNo */
    1,                                                      /* colNo */
    "Update_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo gd_emlrtRTEI = {
    19,                                                     /* lineNo */
    1,                                                      /* colNo */
    "Update_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\Update_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo hd_emlrtRTEI = {
    6,                                                    /* lineNo */
    14,                                                   /* colNo */
    "covariancias",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pName */
};

static emlrtRTEInfo id_emlrtRTEI = {
    6,                                                    /* lineNo */
    1,                                                    /* colNo */
    "covariancias",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pName */
};

static emlrtRTEInfo jd_emlrtRTEI = {
    7,                                                    /* lineNo */
    1,                                                    /* colNo */
    "covariancias",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pName */
};

static emlrtRTEInfo kd_emlrtRTEI = {
    8,                                           /* lineNo */
    33,                                          /* colNo */
    "run_UKF_Lie",                               /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo ld_emlrtRTEI = {
    13,                                                   /* lineNo */
    5,                                                    /* colNo */
    "covariancias",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pName */
};

static emlrtRTEInfo md_emlrtRTEI = {
    13,                                                   /* lineNo */
    10,                                                   /* colNo */
    "covariancias",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pName */
};

static emlrtRTEInfo nd_emlrtRTEI = {
    14,                                                   /* lineNo */
    5,                                                    /* colNo */
    "covariancias",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\covariancias.m" /* pName */
};

static emlrtRSInfo xf_emlrtRSI = {
    66,        /* lineNo */
    "fprintf", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\iofun\\fprintf.m" /* pathName
                                                                          */
};

/* Function Declarations */
static const mxArray *c_feval(const emlrtStack *sp, const mxArray *m,
                              const mxArray *m1, const mxArray *m2,
                              const mxArray *m3, emlrtMCInfo *location);

/* Function Definitions */
static const mxArray *c_feval(const emlrtStack *sp, const mxArray *m,
                              const mxArray *m1, const mxArray *m2,
                              const mxArray *m3, emlrtMCInfo *location)
{
  const mxArray *pArrays[4];
  const mxArray *m4;
  pArrays[0] = m;
  pArrays[1] = m1;
  pArrays[2] = m2;
  pArrays[3] = m3;
  return emlrtCallMATLABR2012b((emlrtConstCTX)sp, 1, &m4, 4, &pArrays[0],
                               "feval", true, location);
}

emlrtCTX emlrtGetRootTLSGlobal(void)
{
  return emlrtRootTLSGlobal;
}

void emlrtLockerFunction(EmlrtLockeeFunction aLockee, emlrtConstCTX aTLS,
                         void *aData)
{
  omp_set_lock(&emlrtLockGlobal);
  emlrtCallLockeeFunction(aLockee, aTLS, aData);
  omp_unset_lock(&emlrtLockGlobal);
}

real_T run_UKF_Lie(run_UKF_LieStackData *SD, const emlrtStack *sp, real_T N,
                   const real_T b_time[229272], const real_T gps_time[1136],
                   real_T hx[38746968], real_T trP[229272], real_T P[51586200],
                   const real_T Pqq[225], const real_T Prr[9],
                   const real_T u[1375632], real_T alpha, real_T beta,
                   real_T kappa, real_T L, const real_T Cen[9],
                   const real_T y[3408], const real_T leverarm[3], real_T M,
                   real_T euler[687816], const struct0_T *ref)
{
  static const int32_T b_iv[2] = {1, 7};
  static const int32_T b_iv1[2] = {1, 31};
  static const char_T c_u[31] = {'r', 'u', 'n', 'n', 'i', 'n',  'g', ' ',
                                 't', 'h', 'e', ' ', 'U', 'K',  'F', '-',
                                 'L', 'i', 'e', '.', '.', '.',  ' ', '%',
                                 '.', '1', 'f', '%', '%', '\\', 'n'};
  static const char_T b_u[7] = {'f', 'p', 'r', 'i', 'n', 't', 'f'};
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  emxArray_real_T *G;
  emxArray_real_T *Wc;
  emxArray_real_T *Wm;
  emxArray_real_T *Y;
  emxArray_real_T *b;
  emxArray_real_T *b_Y;
  emxArray_real_T *b_y;
  emxArray_real_T *c_y;
  emxArray_real_T *epsg;
  emxArray_real_T *epsh;
  const mxArray *d_y;
  const mxArray *e_y;
  const mxArray *m;
  real_T b_P[225];
  real_T b_hx[169];
  real_T Pgh[45];
  real_T b_K[45];
  real_T c_I[16];
  real_T ht[16];
  real_T K[15];
  real_T b_I[9];
  real_T soma[3];
  real_T dt;
  real_T log_interval;
  real_T rmse;
  real_T *G_data;
  real_T *Wc_data;
  real_T *Wm_data;
  real_T *Y_data;
  real_T *epsh_data;
  int32_T b_i;
  int32_T b_k;
  int32_T i;
  int32_T k;
  int32_T loop_ub;
  int32_T nk;
  char_T TRANSA1;
  char_T TRANSB1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  nk = 2;
  /*  pre-transpose once (reused N times in loop) */
  log_interval = muDoubleScalarRound(N / 10.0);
  i = (int32_T)(N - 1.0);
  if (N - 1.0 != N - 1.0) {
    emlrtNotNanCheckR2012b(N - 1.0, &g_emlrtDCI, (emlrtConstCTX)sp);
  }
  emlrtForLoopVectorCheckR2021a(1.0, 1.0, N - 1.0, mxDOUBLE_CLASS,
                                (int32_T)(N - 1.0), &u_emlrtRTEI,
                                (emlrtConstCTX)sp);
  emxInit_real_T(sp, &G, 3, &kd_emlrtRTEI);
  emxInit_real_T(sp, &Wm, 1, &ed_emlrtRTEI);
  emxInit_real_T(sp, &Wc, 1, &fd_emlrtRTEI);
  emxInit_real_T(sp, &Y, 3, &gd_emlrtRTEI);
  emxInit_real_T(sp, &epsh, 2, &id_emlrtRTEI);
  emxInit_real_T(sp, &epsg, 2, &jd_emlrtRTEI);
  emxInit_real_T(sp, &b_y, 2, &ld_emlrtRTEI);
  emxInit_real_T(sp, &b, 2, &md_emlrtRTEI);
  emxInit_real_T(sp, &c_y, 2, &nd_emlrtRTEI);
  emxInit_real_T(sp, &b_Y, 3, &hd_emlrtRTEI);
  for (k = 0; k < i; k++) {
    int32_T i1;
    int32_T i2;
    boolean_T b_b;
    b_b = (((int32_T)((uint32_T)k + 2U) < 1) ||
           ((int32_T)((uint32_T)k + 2U) > 229272));
    if (b_b) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)k + 2U), 1, 229272,
                                    &w_emlrtBCI, (emlrtConstCTX)sp);
    }
    if (((int32_T)((uint32_T)k + 1U) < 1) ||
        ((int32_T)((uint32_T)k + 1U) > 229272)) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)k + 1U), 1, 229272,
                                    &x_emlrtBCI, (emlrtConstCTX)sp);
    }
    rmse = b_time[k];
    dt = b_time[k + 1] - rmse;
    /* adapatative sampling time */
    /*     %% time update (prediction) */
    if (b_b) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)k + 2U), 1, 229272,
                                    &v_emlrtBCI, (emlrtConstCTX)sp);
    }
    memcpy(&b_hx[0], &hx[k * 169], 169U * sizeof(real_T));
    memcpy(&b_P[0], &P[k * 225], 225U * sizeof(real_T));
    i1 = 169 * (k + 1);
    i2 = 225 * (k + 1);
    st.site = &emlrtRSI;
    prediction_UKF_Lie(&st, b_hx, b_P, Pqq, Prr, &u[6 * k], alpha, beta, kappa,
                       L, dt, &hx[i1], G, epsh, &P[i2]);
    epsh_data = epsh->data;
    G_data = G->data;
    /*     %% measurement update (correction) */
    if (nk > 1136) {
      emlrtDynamicBoundsCheckR2012b(1137, 1, 1136, &m_emlrtBCI,
                                    (emlrtConstCTX)sp);
    }
    if (muDoubleScalarAbs(rmse - gps_time[nk - 1]) < dt) {
      __m128d r;
      __m128d r1;
      real_T b_L[169];
      real_T c_P[169];
      real_T dv[45];
      real_T c_b;
      real_T d;
      real_T lambda_tmp;
      int32_T b_loop_ub;
      int32_T i3;
      int32_T unnamed_idx_1;
      boolean_T exitg1;
      st.site = &b_emlrtRSI;
      if (((int32_T)(((real_T)k + 1.0) + 1.0) < 1) ||
          ((int32_T)(((real_T)k + 1.0) + 1.0) > 229272)) {
        emlrtDynamicBoundsCheckR2012b((int32_T)(((real_T)k + 1.0) + 1.0), 1,
                                      229272, &n_emlrtBCI, &st);
      }
      /*  lembretes */
      /*  a medida é Y=h(X)EXP(ruido)  com Y=[I p_gps;0 1] Y é do tipo T(3) */
      /*  fazer log_v(inv(Y1)*Y2) = p2 - p1 */
      /*  Se Y1=[I p1;0 1] e Y2=[I p2;0 1] ==> Y1*Y2 = [I (p1+p2);0 1]; */
      /*  H=h(G)*exp^(R); Se G=[Ceb v p,0 I] ==> h(G)=[I p+Ceb*lb;0 1];
       * expH^(R)=[I R,0 1]  */
      /*  h(G)*expH^(R)= [I p+Ceb*lb + R;0 1]=[I p+Ceb*lb;0 1]*[I R;0 1] */
      /*   */
      b_st.site = &xe_emlrtRSI;
      c_st.site = &tb_emlrtRSI;
      lambda_tmp = alpha * alpha;
      rmse = lambda_tmp * (L + kappa) - L;
      /*  pesos */
      d = 2.0 * L;
      if (!(d >= 0.0)) {
        emlrtNonNegativeCheckR2012b(d, &h_emlrtDCI, &st);
      }
      if (d != (int32_T)muDoubleScalarFloor(d)) {
        emlrtIntegerCheckR2012b(d, &i_emlrtDCI, &st);
      }
      dt = rmse + L;
      c_b = 1.0 / (2.0 * dt);
      unnamed_idx_1 = (int32_T)d;
      loop_ub = Wm->size[0];
      Wm->size[0] = (int32_T)d + 1;
      emxEnsureCapacity_real_T(&st, Wm, loop_ub, &ed_emlrtRTEI);
      Wm_data = Wm->data;
      rmse /= dt;
      Wm_data[0] = rmse;
      for (b_k = 0; b_k < unnamed_idx_1; b_k++) {
        Wm_data[b_k + 1] = c_b;
      }
      b_st.site = &ye_emlrtRSI;
      c_st.site = &tb_emlrtRSI;
      unnamed_idx_1 = (int32_T)d;
      loop_ub = Wc->size[0];
      Wc->size[0] = (int32_T)d + 1;
      emxEnsureCapacity_real_T(&st, Wc, loop_ub, &fd_emlrtRTEI);
      Wc_data = Wc->data;
      Wc_data[0] = rmse + ((1.0 - lambda_tmp) + beta);
      for (b_i = 0; b_i < unnamed_idx_1; b_i++) {
        Wc_data[b_i + 1] = c_b;
      }
      /*   calculo dos sigma points do Grupo para o Update (Eq 45-artigo) */
      /*  G_t=zeros(5,5,2*L+1);  */
      i3 = (int32_T)muDoubleScalarFloor(d + 1.0);
      if (d + 1.0 != i3) {
        emlrtIntegerCheckR2012b(d + 1.0, &j_emlrtDCI, &st);
      }
      loop_ub = Y->size[0] * Y->size[1] * Y->size[2];
      Y->size[0] = 4;
      Y->size[1] = 4;
      b_loop_ub = (int32_T)(d + 1.0);
      Y->size[2] = (int32_T)(d + 1.0);
      emxEnsureCapacity_real_T(&st, Y, loop_ub, &gd_emlrtRTEI);
      Y_data = Y->data;
      loop_ub = (int32_T)(d + 1.0) << 4;
      for (b_i = 0; b_i < loop_ub; b_i++) {
        Y_data[b_i] = 0.0;
      }
      emlrtForLoopVectorCheckR2021a(1.0, 1.0, d + 1.0, mxDOUBLE_CLASS,
                                    (int32_T)(d + 1.0), &v_emlrtRTEI, &st);
      for (b_i = 0; b_i < b_loop_ub; b_i++) {
        if ((b_i + 1 < 1) || (b_i + 1 > G->size[2])) {
          emlrtDynamicBoundsCheckR2012b(b_i + 1, 1, G->size[2], &p_emlrtBCI,
                                        &st);
        }
        memset(&b_I[0], 0, 9U * sizeof(real_T));
        b_I[0] = 1.0;
        b_I[4] = 1.0;
        b_I[8] = 1.0;
        if (((int32_T)((uint32_T)b_i + 1U) < 1) ||
            ((int32_T)((uint32_T)b_i + 1U) > epsh->size[1])) {
          emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)b_i + 1U), 1,
                                        epsh->size[1], &q_emlrtBCI, &st);
        }
        rmse = leverarm[0];
        dt = leverarm[1];
        c_b = leverarm[2];
        for (b_k = 0; b_k < 3; b_k++) {
          loop_ub = b_k + 169 * b_i;
          soma[b_k] = (G_data[loop_ub + 52] +
                       ((G_data[loop_ub] * rmse + G_data[loop_ub + 13] * dt) +
                        G_data[loop_ub + 26] * c_b)) +
                      epsh_data[b_k + 3 * b_i];
        }
        if (((int32_T)((uint32_T)b_i + 1U) < 1) ||
            ((int32_T)((uint32_T)b_i + 1U) > (int32_T)(d + 1.0))) {
          emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)b_i + 1U), 1,
                                        (int32_T)(d + 1.0), &r_emlrtBCI, &st);
        }
        for (b_k = 0; b_k < 3; b_k++) {
          loop_ub = 4 * b_k + 16 * b_i;
          Y_data[loop_ub] = b_I[3 * b_k];
          Y_data[loop_ub + 1] = b_I[3 * b_k + 1];
          Y_data[loop_ub + 2] = b_I[3 * b_k + 2];
          Y_data[(b_k + 16 * b_i) + 12] = soma[b_k];
        }
        Y_data[16 * b_i + 3] = 0.0;
        Y_data[16 * b_i + 7] = 0.0;
        Y_data[16 * b_i + 11] = 0.0;
        Y_data[16 * b_i + 15] = 1.0;
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(&st);
        }
      }
      /*  MEDIA NULA  */
      b_st.site = &af_emlrtRSI;
      /*  equação 32 das notas de UKF-Lie */
      if ((int32_T)(d + 1.0) < 1) {
        emlrtDynamicBoundsCheckR2012b(1, 1, (int32_T)(d + 1.0), &s_emlrtBCI,
                                      &b_st);
      }
      for (b_i = 0; b_i < 4; b_i++) {
        loop_ub = b_i << 2;
        ht[loop_ub] = Y_data[4 * b_i];
        ht[loop_ub + 1] = Y_data[4 * b_i + 1];
        ht[loop_ub + 2] = Y_data[4 * b_i + 2];
        ht[loop_ub + 3] = Y_data[4 * b_i + 3];
      }
      /*  com for */
      unnamed_idx_1 = 0;
      exitg1 = false;
      while (!exitg1 && (unnamed_idx_1 < 30)) {
        soma[0] = 0.0;
        soma[1] = 0.0;
        soma[2] = 0.0;
        emlrtForLoopVectorCheckR2021a(1.0, 1.0, d + 1.0, mxDOUBLE_CLASS,
                                      (int32_T)(d + 1.0), &w_emlrtRTEI, &b_st);
        for (b_i = 0; b_i < b_loop_ub; b_i++) {
          c_st.site = &ff_emlrtRSI;
          if (((int32_T)((uint32_T)b_i + 1U) < 1) ||
              ((int32_T)((uint32_T)b_i + 1U) > Wm->size[0])) {
            emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)b_i + 1U), 1,
                                          Wm->size[0], &y_emlrtBCI, &b_st);
          }
          rmse = lambda_tmp * Wm_data[b_i];
          if ((b_i + 1 < 1) || (b_i + 1 > (int32_T)(d + 1.0))) {
            emlrtDynamicBoundsCheckR2012b(b_i + 1, 1, (int32_T)(d + 1.0),
                                          &t_emlrtBCI, &b_st);
          }
          r = _mm_loadu_pd(&ht[12]);
          r1 = _mm_loadu_pd(&soma[0]);
          _mm_storeu_pd(
              &soma[0],
              _mm_add_pd(r1, _mm_mul_pd(_mm_set1_pd(rmse),
                                        _mm_sub_pd(_mm_loadu_pd(
                                                       &Y_data[16 * b_i + 12]),
                                                   r))));
          soma[2] += rmse * (Y_data[16 * b_i + 14] - ht[14]);
          /* inv(h)*H(:,:,i)= [I H(1:3,4,i)-h(1:3,4);0 1] */
          if (*emlrtBreakCheckR2012bFlagVar != 0) {
            emlrtBreakCheckR2012b(&b_st);
          }
        }
        /*  aux=h; */
        memset(&b_I[0], 0, 9U * sizeof(real_T));
        b_I[0] = 1.0;
        b_I[4] = 1.0;
        b_I[8] = 1.0;
        for (b_k = 0; b_k < 3; b_k++) {
          loop_ub = b_k << 2;
          c_I[loop_ub] = b_I[3 * b_k];
          c_I[loop_ub + 1] = b_I[3 * b_k + 1];
          c_I[loop_ub + 2] = b_I[3 * b_k + 2];
          c_I[b_k + 12] = ht[b_k + 12] + soma[b_k];
        }
        c_I[3] = 0.0;
        c_I[7] = 0.0;
        c_I[11] = 0.0;
        c_I[15] = 1.0;
        memcpy(&ht[0], &c_I[0], 16U * sizeof(real_T));
        /*   h(k+1)=h(k)exp^(soma) */
        if (b_norm(soma) < 0.001) {
          exitg1 = true;
        } else {
          unnamed_idx_1++;
        }
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(&b_st);
        }
      }
      /*  %% com while */
      /*  while (abs(aux(1:3,4)-h(1:3,4)))>1e-3 */
      /*      sum=0; */
      /*      for i=1:2*L+1 */
      /*          sum=sum + (alpha^2)*W(i)*log_apr([eye(3)
       * H(1:3,4,i)-h(1:3,4);zeros(1,3) 1]);  %inv(h)*H(:,:,i)= [I
       * H(1:3,4,i)-h(1:3,4);0 1] */
      /*      end */
      /*      aux=h; */
      /*      h=h*exp_apr(sum); */
      /*  end */
      /*  covariancias de medida e cruzada */
      b_st.site = &bf_emlrtRSI;
      /* dimensao da algebra do processo */
      /*  Eq 47 48 */
      /*  epsh e epsg */
      /*  Vectorised epsh: grab the 4th column of all pages at once */
      loop_ub = b_Y->size[0] * b_Y->size[1] * b_Y->size[2];
      b_Y->size[0] = 3;
      b_Y->size[1] = 1;
      b_Y->size[2] = (int32_T)(d + 1.0);
      emxEnsureCapacity_real_T(&b_st, b_Y, loop_ub, &hd_emlrtRTEI);
      Wc_data = b_Y->data;
      for (b_i = 0; b_i < b_loop_ub; b_i++) {
        Wc_data[3 * b_i] = Y_data[16 * b_i + 12];
        Wc_data[3 * b_i + 1] = Y_data[16 * b_i + 13];
        Wc_data[3 * b_i + 2] = Y_data[16 * b_i + 14];
      }
      c_st.site = &gf_emlrtRSI;
      squeeze(&c_st, b_Y, epsh);
      loop_ub = epsh->size[0] * epsh->size[1];
      epsh->size[0] = 3;
      emxEnsureCapacity_real_T(&b_st, epsh, loop_ub, &id_emlrtRTEI);
      epsh_data = epsh->data;
      loop_ub = epsh->size[1];
      for (b_k = 0; b_k < loop_ub; b_k++) {
        r = _mm_loadu_pd(&ht[12]);
        _mm_storeu_pd(&epsh_data[3 * b_k],
                      _mm_sub_pd(_mm_loadu_pd(&epsh_data[3 * b_k]), r));
        unnamed_idx_1 = 3 * b_k + 2;
        epsh_data[unnamed_idx_1] -= ht[14];
      }
      if (d + 1.0 != i3) {
        emlrtIntegerCheckR2012b(d + 1.0, &k_emlrtDCI, &b_st);
      }
      loop_ub = epsg->size[0] * epsg->size[1];
      epsg->size[0] = 15;
      epsg->size[1] = (int32_T)(d + 1.0);
      emxEnsureCapacity_real_T(&b_st, epsg, loop_ub, &jd_emlrtRTEI);
      Wc_data = epsg->data;
      loop_ub = 15 * (int32_T)(d + 1.0);
      for (b_i = 0; b_i < loop_ub; b_i++) {
        Wc_data[b_i] = 0.0;
      }
      /*  LU factorize g once for all sigma-point solves */
      c_st.site = &hf_emlrtRSI;
      d_st.site = &ge_emlrtRSI;
      LUP(&d_st, &hx[i1], b_L, b_hx, c_P);
      emlrtForLoopVectorCheckR2021a(1.0, 1.0, d + 1.0, mxDOUBLE_CLASS,
                                    (int32_T)(d + 1.0), &x_emlrtRTEI, &b_st);
      for (b_k = 0; b_k < b_loop_ub; b_k++) {
        real_T f_y[169];
        c_st.site = &if_emlrtRSI;
        if ((b_k + 1 < 1) || (b_k + 1 > G->size[2])) {
          emlrtDynamicBoundsCheckR2012b(b_k + 1, 1, G->size[2], &u_emlrtBCI,
                                        &c_st);
        }
        mtimes(c_P, &G_data[169 * b_k], f_y);
        c_st.site = &if_emlrtRSI;
        b_mldivide(&c_st, b_L, f_y);
        c_st.site = &if_emlrtRSI;
        b_mldivide(&c_st, b_hx, f_y);
        if (((int32_T)((uint32_T)b_k + 1U) < 1) ||
            ((int32_T)((uint32_T)b_k + 1U) > epsg->size[1])) {
          emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)b_k + 1U), 1,
                                        epsg->size[1], &ab_emlrtBCI, &b_st);
        }
        c_st.site = &if_emlrtRSI;
        log_multiSE23T6(f_y, &Wc_data[15 * b_k]);
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(&b_st);
        }
      }
      c_st.site = &jf_emlrtRSI;
      d_st.site = &jf_emlrtRSI;
      diag(&d_st, Wc, b);
      d_st.site = &we_emlrtRSI;
      if (b->size[0] != epsh->size[1]) {
        if ((b->size[0] == 1) && (b->size[1] == 1)) {
          emlrtErrorWithMessageIdR2018a(
              &d_st, &b_emlrtRTEI,
              "Coder:toolbox:mtimes_noDynamicScalarExpansion",
              "Coder:toolbox:mtimes_noDynamicScalarExpansion", 0);
        } else {
          emlrtErrorWithMessageIdR2018a(&d_st, &emlrtRTEI, "MATLAB:innerdim",
                                        "MATLAB:innerdim", 0);
        }
      }
      d_st.site = &xd_emlrtRSI;
      d_mtimes(&d_st, epsh, b, b_y);
      Wc_data = b_y->data;
      c_st.site = &jf_emlrtRSI;
      d_st.site = &we_emlrtRSI;
      if (b_y->size[1] != epsh->size[1]) {
        emlrtErrorWithMessageIdR2018a(&d_st, &emlrtRTEI, "MATLAB:innerdim",
                                      "MATLAB:innerdim", 0);
      }
      if (epsh->size[1] == 0) {
        memset(&b_I[0], 0, 9U * sizeof(real_T));
      } else {
        TRANSB1 = 'T';
        TRANSA1 = 'N';
        rmse = 1.0;
        dt = 0.0;
        m_t = (ptrdiff_t)3;
        n_t = (ptrdiff_t)3;
        k_t = (ptrdiff_t)b_y->size[1];
        lda_t = (ptrdiff_t)3;
        ldb_t = (ptrdiff_t)3;
        ldc_t = (ptrdiff_t)3;
        dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &rmse, &Wc_data[0], &lda_t,
              &epsh_data[0], &ldb_t, &dt, &b_I[0], &ldc_t);
      }
      /* (3x2L+1)X(2L+1X2L+1)X(2L+1X3) */
      c_st.site = &kf_emlrtRSI;
      d_st.site = &kf_emlrtRSI;
      diag(&d_st, Wc, b);
      d_st.site = &we_emlrtRSI;
      if (b->size[0] != epsg->size[1]) {
        if ((b->size[0] == 1) && (b->size[1] == 1)) {
          emlrtErrorWithMessageIdR2018a(
              &d_st, &b_emlrtRTEI,
              "Coder:toolbox:mtimes_noDynamicScalarExpansion",
              "Coder:toolbox:mtimes_noDynamicScalarExpansion", 0);
        } else {
          emlrtErrorWithMessageIdR2018a(&d_st, &emlrtRTEI, "MATLAB:innerdim",
                                        "MATLAB:innerdim", 0);
        }
      }
      d_st.site = &xd_emlrtRSI;
      b_mtimes(&d_st, epsg, b, c_y);
      Wc_data = c_y->data;
      c_st.site = &kf_emlrtRSI;
      d_st.site = &we_emlrtRSI;
      if (c_y->size[1] != epsh->size[1]) {
        emlrtErrorWithMessageIdR2018a(&d_st, &emlrtRTEI, "MATLAB:innerdim",
                                      "MATLAB:innerdim", 0);
      }
      if (epsh->size[1] == 0) {
        memset(&Pgh[0], 0, 45U * sizeof(real_T));
      } else {
        TRANSB1 = 'T';
        TRANSA1 = 'N';
        rmse = 1.0;
        dt = 0.0;
        m_t = (ptrdiff_t)15;
        n_t = (ptrdiff_t)3;
        k_t = (ptrdiff_t)c_y->size[1];
        lda_t = (ptrdiff_t)15;
        ldb_t = (ptrdiff_t)3;
        ldc_t = (ptrdiff_t)15;
        dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &rmse, &Wc_data[0], &lda_t,
              &epsh_data[0], &ldb_t, &dt, &Pgh[0], &ldc_t);
      }
      /* (9x2L+1)X(2L+1X2L+1)X(2L+1X3) */
      /*  del_t = logv(inv(ht)*Ygps)= y_gps - ht(1:3,4) */
      /*  Update do eps (eq 49) - Kalman gain via 3x3 solve (Phh is 3x3) */
      /*  K = Pgh / Phh  =>  K = (Phh' \ Pgh')' = (Phh \ Pgh')' */
      /*  Phh is symmetric so Phh'=Phh; use Cholesky-based solve */
      r = _mm_loadu_pd(&b_I[0]);
      _mm_storeu_pd(&b_I[0], _mm_add_pd(r, _mm_loadu_pd(&Prr[0])));
      r = _mm_loadu_pd(&b_I[2]);
      _mm_storeu_pd(&b_I[2], _mm_add_pd(r, _mm_loadu_pd(&Prr[2])));
      r = _mm_loadu_pd(&b_I[4]);
      _mm_storeu_pd(&b_I[4], _mm_add_pd(r, _mm_loadu_pd(&Prr[4])));
      r = _mm_loadu_pd(&b_I[6]);
      _mm_storeu_pd(&b_I[6], _mm_add_pd(r, _mm_loadu_pd(&Prr[6])));
      b_I[8] += Prr[8];
      for (b_k = 0; b_k < 15; b_k++) {
        b_K[3 * b_k] = Pgh[b_k];
        b_K[3 * b_k + 1] = Pgh[b_k + 15];
        b_K[3 * b_k + 2] = Pgh[b_k + 30];
      }
      b_st.site = &cf_emlrtRSI;
      mldivide(&b_st, b_I, b_K, dv);
      for (b_i = 0; b_i < 3; b_i++) {
        for (b_k = 0; b_k < 15; b_k++) {
          b_K[b_k + 15 * b_i] = dv[b_i + 3 * b_k];
        }
      }
      /*  Update Pt */
      b_st.site = &df_emlrtRSI;
      c_st.site = &xd_emlrtRSI;
      TRANSB1 = 'T';
      TRANSA1 = 'N';
      rmse = 1.0;
      dt = 0.0;
      m_t = (ptrdiff_t)15;
      n_t = (ptrdiff_t)15;
      k_t = (ptrdiff_t)3;
      lda_t = (ptrdiff_t)15;
      ldb_t = (ptrdiff_t)15;
      ldc_t = (ptrdiff_t)15;
      dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &rmse, &b_K[0], &lda_t,
            &Pgh[0], &ldb_t, &dt, &b_P[0], &ldc_t);
      for (b_k = 0; b_k < 15; b_k++) {
        for (b_i = 0; b_i <= 12; b_i += 2) {
          loop_ub = b_i + 15 * b_k;
          r = _mm_loadu_pd(&P[loop_ub + i2]);
          r1 = _mm_loadu_pd(&b_P[loop_ub]);
          _mm_storeu_pd(&b_P[loop_ub], _mm_sub_pd(r, r1));
        }
        loop_ub = 15 * b_k + 14;
        b_P[loop_ub] = P[(15 * b_k + i2) + 14] - b_P[loop_ub];
      }
      for (b_i = 0; b_i < 15; b_i++) {
        for (b_k = 0; b_k < 15; b_k++) {
          loop_ub = b_k + 15 * b_i;
          P[loop_ub + i2] = 0.5 * (b_P[loop_ub] + b_P[b_i + 15 * b_k]);
        }
      }
      /*  Update do estado */
      b_st.site = &ef_emlrtRSI;
      memset(&K[0], 0, 15U * sizeof(real_T));
      for (b_k = 0; b_k < 3; b_k++) {
        rmse = y[b_k + 3 * (nk - 1)] - ht[b_k + 12];
        for (b_i = 0; b_i <= 12; b_i += 2) {
          r = _mm_loadu_pd(&b_K[b_i + 15 * b_k]);
          r1 = _mm_loadu_pd(&K[b_i]);
          _mm_storeu_pd(&K[b_i],
                        _mm_add_pd(r1, _mm_mul_pd(r, _mm_set1_pd(rmse))));
        }
        K[14] += b_K[15 * b_k + 14] * rmse;
      }
      c_st.site = &ef_emlrtRSI;
      exp_multiSE23T6(K, b_L);
      memcpy(&b_hx[0], &hx[i1], 169U * sizeof(real_T));
      c_st.site = &xd_emlrtRSI;
      mtimes(b_hx, b_L, &hx[i1]);
      if (nk < M) {
        nk++;
      }
    }
    if (((int32_T)(((real_T)k + 1.0) + 1.0) < 1) ||
        ((int32_T)(((real_T)k + 1.0) + 1.0) > 229272)) {
      emlrtDynamicBoundsCheckR2012b((int32_T)(((real_T)k + 1.0) + 1.0), 1,
                                    229272, &o_emlrtBCI, (emlrtConstCTX)sp);
    }
    memcpy(&b_P[0], &P[k * 225 + 225], 225U * sizeof(real_T));
    for (b_k = 0; b_k < 15; b_k++) {
      K[b_k] = b_P[b_k << 4];
    }
    trP[k + 1] = sumColumnB(K);
    /*  sum of diagonal (faster than trace()) */
    for (b_i = 0; b_i < 3; b_i++) {
      loop_ub = 13 * b_i + i1;
      for (b_k = 0; b_k < 3; b_k++) {
        b_I[b_k + 3 * b_i] =
            (Cen[3 * b_k] * hx[loop_ub] + Cen[3 * b_k + 1] * hx[loop_ub + 1]) +
            Cen[3 * b_k + 2] * hx[loop_ub + 2];
      }
    }
    st.site = &c_emlrtRSI;
    /*  input -> Cba (from a-frame to b-frame) */
    /*  return the euler angles [roll,pitch,yaw] (deg) from a given rotation
     * matrix Cba=C(Psi_ab); */
    /*    */
    b_st.site = &nf_emlrtRSI;
    if ((b_I[6] < -1.0) || (b_I[6] > 1.0)) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &y_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
    }
    loop_ub = 3 * (k + 1);
    euler[loop_ub] = 57.29577951308232 * muDoubleScalarAtan2(b_I[7], b_I[8]);
    euler[loop_ub + 1] = 57.29577951308232 * -muDoubleScalarAsin(b_I[6]);
    euler[loop_ub + 2] =
        57.29577951308232 * muDoubleScalarAtan2(b_I[3], b_I[0]);
    /*     %% */
    if (log_interval == 0.0) {
      rmse = (real_T)k + 1.0;
    } else if (muDoubleScalarIsNaN(log_interval)) {
      rmse = rtNaN;
    } else if (muDoubleScalarIsInf(log_interval)) {
      if (log_interval > 0.0) {
        rmse = (real_T)k + 1.0;
      } else {
        rmse = log_interval;
      }
    } else {
      rmse = muDoubleScalarRem((real_T)k + 1.0, log_interval);
      if (rmse == 0.0) {
        rmse = log_interval * 0.0;
      } else if ((rmse > 0.0) && (log_interval < 0.0)) {
        rmse += log_interval;
      }
    }
    st.site = &d_emlrtRSI;
    if (muDoubleScalarIsNaN(rmse)) {
      emlrtErrorWithMessageIdR2018a(&st, &ab_emlrtRTEI, "MATLAB:nologicalnan",
                                    "MATLAB:nologicalnan", 0);
    }
    if (!(rmse != 0.0)) {
      st.site = &e_emlrtRSI;
      rmse = 100.0 * ((real_T)k + 1.0) / N;
      b_st.site = &of_emlrtRSI;
      d_y = NULL;
      m = emlrtCreateCharArray(2, &b_iv[0]);
      emlrtInitCharArrayR2013a(&b_st, 7, m, &b_u[0]);
      emlrtAssign(&d_y, m);
      e_y = NULL;
      m = emlrtCreateCharArray(2, &b_iv1[0]);
      emlrtInitCharArrayR2013a(&b_st, 31, m, &c_u[0]);
      emlrtAssign(&e_y, m);
      c_st.site = &xf_emlrtRSI;
      emlrt_marshallIn(&c_st,
                       c_feval(&c_st, d_y, emlrt_marshallOut(1.0), e_y,
                               emlrt_marshallOut(rmse), &d_emlrtMCI),
                       "<output of feval>");
    }
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b((emlrtConstCTX)sp);
    }
  }
  emxFree_real_T(sp, &b_Y);
  emxFree_real_T(sp, &c_y);
  emxFree_real_T(sp, &b);
  emxFree_real_T(sp, &b_y);
  emxFree_real_T(sp, &epsg);
  emxFree_real_T(sp, &epsh);
  emxFree_real_T(sp, &Y);
  emxFree_real_T(sp, &Wc);
  emxFree_real_T(sp, &Wm);
  emxFree_real_T(sp, &G);
  for (b_k = 0; b_k < 229272; b_k++) {
    SD->f1.hx[3 * b_k] = hx[169 * b_k + 52];
    SD->f1.b_hx[3 * b_k] = hx[169 * b_k + 39];
    loop_ub = 3 * b_k + 1;
    SD->f1.hx[loop_ub] = hx[169 * b_k + 53];
    SD->f1.b_hx[loop_ub] = hx[169 * b_k + 40];
    loop_ub = 3 * b_k + 2;
    SD->f1.hx[loop_ub] = hx[169 * b_k + 54];
    SD->f1.b_hx[loop_ub] = hx[169 * b_k + 41];
  }
  st.site = &f_emlrtRSI;
  rmse = evaluateStateRMSE(SD, &st, euler, SD->f1.hx, SD->f1.b_hx, ref->pe,
                           ref->euler, ref->ve);
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
  return rmse;
}

/* End of code generation (run_UKF_Lie.c) */
