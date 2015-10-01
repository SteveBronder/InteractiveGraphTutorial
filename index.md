---
title       : Pretty Graphs in R
subtitle    : A Realistic Approach
author      : Steve Bronder
job         : Marketing Analyst 
framework   : revealjs        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : github      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
ext_widgets: {rCharts: "libraries/highcharts"}
revealjs:
  theme: Simple
--- 

### Pretty Graphs in R


 A Realistic Approach
 \- Steve Bronder

--- 

### Outline

<ul class='incremental'>
  <li class='fragment'>What is R?</li>
  <li class='fragment'>Why and why not R?</li>
  <li class='fragment'>Describing the Language</li>
  <li class='fragment'>Data manipulation examples</li>
  <li class='fragment'>Pretty graph examples</li>
  <li class='fragment'>NLP in R</li>
  <li class='fragment'>Learning Resources</li>
</ul>

---

### What is R?

<ul class='incremental'>
  <li class='fragment'>Statistical language for data analysis</li>
    <li class='fragment'>Simple and effective language </li>
  <li class='fragment'>Can talk to Python, Julia, C, C++, HTML, CSS, etc.</li>
  <li class='fragment'>Extended by user contributions</li>
</ul>


---  .class &vertical 

### Why useR?



<ul class='incremental'>
  <li class='fragment'>Created by Statisticians</li>
  <li class='fragment'>Strong Community</li>
  <li class='fragment'>Being lazy. work smart and efficient</li>
  <li class='fragment'>Easy to prototype and make actionable</li>
  <li class='fragment'>Nothing beats R in Graphics</li>
</ul>


<script>
$('ul.incremental li').addClass('fragment')
$('ol.incremental li').addClass('fragment')
</script>

***

### Why notR?

<ul class='incremental'>
  <li class='fragment'>Created by Statisticians</li>
  <li class='fragment'>Sharp learning curve</li>
  <li class='fragment'>No more point and clicking</li>
  <li class='fragment'>Funky syntax</li>
   <li class='fragment'>Poorly written R code is terribly slow</li>
</ul>


<script>
$('ul.incremental li').addClass('fragment')
$('ol.incremental li').addClass('fragment')
</script>

***

### Fast and Slow R Code


```r
library(microbenchmark)
```

```
## Error in library(microbenchmark): there is no package called 'microbenchmark'
```

```r
x <- runif(100)
microbenchmark(
  sqrt(x),
  x ^ 0.5
)
```

```
## Error in eval(expr, envir, enclos): could not find function "microbenchmark"
```


--- .class &vertical 

### Describing the Language
##### Everything is a function


```r
1 + 1
```

```
## [1] 2
```

```r
`+`(1,1)
```

```
## [1] 2
```


***

### Describing the Language
##### Make Statistics Easy


```r
data(iris)
fit.1 <- lm(Sepal.Length ~ Petal.Length + Species, data = iris)
```


```
## Error in loadNamespace(name): there is no package called 'stargazer'
```

---  .class &vertical 

### Describing the Language
##### informal and formal OO systems available


```r
library(pryr)
```

```
## Error in library(pryr): there is no package called 'pryr'
```

```r
# make a generic class and throw random things into it
foo <- structure(list(), class = "foo")
foo$balance <- 100
foo$withdraw <- function(x){
  foo$balance <<- foo$balance - x
}
foo$deposit <- function(x){
  foo$balance <<- foo$balance + x
}

foo$withdraw(10)
foo$deposit(1000)
foo$balance
```

```
## [1] 1090
```

```r
otype(foo)
```

```
## Error in eval(expr, envir, enclos): could not find function "otype"
```


*** 

### Describing the language
##### informal and formal OO systems available


```r
library(methods)
# make a formal RC class
Accounts <- setRefClass("Accounts",
  fields = list(balance = "numeric"),
  methods = list(
    withdraw = function(x) {
      balance <<- balance - x
    },
    deposit = function(x) {
      balance <<- balance + x
    }
  )
)

a <- Accounts$new(balance = 100)
a$deposit(100)
a$balance
```

```
## [1] 200
```

```r
a$lottery <- "Insert winning lottery numbers here"
```

```
## Error in envRefSetField(x, what, refObjectClass(x), selfEnv, value): 'lottery' is not a field in class "Accounts"
```

```r
otype(a)
```

```
## Error in eval(expr, envir, enclos): could not find function "otype"
```


--- .class &vertical 

### Data manipulation in R
##### data.table Objective

<ol class='incremental'>
  <li class='fragment'>Develop light, SQL style data manipulation language in R.</li>
    <li class='fragment'>Fast, readable, consistent </li>
</ol>


***

### Data manipulation in R

- Create bins by flower type for sepal length


```r
library(reshape2)
data(iris)
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

```r
iris$cut.sepal <- melt(vapply(split(iris$Sepal.Length,iris$Species),
                   function(x) cut(x,5),vector(mode = "integer", length=50)))$value
head(iris,n=5)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species cut.sepal
## 1          5.1         3.5          1.4         0.2  setosa         3
## 2          4.9         3.0          1.4         0.2  setosa         3
## 3          4.7         3.2          1.3         0.2  setosa         2
## 4          4.6         3.1          1.5         0.2  setosa         1
## 5          5.0         3.6          1.4         0.2  setosa         3
```

***

### Data manipulation in R
##### data.table Answer

  `data[i , j, by]`

| Syntax  | SQL     | Meaning             | Example                         |
| ------- |:-------:|:-------------------:| -------------------------------:|
| i       |WHERE    | subset rows by i    | price > 0                       |
| j       |SELECT   | using column j      | logPrice := log(price)          |
| by      |GROUP-BY | grouped by          | by = store                      |




```r
iris <- data.table(iris)
```

```
## Error in eval(expr, envir, enclos): could not find function "data.table"
```

```r
iris[Petal.Width >=.2 , cut.sepal := as.integer(cut(Sepal.Length, 5)), by = Species]
```

```
## Error in `[.data.frame`(iris, Petal.Width >= 0.2, `:=`(cut.sepal, as.integer(cut(Sepal.Length, : unused argument (by = Species)
```

--- .class &vertical

### Example: Cleaning Data
General Payment Dataset:
> - All general payments made to physicians and hospitals 
> - Recipients name, address, and specialty, payment, and "nature of payment", etc.
> - 2.6 million by 63 variables


```r
library(data.table, quietly =  TRUE,warn.conflicts = FALSE)
```

```
## data.table 1.9.6  For help type ?data.table or https://github.com/Rdatatable/data.table/wiki
## The fastest way to learn (by data.table authors): https://www.datacamp.com/courses/data-analysis-the-data-table-way
```

```r
dat <- fread("/home/steve/Documents/OP_DTL_GNRL_PGYR2013_P06302015.csv")
```

```
## Read 0.0% of 4055634 rowsRead 1.7% of 4055634 rowsRead 3.7% of 4055634 rowsRead 7.6% of 4055634 rowsRead 12.1% of 4055634 rowsRead 17.3% of 4055634 rowsRead 23.9% of 4055634 rowsRead 30.8% of 4055634 rowsRead 32.5% of 4055634 rowsRead 38.5% of 4055634 rowsRead 42.9% of 4055634 rowsRead 50.8% of 4055634 rowsRead 56.2% of 4055634 rowsRead 63.6% of 4055634 rowsRead 70.8% of 4055634 rowsRead 71.0% of 4055634 rowsRead 77.9% of 4055634 rowsRead 82.6% of 4055634 rowsRead 90.5% of 4055634 rowsRead 90.7% of 4055634 rowsRead 98.1% of 4055634 rowsRead 4055634 rows and 63 (of 63) columns from 1.984 GB file in 00:00:33
```
***

### Example: Aggregation


```r
#Remove $ sign from Dollars column
  dat[ , Total_Amount_of_Payment_USDollars := as.numeric(substring(Total_Amount_of_Payment_USDollars,2))]

# Set the key variable for taking unique values
setkey(dat, Recipient_State)

#Get the averages for each state
  dat.means <- unique(dat[, mean(Total_Amount_of_Payment_USDollars,
                                           na.rm = TRUE),by = Recipient_State])
```

<!---
This actually runs
-->

```r
#Remove $ sign from Dollars column
invisible(
  dat[ , Total_Amount_of_Payment_USDollars := as.numeric(substring(Total_Amount_of_Payment_USDollars,2))]
  )

# Set the key variable for taking unique values
setkey(dat, Recipient_State)

#Get the averages for each state
system.time(
  dat.means <- unique(dat[, mean(Total_Amount_of_Payment_USDollars,
                                           na.rm = TRUE),by = Recipient_State])
  )
```

```
##    user  system elapsed 
##   0.032   0.000   0.033
```

```r
rm(dat)
```



***

### Example: Displaying Data



<iframe src="dat.means.html"style="border: none; width: 1200px; height: 1000px"></iframe>

***

### Example: Cleaning Data

```r
dim(dat.means)
```

```
## Error in eval(expr, envir, enclos): object 'dat.means' not found
```

```r
# Set keys
setkey(dat.means, state)
```

```
## Error in setkey(dat.means, state): object 'dat.means' not found
```

```r
dat.means <- dat.means[!c("AA","AE","PR","VI","ON","AP","GU")]
```

```
## Error in eval(expr, envir, enclos): object 'dat.means' not found
```

```r
dat.means <- dat.means[nzchar(state)]
```

```
## Error in eval(expr, envir, enclos): object 'dat.means' not found
```

***

### Example: Making Interactive

```r
library(rMaps)
library(htmlwidgets)
library(rcstatebin)
map <- statebin(as.data.frame(dat.means), payments ~ state,
                heading = "<b>Average Payment from Pharmaceutical Companies to Doctors By State</b>",
                footer = "<small>Data comes from openpaymentsdata.cms.gov</small>",
                type = "hex")

saveWidget(map,"mean_states.html", selfcontained = FALSE)
```

***

### Example: End Result

```r
cat('<iframe src="./mean_states.html" width=100%, height=600></iframe>')
```

<iframe src="./mean_states.html" width=100%, height=600></iframe>

---  .class &vertical 

### rCharts: D3 in R

> - Create and customize interactive visualizations
> - Gives access to multiple D3 libraries
> - Easy to make and share

***

### A Lot from a Little


```r
library(rCharts)
library(knitr)
#read in csv
tobacco <- fread(
  "C:/Users/SBronder/Documents/Projects/prettyGraphs/tobacco.csv",header=TRUE)
# Source:
# https://research.stlouisfed.org/fred2/series/M0188AUSM149NNBR

# Convert characters to dates in seconds
  tobacco[, dates :=  as.numeric(
  as.POSIXct(tobacco$dates, origin="1929-06-14")) * 1000]
```

<!---
This actually runs
-->

```
Error in fread("C:/Users/SBronder/Documents/Projects/prettyGraphs/tobacco.csv", : File 'C:/Users/SBronder/Documents/Projects/prettyGraphs/tobacco.csv' does not exist. Include one or more spaces to consider the input a system command.
```

```
Error in eval(expr, envir, enclos): object 'tobacco' not found
```


```
## Error in loadNamespace(name): there is no package called 'stargazer'
```
***

### Making FRED plots

```r
# use rCharts to access Highcharts d3 library
h1 <- hPlot( 
  Tobacco_Consumption ~ dates,
  data = as.data.frame(tobacco),
  type = "line",
  title = "Tobacco Consumption, Manufactured Tobacco Supplies for United States"
           )
```

```
## Error in as.data.frame(tobacco): object 'tobacco' not found
```

```r
# Set type for x/y axis
h1$xAxis(type = "datetime")
```

```
## Error in eval(expr, envir, enclos): object 'h1' not found
```

```r
h1$yAxis(title = list(text = "Tobacco Consumption in Millions lb."))
```

```
## Error in eval(expr, envir, enclos): object 'h1' not found
```

```r
# Allow zoom
h1$chart(zoomType = "x")
```

```
## Error in eval(expr, envir, enclos): object 'h1' not found
```

```r
h1$tooltip(formatter = # Kimm - how to make custom tooltip
              "#! function() { return 'Date: '     + 
                              Highcharts.dateFormat('%b/%e/%Y',
                                                    new Date(this.x)) +
                              '<br>' +'Consumption: ' + this.point.y; } !#")
```

```
## Error in eval(expr, envir, enclos): object 'h1' not found
```

`$object` comes from the [highchart's API](http://api.highcharts.com/highcharts) 

***

### Making FRED plots


```
Error in eval(expr, envir, enclos): object 'h1' not found
```

***

### Making Bubble Chart


```r
a <- hPlot(Pulse ~ Height, data = MASS::survey, type = "bubble",
           title = "Zoom demo", subtitle = "bubble chart",
           size = "Age", group = "Exer")

a$chart(zoomType = "xy")
a$exporting(enabled = T)
```

***

### Making Bubble Chart


```
Loading required package: base64enc
```

```
Warning in library(package, lib.loc = lib.loc, character.only = TRUE,
logical.return = TRUE, : there is no package called 'base64enc'
```

```
Error: You need to install the base64enc package.
```




***

## Example App

<iframe src="https://johnricco.shinyapps.io/metro_walksheds/" style="border: none; width: 1200px; height: 900px"></iframe>


---  .class &vertical 

## Natural Language Processing



```
## Error in library(tm): there is no package called 'tm'
```

```
## Error in library(slam): there is no package called 'slam'
```

```
## Error in library(wordcloud): there is no package called 'wordcloud'
```

```
## Error in library(stm): there is no package called 'stm'
```

```
## Error in library(LDAvis): there is no package called 'LDAvis'
```

```
## Warning in file(file, "rt", encoding = fileEncoding): cannot open file 'Z:/
## BAGroup/Share/SBronder/prettyGraphs_old/Pens_Tweets_Downtown_Pgh.csv': No
## such file or directory
```

```
## Error in file(file, "rt", encoding = fileEncoding): cannot open the connection
```

```
## Error in gsub("â€", "", docsDowntown$text): object 'docsDowntown' not found
```

```
## Error in gsub("â", "", docsDowntown$text): object 'docsDowntown' not found
```

```
## Error in gsub("\n", "", docsDowntown$text): object 'docsDowntown' not found
```

```
## Error in gsub("-", " to ", docsDowntown$text): object 'docsDowntown' not found
```

```
## Error in gsub("&gt;", ">", docsDowntown$text): object 'docsDowntown' not found
```

```
## Error in gsub("&lt;", "<", docsDowntown$text): object 'docsDowntown' not found
```

```
## Error in gsub("\\", "", docsDowntown$text, fixed = TRUE): object 'docsDowntown' not found
```

```
## Error in eval(expr, envir, enclos): could not find function "VCorpus"
```

```
## Error in eval(expr, envir, enclos): could not find function "DocumentTermMatrix"
```

```
## Error in eval(expr, envir, enclos): object 'twt_dtm' not found
```

```
## Error in eval(expr, envir, enclos): object 'twt_dtm' not found
```

```
## Error in eval(expr, envir, enclos): object 'twt_dtm' not found
```

```
## Error in eval(expr, envir, enclos): object 'twt_dtm' not found
```

```
## Error in eval(expr, envir, enclos): could not find function "DocumentTermMatrix"
```

```
## Error in tapply(twt_dtm$v/row_sums(twt_dtm)[twt_dtm$i], twt_dtm$j, mean): object 'twt_dtm' not found
```

```
## Error in eval(expr, envir, enclos): object 'twt_dtm' not found
```

```
## Error in eval(expr, envir, enclos): object 'twt_dtms' not found
```

> - The application of statistical modeling to unstructured text data (Corpora)
> - Use: Grouping documents, search, inference prediction

***

### NLP: Data Structure

> - Corpus - Collection of text with similar attributes
> - Document Term Matrix: Word counts per document
>   * Rows: Documents
>   * Columns: Words

***

### NLP: Making Corpus


```r
# Read in csv
docsDowntown <- read.csv("Z:/BAGroup/Share/SBronder/prettyGraphs_old/Pens_Tweets_Downtown_Pgh.csv",header=TRUE,sep=",",
                         fileEncoding= "native.enc",stringsAsFactors = FALSE)

# Create corpus
corpus <- VCorpus(VectorSource(docsDowntown$text))

# Create Document Term Matrix + cleaning
twt_dtm <- DocumentTermMatrix(corpus , control = list(stemming = TRUE,
                                                      minWordLength = 1,
                                                      removePunctuation = TRUE))
```
 
***

### NLP: Cleaning

> - Stemming
> - Bagging
> - Stop words?
<ul class='incremental'>
  <li class='fragment'>Maybe not</li>
  <li class='fragment'>He is the king of Spain</li>
  <li class='fragment'>He and the king are from Spain</li>
  <li class='fragment'> Rm Stops: "he king Spain"</li>
</ul>



***

### NLP: TFIDF
<ul class='incremental'>
  <li class='fragment'>Term Frequency-Inverse Document Frequency</li>
  <li class='fragment'>Most common words across documents</li>
</ul>
  

```r
# Create term frequency-inverse document frequency 
term_tfidf <- tapply(twt_dtm$v/row_sums(twt_dtm)[twt_dtm$i], twt_dtm$j, mean) *
  log2(nDocs(twt_dtm)/col_sums(twt_dtm > 0))
```


```
## Error in loadNamespace(name): there is no package called 'stargazer'
```

***

### NLP: TF-IDF Scores

```
Error in density(term_tfidf): object 'term_tfidf' not found
```

```
Error in data.frame(x = term_density$x, y = term_density$y): object 'term_density' not found
```

```
Error in term_density$Var <- "tf-idf": object 'term_density' not found
```

```
Error in getLayer.default(...): object 'term_density' not found
```

```
Error in eval(expr, envir, enclos): object 'dens' not found
```

```
Error in eval(expr, envir, enclos): object 'dens' not found
```


```r
# Only take words with a score > 1 and whose rows sum to zero
twt_dtms <- twt_dtm[, term_tfidf >= 1]
twt_dtms <- twt_dtms[row_sums(twt_dtms) > 0,]
summary(col_sums(twt_dtms))
```

***

### NLP: WordClouds


```r
# Return frequency table for words showing up
freq <- sort(col_sums(twt_dtms, decreasing = F))
```

```
Error in sort(col_sums(twt_dtms, decreasing = F)): could not find function "col_sums"
```

```r
wordcloud(names(freq), freq, max.words=100,
          min.freq = 80,colors=brewer.pal(6, "Dark2"))
```

```
Error in eval(expr, envir, enclos): could not find function "wordcloud"
```

***

### NLP: Correlations between words


```r
plot(twt_dtms,terms=findFreqTerms(twt_dtms, lowfreq=220)[1:20],corThreshold=0.001)
```

```
## Error in plot(twt_dtms, terms = findFreqTerms(twt_dtms, lowfreq = 220)[1:20], : object 'twt_dtms' not found
```

--- .class &vertical 

### NLP: Topic Models

> - NLP model for finding abstract "topics" that occur in a corpus
<ul class='incremental'>
  <li class='fragment'>Soft clustering technique</li>
  <li class='fragment'>Helps classify unstructured data</li>
  <li class='fragment'>Many unanswered questions</li>
</ul>

***

### NLP: Graph for topic model
[Link if iframe is broken](http://bl.ocks.org/Stevo15025/raw/d1f5a9ccbb36784ac9e2/#topic=0&lambda=1&term=now)

<iframe src="http://bl.ocks.org/Stevo15025/raw/d1f5a9ccbb36784ac9e2/#topic=0&lambda=1&term=now" style="border: none; width: 1200px; height: 1000px"></iframe>

---

## Resouces for Learning R

> - [Data Mining with R](http://www.dainf.ct.utfpr.edu.br/~kaestner/Mineracao/RDataMining/Data%20Mining%20with%20R-Kumar.pdf)
> - [Stackoverflow](http://stackoverflow.com/questions/tagged/r?sort=frequent&pageSize=50)
> - [NLP](http://onepager.togaware.com/TextMiningO.pdf)
> - [Datacamp](https://www.datacamp.com/courses/free-introduction-to-r)
> - [R-bloggers](http://www.r-bloggers.com/)


