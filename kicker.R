library(rCharts)
library(rMaps)
library(slidify)
library(htmlwidgets)
library(rcstatebin)

saveWidget(map,"mean_states.html")

slidify("./index.Rmd")
servr::httd()



#map <- ichoropleth(mean_payments ~ Recipient_State,
#            data = as.data.frame(dat.means),
#            pal = 'PuRd',
#            ncuts = 5)

.fragment
> - point 1
> - point 2

> .fragment - Created by Statisticians
> .fragment - Being lazy. work smart and efficient

.fragment > - Easy to prototype and make actionable
.fragment > - Nothing beats R in Graphics
