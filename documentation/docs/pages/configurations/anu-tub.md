# ANU-TUB, an idealised sector model

The purpose of this page is to demonstrate how to set up the ANU-TUB model up with a MOM6 executable of the user's choice on gadi.

## ANU-TUB configurarion details

The [ANU-TUB](https://github.com/AndyHoggANU/anu-tub) is a MOM6 configuration that aims to:

>produce the simplest configuration that incorporates buoyancy and wind forcing, gyre circulation, overturning circulation and topographically-constrained overflow

The configuration was setup by [Andy Hogg](https://github.com/AndyHoggANU) and [Angus Gibson](https://github.com/angus-g) for exploring vertical coordinate choice and design in MOM6 which uses [generalised vertical coordinates](https://mom6.readthedocs.io/en/dev-gfdl/api/generated/pages/General_Coordinate.html) thereby placing vertical coordinate choice in the users hands.
More specific details about the configuraiton, taken from the repository [README](https://github.com/AndyHoggANU/anu-tub?tab=readme-ov-file#anu-tub), are:

- The sector is 40° wide, and goes from ~70.3°S to ~70.3°N.
- It has a 1/4° nominal resolution and a Mercator grid refinement.
- the default vertical coordinate is ZSTAR with 75 vertical levels.
- The bathymetry is simple, with a vertical wall to the north, an "Antarctic shelf and slope" in the south and sloping sidewalls on the east and west.
- The domain is periodic in the east-west direction, allowing zonal flow in a narrow "Drake Passage" between ~65°S and ~52°S.
- Surface momentum forcing is via a prescribed zonal wind field that is constant, but varies with latitude.
- Thermal forcing is through relation to a latitude-dependent SST profile, and there is (currently) no freshwater forcing so that salinity is constant. 
- We use the WRIGHT equation of state, without frazil formation or sea ice.
- The model includes the PBL surface boundary layer scheme with a contant background diffusivity of $2 \times 10^{-5}$.
- The MEKE eddy parameterisation scheme is turned off, as is the mixed layer restratification scheme.

The model has $160 \times 800$ grid points, with a tile layout of $6 \times 40$ to run efficiently on 240 cores.
With a 1200-second timestep, the standard ZSTAR case takes 1:45 hours per year (~14 years/day) and consumes ~900 SU per model year.
The relatively low cost of the ANU-TUB configuration allows for a wide variety of idealised experiments to be run that can investigate vertical coordinates, new diagnostics and many other things!

## Requirements

The required components for setting up ANU-TUB are:

- access to the relevant projects on gadi
- a MOM6 executable
- a fork or clone of the ANU-TUB repository.

### Project access

Talk to Chris about what to do and where to point people here.
Need payu so vk83?
Maybe with Andy's permission can put the restart files into the COSIMA directory and provide access that way.

### MOM6 executable

We reccommend [building a MOM6 executable](https://access-community-hub.github.io/access-iom3-configs/infrastructure/Building/).
This will provide the most flexibility as source code can be modified.
If you would like to use an existing standalone MOM6 executable just make sure you know the exact path that points to it.

### Forking or cloning the ANU-TUB repository

Either option is fine here so whatever suits you!
The following commands clone the repository into the `$USER` directory:

```bash
cd /g/data/$PROJECT/$USER/
git clone https://github.com/AndyHoggANU/anu-tub.git
```

<terminal-window>
  <terminal-line data="input"> cd /g/data/$PROJECT/$USER</terminal-line>
  <terminal-line data="input", directory="$USER">git clone https://github.com/AndyHoggANU/anu-tub.git</terminal-line>
  <terminal-line>Cloning into anu-tub...</terminal-line>
</terminal-window>

!!! tip
    If you have forked the repository and wish to clone the fork, change `AndyHoggANU` to your github username in the url.

## Setting up

With the ANU-TUB repository cloned to gadi we change into the `zstar` directory and edit the necessary part of the `config.yaml` file
!!! tip
    The same process below will work for any of the other vertical coordinate choices but `zstar` is a good place to start.

```bash
cd anu-tub/control/zstar
vim config.yaml
```

<terminal-window>
  <terminal-line data="input", directory="$USER">cd anu-tub/control/zstar</terminal-line>
  <terminal-line data="input", directory="zstar">vim config.yaml</terminal-line>
</terminal-window>

The contents of the `config.yaml` file should look like (without the comments that indicate what lines need changing):

```yaml
ncpus: 240
walltime: 12:00:00
jobname: tub-new
project: x77                                  # replace with NCI project you are part of
queue: normal

model: mom6
shortpath: /scratch/x77                       # replace with NCI project you are part of
exe: /g/data/x77/ahg157/exes/MOM6/AG-07f0a144 # replace with path to MOM6 executable
input: /g/data/x77/amh157/mom6/input/anu-tub  # replace with path to input, possible COSIMA path Chris mentioned

storage:
  gdata:
    - x77                                     # replace with NCI project you are part of

collate: False

mpi:
    module: openmpi/4.1.2

qsub_flags: -W umask=027
restart_freq: 1  # use tidy_restarts.py instead

userscripts:
   archive: qsub sync_output_to_gdata.sh
```

As indicated above the `project`, `exe` and `input` information needs to been updated.
Once these changes have been made save and close vim.
!!! tip
    To enter insert mode in vim press `i` and change the required fields. 
    To save and quit type `:wq`.
    For further information or more commands view a [vim cheat sheet](https://vim.rtorr.com/).

The experiment is designed to run on `scratch` so any output will be saved there.
This can then be manually moved to `/g/data` or the executable script `sync_output_to_gdata.sh` can be run.

*Check with Chris if there is a preferable way to move data to `/g/data` or if we should advise removing these lines.*

## Running ANU-TUB

To run the ANU-TUB model we use [`payu`](https://payu.readthedocs.io/en/stable/install.html), a workflow management tool for running models on gadi.
This requires membership to project vk83 -- add details of how to become member here (or above).

First, we load payu into our gadi environment
```bash
module use /g/data/vk83/modules
module load payu
```

<terminal-window>
  <terminal-line data="input", directory="zstar">module use /g/data/vk83/modulest</terminal-line>
  <terminal-line data="input", directory="zstar">module load payu</terminal-line>
  <terminal-line>Loading payu/1.2.0</terminal-line>
  <terminal-line>  Loading requirement: singularity</terminal-line>
</terminal-window>

Within the `zstar` directory, where the `config.yaml` file we have just edited lives, run:

```bash
payu setup
```

<terminal-window>
  <terminal-line data="input", directory="zstar">payu setup</terminal-line>
  <terminal-line>laboratory path:  /scratch/$PROJECT/$USER/mom6</terminal-line>
  <terminal-line>input path:  /scratch/$PROJECT/$USER/mom6/input</terminal-line>
  <terminal-line>work path:  /scratch/$PROJECT/$USER/mom6/work</terminal-line>
  <terminal-line>archive path:  /scratch/$PROJECT/$USER/mom6/archive</terminal-line>
  <terminal-line>Found experiment archive: /scratch/$PROJECT/$USER/mom6/archive/zstar-tag_or_uuid</terminal-line>
  <terminal-line>payu: Found modules in /opt/Modules/v4.3.0</terminal-line>
  <terminal-line>Loading input manifest: manifests/input.yaml</terminal-line>
  <terminal-line>Loading restart manifest: manifests/restart.yaml</terminal-line>
  <terminal-line>Loading exe manifest: manifests/exe.yaml</terminal-line>
  <terminal-line>Setting up mom6</terminal-line>
  <terminal-line>Checking exe, input and restart manifests</terminal-line>
  <terminal-line>Writing manifests/restart.yaml</terminal-line>
</terminal-window>

The `tag_or_uuid` is something that will be generated as part of `payu setup` for this experiment.
!!! tip
    If you recieve a message from `payu` that it expects a git repository run `git init` in the `zstar` directory.
    *Chris this is something I have had to do but maybe there are better ways around it?*
    *Or we run `git tag` to tag the experiment?*

Now we move the experiment to `scratch` with

```bash
payu sweep
```

<terminal-window>
  <terminal-line data="input", directory="zstar">payu sweep</terminal-line>
  <terminal-line>laboratory path:  /scratch/$PROJECT/$USER/mom6</terminal-line>
  <terminal-line>input path:  /scratch/$PROJECT/$USER/mom6/input</terminal-line>
  <terminal-line>work path:  /scratch/$PROJECT/$USER/mom6/work</terminal-line>
  <terminal-line>archive path:  /scratch/$PROJECT/$USER/mom6/archive</terminal-line>
  <terminal-line>Found experiment archive: /scratch/$PROJECT/$USER/mom6/archive/zstar-tag_or_uuid</terminal-line>
  <terminal-line>payu: Found modules in /opt/Modules/v4.3.0</terminal-line>
  <terminal-line>Loading input manifest: manifests/input.yaml</terminal-line>
  <terminal-line>Loading restart manifest: manifests/restart.yaml</terminal-line>
  <terminal-line>Loading exe manifest: manifests/exe.yaml</terminal-line>
  <terminal-line>Setting up mom6</terminal-line>
  <terminal-line>Checking exe, input and restart manifests</terminal-line>
  <terminal-line>Removing work path /scratch/$PROJECT/$USER/mom6/work/zstar-tag_or_uuid</terminal-line>
  <terminal-line>Removing symlink /g/data/$PROJECT/$USER/anu-tub/control/zstar/work</terminal-line>
</terminal-window>

Lastly, we run the experiment with

```bash
payu run
```

<terminal-window>
  <terminal-line data="input", directory="zstar">payu run</terminal-line>
  <terminal-line>laboratory path:  /scratch/$PROJECT/$USER/mom6</terminal-line>
  <terminal-line>input path:  /scratch/$PROJECT/$USER/mom6/input</terminal-line>
  <terminal-line>work path:  /scratch/$PROJECT/$USER/mom6/work</terminal-line>
  <terminal-line>archive path:  /scratch/$PROJECT/$USER/mom6/archive</terminal-line>
  <terminal-line>Found experiment archive: /scratch/$PROJECT/$USER/mom6/archive/zstar-tag_or_uuid</terminal-line>
  <terminal-line>payu: Found modules in /opt/Modules/v4.3.0</terminal-line>
  <terminal-line>Loading input manifest: manifests/input.yaml</terminal-line>
  <terminal-line>Loading restart manifest: manifests/restart.yaml</terminal-line>
  <terminal-line>Loading exe manifest: manifests/exe.yaml</terminal-line>
  <terminal-line>payu: Found modules in /opt/Modules/v4.3.0</terminal-line>
  <terminal-line>qsub -q normal -P e14 -l walltime=43200 -l ncpus=240 -l mem=960GB -N tub-new -l wd -j n -v PAYU_PATH=/g/data/vk83/apps/base_conda/envs/payu-1.2.0/bin,MODULESHOME=/opt/Modules/v4.3.0,MODULES_CMD=/opt/Modules/v4.3.0/libexec/modulecmd.tcl,MODULEPATH=/g/data/vk83/modules:/etc/scl/modulefiles:/opt/Modules/modulefiles:/opt/Modules/v4.3.0/modulefiles:/apps/Modules/modulefiles -W umask=027 -l storage=gdata/e14+gdata/vk83+gdata/x77+scratch/e14 -- /g/data/vk83/./apps/conda_scripts/payu-1.2.0.d/bin/launcher.sh /g/data/vk83/./apps/base_conda/envs/payu-1.2.0/bin/python3.10 /g/data/vk83/apps/base_conda/envs/payu-1.2.0/bin/payu-run</terminal-line>
  <terminal-line>155451836.gadi-pbs</terminal-line>
</terminal-window>

!!! tip
    By default, a restart directory is created that is used when the experiment is run again.
    If you wish to not restart from this state it, and the corresponding output directory need to be removed within the experiment archive.

## Changes to the experiment setup

Mention:

- altering the `diag_table`
- changing run time
- editing MOM6 source code

# Other resources

The following resources may be useful for changing configurations or experiment setup:

- [MOM6 documentation](https://mom6.readthedocs.io/en/main/)
- [running ACCESS models with `payu`](https://docs.access-hive.org.au/models/run_a_model/run_access-om3/)
