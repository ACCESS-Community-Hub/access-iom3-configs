To run idealised models, or add extra features for yourself and others, you will likely need to build a MOM6 executable.
The aim of this page is provide instructions for how to do this using the infrastructure provided by ACCESS-NRI.
If you notice anything that is missing or could be improved in the explanation please [raise an issue!](https://github.com/ACCESS-Community-Hub/access-iom3-configs/issues)

# Building MOM6 standalone 

The below are instructions for how to build MOM6 standalone. Here, we show two ways of building MOM6 standalone using [Spack](https://spack.io/) with OM3.

For some inspiration of why this is fun, have a look at the available test cases in the [`MOM6-examples` repository](https://github.com/NOAA-GFDL/MOM6-examples/tree/dev/gfdl/src). For some additional background on the below two workflows, see these official docs:

 - [Modify and build an ACCESS model's source code](https://docs.access-hive.org.au/models/build_a_model/build_source_code/)
 - [Create Prereleases and Releases for an ACCESS Model](https://docs.access-hive.org.au/models/build_a_model/create_a_prerelease/)

## Building MOM6 standalone within your own Spack environment
!!! tip
    This option is slower but does not require `write` access to [ACCESS-NRI/ACCESS-OM3](https://github.com/ACCESS-NRI/ACCESS-OM3).

Before starting on the below steps, it is suggested that you install your own version of Spack. There are instructions on how to do that [here](https://docs.access-hive.org.au/getting_started/spack/#enable-spack), you can stop once you've completed the [enable spack step](https://docs.access-hive.org.au/getting_started/spack/#enable-spack) (i.e. you may skip the test step).
With spack installed, we first need to change to the spack directory, then load spack's custom bash script and check everything is up to date:

```bash
[user1234@gadi-login ~] cd /g/data/$PROJECT/$USER/spack/0.22

[user1234@gadi-login 0.22] . spack-config/spack-enable.bash

[user1234@gadi-login 0.22] cd spack-packages

[user1234@gadi-login spack-packages] git pull

[user1234@gadi-login spack-packages] cd ../spack-config 

[user1234@gadi-login spack-config] git pull

[user1234@gadi-login spack-config] cd /g/data/$PROJECT/$USER/spack/0.22
```

Now we clone ACCESS-OM3 into our spack directory:
```bash
[user1234@gadi-login 0.22] git clone git@github.com:ACCESS-NRI/ACCESS-OM3.git

[user1234@gadi-login 0.22] cd ACCESS-OM3

[user1234@gadi-login ACCESS-OM3] git tag

#check out the release you want

[user1234@gadi-login ACCESS-OM3] git checkout 2025.08.001
```

At this point we need to modify the `ACCESS-OM3/spack.yaml` so it knows how to build MOM6 on it's own, we do this by modifying this line:
```yaml
spack:
  specs:
    - access-om3@git.2025.08.001
```

To this:
```yaml
spack:
  specs:
    - access-mom6@2025.07.000 fflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" cflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" cxxflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" ~access3

```
Note the use of `access-mom6` at `@2025.07.000`, this is because that is what was originally specified in the spack.yaml with tag `2025.08.001`.
Then we have to comment out the following lines:
```yaml
    access-mom6:
      require:
        - '@2025.07.000'
        - 'fflags="-march=sapphirerapids -mtune=sapphirerapids -unroll"'
        - 'cflags="-march=sapphirerapids -mtune=sapphirerapids -unroll"'
        - 'cxxflags="-march=sapphirerapids -mtune=sapphirerapids -unroll"'
```

Now we can create the spack environment in which to build MOM6:
```bash
[user1234@gadi-login ACCESS-OM3] cd ..
[user1234@gadi-login 0.22] spack env create mom6standalone ACCESS-OM3/spack.yaml
#Returns

==> Created environment mom6standalone in: /g/data/tm70/cyb561/spack/0.22/environments/mom6standalone
==> Activate with: spack env activate mom6standalone

[user1234@gadi-login 0.22] spack env activate mom6standalone -p

[mom6standalone][user1234@gadi-login 0.22] spack concretize -f --fresh
[mom6standalone][user1234@gadi-login 0.22] spack install access-mom6 ~access3
```

These last two commands will take some time.
!!! tip
    `spack concretize` only need be re-run if there are changes to the `spack.yaml` file. If changes are made to the MOM6
    source code that `mom6standalone` is built from, running `spack install` should be sufficient for the build system to use the modified source code.
     However, if something does not work correctly running `spack concretize` should fix things up.

Once completed one can find the executable with:
```bash
[mom6standalone][cyb561@gadi-login-09 0.22]$ which mom6
/g/data/tm70/cyb561/spack/0.22/environments/mom6standalone/.spack-env/view/bin/mom6
```
!!! note
    The `mom6` executable can only be found if the spack environment it is built from is `activated`. Specifically,
    if `spack deactivate` is run, the command `which mom6` will not be able to find the MOM6 executable unless it is added.
    to `PATH`.

## Building MOM6 standalone with a pre-release build 
!!! tip
    This option is faster but requires `write` access to [ACCESS-NRI/ACCESS-OM3](https://github.com/ACCESS-NRI/ACCESS-OM3).

!!! warning
    This is [NOT a supported workflow](https://github.com/ACCESS-NRI/ACCESS-OM3/pull/151#issuecomment-3326505434) and is only provided to show that it is possible.

1. Create branch from main, e.g. `cbull_test_mom6standalone`
1. Edit the spack.yaml to have the following line:
```yaml
spack:
  specs:    
    - access-mom6@2025.07.000 fflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" cflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" cxxflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" ~access3
```
1. create a pre-release by opening a pull request with the above change ([example](https://github.com/ACCESS-NRI/ACCESS-OM3/pull/151))

When loading the pre-release a slight change of text is needed, here's an example:
```bash
$ module purge
$ module use /g/data/vk83/prerelease/modules
$ module load access-mom6/pr151-4
Loading access-mom6/pr151-4
  Loading requirement: access-mom6/dependencies/pr151-4/access-mocsy/2025.07.002-ucihukj access-mom6/dependencies/pr151-4/access-generic-tracers/2025.08.000-lbeknxx
which mom6
/g/data/vk83/prerelease/apps/spack/0.22/release/linux-rocky8-x86_64_v4/oneapi-2025.2.0/access-mom6-2025.07.000-ruhunvj5oyc2nidysvbmajb42ehtszzm/bin/mom6
```

Then add the following to your `config.yaml`:
```bash
modules:
    use:
        - /g/data/vk83/prerelease/modules
    load:
        - access-mom6/pr151-4

model: mom6
exe: mom6
```
The model field is the name of the Payu "model driver" to use. The `exe` field is the path to the executable (or just the executable name if it is already in your PATH).

## Additional resources for running MOM6 standalone 

Here are some other guides for building MOM6 using FMS, these builds will be more difficult to relate to ACCESS-OM3. Links:

 - https://github.com/angus-g/mom6-ninja-nci
 - https://noaa-gfdl.github.io/MOM6/ac/
 - https://www.marshallward.org/mom6workshop/build.html#/title-slide
 - https://www.youtube.com/watch?v=xuqjV1OYjbI

