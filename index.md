---
layout: default
title: Jon Katz
description: Jon Katz is a postdoctoral researcher at the University of Vermont's Cooperative Fish adn Wildlife Research Unit.
keywords: Katz, data visualization, data analysis, shiny, R, CRAN, statistics
---

<!--<div class="navbar navbar-default">-->
<!--  <div class="navbar navbar-collapse" style="margin-bottom:0px;">-->
<!--      <ul class="nav navbar-nav">-->
<!--          <li><a href="{{ BASE_PATH }}/assets/blog/blog.html">blog</a></li>-->
<!--          <li><a href="{{ BASE_PATH }}/assets/jkatzResume.pdf">resume</a></li>-->
<!--          <li><a href="https://github.com/jonkatz2">github</a></li>-->
<!--      </ul>-->
<!--  </div>-->
<!--</div>-->

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-104441725-1', 'auto');
  ga('send', 'pageview');

</script>


<div>
    <div style="font-size:1.25em;font-weight:bold;text-align:center;">
        <a style="color:black;" href="{{ BASE_PATH }}/assets/blog/blog.html">Recent posts</a>
    </div>

    {% for post in site.posts %}
        <li><span>{{ post.date | date_to_string }}</span> » <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a></li>
    {% endfor %}

</div>
























