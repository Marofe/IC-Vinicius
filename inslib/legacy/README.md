# Quarantined Legacy & Orphaned Codebase (inslib/legacy/)

This directory houses deprecated, uncalled, and legacy navigation routines segregated from the active Lie-group navigation pipeline ($SE_2(3) \times \mathbb{R}^6$) in accordance with Requirements R1 (Problems #21, #24, #35) of the IC-Vinicius refactoring initiative.

---

## 1. Directory Structure

```
inslib/legacy/
??? README.md                           # This document
??? filters_euler/                      # Legacy Euler-angle filtering routines
?   ??? EKF_prediction.m
?   ??? EKF_update.m                    # Latent bug: missing transpose on Ceb = rotm(...)
?   ??? UKF_prediction_ins.m
?   ??? UKF_update_ins.m                # Latent bug: calls undefined function h()
?   ??? UKF_eul_pred.m
?   ??? UKF_eul_upd.m
?   ??? dynamicJacobian_euler.m         # Euler gimbal rate singularity at pitch = ?90?
?   ??? measurementJacobian_euler.m
?   ??? f.m
?   ??? Gamma.m
??? filters_quaternion/                 # Legacy quaternion filtering routines
?   ??? Prediction_EKF_Quat.m           # Canonical name (fixed typo: predction -> prediction) (#21)
?   ??? predction_ekf_quat.m            # Backward-compatible typo alias wrapper (#21)
?   ??? prediction_ekf_quat.m           # Lowercase alias wrapper
?   ??? update_ekf_quat.m
?   ??? UKF_pred_quat.m
?   ??? UKF_upd_quat.m
?   ??? f_quat.m
?   ??? Jacobian_quat.m
?   ??? Jacobian_medida_quat.m
?   ??? media_quat.m
?   ??? mult_quat.m
?   ??? rotmFromQuat.m                  # Quarantined from inslib/common/
?   ??? sigmaPoints_quat.m
??? symbolic_scratch/                   # Offline symbolic derivation scripts
?   ??? Jacobian_C.m                    # Scratch script with clear all; close all; clc;
?   ??? Jacobian_H.m                    # Scratch script with clear all; close all; clc;
?   ??? Jacobian_euler.m                # Scratch script with clear all; close all; clc;
?   ??? Matriz_C.m                      # Obsolete 9-state state Jacobian
?   ??? matriz_H.m                      # Obsolete 9-state measurement matrix
??? orphaned_utilities/                 # Uncalled plotting, math, and Lie approximations
    ??? plotAccel.m, plotAttitude.m, plotBias.m, plotBody.m, plotGyro.m, plotHeight.m, plotLeverarm.m
    ??? nedFromEcef.m, nedRotation.m, nedCart2lla.m, nedCart2llad.m, eulerECEF2NED.m
    ??? rotIMUData.m, rotIMUData2.m, rotXd.m, rotYd.m, rotZd.m
    ??? expSE3.m, exp_apr.m, exp_multiframeSE3.m, exp_multiframeSE32.m, exp_multiSE3_sym.m
    ??? log_apr.m, log_multiSE3_approx.m, log_SE3.m, log_SE3_approx.m
    ??? log_SO3.m, log_SO3_approx.m, log_SO_2_3.m, exp_SO_2_3.m
    ??? processo.m, medidaLie.m, sigmaPoints.m
    ??? exportSolution.m, hampelFilter.m, subtractOnTime.m
```

---

## 2. Quarantine Rationale & Latent Defect Register

### 2.1 Problem #21: Misspelled Function Filename
- `inslib/predction_ekf_quat.m` contained a severe typo in both the file name and function signature (`predction` missing the letter `i`).
- **Remediation**: Renamed to canonical Pascal_Snake_Case `Prediction_EKF_Quat.m` in `filters_quaternion/`. Thin wrappers `predction_ekf_quat.m` and `prediction_ekf_quat.m` are maintained to prevent breaking historical call sites.

### 2.2 Problem #24: Zero Active Callers & Mathematical Liabilities
The active navigation suite uses state estimation on matrix Lie groups ($SE_2(3) \times \mathbb{R}^6$), eliminating Euler singularities. The 6 legacy Euler and quaternion filters were uncalled and exhibited critical latent defects:
1. **`UKF_update_ins.m`**: Line 11 invokes `h(X(1:3, i))`. The function `h()` is undefined anywhere in the repository. Any invocation will crash MATLAB with `Unrecognized function or variable 'h'`.
2. **`EKF_update.m`**: Line 17 evaluates `Ceb = rotm(hx0(1:3))` instead of `Ceb = rotm(hx0(1:3))'`. In the navigation library's convention, `rotm` produces $C_{be}$ (body to ECEF/navigation frame); the un-transposed matrix corrupts antenna lever-arm correction.
3. **`dynamicJacobian_euler.m`**: Uses explicit division by $\cos(\text{pitch})$, leading to numerical division-by-zero singularities at $\text{pitch} = \pm 90^\circ$.

### 2.3 Problem #35: Orphaned Utilities & Workspace Hazards
- **Destructive Scratch Scripts (`symbolic_scratch/`)**: Files `Jacobian_C.m`, `Jacobian_H.m`, and `Jacobian_euler.m` begin with unconditional `clear all; close all; clc;`. If inadvertently called from the active workspace or during automated test runs, all variables and figures are permanently deleted.
- **Obsolete 9-State Models**: `Matriz_C.m` and `matriz_H.m` define 9-state (orientation, velocity, position) kinematics that are superseded by the 15-state $SE_2(3) \times \mathbb{R}^6$ analytical models (`matriz_C_se23T6.m` and `matriz_H_se23T6.m`).
- **Orphaned Plotting & Geometry Helpers**: 36 routines in `orphaned_utilities/` have zero active callers across the repository and were isolated to keep the core namespace clean and maintainable.

---

## 3. Backwards Compatibility & Access

All active Lie-group, rotation, metric, and visualization functions reside in `core/`, `metrics/`, and `visualization/`. Legacy routines and backwards-compatible name aliases (`compat_aliases/`) are quarantined under `inslib/legacy/`.

To explicitly add all legacy folders and compatibility aliases to MATLAB's search path for testing or historical comparison:
```matlab
Setup_Paths(true);
```
(or call `addLibrary()` from `inslib/addLibrary.m`).

