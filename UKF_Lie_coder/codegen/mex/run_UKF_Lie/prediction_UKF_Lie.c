/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * prediction_UKF_Lie.c
 *
 * Code generation for function 'prediction_UKF_Lie'
 *
 */

/* Include files */
#include "prediction_UKF_Lie.h"
#include "SigmaPointsLie.h"
#include "cosd.h"
#include "eml_int_forloop_overflow_error.h"
#include "exp_multiSE23T6.h"
#include "log_multiSE23T6.h"
#include "lu.h"
#include "mldivide.h"
#include "mtimes.h"
#include "norm.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"
#include "sind.h"
#include "squeeze.h"
#include "mwmathutil.h"
#include <emmintrin.h>
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo g_emlrtRSI = {
    12,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo h_emlrtRSI = {
    14,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo i_emlrtRSI = {
    15,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo j_emlrtRSI = {
    16,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo k_emlrtRSI = {
    25,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo l_emlrtRSI = {
    27,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo m_emlrtRSI = {
    35,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo n_emlrtRSI = {
    45,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo o_emlrtRSI = {
    49,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo p_emlrtRSI = {
    56,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo q_emlrtRSI = {
    58,                                                         /* lineNo */
    "prediction_UKF_Lie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pathName */
};

static emlrtRSInfo cd_emlrtRSI = {
    52,                  /* lineNo */
    "reshapeSizeChecks", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\reshapeSizeChecks.m" /* pathName */
};

static emlrtRSInfo ed_emlrtRSI = {
    16,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo fd_emlrtRSI = {
    18,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo gd_emlrtRSI = {
    20,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo hd_emlrtRSI = {
    21,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo id_emlrtRSI = {
    22,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo jd_emlrtRSI = {
    23,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo kd_emlrtRSI = {
    25,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo ld_emlrtRSI = {
    26,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo md_emlrtRSI = {
    27,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo nd_emlrtRSI = {
    29,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo od_emlrtRSI = {
    30,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo pd_emlrtRSI = {
    31,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo qd_emlrtRSI = {
    32,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo rd_emlrtRSI = {
    36,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo sd_emlrtRSI = {
    39,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo td_emlrtRSI = {
    43,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

static emlrtRSInfo ud_emlrtRSI = {
    12,                                                           /* lineNo */
    "gravityModel",                                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\common\\gravityModel.m" /* pathName */
};

static emlrtRSInfo be_emlrtRSI = {
    8,                                                    /* lineNo */
    "media_nula_g",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m" /* pathName */
};

static emlrtRSInfo ce_emlrtRSI = {
    12,                                                   /* lineNo */
    "media_nula_g",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m" /* pathName */
};

static emlrtRSInfo de_emlrtRSI = {
    16,                                                   /* lineNo */
    "media_nula_g",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m" /* pathName */
};

static emlrtRSInfo ee_emlrtRSI = {
    17,                                                   /* lineNo */
    "media_nula_g",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m" /* pathName */
};

static emlrtRSInfo fe_emlrtRSI = {
    20,                                                   /* lineNo */
    "media_nula_g",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m" /* pathName */
};

static emlrtMCInfo c_emlrtMCI = {
    24,                                                        /* lineNo */
    1,                                                         /* colNo */
    "SingleLlaFromEcef",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pName */
};

static emlrtBCInfo emlrtBCI = {
    -1,                                                    /* iFirst */
    -1,                                                    /* iLast */
    16,                                                    /* lineNo */
    35,                                                    /* colNo */
    "G",                                                   /* aName */
    "media_nula_g",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m", /* pName */
    0                                                      /* checkKind */
};

static emlrtRTEInfo d_emlrtRTEI = {
    14,                                                   /* lineNo */
    11,                                                   /* colNo */
    "media_nula_g",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m" /* pName */
};

static emlrtRTEInfo e_emlrtRTEI =
    {
        82,         /* lineNo */
        5,          /* colNo */
        "fltpower", /* fName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\ops\\power.m" /* pName
                                                                          */
};

static emlrtRTEInfo f_emlrtRTEI = {
    55,                                                         /* lineNo */
    7,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtDCInfo emlrtDCI = {
    54,                                                          /* lineNo */
    14,                                                          /* colNo */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    1                                                            /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    45,                                                          /* lineNo */
    52,                                                          /* colNo */
    "Q",                                                         /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    35,                                                          /* lineNo */
    36,                                                          /* colNo */
    "E",                                                         /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtRTEInfo g_emlrtRTEI = {
    34,                                                         /* lineNo */
    7,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtDCInfo b_emlrtDCI = {
    33,                                                          /* lineNo */
    17,                                                          /* colNo */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    1                                                            /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = {
    10,                                                          /* lineNo */
    11,                                                          /* colNo */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    1                                                            /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = {
    10,                                                          /* lineNo */
    11,                                                          /* colNo */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    4                                                            /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    56,                                                          /* lineNo */
    41,                                                          /* colNo */
    "G_t",                                                       /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    14,                                                          /* lineNo */
    14,                                                          /* colNo */
    "Xi",                                                        /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    15,                                                          /* lineNo */
    14,                                                          /* colNo */
    "Xi",                                                        /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    45,                                                          /* lineNo */
    13,                                                          /* colNo */
    "G_t",                                                       /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    56,                                                          /* lineNo */
    12,                                                          /* colNo */
    "epsg",                                                      /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = {
    -1,                                                    /* iFirst */
    -1,                                                    /* iLast */
    17,                                                    /* lineNo */
    32,                                                    /* colNo */
    "W",                                                   /* aName */
    "media_nula_g",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\media_nula_g.m", /* pName */
    0                                                      /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = {
    -1,                                                          /* iFirst */
    -1,                                                          /* iLast */
    16,                                                          /* lineNo */
    14,                                                          /* colNo */
    "Xi",                                                        /* aName */
    "prediction_UKF_Lie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m", /* pName */
    0                                                            /* checkKind */
};

static emlrtRTEInfo db_emlrtRTEI = {
    10,                                                         /* lineNo */
    5,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo eb_emlrtRTEI = {
    14,                                                         /* lineNo */
    1,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo fb_emlrtRTEI = {
    15,                                                         /* lineNo */
    1,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo gb_emlrtRTEI = {
    16,                                                         /* lineNo */
    11,                                                         /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo hb_emlrtRTEI = {
    33,                                                         /* lineNo */
    1,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo ib_emlrtRTEI = {
    54,                                                         /* lineNo */
    1,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo jb_emlrtRTEI = {
    58,                                                         /* lineNo */
    9,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo kb_emlrtRTEI = {
    12,                                                         /* lineNo */
    2,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo lb_emlrtRTEI = {
    12,                                                         /* lineNo */
    5,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRTEInfo mb_emlrtRTEI = {
    12,                                                         /* lineNo */
    8,                                                          /* colNo */
    "prediction_UKF_Lie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\prediction_UKF_Lie.m" /* pName */
};

static emlrtRSInfo wf_emlrtRSI = {
    24,                                                        /* lineNo */
    "SingleLlaFromEcef",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SingleLlaFromEcef.m" /* pathName */
};

/* Function Declarations */
static void b_error(const emlrtStack *sp, const mxArray *m,
                    emlrtMCInfo *location);

/* Function Definitions */
static void b_error(const emlrtStack *sp, const mxArray *m,
                    emlrtMCInfo *location)
{
  emlrtCallMATLABR2012b((emlrtConstCTX)sp, 0, NULL, 1, &m, "error", true,
                        location);
}

void prediction_UKF_Lie(const emlrtStack *sp, const real_T g0[169],
                        const real_T Pt0[225], const real_T Pqq[225],
                        const real_T Prr[9], const real_T u[6], real_T alpha,
                        real_T beta, real_T kappa, real_T L, real_T dt,
                        real_T g[169], emxArray_real_T *G_t, emxArray_real_T *R,
                        real_T Pt[225])
{
  static const int32_T b_iv[2] = {1, 21};
  static const char_T b_u[21] = {'H', '<', 'H', 'm', 'i', 'n', '.',
                                 '.', ' ', 'n', 'o', 't', ' ', 'f',
                                 'e', 'a', 's', 'i', 'b', 'l', 'e'};
  __m128d r1;
  __m128d r2;
  __m128d r3;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  emxArray_real_T *E;
  emxArray_real_T *Q;
  emxArray_real_T *Wc;
  emxArray_real_T *Wm;
  emxArray_real_T *Xi;
  emxArray_real_T *r;
  const mxArray *b_m;
  const mxArray *b_y;
  real_T dv[225];
  real_T G_t_1[169];
  real_T b[169];
  real_T c_u[15];
  real_T soma[15];
  real_T Cbe_i[9];
  real_T b_Cbe_i[3];
  real_T fib0[3];
  real_T lla0[3];
  real_T C;
  real_T G;
  real_T H;
  real_T b_beta;
  real_T b_n;
  real_T b_x;
  real_T m;
  real_T p;
  real_T w2;
  real_T x;
  real_T y;
  real_T z;
  real_T *E_data;
  real_T *G_t_data;
  real_T *Q_data;
  real_T *R_data;
  real_T *Wc_data;
  real_T *Wm_data;
  int32_T b_i;
  int32_T c_i;
  int32_T i;
  int32_T n;
  int32_T nx;
  boolean_T exitg1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  /*  lembretes */
  /*  Pt0= antigo P0 */
  /*  Pqq= antigo Q (cov do ruido de processo) */
  /*  Prr= antigo R (cov do ruido de medida) */
  /*  */
  /* dimensão da algebra do processo */
  /* dimensão da algebra da medida */
  /*  calculo do 'novo' estado eta = [eps q r]  */
  if (!(L >= 0.0)) {
    emlrtNonNegativeCheckR2012b(L, &d_emlrtDCI, (emlrtConstCTX)sp);
  }
  if (L != (int32_T)muDoubleScalarFloor(L)) {
    emlrtIntegerCheckR2012b(L, &c_emlrtDCI, (emlrtConstCTX)sp);
  }
  /*  calculo sigma Points */
  emxInit_real_T(sp, &r, 1, &db_emlrtRTEI);
  n = (int32_T)L;
  nx = r->size[0];
  r->size[0] = (int32_T)L;
  emxEnsureCapacity_real_T(sp, r, nx, &db_emlrtRTEI);
  G_t_data = r->data;
  for (i = 0; i < n; i++) {
    G_t_data[i] = 0.0;
  }
  emxInit_real_T(sp, &Xi, 2, &kb_emlrtRTEI);
  emxInit_real_T(sp, &Wm, 1, &lb_emlrtRTEI);
  emxInit_real_T(sp, &Wc, 1, &mb_emlrtRTEI);
  st.site = &g_emlrtRSI;
  SigmaPointsLie(&st, r, alpha, beta, kappa, Pt0, Pqq, Prr, L, Xi, Wm, Wc);
  Wc_data = Wc->data;
  Wm_data = Wm->data;
  G_t_data = Xi->data;
  emxFree_real_T(sp, &r);
  /*  Xi é composto por: */
  emxInit_real_T(sp, &E, 2, &eb_emlrtRTEI);
  nx = E->size[0] * E->size[1];
  E->size[0] = 15;
  n = Xi->size[1];
  E->size[1] = Xi->size[1];
  emxEnsureCapacity_real_T(sp, E, nx, &eb_emlrtRTEI);
  E_data = E->data;
  for (i = 0; i < n; i++) {
    for (b_i = 0; b_i < 15; b_i++) {
      if (b_i + 1 > Xi->size[0]) {
        emlrtDynamicBoundsCheckR2012b(b_i + 1, 1, Xi->size[0], &e_emlrtBCI,
                                      (emlrtConstCTX)sp);
      }
      E_data[b_i + 15 * i] = G_t_data[b_i + Xi->size[0] * i];
    }
  }
  st.site = &h_emlrtRSI;
  b_squeeze(&st, E);
  emxInit_real_T(sp, &Q, 2, &fb_emlrtRTEI);
  nx = Q->size[0] * Q->size[1];
  Q->size[0] = 15;
  Q->size[1] = Xi->size[1];
  emxEnsureCapacity_real_T(sp, Q, nx, &fb_emlrtRTEI);
  Q_data = Q->data;
  for (i = 0; i < n; i++) {
    for (b_i = 0; b_i < 15; b_i++) {
      if (b_i + 16 > Xi->size[0]) {
        emlrtDynamicBoundsCheckR2012b(b_i + 16, 1, Xi->size[0], &f_emlrtBCI,
                                      (emlrtConstCTX)sp);
      }
      Q_data[b_i + 15 * i] = G_t_data[(b_i + Xi->size[0] * i) + 15];
    }
  }
  st.site = &i_emlrtRSI;
  b_squeeze(&st, Q);
  st.site = &j_emlrtRSI;
  nx = R->size[0] * R->size[1];
  R->size[0] = 3;
  R->size[1] = Xi->size[1];
  emxEnsureCapacity_real_T(&st, R, nx, &gb_emlrtRTEI);
  R_data = R->data;
  for (i = 0; i < n; i++) {
    if (Xi->size[0] < 31) {
      emlrtDynamicBoundsCheckR2012b(31, 1, Xi->size[0], &j_emlrtBCI, &st);
    }
    R_data[3 * i] = G_t_data[Xi->size[0] * i + 30];
    if (Xi->size[0] < 32) {
      emlrtDynamicBoundsCheckR2012b(32, 1, Xi->size[0], &j_emlrtBCI, &st);
    }
    R_data[3 * i + 1] = G_t_data[Xi->size[0] * i + 31];
    if (Xi->size[0] < 33) {
      emlrtDynamicBoundsCheckR2012b(33, 1, Xi->size[0], &j_emlrtBCI, &st);
    }
    R_data[3 * i + 2] = G_t_data[Xi->size[0] * i + 32];
  }
  b_st.site = &bd_emlrtRSI;
  nx = 3 * Xi->size[1];
  c_st.site = &cd_emlrtRSI;
  n = 3;
  if (Xi->size[1] > 3) {
    n = Xi->size[1];
  }
  if (Xi->size[1] > muIntScalarMax_sint32(nx, n)) {
    emlrtErrorWithMessageIdR2018a(&b_st, &i_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  /*  Pre-compute geodetic quantities from mean state (shared by all sigma pts)
   */
  /*  This avoids calling SingleLlaFromEcef/DCM_en/gravityModel 2*L+1 times. */
  /*  Cbe = Ceb' */
  st.site = &k_emlrtRSI;
  /* ECEFFROMLLA Summary of this function */
  /*  input-> [x,y,z] in meters */
  /*  output->[lat,lon,alt] in degree and meters */
  /*  Reference: */
  /*  Karl Osen. Accurate Conversion of Earth-Fixed Earth-Centered Coordinates
   */
  /*  to Geodetic Coordinates. [Research Report] */
  /*  Norwegian University of Science and Technology. 2017.  */
  x = g0[52];
  y = g0[53];
  z = g0[54];
  /* R0 */
  b_st.site = &ed_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  /*  Enhanced Algorithm */
  b_st.site = &fd_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_st.site = &fd_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  w2 = g0[52] * g0[52] + g0[53] * g0[53];
  m = w2 / 4.0680631590769E+13;
  b_st.site = &gd_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  b_st.site = &gd_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_n = g0[54] * g0[54] * 0.9933056200098785 / 4.0680631590769E+13;
  b_st.site = &hd_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  p = ((m + b_n) - 4.481472345213827E-5) / 6.0;
  b_st.site = &id_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  G = m * b_n * 1.1203680863034568E-5;
  b_st.site = &jd_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  H = 2.0 * muDoubleScalarPower(p, 3.0) + G;
  if (H < 2.2501018202642083E-14) {
    b_y = NULL;
    b_m = emlrtCreateCharArray(2, &b_iv[0]);
    emlrtInitCharArrayR2013a(&st, 21, b_m, &b_u[0]);
    emlrtAssign(&b_y, b_m);
    b_st.site = &wf_emlrtRSI;
    b_error(&b_st, b_y, &c_emlrtMCI);
  }
  b_st.site = &kd_emlrtRSI;
  c_st.site = &kd_emlrtRSI;
  b_x = H * G;
  if (b_x < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &c_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  b_x = muDoubleScalarSqrt(b_x);
  C = (H + G) + 2.0 * b_x;
  c_st.site = &ub_emlrtRSI;
  if (C < 0.0) {
    emlrtErrorWithMessageIdR2018a(&c_st, &e_emlrtRTEI,
                                  "Coder:toolbox:power_domainError",
                                  "Coder:toolbox:power_domainError", 0);
  }
  C = muDoubleScalarPower(C, 0.3333333333333333) / 1.2599210498948732;
  b_st.site = &ld_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  H = -((m + 2.2407361726069136E-5) + b_n) / 2.0;
  b_st.site = &md_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_beta = (H / 3.0 - C) - p * p / C;
  b_st.site = &nd_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  b_st.site = &nd_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  G = 1.1203680863034568E-5 * ((1.1203680863034568E-5 - m) - b_n);
  b_st.site = &od_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_st.site = &od_emlrtRSI;
  C = b_beta * b_beta - G;
  if (C < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  C = muDoubleScalarSqrt(C);
  b_st.site = &od_emlrtRSI;
  b_st.site = &od_emlrtRSI;
  m -= b_n;
  p = muDoubleScalarSqrt(C - (b_beta + H) / 2.0) -
      muDoubleScalarSign(m) *
          muDoubleScalarSqrt(muDoubleScalarAbs((b_beta - H) / 2.0));
  b_st.site = &pd_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_st.site = &pd_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_st.site = &qd_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  C = 0.006694379990121436 * m;
  b_st.site = &rd_emlrtRSI;
  b_st.site = &sd_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  C = p + -(((muDoubleScalarPower(p, 4.0) + 2.0 * H * (p * p)) + C * p) + G) /
              ((4.0 * muDoubleScalarPower(p, 3.0) + 4.0 * H * p) + C);
  lla0[0] =
      57.29577951308232 *
      muDoubleScalarAtan2(z * (C + 0.003347189995060718),
                          muDoubleScalarSqrt(w2) * (C - 0.003347189995060718));
  /* latitude */
  lla0[1] = 57.29577951308232 * muDoubleScalarAtan2(y, x);
  /* longitude */
  b_st.site = &td_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_st.site = &td_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  b_st.site = &td_emlrtRSI;
  /* altitude */
  /*  Compute DCM from navigation to ECEF frame */
  /*  input-> lat,lon (deg) */
  /*  output-> Cen */
  p = lla0[1];
  b_cosd(&p);
  G = lla0[0];
  b_sind(&G);
  H = lla0[1];
  b_sind(&H);
  b_x = lla0[0];
  b_cosd(&b_x);
  st.site = &l_emlrtRSI;
  /* Compute the nominal gravity value considering the WGS-84 model */
  /*   input -> latitude in deg */
  /*   output -> local gravity in m/s^2 */
  /*  Reference:  */
  /* [1] R. M. Rogers, Applied Mathematics in Integrated Navigation Systems, */
  /*  vol. 27, no. 7. 2003. */
  /* First Eccentricity */
  /* Gravit at equator */
  /*  Gravity formula constant */
  b_st.site = &ud_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  b_st.site = &ud_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  b_st.site = &ud_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  b_st.site = &ud_emlrtRSI;
  C = G * G;
  C = 9.7803267714 * (0.00193185138639 * C + 1.0) /
      muDoubleScalarSqrt(1.0 - 0.0066943799901378 * C);
  Cbe_i[0] = -G * p;
  Cbe_i[3] = -H;
  Cbe_i[6] = -b_x * p;
  Cbe_i[1] = -G * H;
  Cbe_i[4] = p;
  Cbe_i[7] = -b_x * H;
  Cbe_i[2] = b_x;
  Cbe_i[5] = 0.0;
  Cbe_i[8] = -G;
  memset(&lla0[0], 0, 3U * sizeof(real_T));
  r1 = _mm_loadu_pd(&Cbe_i[0]);
  r2 = _mm_loadu_pd(&lla0[0]);
  r3 = _mm_set1_pd(0.0);
  _mm_storeu_pd(&lla0[0], _mm_add_pd(r2, _mm_mul_pd(r1, r3)));
  lla0[2] += b_x * 0.0;
  fib0[0] = u[0] * C;
  r1 = _mm_loadu_pd(&Cbe_i[3]);
  r2 = _mm_loadu_pd(&lla0[0]);
  _mm_storeu_pd(&lla0[0], _mm_add_pd(r2, _mm_mul_pd(r1, r3)));
  fib0[1] = u[1] * C;
  r1 = _mm_loadu_pd(&Cbe_i[6]);
  r2 = _mm_loadu_pd(&lla0[0]);
  _mm_storeu_pd(&lla0[0], _mm_add_pd(r2, _mm_mul_pd(r1, _mm_set1_pd(C))));
  lla0[2] += C * -G;
  fib0[2] = u[2] * C;
  /*  EQ 41 e 42 sigmPoint pela função dinâmica */
  b_n = 2.0 * L + 1.0;
  n = (int32_T)muDoubleScalarFloor(b_n);
  if (b_n != n) {
    emlrtIntegerCheckR2012b(b_n, &b_emlrtDCI, (emlrtConstCTX)sp);
  }
  nx = G_t->size[0] * G_t->size[1] * G_t->size[2];
  G_t->size[0] = 13;
  G_t->size[1] = 13;
  c_i = (int32_T)b_n;
  G_t->size[2] = c_i;
  emxEnsureCapacity_real_T(sp, G_t, nx, &hb_emlrtRTEI);
  G_t_data = G_t->data;
  nx = 169 * c_i;
  for (b_i = 0; b_i < nx; b_i++) {
    G_t_data[b_i] = 0.0;
  }
  /* G => SE_2(3)= [Ceb v p,0 I]5X5  */
  emlrtForLoopVectorCheckR2021a(1.0, 1.0, b_n, mxDOUBLE_CLASS, c_i,
                                &g_emlrtRTEI, (emlrtConstCTX)sp);
  C = lla0[0];
  p = lla0[1];
  G = lla0[2];
  r2 = _mm_set1_pd(dt);
  for (i = 0; i < c_i; i++) {
    st.site = &m_emlrtRSI;
    if ((int32_T)((uint32_T)i + 1U) > E->size[1]) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)i + 1U), 1, E->size[1],
                                    &c_emlrtBCI, &st);
    }
    b_st.site = &m_emlrtRSI;
    exp_multiSE23T6(&E_data[15 * i], b);
    b_st.site = &xd_emlrtRSI;
    mtimes(g0, b, G_t_1);
    /*  G(t-1|t-1) */
    /*  Re-use pre-computed gn,ge,Cen — extract per-sigma Cbe,v,ba,bg */
    for (b_i = 0; b_i < 3; b_i++) {
      Cbe_i[3 * b_i] = G_t_1[b_i];
      Cbe_i[3 * b_i + 1] = G_t_1[b_i + 13];
      Cbe_i[3 * b_i + 2] = G_t_1[b_i + 26];
    }
    /*  fib + Cbe*ge */
    st.site = &n_emlrtRSI;
    memset(&b_Cbe_i[0], 0, 3U * sizeof(real_T));
    H = b_Cbe_i[0];
    b_x = b_Cbe_i[1];
    m = b_Cbe_i[2];
    for (b_i = 0; b_i < 3; b_i++) {
      b_beta = G_t_1[b_i + 39];
      H += Cbe_i[3 * b_i] * b_beta;
      b_x += Cbe_i[3 * b_i + 1] * b_beta;
      m += Cbe_i[3 * b_i + 2] * b_beta;
      lla0[b_i] = (fib0[b_i] - G_t_1[b_i + 109]) +
                  ((Cbe_i[b_i] * C + Cbe_i[b_i + 3] * p) + Cbe_i[b_i + 6] * G);
    }
    b_Cbe_i[2] = m;
    b_Cbe_i[1] = b_x;
    b_Cbe_i[0] = H;
    if ((int32_T)((uint32_T)i + 1U) > Q->size[1]) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)i + 1U), 1, Q->size[1],
                                    &b_emlrtBCI, &st);
    }
    r1 = _mm_loadu_pd(&G_t_1[165]);
    _mm_storeu_pd(&c_u[0], _mm_mul_pd(_mm_sub_pd(_mm_loadu_pd(&u[3]), r1), r2));
    r1 = _mm_loadu_pd(&lla0[0]);
    _mm_storeu_pd(&c_u[3], _mm_mul_pd(r1, r2));
    r1 = _mm_loadu_pd(&b_Cbe_i[0]);
    _mm_storeu_pd(&c_u[6], _mm_mul_pd(r1, r2));
    c_u[2] = (u[5] - G_t_1[167]) * dt;
    c_u[5] = lla0[2] * dt;
    c_u[8] = m * dt;
    for (b_i = 0; b_i < 6; b_i++) {
      c_u[b_i + 9] = 0.0 * dt;
    }
    for (b_i = 0; b_i <= 12; b_i += 2) {
      r1 = _mm_loadu_pd(&c_u[b_i]);
      _mm_storeu_pd(&c_u[b_i],
                    _mm_add_pd(r1, _mm_loadu_pd(&Q_data[b_i + 15 * i])));
    }
    c_u[14] += Q_data[15 * i + 14];
    b_st.site = &n_emlrtRSI;
    exp_multiSE23T6(c_u, b);
    if ((int32_T)((uint32_T)i + 1U) > G_t->size[2]) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)i + 1U), 1,
                                    G_t->size[2], &g_emlrtBCI, &st);
    }
    b_st.site = &xd_emlrtRSI;
    mtimes(G_t_1, b, &G_t_data[169 * i]);
    /*  G(t|t-1) */
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b((emlrtConstCTX)sp);
    }
  }
  /*  Predição do estado (eq 32) - Média nula */
  st.site = &o_emlrtRSI;
  /*  equação 32 das notas de UKF-Lie */
  /*  Optimized: vectorised inner sum + single LU-solve for inverse. */
  for (i = 0; i < 169; i++) {
    g[i] = G_t_data[i];
  }
  b_st.site = &be_emlrtRSI;
  c_st.site = &tb_emlrtRSI;
  C = alpha * alpha;
  nx = 0;
  exitg1 = false;
  while (!exitg1 && (nx < 30)) {
    real_T P[169];
    /*  LU-factorize once; use to solve g\G_t(:,:,i) for all i */
    b_st.site = &ce_emlrtRSI;
    c_st.site = &ge_emlrtRSI;
    LUP(&c_st, g, G_t_1, b, P);
    memset(&soma[0], 0, 15U * sizeof(real_T));
    emlrtForLoopVectorCheckR2021a(1.0, 1.0, b_n, mxDOUBLE_CLASS, c_i,
                                  &d_emlrtRTEI, &st);
    for (b_i = 0; b_i < c_i; b_i++) {
      real_T Gi_rel[169];
      /*  g\G(:,:,i) via precomputed LU  (avoids extra factorisation) */
      b_st.site = &de_emlrtRSI;
      if (b_i + 1 > G_t->size[2]) {
        emlrtDynamicBoundsCheckR2012b(b_i + 1, 1, G_t->size[2], &emlrtBCI,
                                      &b_st);
      }
      c_st.site = &xd_emlrtRSI;
      mtimes(P, &G_t_data[169 * b_i], Gi_rel);
      b_st.site = &de_emlrtRSI;
      b_mldivide(&b_st, G_t_1, Gi_rel);
      b_st.site = &de_emlrtRSI;
      b_mldivide(&b_st, b, Gi_rel);
      if ((int32_T)((uint32_T)b_i + 1U) > Wm->size[0]) {
        emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)b_i + 1U), 1,
                                      Wm->size[0], &i_emlrtBCI, &st);
      }
      p = C * Wm_data[b_i];
      b_st.site = &ee_emlrtRSI;
      log_multiSE23T6(Gi_rel, c_u);
      for (i = 0; i <= 12; i += 2) {
        r1 = _mm_loadu_pd(&c_u[i]);
        r2 = _mm_loadu_pd(&soma[i]);
        _mm_storeu_pd(&soma[i], _mm_add_pd(r2, _mm_mul_pd(_mm_set1_pd(p), r1)));
      }
      soma[14] += p * c_u[14];
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(&st);
      }
    }
    b_st.site = &fe_emlrtRSI;
    c_st.site = &fe_emlrtRSI;
    exp_multiSE23T6(soma, b);
    memcpy(&G_t_1[0], &g[0], 169U * sizeof(real_T));
    c_st.site = &xd_emlrtRSI;
    mtimes(G_t_1, b, g);
    /*  Convergence: use the soma norm (already computed) as proxy */
    if (c_norm(soma) < 0.001) {
      exitg1 = true;
    } else {
      nx++;
    }
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }
  emxFree_real_T(&st, &Wm);
  /*  Predição covariancia (eq 44) - vectorised */
  /*  Batch-solve: epsg(:,i) = log( g \ G_t(:,:,i) ) */
  /*  Reshape G_t pages into columns, solve once, reshape back */
  if (c_i != n) {
    emlrtIntegerCheckR2012b(b_n, &emlrtDCI, (emlrtConstCTX)sp);
  }
  nx = E->size[0] * E->size[1];
  E->size[0] = 15;
  E->size[1] = c_i;
  emxEnsureCapacity_real_T(sp, E, nx, &ib_emlrtRTEI);
  E_data = E->data;
  nx = 15 * c_i;
  for (i = 0; i < nx; i++) {
    E_data[i] = 0.0;
  }
  emlrtForLoopVectorCheckR2021a(1.0, 1.0, b_n, mxDOUBLE_CLASS, c_i,
                                &f_emlrtRTEI, (emlrtConstCTX)sp);
  for (i = 0; i < c_i; i++) {
    if ((int32_T)((uint32_T)i + 1U) > G_t->size[2]) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)i + 1U), 1,
                                    G_t->size[2], &d_emlrtBCI,
                                    (emlrtConstCTX)sp);
    }
    for (b_i = 0; b_i < 169; b_i++) {
      G_t_1[b_i] = G_t_data[b_i + i * 169];
    }
    st.site = &p_emlrtRSI;
    b_mldivide(&st, g, G_t_1);
    if ((int32_T)((uint32_T)i + 1U) > E->size[1]) {
      emlrtDynamicBoundsCheckR2012b((int32_T)((uint32_T)i + 1U), 1, E->size[1],
                                    &h_emlrtBCI, (emlrtConstCTX)sp);
    }
    st.site = &p_emlrtRSI;
    log_multiSE23T6(G_t_1, &E_data[15 * i]);
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b((emlrtConstCTX)sp);
    }
  }
  st.site = &q_emlrtRSI;
  b_st.site = &q_emlrtRSI;
  n = Wc->size[0];
  nx = Xi->size[0] * Xi->size[1];
  Xi->size[0] = Wc->size[0];
  Xi->size[1] = Wc->size[0];
  emxEnsureCapacity_real_T(&b_st, Xi, nx, &jb_emlrtRTEI);
  G_t_data = Xi->data;
  nx = Wc->size[0] * Wc->size[0];
  for (b_i = 0; b_i < nx; b_i++) {
    G_t_data[b_i] = 0.0;
  }
  c_st.site = &ve_emlrtRSI;
  if (Wc->size[0] > 2147483646) {
    d_st.site = &hb_emlrtRSI;
    eml_int_forloop_overflow_error(&d_st);
  }
  c_st.site = &ve_emlrtRSI;
  for (i = 0; i < n; i++) {
    G_t_data[i + Xi->size[0] * i] = Wc_data[i];
  }
  emxFree_real_T(&b_st, &Wc);
  b_st.site = &we_emlrtRSI;
  if (Xi->size[0] != E->size[1]) {
    if ((Xi->size[0] == 1) && (Xi->size[1] == 1)) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &b_emlrtRTEI, "Coder:toolbox:mtimes_noDynamicScalarExpansion",
          "Coder:toolbox:mtimes_noDynamicScalarExpansion", 0);
    } else {
      emlrtErrorWithMessageIdR2018a(&b_st, &emlrtRTEI, "MATLAB:innerdim",
                                    "MATLAB:innerdim", 0);
    }
  }
  b_st.site = &xd_emlrtRSI;
  b_mtimes(&b_st, E, Xi, Q);
  emxFree_real_T(&st, &Xi);
  st.site = &q_emlrtRSI;
  b_st.site = &we_emlrtRSI;
  if (Q->size[1] != E->size[1]) {
    emlrtErrorWithMessageIdR2018a(&b_st, &emlrtRTEI, "MATLAB:innerdim",
                                  "MATLAB:innerdim", 0);
  }
  b_st.site = &xd_emlrtRSI;
  c_mtimes(Q, E, Pt);
  emxFree_real_T(&st, &Q);
  emxFree_real_T(&st, &E);
  for (i = 0; i <= 222; i += 2) {
    r1 = _mm_loadu_pd(&Pt[i]);
    _mm_storeu_pd(&Pt[i], _mm_add_pd(r1, _mm_loadu_pd(&Pqq[i])));
  }
  Pt[224] += Pqq[224];
  /* eq 44 */
  for (b_i = 0; b_i < 15; b_i++) {
    for (i = 0; i < 15; i++) {
      nx = i + 15 * b_i;
      dv[nx] = 0.5 * (Pt[nx] + Pt[b_i + 15 * i]);
    }
  }
  memcpy(&Pt[0], &dv[0], 225U * sizeof(real_T));
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

/* End of code generation (prediction_UKF_Lie.c) */
