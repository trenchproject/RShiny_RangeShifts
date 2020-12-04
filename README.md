# RShiny_RangeShifts

RangeShifts is an interactive shiny app that allows any user to visualize the effects of climate change on marine species range shifts. The app was adapted from [Marine Taxa Track Local Climate Velocities](https://science.sciencemag.org/content/341/6151/1239).  
The app is one of the materials in [TrEnCh-Ed](https://trench-ed.github.io/#), which is an education product from the Buckley Lab, Department of Biology, University of Washington.


## Prerequisites for opening in Rstudio
Git and Rstudio ([Instructions](https://resources.github.com/whitepapers/github-and-rstudio/))  
Installation of the following R packages: shiny, R.utils, plotly, shinywidgets, cicerone, markdown, shinyjs, shinyBS

```
pkgs <- c("shiny", "R.utils", "plotly", "shinyWidgets", "cicerone", "markdown", "shinyjs", "shinyBS")
lapply(pkgs, FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
    }
  }
)
```

## Using RangeShifts
* Opening in Rstudio:  
Click on "Code" on the top right to copy the link to this repository.  
Click ```File```, ```New Project```, ```Version Control```, ```Git```  
Paste the repository URL and click ```Create Project```.

* Alternatively, go to [this link](https://huckley.shinyapps.io/RShiny_RangeShifts/).

We have a google doc with questions to guide through the app for further understanding of the topic.

## Contributing to RangeShifts
<!--- If your README is long or you have some specific process or steps you want contributors to follow, consider creating a separate CONTRIBUTING.md file--->
To contribute to RangeShifts, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

## Contributors
* [@avmey](https://github.com/avmey)
* [@ys634](https://github.com/ys634)
