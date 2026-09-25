# Kalman Filtering on Lie Groups for GNSS/INS Navigation

MATLAB implementation of state estimation filters on the matrix Lie group **SE₂(3) × T(6)** for tightly-coupled GNSS/INS integration, developed as a Scientific Initiation research project.

Instead of parametrizing attitude with Euler angles or quaternions in ℝⁿ, all filters operate directly on the Lie group manifold, using the group exponential and logarithm maps to move between the manifold and its tangent space (the Lie algebra) only when computing means and covariances. Sigma-point propagation stays entirely on the group, preserving rotation-matrix structure at every step.

## State Representation

| Component     | Symbol   | Dimension | Description                       |
|:------------- |:-------- |:---------:|:--------------------------------- |
| Rotation      | C_eb     | 3 × 3     | DCM body-to-ECEF (SO(3))          |
| Velocity      | v        | 3 × 1     | ECEF velocity (m/s)               |
| Position      | p        | 3 × 1     | ECEF position (m)                 |
| Accel. bias   | b_a      | 3 × 1     | Accelerometer bias (m/s²)         |
| Gyro. bias    | b_g      | 3 × 1     | Gyroscope bias (rad/s)            |

- **State group G**: SE₂(3) × ℝ⁶, encoded as 13 × 13 homogeneous matrices
- **Error state (Lie algebra)**: ℝ¹⁵ (p = 15)
- **Measurement group H**: T(3) (GNSS position), dimension q = 3

## Filter Variants

| Filter       | Description                                                                                       | Sigma Points |
|:------------ |:------------------------------------------------------------------------------------------------- |:------------:|
| **EKF-Lie**  | Analytical EKF on SE₂(3) × ℝ⁶ using the group adjoint Ad_G and discrete error Jacobians          | —            |
| **UKF-Lie**  | Full augmented sigma-point filter with nonlinear Fréchet mean estimation (L = 33)                 | 67           |
| **SRUKF-Lie**| Square-Root formulation on lower-triangular Cholesky factors, no explicit matrix inversion        | 67           |

**References:**
1. G. M. Magalhães, H. T. M. Kussaba, and J. Y. Ishihara, "Unscented Kalman filter on Lie groups for radar tracking," CBA, pp. 1–8, Sep. 2018.
2. C. D. R. Menegaz, J. Y. Ishihara, G. A. Borges, and A. N. Vargas, "A systematization of the unscented Kalman filter theory," IEEE TAC, vol. 60, no. 10, pp. 2583–2598, Oct. 2015.
3. G. Bourmaud, R. Mégret, A. Giremus, and Y. Berthoumieu, "Discrete extended Kalman filter on Lie groups," EUSIPCO, pp. 1–5, Sep. 2013.
4. R. van der Merwe and E. A. Wan, "The square-root unscented Kalman filter for state and parameter-estimation," ICASSP, vol. 6, pp. 3461–3464, May 2001.

## Repository Structure

```
IC-Vinicius/
├── config/                        # Configuration structs, trajectory settings, sensor specs
│   ├── WGS84_Constants.m          # Centralized WGS-84 physical constants
│   └── Default_Filter_Config.m    # Default filter parameters, dimensions, and noise models
├── core/                          # Core algorithmic Lie group and rotation routines
│   ├── lie_algebra/               # Exponential, logarithmic, adjoint, bracket, and Jacobian maps
│   │   ├── Exp_Multi_SE23T6.m
│   │   ├── Log_Multi_SE23T6.m
│   │   ├── Exp_Multi_SE3.m
│   │   ├── Log_Multi_SE3.m
│   │   ├── Extract_Lie_States.m
│   │   ├── Skew_Symmetric_3.m
│   │   ├── Ad_G.m
│   │   ├── Adj_G.m
│   │   ├── Phi_SE23T6.m
│   │   ├── Omega_SE23T6.m
│   │   ├── Bracket_Up_SE23.m
│   │   ├── Matrix_C_SE23T6.m
│   │   └── Matrix_H_SE23T6.m
│   ├── manifold/                  # Manifold Fréchet means and covariance computations
│   │   ├── Frechet_Mean_G.m       # Iterative Fréchet mean on state group G
│   │   ├── Frechet_Mean_H.m       # Fréchet mean on measurement group H (T(3))
│   │   └── Lie_Covariances.m      # Innovation Phh and cross-covariance Pgh
│   ├── sigma_points/              # Augmented sigma points generation
│   │   └── Sigma_Points_Lie.m
│   └── rotation/                  # Attitude DCM and Euler angle conversions
│       ├── Euler_Deg_From_Rotm.m
│       ├── Euler_Rad_From_Rotm.m
│       ├── Rotm_Euler_Rad.m
│       ├── Rotm_Euler_Deg.m
│       └── Euler_ENU_To_NED.m
├── filters/                       # Filter state prediction and measurement update routines
│   ├── ekf_lie/
│   │   ├── Prediction_EKF_Lie.m
│   │   └── Update_EKF_Lie.m
│   ├── ukf_lie/
│   │   ├── Prediction_UKF_Lie.m
│   │   └── Update_UKF_Lie.m
│   └── srukf_lie/
│       ├── Prediction_SRUKF_Lie.m
│       └── Update_SRUKF_Lie.m
├── runners/                       # Filter loop orchestrators
│   ├── Run_EKF_Lie.m
│   ├── Run_UKF_Lie.m
│   └── Run_SRUKF_Lie.m
├── geodesy/                       # Geodetic conversions and frame transformations
│   ├── Single_LLA_From_ECEF.m     # Karl Osen (2017) LLA from ECEF coordinate conversion
│   ├── ECEF_From_LLA.m
│   ├── DCM_ECEF_To_NED.m
│   ├── Gravity_WGS84.m
│   └── Earth_Rotation.m
├── metrics/                       # Physical state estimation error evaluation
│   └── Evaluate_State_RMSE.m      # Physically partitioned RMSE (pos, vel, att)
├── visualization/                 # Pure plotting routines (isolated from algorithms)
│   ├── Plot_Filter_Diagnostics.m
│   ├── Plot_Position_NED.m
│   ├── Plot_Position_ECEF.m
│   └── Plot_Euler_Angles.m
├── build/                         # MATLAB Coder / MEX build scripts and compile checks
│   ├── mex/                       # Compiled MEX binaries (gitignored)
│   ├── Build_EKF_Lie_MEX.m
│   ├── Build_UKF_Lie_MEX.m
│   ├── Build_SRUKF_Lie_MEX.m
│   └── Check_MEX_Dependencies.m
├── inslib/                        # Legacy navigation archive
│   ├── addLibrary.m               # Backwards-compatible legacy path loader
│   └── legacy/                    # Quarantined Euler/quaternion routines and aliases
│       ├── filters_euler/
│       ├── filters_quaternion/
│       ├── orphaned_utilities/
│       ├── symbolic_scratch/
│       └── compat_aliases/
├── data/                          # Simulated GNSS/INS trajectory datasets & generator
│   ├── sim_gnss_ins_data.m
│   ├── rectangular/
│   ├── circular/
│   └── helicoidal/
├── doc/                           # LaTeX technical documentation
│   └── main.tex
├── Setup_Paths.m                  # Root bootstrapping path setup
└── benchmark_filters.m            # Unified filter runner and comparison benchmark suite
```

## Quick Start

```matlab
% 1. Interactive mode (prompts for trajectory, filter combinations, and plots)
benchmark_filters;

% 2. Scripted mode (run specific filters/trajectories or combinations)
traj_choice  = '1 2';   % 1: rectangular, 2: circular, 3: helicoidal, 4: all
filt_choice  = '1 2 3'; % 1: EKF_Lie, 2: UKF_Lie, 3: SRUKF_Lie, 4: all
use_mex      = true;    % true: compiled MEX | false: pure MATLAB .m
enable_plots = false;   % true: show diagnostic plots
benchmark_filters;
```

### MEX Compilation (Optional)

Pre-compiled MEX binaries provide 10-50x speedup for long trajectories:

```matlab
Setup_Paths;
Build_EKF_Lie_MEX;
Build_UKF_Lie_MEX;
Build_SRUKF_Lie_MEX;
```

Requires MATLAB Coder and a supported C/C++ compiler.

## Requirements

- MATLAB R2020b or later
- MATLAB Coder (optional, for MEX compilation)
- Supported C/C++ compiler (optional, for MEX)

## Legacy Code

Deprecated Euler-angle and quaternion filter implementations are quarantined in `inslib/legacy/`. To add them to the MATLAB path for historical comparison:

```matlab
Setup_Paths(true);
```

See [`inslib/legacy/README.md`](inslib/legacy/README.md) for the full quarantine rationale and latent defect register.
