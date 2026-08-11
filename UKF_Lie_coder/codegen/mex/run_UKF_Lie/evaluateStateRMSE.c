/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * evaluateStateRMSE.c
 *
 * Code generation for function 'evaluateStateRMSE'
 *
 */

/* Include files */
#include "evaluateStateRMSE.h"
#include "eulerENU2NED.h"
#include "mean.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_types.h"
#include "sumMatrixIncludeNaN.h"
#include "mwmathutil.h"
#include "omp.h"
#include <emmintrin.h>
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo pf_emlrtRSI = {
    15,                  /* lineNo */
    "evaluateStateRMSE", /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\common\\evaluateStateRMSE.m" /* pathName
                                                                        */
};

/* Function Definitions */
real_T evaluateStateRMSE(run_UKF_LieStackData *SD, const emlrtStack *sp,
                         const real_T euler[687816], const real_T pe[687816],
                         const real_T ve[687816], const real_T ref_pe[687816],
                         const real_T ref_euler[687816],
                         const real_T ref_ve[687816])
{
  jmp_buf *volatile emlrtJBStack;
  emlrtStack st;
  real_T d;
  real_T q;
  real_T rmse;
  int32_T a_tmp;
  int32_T b_a_tmp;
  int32_T b_k;
  int32_T evaluateStateRMSE_numThreads;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T i3;
  int32_T k;
  int32_T x_tmp;
  st.prev = sp;
  st.tls = sp->tls;
  /*  EVALUATESTATERMSE - Compute RMSE for attitude, position, and velocity */
  /*  */
  /*  Inputs: */
  /*  hx  - state vector(s) [roll,pitch,yaw,vx,vy,vz,px,py,pz] (9xN) in NED
   * frame */
  /*  ref - reference structure with fields: euler (ENU), pe (position), ve
   * (velocity) */
  /*  Cen - geodetic center needed for ECEF->NED conversion */
  /*  Outputs: */
  /*  rmse   - combined RMSE across angles, position, and velocity */
  /*  angles - RMSE per Euler angle */
  /*  pos    - RMSE for position (3D) */
  /*  vel    - RMSE for velocity (3D) */
  /* hx=[roll,pitch,yaw,vx,vy,vz,px,py,pz] (9x1) NED-frame */
  memcpy(&SD->f0.eulerRef[0], &ref_euler[0], 687816U * sizeof(real_T));
  st.site = &pf_emlrtRSI;
  eulerENU2NED(&st, SD->f0.eulerRef);
  /* NED frame */
  /*  Per-angle RMSE between reference and estimated Euler angles */
  /*  Wrap using modulo arithmetic */
  /* wrapped_error = mod(raw_error + pi, 2*pi) - pi; */
  emlrtEnterParallelRegion((emlrtCTX)sp, omp_in_parallel());
  emlrtPushJmpBuf((emlrtCTX)sp, &emlrtJBStack);
  evaluateStateRMSE_numThreads = emlrtAllocRegionTLSs(
      sp->tls, omp_in_parallel(), omp_get_max_threads(), omp_get_num_procs());
#pragma omp parallel for num_threads(evaluateStateRMSE_numThreads) private(    \
        i1, x_tmp)

  for (i = 0; i < 3; i++) {
    for (i1 = 0; i1 < 229272; i1++) {
      x_tmp = i1 + 229272 * i;
      SD->f0.x[x_tmp] =
          (SD->f0.eulerRef[x_tmp] - euler[i + 3 * i1]) + 3.141592653589793;
    }
  }
  emlrtPopJmpBuf((emlrtCTX)sp, &emlrtJBStack);
  emlrtExitParallelRegion((emlrtCTX)sp, omp_in_parallel());
  emlrtEnterParallelRegion((emlrtCTX)sp, omp_in_parallel());
  emlrtPushJmpBuf((emlrtCTX)sp, &emlrtJBStack);
  evaluateStateRMSE_numThreads = emlrtAllocRegionTLSs(
      sp->tls, omp_in_parallel(), omp_get_max_threads(), omp_get_num_procs());
#pragma omp parallel for num_threads(evaluateStateRMSE_numThreads) private(q, d)

  for (k = 0; k < 687816; k++) {
    d = SD->f0.x[k];
    if (muDoubleScalarIsNaN(d) || muDoubleScalarIsInf(d)) {
      q = rtNaN;
    } else {
      q = muDoubleScalarAbs(d / 6.283185307179586);
      if (muDoubleScalarAbs(q - muDoubleScalarFloor(q + 0.5)) >
          2.220446049250313E-16 * q) {
        q = muDoubleScalarRem(d, 6.283185307179586);
      } else {
        q = 0.0;
      }
      if (q == 0.0) {
        q = 0.0;
      } else if (q < 0.0) {
        q += 6.283185307179586;
      }
    }
    SD->f0.eulerRef[k] = q;
  }
  emlrtPopJmpBuf((emlrtCTX)sp, &emlrtJBStack);
  emlrtExitParallelRegion((emlrtCTX)sp, omp_in_parallel());
  /*  Position RMSE (3 components) */
  /*  Velocity RMSE (3 components) */
  /*  Combined RMSE over all concatenated error components */
  emlrtEnterParallelRegion((emlrtCTX)sp, omp_in_parallel());
  emlrtPushJmpBuf((emlrtCTX)sp, &emlrtJBStack);
  evaluateStateRMSE_numThreads = emlrtAllocRegionTLSs(
      sp->tls, omp_in_parallel(), omp_get_max_threads(), omp_get_num_procs());
#pragma omp parallel for num_threads(evaluateStateRMSE_numThreads) private(    \
        i3, a_tmp, b_a_tmp)

  for (i2 = 0; i2 < 3; i2++) {
    for (i3 = 0; i3 < 229272; i3++) {
      a_tmp = i3 + 229272 * i2;
      SD->f0.a[a_tmp] = SD->f0.eulerRef[a_tmp] - 3.141592653589793;
      b_a_tmp = i2 + 3 * i3;
      SD->f0.a[i3 + 229272 * (i2 + 3)] = ref_pe[a_tmp] - pe[b_a_tmp];
      SD->f0.a[i3 + 229272 * (i2 + 6)] = ref_ve[a_tmp] - ve[b_a_tmp];
    }
  }
  emlrtPopJmpBuf((emlrtCTX)sp, &emlrtJBStack);
  emlrtExitParallelRegion((emlrtCTX)sp, omp_in_parallel());
  for (b_k = 0; b_k <= 2063446; b_k += 2) {
    __m128d r;
    r = _mm_loadu_pd(&SD->f0.a[b_k]);
    _mm_storeu_pd(&SD->f0.y[b_k], _mm_mul_pd(r, r));
  }
  real_T dv[9];
  mean(SD->f0.y, dv);
  rmse = muDoubleScalarSqrt(c_sumColumnB(dv));
  return rmse;
}

/* End of code generation (evaluateStateRMSE.c) */
