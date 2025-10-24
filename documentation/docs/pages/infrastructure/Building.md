

# Building MOM6 standalone 

The below are instructions for how to build MOM6 standalone. Here, we show two ways of building MOM6 standalone using Spack with OM3.

Here are some other guides for building MOM6 using FMS, these builds will be more difficult to relate to ACCESS-OM3. Links:

 - https://github.com/angus-g/mom6-ninja-nci
 - https://noaa-gfdl.github.io/MOM6/ac/
 - https://www.marshallward.org/mom6workshop/build.html#/title-slide
 - https://www.youtube.com/watch?v=xuqjV1OYjbI

For some inspiration of why this is fun, have a look at the available test cases in the [`MOM6-examples` repository](https://github.com/NOAA-GFDL/MOM6-examples/tree/dev/gfdl/src).


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

## Building MOM6 standalone within your own Spack environment
!!! tip
    This option is slower but does not require `write` access to [ACCESS-NRI/ACCESS-OM3](https://github.com/ACCESS-NRI/ACCESS-OM3).

```bash
cd /g/data/$PROJECT/$USER/spack/0.22;. spack-config/spack-enable.bash

cd /g/data/tm70/cyb561/spack/0.22/spack-packages; git pull

cd /g/data/tm70/cyb561/spack/0.22/spack-config; git pull

cd /g/data/$PROJECT/$USER/spack/0.22

git clone git@github.com:ACCESS-NRI/ACCESS-OM3.git

cd ACCESS-OM3

git tag

#check out the release you want

git checkout 2025.08.001
```

At this point we need to modify the `ACCESS-OM3/spack.yaml` so it knows how to build MOM6 on it's own, we do this by modifying this line:
```bash
spack:
  specs:
    - access-om3@git.2025.08.001
```

To this:
```bash
spack:
  specs:
    - access-mom6@2025.07.000 fflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" cflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" cxxflags="-march=sapphirerapids -mtune=sapphirerapids -unroll" ~access3

```
Note the use of `access-mom6` at `@2025.07.000`, this is because that is what was originally specified in the spack.yaml with tag `2025.08.001`.

```bash
cd ..
spack env create mom6standalone ACCESS-OM3/spack.yaml
#Returns

==> Created environment mom6standalone in: /g/data/tm70/cyb561/spack/0.22/environments/mom6standalone
==> Activate with: spack env activate mom6standalone

spack env activate mom6standalone

spack concretize -f --fresh
spack install access-mom6 ~access3
```

These last two commands will take some time.

Once completed one can find the executable with:
```bash
[cyb561@gadi-login-09 0.22]$ which mom6
/g/data/tm70/cyb561/spack/0.22/environments/mom6standalone/.spack-env/view/bin/mom6
```

# Running a simple MOM6 standalone example

Some chat with Dougie:
> I've modified a few of the configs in:

> /g/data/tm70/ds0092/model/config/MOM6-examples
> E.g. the one we were looking at yesterday is:

> /g/data/tm70/ds0092/model/config/MOM6-examples/ocean_only/global

> @Dougie Squire, do you have all the input files downloaded somewhere?

> I noticed this /g/data/tm70/ds0092/model/config/MOM6-examples/.datasets/README which suggests you just have three of them.
