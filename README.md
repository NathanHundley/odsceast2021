
# R Class

This is an empty repo to initialize an R project for class at
[ODSC](https://www.odsc.com/): Modern Machine Learning in R Parts
[I](https://odsc.com/speakers/modern-machine-learning-in-r-part-i/) &
[II](https://odsc.com/speakers/modern-machine-learning-in-r-part-ii/).

Please **follow all instructions** to set up your environment for the
training. Skimming the instructions often leads to errors, so be sure to
read everything.

# Install R and RStudio

This is just like installing any other program.

-   [R](https://cloud.r-project.org/)
-   [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

# Getting the Repo

In order to get the most out of class you have to be working in this
project. There are three ways to get this project on your computer.

Choose **one of these methods**.

1.  Clone the repo using the command line
2.  Clone the repo using the RStudio GUI
3.  Use the [`{usethis}`](https://usethis.r-lib.org) package to download
    and unzip the repo

Please only follow one of these methods. Attempting more than one can
lead to errors.

## Command Line

This assumes you have `git`
[installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).[1]

Run this command in the command line or shell.[2]

``` sh
git clone https://github.com/jaredlander/odsceast2021.git
```

Then open the `odsceast2021.Rproj` file.

## RStudio Gui

This assumes you have `git`
[installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

Click `File > New Project`.

![](images/rstudio-project-menu.png)<!-- -->

Click `Version Control`.

![](images/rstudio-create-project.png)<!-- -->

Click `Git`.

![](images/rstudio-create-project-version-control.png)<!-- -->

Choose a folder in the `Create project as a subdirectory of` field.

Paste `https://github.com/jaredlander/odsceast2021`[3] in the
`Repository URL` field.

![](images/rstudio-create-project-git.png)<!-- -->

## `usethis` Package

Run these commands in the R console.

``` r
# install usethis package
install.packages('usethis')

# get the repo
newProject <- usethis::use_course('https://github.com/jaredlander/odsceast2021/archive/main.zip')
```

Be sure to select the positive prompts such as `yes`, `yeah`, etc.

This will open the project in a new RStudio window.

After any of these methods you should have a new RStudio project called
`odsceast2021` or `odsceast2021-main`. You can see this in the top right
of RStudio (the name in the image may be different).

![](images/ProjectCorner.png)<!-- -->

# Finish Setup

Setting up all of the needed packages[4] and data will be handled by
running the following line of code in the R console.

``` r
source('prep/setup.r')
```

If asked to compile from source, select `no`.

Otherwise, answer `y` to any questions asked in the terminal.

# All Done

That’s everything. You should now do all of your work for this class in
this project.

# If It Still Does Not Work

If you are still having trouble setting up the project and getting
everything installed, sign up for an
[RStudio.cloud](https://rstudio.cloud/) account, contact the TA and ask
for access to the class project.[5]

# Footnotes

[1] Can also be done with ssh instead of https.

[2] Or git clone <git@github.com>:jaredlander/odsceast2021.git for ssh.

[3] Or <git@github.com>:jaredlander/odsceast2021.git for ssh.

[4] Linux users might need to install `libxml2-dev` and `zlib1g-dev`

[5] The compute instance has limited processing and memory so
performance on some topics may be suboptimal.
