---
layout: default
title: Jon Katz
description: Jon Katz is a freelance data analyst.
keywords: Katz, data visualization, data analysis, shiny, R, CRAN, statistics
---

<div>
    <div style="font-size:1.25em;font-weight:bold;text-align:center;">
        <p>R Programmer and Data Analyst</p>
    </div>

    <p>Lately I have been writing lots of shiny applications. The value of a shiny application is it can easily make a dataset not only public, but publicly explorable, and they are easy to build, easy to host, and easy to maintain.</p>
    
    <p>Here are a few public applications I recently completed.</p>
    <p>You might also want to <a href="http://jonkatz2.github.io/resume" target="_blank">check out my resume</a>, or I have a couple of blog posts <a href="http://jonkatz2.github.io/2016/05/01/mapping-with-base-graphics-in-r" target="_blank">illustrating some simple R functions I wrote.</a></p>
    
    <div style="border:1px solid gray;padding:15px 0px;">
        <a style="font-size:large;" href="https://vtcfwru-am.shinyapps.io/AMExpertModeler/" target="_blank">An Interactive Expert Elicitation Tool</a>
        <a href="https://vtcfwru-am.shinyapps.io/AMExpertModeler/" target="_blank"><img style="width:1000px;" src="https://www.dropbox.com/s/3i1ryww2j2meh9l/website_elicit2.png?raw=1" alt=""></a>
        <p><strong>To browse this app as a guest, login with the username "guest."</strong></p>
        <p>This is an interactive survey to gather expert opinion on species occurrence at a number of points. This app is currently shared by three projects, so experts log in to connect their responses to the project in which they are participating</p>
        
        <p>This app is shared by three projects, so there is a separate private app that allows each project to customize each survey and download responses. Customization includes the ability to:</p>
        
        <ul> 
            <li>add/remove features</li> 
            <li>upload points</li> 
            <li>change the number/type/content of each survey question</li> 
            <li>rename covariates</li> 
            <li>add/remove experts</li> 
        </ul>
        
        <p>The survey parameters and expert responses are stored in a mongoDB database hosted at mlab.com. Projects upload locations as a shapefile containing either polygons or points; persistent file storage for the shapefile is via an AWS S3 storage bucket. I have also used AWS RDS as a relational database back-end for some apps.</p>
    </div>
    <div style="border:1px solid gray;padding:15px 0px;">
        <a style="font-size:large;" href="https://jkatz.shinyapps.io/tradeoff/" target="_blank">An MCDA Visualization</a>
        <a href="https://jkatz.shinyapps.io/tradeoff/" target="_blank"><img style="width:1000px;" src="https://www.dropbox.com/s/hv88ybgyl4atxvm/website_tradeoff.png?raw=1" alt=""></a>
        <p>This app is designed for a multiple-criteria decision analysis, particularly the decision for how to restore natural tidal flows to an estuary on Cape Cod, Massachussets, while minimizing negative impacts to surrounding landowners and businesses. The app is driven by a series of csv files uploaded at the start of the process. Sample csv files can be downloaded in using the menu in the upper right. The full analysis can be saved and downloaded so that it may be re-visited in the future without re-parameterizing the entire app. Logging in for this app allows the analysis to be saved to a server; persistent file storage is on Google Drive, which is free and convenient due to the web-editing capability. </p>

        <p>To ensure you can see the final graphs, here are brief instructions for use:</p>
        <ol>
            <li>Download and extract the sample data using the menu at the top right.</li>
            <li>Upload the "Policies.csv" file on the left.</li>
            <li>Upload the "Attributes_JK.csv" file in the center.</li>
            <li>Upload both "EE_Predictions_Tim.csv" and "EE_Predictions_Eric.csv" at the top right.</li>
            <li>Upload "EFDC_Predictions.csv" in the center-right.</li>
            <li>Switch to "Group/Name Policies" at the left, and enter a 1 in the second row ("Group") for both the right-most columns ("P_Sed1" and "P_Sed11") to indicate they are members of a group. Leave all other fields in the "Group" row blank. Enter a 1 in the "Allocation" row under P_Sed1, and 11 in the "Allocation" row under P_Sed11. Leave all other fields in the "Allocation" row blank.</li>
        </ol>
        
        <p>I am self-hosting this app during development, but it will be hosted by the client on completion. If it doesn't load I may have run out of time on my free shinyapps.io account. Drop me an email and I'll send you an active link to a functional app.</p>
    </div>
    <div style="border:1px solid gray;padding:15px 0px;">
        <a style="font-size:large;" href="https://jkatz.shinyapps.io/demo1/" target="_blank">An Explorable Dataset</a>
        <a href="https://jkatz.shinyapps.io/demo1/" target="_blank"><img style="width:1000px;" src="https://www.dropbox.com/s/eoq35cgs1x43u9v/website_alfam2.png?raw=1" alt=""></a>
        <p>This app fills the need for a researcher to make the data from a project publicly accessible. I'm most happy with how well the data subsetting for this app works. Data subsetting is day-1 stuff in R, but somehow it was not intuitive to display the relative contents of the subset compared to the entire dataset in an interactive setting. I posted a few notes about this in my short blog.</p>
    </div>
    <div style="border:1px solid gray;padding:15px 0px;">
        <a style="font-size:large;" href="https://biotransformers.shinyapps.io/oba1/" target="_blank">The Online Biogas Calculator</a> 
        <a href="https://biotransformers.shinyapps.io/oba1/" target="_blank"><img style="width:1000px;" src="https://www.dropbox.com/s/5o246v7qmf6wexd/website_biogas.png?raw=1" alt=""></a> 
        <p>This app is a calculator for computing the volume of methane biogas produced by controlled digesters. It is essentially a web interface for the R package <a href="https://cran.r-project.org/package=biogas" target="_blank">biogas</a> by Sasha Hafner et al. This is an early app, but still completely functional. </p>
    </div>
    
</div>
























