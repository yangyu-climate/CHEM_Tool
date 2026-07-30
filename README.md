# CHEM_Tool

CHEM_Tool is a MATLAB-based preprocessing toolkit for WRF-Chem emissions.
It prepares gridded emission files by reading raw chemistry emission
inventories, projecting them to WRF domains, and writing WRF-Chem-compatible
NetCDF emission files.

Repository: https://github.com/yangyu-climate/CHEM_Tool

## Author and Copyright

Author: Yang Yu  
Email: yang.yu@whoi.edu  

Copyright (c) 2026 Yang Yu. All rights reserved unless otherwise stated.

Bundled third-party components keep their own copyright and license terms.
See the README, license, or header files inside each third-party directory
before redistributing this toolkit.

## What It Does

The main workflow under `Run/WRF_Emission`:

1. Creates empty `emis_dXX.nc` files from WRF `wrfinput_dXX` files.
2. Projects surface emission inventory data onto each WRF domain.
3. Adds point-source emissions using stack location and height information.
4. Optionally merges/fills missing values with global WRF-Chem emission data.

The generated output is intended for WRF-Chem emission input files such as:

```text
emis_d01.nc
emis_d02.nc
emis_d03.nc
```

## Directory Layout

```text
CHEM_Tool/
+-- start.m                  MATLAB path bootstrap script
+-- start_windows.m          Adds Windows MATLAB toolbox paths
+-- start_linux.m            Adds Linux MATLAB toolbox paths
+-- Run/
|   +-- WRF_Emission/        Main MATLAB emission-generation workflow
|   +-- ANTHRO_EMIS/         Anthro emission preprocessing tools
|   +-- MOZBC/               MOZART boundary-condition tools
|   +-- WES_COLDENS/         Wesely and exo coldens tools
+-- Tool_box/                Shared MATLAB utility functions
+-- m_map/                   Mapping toolbox
+-- mexcdf/                  NetCDF/MEXCDF support libraries
+-- ncl_color/               NCL-style color maps
+-- coastline/               Coastline data
+-- Data/                    Static terrain, grid, and shapefile data
```

## Main WRF Emission Workflow

The primary entry point is:

```text
Run/WRF_Emission/Run.m
```

It runs these scripts in order:

```matlab
Generate_Empty_Emission
Projecting_Emission_Data
Projecting_Point_Source
```

### 1. `Generate_Empty_Emission.m`

Creates empty WRF-Chem emission NetCDF files for each configured domain.
It reads domain size and global attributes from:

```text
wrfinput_d01
wrfinput_d02
...
```

The actual NetCDF creation is handled by:

```text
Run/WRF_Emission/creat_wrfchem_emission.m
```

### 2. `Projecting_Emission_Data.m`

Processes surface emissions from files matching patterns like:

```text
area*YYmonDD*.nc7
```

It reads configured chemical species, converts units, optionally smooths or
degrades the input grid, interpolates emissions to WRF longitude/latitude
grids, and writes the first emission vertical layer.

### 3. `Projecting_Point_Source.m`

Processes point-source emissions from files matching:

```text
point*YYmonDD*.nc7
stack*YYmonDD*.nc7
```

It uses stack longitude, latitude, and height to locate the target WRF grid
cell and vertical emission layer, then adds those emissions to the existing
domain emission file.

## Configuration

Edit this file before running:

```text
Run/WRF_Emission/CHEM_parameter.m
```

Important settings include:

```matlab
Data_dir = '...';      % Directory containing wrfinput_dXX files
Chem_dir = '...';      % Directory containing raw emission inventory files
Save_dir = '...';      % Output directory for emis_dXX.nc files

IF_Merge = 1;          % Merge/fill with global emission data
GLBE_dir = '../ANTHRO_EMIS';

domainN = 3;           % Number of WRF domains
subDomN = 0;           % 0 means all domains; >0 runs one domain only

Time_beg = [2020 6  1 0 0 0];
Time_end = [2020 9 30 0 0 0];
Time_frq = 1;          % Time interval in hours

emissions_zdim = 5;    % Number of emission vertical layers
```

Chemical species are configured through input and output name lists, for
example:

```matlab
CHEM_Iname = {'CO'; 'NO'; 'NO2'; 'SO2'; 'NH3'};
CHEM_Oname = {'E_CO'; 'E_NO'; 'E_NO2'; 'E_SO2'; 'E_NH3'};
```

Particle species are configured similarly:

```matlab
PM_Iname = {'PEC'; 'POC'; 'PMC'};
PM_Oname = {'E_BC'; 'E_OC'; 'E_PM_10'};
```

Grouped species can be defined with cell arrays and weighting factors:

```matlab
PM_InameG = {{'PFE'; 'PMN'; 'PMOTHER'}};
PM_OnameG = {'E_PM_25'};
PM_factor = {[1, 1, 1]};
```

## Running

From MATLAB, change into the WRF emission workflow directory:

```matlab
cd Run/WRF_Emission
Run
```

On Linux, the provided shell wrapper can run MATLAB in the background:

```bash
cd Run/WRF_Emission
sh Run.sh
```

The shell script writes standard output and errors to:

```text
running.log
running.err
```

## Path Setup

Each WRF emission script sets:

```matlab
Run_dir = '../../';
addpath(Run_dir)
start
```

Then `start.m` calls either `start_windows.m` or `start_linux.m` to add
toolbox paths. If `Run_dir` is not already defined, `start.m` now falls back
to the directory where `start.m` itself is located.

## Required Inputs

For each WRF domain:

```text
wrfinput_d01
wrfinput_d02
...
```

For each configured date:

```text
area*YYmonDD*.nc7
point*YYmonDD*.nc7
stack*YYmonDD*.nc7
```

If `IF_Merge = 1`, global emission files are also expected:

```text
wrfchemi_d01
wrfchemi_d02
...
```

## Outputs

Generated emission files are written to `Save_dir`:

```text
emis_d01.nc
emis_d02.nc
emis_d03.nc
```

Variables are created with WRF-Chem-style names such as:

```text
E_CO
E_NO
E_NO2
E_SO2
E_NH3
E_BC
E_OC
E_PM_10
E_PM_25
```

## Code Review Notes

- This project is maintained in GitHub at
  `https://github.com/yangyu-climate/CHEM_Tool`.
- The main maintained project code was reviewed in `start*.m`, `Tool_box`,
  and `Run/WRF_Emission`. Bundled third-party packages such as `m_map` and
  `mexcdf` were treated as external dependencies.
- `Projecting_Emission_Data.m` initializes merge metadata safely, so
  `IF_Merge = 0` no longer leaves `glbN` undefined.
- If `IF_Merge = 1` but the global emission file is missing, the script emits
  a warning and continues with zero-fill behavior for variables that cannot be
  found in the global file.
- File patterns such as `area*.nc7`, `point*.nc7`, and `stack*.nc7` should
  match exactly one file for each date. The WRF emission scripts now raise an
  explicit error when ambiguous matches are found.
- Point and stack emission files must exist as a pair for each point-source
  date. If a stack location matches multiple grid cells, the current code uses
  the first matched cell.
- Legacy `stop` calls in the WRF emission workflow were replaced with
  `error(...)` calls so failures report clearer messages.
- `degrade_field.m` and `degrade_field_input.m` now validate required
  arguments and report invalid units through `error(...)`.
- Some comments in `creat_wrfchem_emission.m` appear to have encoding issues.

MATLAB static validation was attempted with MATLAB R2021a, but the local
license checkout failed. The code has therefore been checked by source review
and text search, but not by a MATLAB runtime execution in this workspace.

## Third-Party Components

This repository includes or depends on several bundled MATLAB toolboxes and
data packages:

- `m_map`
- `mexcdf`
- `snctools`
- `ncl_color`

Check the license and README files inside those directories before
redistributing the toolkit.

## Git LFS

Large NetCDF and archive files are tracked with Git LFS:

```text
*.nc
*.tgz
```

Install Git LFS before cloning or updating large data files:

```bash
git lfs install
git lfs pull
```
