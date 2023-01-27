# Targets demos

## A workflow manager

[**Targets**](https://github.com/ropensci/targets) is an **R** package that is

>Function-oriented Make-like declarative workflows for R 

Main author: [William Landau](https://wlandau.github.io/about.html).
See the `targets` [manual](https://books.ropensci.org/targets/literate-programming.html) for an extensive documentation.

The goal is to create so-called `targets` that are significant steps that linked between one another.
Those links create the dependencies, and once one `target` run successfully and its upstream dependencies are up-to-date,
they are no reason to run it again. Time/Computing intensive steps are then cached in the `store`.

Invalidation of a `target` arises when:

- Upstream targets invalidate (or input files _checksum_ for special `format = "file"`)
- Code of the targets changed
- Package used was updated

## Example dataset: datasauRus ![](https://jumpingrivers.github.io/datasauRus/logo.png){height=100}

The great package [`datasauRus`](https://jumpingrivers.github.io/datasauRus/) offers a fake table which
 consists of 13 dataset (each of 142 observations) with 2 values `x` and `y`:
 
```
# A tibble: 1,846 × 3
   dataset     x     y
   <chr>   <dbl> <dbl>
 1 dino     55.4  97.2
 2 dino     51.5  96.0
 3 dino     46.2  94.5
 4 dino     42.8  91.4
 5 dino     40.8  88.3
 6 dino     38.7  84.9
 7 dino     35.6  79.9
 8 dino     33.1  77.6
 9 dino     29.0  74.5
10 dino     26.2  71.4
# … with 1,836 more rows
```

For each the 3 demos, we use different versions of the same data:

- One tabulated-separated-value (tsv) file of 1847 lines (1846 observations + 1 header)
- One folder that contains 13 tsv of 143 lines 
- Three folders of 2, 4 and 7 tsv of 143 lines each


## One file, linear pipeline

Using the 

![ds1](img/dag_linear.png)

## One folder, dynamic branching


![ds2](img/dag_dynamic.png)


## Several folders, dynamic within static branching


![ds3](img/dag_static.png)
