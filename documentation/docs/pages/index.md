
Welcome to the documentation for the ACCESS-iOM3 ocean-seaice model configurations! 

The purpose of this repository, is to encourage community users to both use and share _idealised_ [OM3](https://access-om3-configs.access-hive.org.au/) model configurations.

## Getting involved in ACCESS-iOM3

**Contributions from people of all career stages and backgrounds are highly encouraged.** All these models and configurations are developed are open source. Development is led by ACCESS-NRI and the [COSIMA working group](https://cosima.org.au/) where we follow an open development model building on the work of international modelling consortia.

### Report a bug or make a suggestion

Technical issues related to ACCESS-iOM3 are best posted to [github.com/ACCESS-NRI/access-om3-configs/issues](https://github.com/ACCESS-Community-Hub/access-iom3-configs/issues). If you would like to discuss the issue first, feel free to post it on the [access hive forum](https://forum.access-hive.org.au/c/cosima/29).

### Add a new iOM3 configuration

There are several different ways to do this depending on the kind of contribution. Best to get in touch on the [access hive forum](https://forum.access-hive.org.au/c/cosima/29), ping @ACCESS-NRI/ocean on GitHub or email `chris.bull@anu.edu.au`.

### ACCESS-iOM3 documentation

We appreciate contributions, typo and bugs fixes to this documentation. To make suggestions please see [Edit Config Docs](Edit-Config-Docs/) page.

#### Quick contributions 
!!! tip
    This method has the advantage is that it's *very quick* (<1 minute!). The caveat is that, unless you have write access to the `access-om3-configs` repository, you will not be able to preview the changes rendered into a website or create whole new pages. <br>

The simplest and fastest way to make a change to an _existing_ page is to click the edit "pencil" on the top-right corner. This will go to the relevant GitHub markdown file and clicking the top-right pencil again on GitHub will allow you to edit the file. Once complete, click `Commit changes...`. There are then _two_ possibilities, depending on whether you have  write access to [`access-om3-configs`](https://github.com/ACCESS-NRI/access-om3-configs): 

1.  **No write access** (e.g. you are not part of the `ACCESS-NRI` GitHub organisation): this will prompt you to make a fork and then a pull request (less than 1 minute!). 
1.  **You have write access**: please commit changes on a new branch and then use a pull request (this relates to the next option). 

#### Larger contributions (online PR-previews)
!!! tip
    This method allows you create whole new pages, and to preview the changes rendered into a website. It does not require you to install any software, but is **only available for people with write access to [`access-om3-configs`](https://github.com/ACCESS-NRI/access-om3-configs)**.<br>

Create a new branch, e.g. `jblogs/doc-update`, make doc changes (the documentation sources are in [github.com/ACCESS-NRI/access-om3-configs/tree/main/documentation](https://github.com/ACCESS-NRI/access-om3-configs/tree/main/documentation)), then open a related PR and a GitHub preview will be made automatically.

#### Larger contributions (`mkdocs` offline)
!!! tip
    Similar to the above, this method allows you create whole new pages and to preview the changes rendered into a website. It works whether or not you have write access to [`access-om3-configs`](https://github.com/ACCESS-NRI/access-om3-configs), but requires you to install `mkdocs` and takes the longest to set up.<br>

Following [these instructions](https://docs.access-hive.org.au/about/contribute/contribute_on_github/) but noting the documentation sources are in [github.com/ACCESS-NRI/access-om3-configs/tree/main/documentation](https://github.com/ACCESS-NRI/access-om3-configs/tree/main/documentation). You'll need to fork and clone [github.com/ACCESS-NRI/access-om3-configs](https://github.com/ACCESS-NRI/access-om3-configs) if you want to [write your own content](https://docs.access-hive.org.au/about/contribute/contribute_on_github/) (`mkdocs serve` should be invoked from within the `documentation` directory).

If you want to add a new page, then you need to add another markdown file in the folder (or sub-folder as appropriate):
[github.com/ACCESS-NRI/access-om3-configs/tree/main/documentation/docs/pages](https://github.com/ACCESS-NRI/access-om3-configs/tree/main/documentation/docs/pages)

Once done, update the documentation navigation in [github.com/ACCESS-NRI/access-om3-configs/blob/main/documentation/mkdocs.yml](https://github.com/ACCESS-NRI/access-om3-configs/blob/main/documentation/mkdocs.yml) by adding an entry under the `nav:` section. Note you'll need to add the sub-folder paths as appropriate.


