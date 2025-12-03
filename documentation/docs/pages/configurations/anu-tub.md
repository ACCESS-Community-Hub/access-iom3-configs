# ANU-TUB, an idealised sector model

The purpose of this page is to demonstrate how to:
1. run an ANU-TUB model with a MOM6 ocean only executable provided by ACCESS-NRI; and/or
1. set up the ANU-TUB model up with a MOM6 executable of the user's choice on gadi.

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
- The model includes the PBL surface boundary layer scheme with a contant background diffusivity of $2 \times 10^{-5}$m$^{2}$s$^{-1}$.
- The MEKE eddy parameterisation scheme is turned off, as is the mixed layer restratification scheme.

The model has $160 \times 800$ grid points, with a tile layout of $6 \times 40$ to run efficiently on 240 cores.
With a 1200-second timestep, the standard ZSTAR case takes 1:45 hours per year (~14 years/day) and consumes ~900 SU per model year.
The relatively low cost of the ANU-TUB configuration allows for a wide variety of idealised experiments to be run that can investigate vertical coordinates, new diagnostics and many other things!

# Using a pre-built ANU-TUB configuration

This will be done once the ACCESS-NRI mom6 ocean only build is done.

# Building your own ANU-TUB configuration

Below the steps for creating your own ANU-TUB configuration are outlined.
!!! tip
    This is more advanced than just running the ANU-TUB configuration that is provided, however it does allow more flexibility especially with regards to changing the MOM6 source code the model uses.

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

### Cloning the ANU-TUB repository

ANU-TUB can either be cloned directly or, you can create a fork and clone that---either option is fine here so whatever suits you!
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
    The same process below will work for any of the other vertical coordinate choice but `zstar` is a good place to start.

```bash
cd anu-tub/control/zstar
vim config.yaml
```

<terminal-window>
  <terminal-line data="input", directory="$USER">cd anu-tub/control/zstar</terminal-line>
  <terminal-line data="input", directory="zstar">vim config.yaml</terminal-line>
</terminal-window>

The contents of the `config.yaml` file should, without the comments indicating what lines need changing, look like:

```yaml
ncpus: 240
walltime: 12:00:00
jobname: tub-new
project: x77                                  # replace with NCI project you are part of
queue: normal

model: mom6
shortpath: /scratch/x77                       # replace with NCI project you are part of
exe: /g/data/x77/ahg157/exes/MOM6/AG-07f0a144 # replace with path to MOM6 executable
input: /g/data/x77/amh157/mom6/input/anu-tub  # replace with path to input, see instructions below

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

As indicated above the `project`, `shortpath`, `exe` and `input` information needs to been updated:

- `project` needs to be changed to the project which will be used to run the job on gadi;
- `shortpath` needs to have `x77` changed to the same project number as `project`;
- `exe` needs to point to the compiled ocean only MOM6 executable to be used in the model, e.g. `exe: /g/data/$PROJECT/$USER/path/to/MOM6executable`
- `input` needs to point to where the input files are stored. These files are located at **add path once known** so change to `input: /g/data/path/to/files/when/known`.

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
We also need to get the necessary input file from **/path/to/stored/input/files.**

### Getting the necessary input files (remove once files are saved on gadi)

This can be done in two ways.
The simplest way is to edit the `input` field in `config.yaml` to point to where these files are located on gadi.
To do this change the `input` field to

```yaml
input: /path/to/stored/input/files
```

Alternatively, the input files can be copied to a directory of your choice.
Then, add the path to where they have been copied to the `input` field.

### Saving script to copy experiment output to `g/data/`

**Ask Chris if we should provide this or just mention data is saved on scratch so need to be moved to `g/data` if you want to keep it for longer.**

### Experiment setup with `payu`

First, we load payu into our gadi environment
```bash
module use /g/data/vk83/modules
module load payu
```

<terminal-window>
  <terminal-line data="input", directory="zstar">module use /g/data/vk83/modules</terminal-line>
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

### Getting restart files

Restart files are available that **get info about it.**
If you wish to use this restart, it needs to be copied into the experiment directory.
To do this, and check it has been copied to the directory type:

```bash
cd  /scratch/$PROJECT/$USER/mom6/work/zstar-tag_or_uuid
cp /path/to/restart .
ls -a
```


<terminal-window>
  <terminal-line data="input", directory="zstar"/scratch/$PROJECT/$USER/mom6/archive/zstar-tag_or_uuid></terminal-line>
  <terminal-line data="input", directory="zstar-tag_or_uuid">cp path/to/restart .</terminal-line>
  <terminal-line data="input", directory="zstar-tag_or_uuid">ls -a</terminal-line>
  <terminal-line>.  ..  manifests  metadata.yaml  payu_jobs  pbs_logs  restart441</terminal-line>
</terminal-window>

!!! tip
    This is where restart files that are generated at the end of an experiment run are saved.

### Run an experiment

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
    By default, a new restart directory is created at the end of an experiment that is used to pick up from when the experiment is run again.
    If you wish to not restart from this state remove the newly created restart directory, and the corresponding output directory. These will be named `restartXXX` and `outputXXX` where `XXX` is a string of numbers.

To check the progress of the experiment type:

```bash
qstat -swx
```

into the terminal.
Further details on [job monitoring](https://opus.nci.org.au/spaces/Help/pages/236880322/Job+monitoring...) are available in the using gadi section of the NCI documentation.

## Changes to the experiment setup

### Altering the `diag_table`

By cloning the repository, we have a `diag_table`.
To edit this use:

```bash
vim diag_table
```


<terminal-window>
  <terminal-line data="input", directory="zstar">vim diag_table</terminal-line>
</terminal-window>

This is a standard `diag_table` for MOM6 so [controlling run time diagnostics](https://mom6.readthedocs.io/en/main/api/generated/pages/Diagnostics.html) can be handled like any MOM6 model run.

### Changing model run time

To change the model run time we need to edit the `input.nml` file within the `zstar` directory.
Running,

```bash
vim input.nml
```

we get:

```bash
&mom_input_nml
    output_directory = './'
    input_filename = 'r'
    restart_input_dir = 'INPUT/'
    restart_output_dir = 'RESTART/'
    parameter_filename = 'MOM_input', 'MOM_override'
/

&fms_nml
    clock_grain = 'MODULE'
    clock_flags = 'NONE'
    domains_stack_size = 1200000
/

&ocean_domains_nml
/

&diag_manager_nml
/

&ocean_solo_nml
    months = 60
    days = 0
    date_init = 1, 1, 1, 0, 0, 0
    hours = 0
    minutes = 0
    seconds = 0
    calendar = 'julian'
/

&mpp_io_nml
    deflate_level = 5
    shuffle = 1
/
```

By default, the model is set to run for 60 months.
To change the length of time update the `months` and `dates` field accordingly.
!!! warning
    Be sure not to change other parts of this file (unless you know what you are doing) as it will likely lead to the model not running.

### Editing MOM6 source code

If you have built your own MOM6 executable, as long as you re-build before, and the `$PATH` to the executable has not changed, running:

```bash
payu setup
payu sweep
payu run
```

should be sufficient for the new changes to the MOM6 source code to be used.
If not please get in touch!

# Other resources

The following resources may be useful for changing configurations or experiment setup:

- [MOM6 documentation](https://mom6.readthedocs.io/en/main/)
- [Running ACCESS models with `payu`](https://docs.access-hive.org.au/models/run_a_model/run_access-om3/)
- [Learning to use vim](https://github.com/iggredible/Learn-Vim?tab=readme-ov-file)
