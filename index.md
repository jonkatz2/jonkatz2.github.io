---
layout: default
title: Jon Katz
description: Jon Katz is a freelance data analyst.
keywords: Katz, data visualization, data analysis, shiny, R, CRAN, statistics
---
<!-- HEADER -->
<div id="header_wrap" class="outer topelement">
    <div class="row">
        <div class="col-sm-4">
            <img id="headerimg" src="{{ BASE_PATH }}/assets/images_sm/plot.png">
        </div>
        <div class="col-sm-8">
            <header id="index_inner" class="inner">
                <a style="color:#fff;" href="https://jonkatz2.github.io/"><h1 id="project_title">Jonathan Katz</h1></a>
                <h2 id="project_tagline">Programmer, Data Analyst, Wildlife Biologist</h2>
            </header>
        </div>
    </div>  
<!--          {% if site.show_downloads %}-->
<!--            <section id="downloads">-->
<!--              <a class="zip_download_link" href="{{ site.github.zip_url }}">Download this project as a .zip file</a>-->
<!--              <a class="tar_download_link" href="{{ site.github.tar_url }}">Download this project as a tar.gz file</a>-->
<!--            </section>-->
<!--          {% endif %}-->
</div>



<div class="container-fluid">
  <div class="row">
<!--    <div class="col-sm-3">-->
      <a href="/shiny" class="mygrid">
        <p class="gridtitle">Shiny Applications</p>
        <img class="gridimg" src="{{ BASE_PATH }}/assets/images_sm/grab1_sq.png" alt="Go to shiny gallery">
      </a>
<!--    </div>-->
<!--    <div class="col-sm-3">-->
<!--      <a href="/shiny" class="mygrid">-->
<!--        <p class="gridtitle">Server-side Coding</p>-->
<!--        <img class="gridimg" src="{{ BASE_PATH }}/assets/images_sm/flowpart_sq.png" alt="Application planning">-->
<!--      </a>-->
<!--    </div>-->
<!--    <div class="col-sm-3">-->
      <a href="/shiny" class="mygrid">
        <p class="gridtitle">Statistical Analysis</p>
        <img class="gridimg" src="{{ BASE_PATH }}/assets/images_sm/stratifiedParams_closed_sq.png" alt="Statistical analysis">
      </a>
<!--    </div>-->
<!--    <div class="col-sm-3">-->
      <a href="https://jonkatz2.github.io/2017/11/15/interpolating-points-to-raster-in-r" class="mygrid">
        <p class="gridtitle">Spatial Analysis</p>
        <img class="gridimg" src="{{ BASE_PATH }}/assets/images_sm/rastermap_sq.png" alt="Spatial analysis">
      </a>
<!--    </div>-->
<!--    <div class="col-sm-3">-->
      <a href="http://jonkatz2.github.io/monitoR" class="mygrid">
        <p class="gridtitle">R Packages</p>
        <img class="gridimg" src="{{ BASE_PATH }}/assets/images_sm/monitor_sq.png" alt="R packages">
      </a>
<!--    </div>-->
  </div>
</div>

<!--    <div style="font-size:1.25em;font-weight:bold;text-align:center;">-->
<!--        <p>Freelance R Programming, Data Analysis, and Shiny Engineer</p>-->
<!--    </div>-->
<!--    <p>Lately I have been writing lots of shiny applications. R does not run natively in a web browser, but it has many native and contributed entry points to exchange objects with other languages. The Shiny package from RStudio allows R and javascript to exchange information, along with a host of R functions to build HTML inputs. Using Shiny it is easy to make a dataset not only public, but publicly explorable, and applications are easy to build, easy to host, and easy to maintain.</p>-->
<!--    -->
<!--    <p>Here are a few public applications I recently completed. The titles and images link to live applications; if I am self-hosting them and they do not load, I am probably out of time in my account. Send me a note and I'll make sure you can explore them.</p>-->
<!--    -->
<!--    <p>You might also want to <a href="http://jonkatz2.github.io/resume" target="_blank">check out my resume</a>, or I have a couple of blog posts <a href="http://jonkatz2.github.io/2016/05/01/mapping-with-base-graphics-in-r" target="_blank">illustrating some simple R functions I wrote.</a></p>-->
<!--    -->
<!--    <div style="clear:both;border:1px solid gray;margin:8px 0px;padding:8px;overflow:hidden;">-->
<!--        <div class="col-sm-6">-->
<!--            <a style="font-size:large;" href="https://vtcfwru-am.shinyapps.io/AMExpertModeler/" target="_blank">An Interactive Expert Elicitation Tool</a>-->
<!--            <div class="imgcontainer">-->
<!--                <a href="https://vtcfwru-am.shinyapps.io/AMExpertModeler/" target="_blank"><img class="imglink" src="https://www.dropbox.com/s/3i1ryww2j2meh9l/website_elicit2.png?raw=1" alt=""></a>-->
<!--                <div class="middle">-->
<!--                  <a class="imglinktext" style="font-size:large;" href="https://vtcfwru-am.shinyapps.io/AMExpertModeler/" target="_blank">Open App</a>-->
<!--                </div>-->
<!--            </div>-->
<!--        </div>-->
<!--       -->
<!--         <div class="col-sm-6">   -->
<!--            <p style="padding-top:17px;"><strong>An interactive survey to gather expert opinion on species occurrence at a number of points. </strong></p>-->
<!--            <p>Experts log in, respond to questions about their expertise, then offer opinions on species presence at a number of locations.</p>-->
<!--            -->
<!--            <p><emph>To browse this app as a guest, login with the username "guest."</emph></p>-->
<!--            -->
<!--            -->
<!--            <p>This app is shared by three projects, so there is a separate private app that allows each project's principal investigator to customize the survey and download responses. Customization includes the ability to:</p>-->
<!--            -->
<!--            <ul>   -->
<!--                <li>Upload points</li> -->
<!--                <li>Change the number/type/content of each survey question</li> -->
<!--                <li>Rename variables</li> -->
<!--                <li>Add/remove experts</li> -->
<!--                <li>Add/remove features. Some features include:-->
<!--                    <ul>-->
<!--                        <li>Fixed or random starting values</li>-->
<!--                        <li>Ordered or random point presentation</li>-->
<!--                        <li>Multiple distributions (beta, poisson, normal), a simple number line, or a likert selector</li>-->
<!--                        <li>Supplemental imagery/graphics</li>-->
<!--                        <li>Variable number of points</li>-->
<!--                    </ul>-->
<!--                </li> -->
<!--            </ul>-->
<!--            -->
<!--            <p>The survey parameters and expert responses are stored in a mongoDB (no-SQL) database hosted at <a href="https://mlab.com/" target="_blank">mlab.com*</a>. Project PIs upload locations as a shapefile containing either polygons or points; persistent file storage for the shapefile is via an AWS S3 storage bucket.</p>-->
<!--            -->
<!--            <p><emph>*I have also used AWS RDS as a relational database back-end for other apps.</emph></p>-->
<!--        </div> -->
<!--    </div>-->
<!--    -->
<!--    <div style="clear:both;border:1px solid gray;margin:8px 0px;padding:8px;overflow:hidden;">-->
<!--        <div class="col-sm-6">-->
<!--            <a style="font-size:large;" href="https://jkatz.shinyapps.io/tradeoff/" target="_blank">An MCDA Visualization</a>-->
<!--            <div class="imgcontainer">-->
<!--                  <a href="https://jkatz.shinyapps.io/tradeoff/" target="_blank"><img class="imglink"  src="https://www.dropbox.com/s/hv88ybgyl4atxvm/website_tradeoff.png?raw=1" alt=""></a>-->
<!--                  <div class="middle">-->
<!--                    <a class="imglinktext" style="font-size:large;" href="https://jkatz.shinyapps.io/tradeoff/" target="_blank">Open App</a>-->
<!--                  </div>-->
<!--            </div>-->
<!--        </div>-->
<!--          -->
<!--        <div class="col-sm-6">-->
<!--            <p style="padding-top:17px;"><strong>Multiple-criteria decision analysis</strong> is a decision strategy that offers transparency to the process of integrating input from a variety of stakeholders. This app was designed to visualize how various strategies to restore natural tidal flows to an estuary on Cape Cod, Massachussets will affect residents, the local economy, and local areas with historic or scenic value. The goal is to maximize the benefits of natural tidal flow such as flood control, improved wildlife habitat, and reduced management costs while minimizing negative impacts such as sediment movement, stagnant water, or vegetation mortality due to floodplain inundation. The app is driven by two csv files of parameters and a series of prediction files, all uploaded at the start of the process (sample csv files can be downloaded in using the menu in the upper right). The full analysis can be saved so that it may be re-visited in the future without re-parameterizing the entire app. The app also produces a variety of graphics to inform management or support the decision making process. Persistent file storage for this app is on Google Drive, which is free and convenient due to the web-editing capability. </p>-->

<!--            <p>To ensure you can see the final graphs, here are brief instructions for use:</p>-->
<!--            <ol>-->
<!--                <li>Download and extract the sample data using the menu at the top right.</li>-->
<!--                <li>Upload "Policies.csv" as the policy file. Under "Group/Name Policies" down below, enter a 1 in the "Group" row for both the right-most columns ("P_Sed1" and "P_Sed11") to indicate they are members of a group. Leave all other fields in the "Group" row blank. Enter a 1 in the "Allocation" row under P_Sed1, and 11 in the "Allocation" row under P_Sed11. Leave all other fields in the "Allocation" row blank.</li>-->
<!--                <li>Upload "Attributes.csv" as the attribute file.</li>-->
<!--                <li>Upload one or both "EE_Predictions_Tim.csv" and "EE_Predictions_Eric.csv" as expert prediction files.</li>-->
<!--                <li>Upload "models_LOOKUP.csv" and "models_INTERP.csv" as model prediction files.</li>-->
<!--                <li>View the "Group Objectives" tab (no need to change anything, but it must be viewed)</li>-->
<!--                <li>View the "Prediction Sources" tab (no need to change anything, but it must be viewed)</li>-->
<!--            </ol>-->
<!--            -->
<!--            <p>I am self-hosting this app during development, but it will be hosted by the client on completion. If it doesn't load I may have run out of time on my free shinyapps.io account. Drop me an email and I'll send you an active link to a functional app.</p>-->
<!--        </div>-->
<!--    </div>-->
<!--    -->
<!--    <div style="clear:both;border:1px solid gray;margin:8px 0px;padding:8px;overflow:hidden;">-->
<!--        <div class="col-sm-6">-->
<!--            <a style="font-size:large;" href="https://biotransformers.shinyapps.io/ALFAM2/" target="_blank">An Explorable Dataset</a>-->
<!--            <div class="imgcontainer">-->
<!--                <a href="https://biotransformers.shinyapps.io/ALFAM2/" target="_blank"><img class="imglink" src="https://www.dropbox.com/s/eoq35cgs1x43u9v/website_alfam2.png?raw=1" alt=""></a>-->
<!--                <div class="middle">-->
<!--                    <a class="imglinktext" style="font-size:large;" href="https://biotransformers.shinyapps.io/ALFAM2/" target="_blank">Open App</a>-->
<!--                </div>-->
<!--            </div>-->
<!--        </div>-->
<!--      -->
<!--        <div class="col-sm-6">-->
<!--          <p style="padding-top:17px;"><strong>Making data public, and publicly explorable.</strong> The researcher who commissioned this app was required by his grant to make the data publicly accessible. I like how the data subsetting is presented on-screen, where options that are not present in the data are shown in gray (see lower checkboxes in image at left). Data subsetting is day-one stuff in R, but somehow it was not intuitive to display the relative contents of the subset compared to the entire dataset in an interactive setting. I posted <a href="http://jonkatz2.github.io/2017/08/11/Dynamic-Filtered-checkboxGroupInputs-In-Shiny-Applications" target="_blank">a few notes about this</a> in my short blog.</p>-->
<!--        </div>-->
<!--    </div>-->
<!--        -->
<!--    <div style="clear:both;border:1px solid gray;margin:8px 0px;padding:8px;overflow:hidden;">-->
<!--        <div class="col-sm-6">-->
<!--            <a style="font-size:large;" href="https://biotransformers.shinyapps.io/oba1/" target="_blank">The Online Biogas Calculator</a> -->
<!--            <div class="imgcontainer">-->
<!--                <a href="https://biotransformers.shinyapps.io/oba1/" target="_blank"><img class="imglink" src="https://www.dropbox.com/s/5o246v7qmf6wexd/website_biogas.png?raw=1" alt=""></a> -->
<!--                <div class="middle">-->
<!--                    <a class="imglinktext" style="font-size:large;" href="https://biotransformers.shinyapps.io/oba1/" target="_blank">Open App</a>-->
<!--                </div>-->
<!--            </div>-->
<!--        </div>-->

<!--        <div class="col-sm-6">-->
<!--            <p style="padding-top:17px;"><strong>An interactive calculator.</strong> This app is a calculator for computing the volume of methane biogas produced by controlled digesters. It is essentially a web interface for the R package <a href="https://cran.r-project.org/package=biogas" target="_blank">biogas</a> by Sasha Hafner et al. This package, and this app, are proving to be essential tools for members of the biofuel industry, particularly in Europe. </p>-->
<!--        </div>-->
<!--    </div>-->
<!--    -->
<!--</div>-->
























