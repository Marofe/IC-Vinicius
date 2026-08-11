/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * log_multiSE23T6.c
 *
 * Code generation for function 'log_multiSE23T6'
 *
 */

/* Include files */
#include "log_multiSE23T6.h"
#include "norm.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "mwmathutil.h"
#include <emmintrin.h>
#include <string.h>

/* Function Definitions */
void log_multiSE23T6(const real_T X[169], real_T b_log[15])
{
  __m128d r;
  real_T skew_C[9];
  real_T b_skew_C[6];
  real_T a[3];
  real_T phi;
  real_T phi_a_idx_0;
  real_T phi_a_idx_1;
  real_T sin_phi;
  int32_T i;
  /*  log (X_SE_2(3)) */
  /*  Log map for SE_2(3) (multi-SE3): closed-form, avoids eig(). */
  /*  Uses direct Rodrigues extraction from the rotation matrix. */
  /*  phi from trace: tr(C) = 1 + 2*cos(phi) */
  /*  clamp for numerical safety */
  phi = muDoubleScalarAcos(muDoubleScalarMin(
      1.0, muDoubleScalarMax(-1.0, 0.5 * (((X[0] + X[14]) + X[28]) - 1.0))));
  if (phi < 1.0E-10) {
    /*  Near-identity: iJ ~ I, axis is arbitrary */
    phi_a_idx_0 = 0.0;
    phi_a_idx_1 = 0.0;
    phi = 0.0;
    memset(&skew_C[0], 0, 9U * sizeof(real_T));
    skew_C[0] = 1.0;
    skew_C[4] = 1.0;
    skew_C[8] = 1.0;
  } else {
    real_T b_half_phi[9];
    real_T b_a;
    real_T half_phi;
    /*  Extract axis from skew-symmetric part: C - C' = 2*sin(phi)*[a]_x */
    for (i = 0; i < 3; i++) {
      skew_C[3 * i] = 0.5 * (X[13 * i] - X[i]);
      skew_C[3 * i + 1] = 0.5 * (X[13 * i + 1] - X[i + 13]);
      skew_C[3 * i + 2] = 0.5 * (X[13 * i + 2] - X[i + 26]);
    }
    sin_phi = muDoubleScalarSin(phi);
    a[0] = skew_C[5] / sin_phi;
    a[1] = skew_C[6] / sin_phi;
    a[2] = skew_C[1] / sin_phi;
    /*  Normalise to unit vector (guard against numerical drift) */
    sin_phi = b_norm(a);
    if (sin_phi > 1.0E-12) {
      r = _mm_loadu_pd(&a[0]);
      _mm_storeu_pd(&a[0], _mm_div_pd(r, _mm_set1_pd(sin_phi)));
      a[2] /= sin_phi;
    }
    half_phi = phi / 2.0;
    b_a =
        half_phi * (muDoubleScalarCos(half_phi) / muDoubleScalarSin(half_phi));
    phi_a_idx_0 = phi * a[0];
    r = _mm_loadu_pd(&a[0]);
    _mm_storeu_pd(&skew_C[0], _mm_mul_pd(r, _mm_set1_pd(a[0])));
    skew_C[2] = a[0] * a[2];
    phi_a_idx_1 = phi * a[1];
    r = _mm_loadu_pd(&a[0]);
    _mm_storeu_pd(&skew_C[3], _mm_mul_pd(r, _mm_set1_pd(a[1])));
    skew_C[5] = a[1] * a[2];
    phi *= a[2];
    r = _mm_loadu_pd(&a[0]);
    _mm_storeu_pd(&skew_C[6], _mm_mul_pd(r, _mm_set1_pd(a[2])));
    skew_C[8] = a[2] * a[2];
    sin_phi = half_phi * 0.0;
    b_half_phi[0] = sin_phi;
    b_half_phi[3] = half_phi * -a[2];
    b_half_phi[6] = half_phi * a[1];
    b_half_phi[1] = half_phi * a[2];
    b_half_phi[4] = sin_phi;
    b_half_phi[7] = half_phi * -a[0];
    b_half_phi[2] = half_phi * -a[1];
    b_half_phi[5] = half_phi * a[0];
    b_half_phi[8] = sin_phi;
    for (i = 0; i < 9; i++) {
      skew_C[i] =
          (b_a * (real_T)iv[i] + (1.0 - b_a) * skew_C[i]) - b_half_phi[i];
    }
  }
  /*  Log([eye(3) b,zeros(1,3) 1])=b */
  memset(&b_skew_C[0], 0, 6U * sizeof(real_T));
  for (i = 0; i < 2; i++) {
    __m128d r1;
    int32_T i1;
    int32_T skew_C_tmp;
    i1 = 13 * (i + 3);
    sin_phi = X[i1];
    r = _mm_loadu_pd(&skew_C[0]);
    r1 = _mm_loadu_pd(&b_skew_C[3 * i]);
    _mm_storeu_pd(&b_skew_C[3 * i],
                  _mm_add_pd(r1, _mm_mul_pd(r, _mm_set1_pd(sin_phi))));
    skew_C_tmp = 3 * i + 2;
    b_skew_C[skew_C_tmp] += skew_C[2] * sin_phi;
    sin_phi = X[i1 + 1];
    r = _mm_loadu_pd(&skew_C[3]);
    r1 = _mm_loadu_pd(&b_skew_C[3 * i]);
    _mm_storeu_pd(&b_skew_C[3 * i],
                  _mm_add_pd(r1, _mm_mul_pd(r, _mm_set1_pd(sin_phi))));
    b_skew_C[skew_C_tmp] += skew_C[5] * sin_phi;
    sin_phi = X[i1 + 2];
    r = _mm_loadu_pd(&skew_C[6]);
    r1 = _mm_loadu_pd(&b_skew_C[3 * i]);
    _mm_storeu_pd(&b_skew_C[3 * i],
                  _mm_add_pd(r1, _mm_mul_pd(r, _mm_set1_pd(sin_phi))));
    b_skew_C[skew_C_tmp] += skew_C[8] * sin_phi;
  }
  b_log[0] = phi_a_idx_0;
  b_log[1] = phi_a_idx_1;
  b_log[2] = phi;
  for (i = 0; i < 6; i++) {
    b_log[i + 3] = b_skew_C[i];
  }
  b_log[9] = X[109];
  b_log[12] = X[165];
  b_log[10] = X[110];
  b_log[13] = X[166];
  b_log[11] = X[111];
  b_log[14] = X[167];
}

/* End of code generation (log_multiSE23T6.c) */
