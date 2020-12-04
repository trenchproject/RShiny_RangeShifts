guide <- Cicerone$
  new()$
  step(
    el = "plot-wrapper",
    title = "Plot",
    description = HTML("The plot shows the climate velocity of populations' thermal envelope against the observed shift of populations.<br>
                       The yellow line represent a 1-to-1 line, which tells you if the population is shifting more or less compared to the thermal envelope.")
  )$
  step(
    el = "switch-wrapper",
    title = "Latitude/Depth",
    description = "This button toggles between two plots that show different directions of the shifts. Greater values correspond to further north in the latitude plot and deeper in the depth plot. Keep it at <b>Latitude</b> for now."
  )$
  step(
    el = "plot-wrapper",
    title = "Plot details",
    description = HTML("Hover over the point at (0.04, 0.28). It shows you what species the point represents and which taxa it belongs to. 
                       We can learn that <em>Anarhichas denticulatus</em> is a fish species, and it shifted 0.28 degrees North per year when its thermal envelope only moved by 0.04 degrees per year.
                       It is way above the 1-to-1 line.")
  )$
  step(
    el = "sidebar-wrapper",
    title = "Taxa and regions",
    description = HTML("This tells you which taxa from which region are plotted.<br> 
                       Let's see how <b>Fish</b> from the <b>Aleutians</b> are doing. Select <b>Fish</b> under taxa and <b>Aleutians</b> under regions. Then hit next."),
    position = "top"
  )$
  step(
    el = "plot-wrapper",
    title = "New plot",
    description = "Now we see how fish from Aleutians have shifted their range. The thermal envelope in the region seems to be moving slightly to the North and the fish are shifting more or less along with it."
  )$
  step(
    el = "viz-wrapper",
    title = "End of tour",
    description = "That's it for a quick tour. Move around the variables and make your own plot!"
  )