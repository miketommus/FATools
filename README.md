
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **FATools**

<!-- badges: start -->

![GitHub R package
version](https://img.shields.io/github/r-package/v/miketommus/FATools)
<!-- badges: end -->

R package for working with fatty acid data derived from gas
chromatography and mass spectrometry.

## Description

**FATools** aims to streamline and enhance the analysis of fatty acid
(FA) data using R. It’s primary goal is to promote traceability and
reproducibility of results, while also seeking to reduce laboratory
reliance on expensive proprietary software. **FATools** development is
currently focused on automating common workflows involved in exporting
gas chromatographic (GC) and mass spectrometric (MS) data from GC/MS
software and post-processing that data prior to further analysis. Many
**FATools** functions may be used for general GC/MS data, however, the
package is focused on the analysis of FA data and some functions are
specific to this group of lipids.

## Getting Started

### Prerequisites

Having the [devtools](https://devtools.r-lib.org/) package installed
greatly simplifies installing **FATools** directly from this repository.

``` r
# Install devtools from CRAN
install.packages("devtools")
library(devtools)
```

### Installing

To install **FATools** on your machine, I recommended installing the
[latest release](https://github.com/miketommus/FATools/releases).
Released versions of the package are more stable and better documented.

``` r
# Install & use latest release
devtools::install_github("miketommus/FATools@v0.1.0-alpha")
library(FATools)
```

If you’re feelin’ froggy & want to install the current development
version (bugs & all):

``` r
# Install development version
devtools::install_github("miketommus/FATools")
library(FATools)
```

### A word of caution

**FATools** is in early devlopment and is not ready to be used in
production code.

Feel free to install and play around with the package, but be warned
that function names and other breaking changes may be made to the
package. Don’t use any of these functions in any production code at this
stage unless you download the source code and store it along with your
analysis (see **Download Old Versions** below). That way you have a
record of the state of the package when you ran your analysis.

### Download Old Versions

You can find copies of all FATools [releases
here](https://github.com/miketommus/FATools/releases).

## Using FATools

### Concept of Operations

**FATools** is designed to accept data as chromatogram peak areas in
cross-tab format (compounds in columns, samples as rows) and perform all
computation necesary to end up with compound tissue concentrations or
compound proportions; whichever is desired. Below is a simplified view
of this workflow.

``` mermaid
flowchart TD
A{GC/MS}
B[/Chromatogram Peak Areas/]:::data
C(["FATools::calc_gc_response_factors()"]):::func
D(["FATools::convert_area_to_conc()"]):::func
A -->|data export| B
B -->|Peak Areas: Standards| C
B -->|Peak Areas: Samples| D
C -->|Response Factors| D
D -->|Compound Concentrations| G
F[/Sample Information/]:::data
G(["FATools::adjust_for_tissue_mass()"]):::func
F -->|Mass of Extracted Tissue| G
H[Tissue Concentrations]:::result
G --> H
I(["FATools::convert_result_to_prop()"]):::func
H --> I
J[Proportions]:::result
I-->J
 
classDef data stroke:#787276, stroke-width:3
classDef result stroke:#000, stroke-width:3
classDef func fill:#ff9933
```

### Highlighted Features

#### Fatty Acid Names

One of the core features of **FATools** is the ability to standardize
fatty acid (FA) nomenclature using convert_fa_name(). If you’ve ever
worked with FA names in Excel, you’ve probably come up with some
creative ways to write FA names because of Excel’s proclivity to
auto-format things containing “:” or “.”. Then you have to convert those
names again when it’s time to publish. convert_fa_name() allows the user
to easily standardize and customize how FA names are written.

Example:

``` mermaid
flowchart LR
A["16:1 n7"]:::data
B["c16-1n7"]:::data
C["16.1 w-7"]:::data
D["16_1w7"]:::data
E(["FATools::convert_fa_name()"]):::func
A --> E
B --> E
C--> E
D --> E
F(["16:1ω7"])
E -->|returns | F:::result

classDef data stroke:#787276, stroke-width:3
classDef func fill:#ff9933
classDef result stroke:#000, stroke-width:3
```

Customizing the output is also possible:

``` mermaid
flowchart LR
A["16:1 n7"]:::data
B["c16-1n7"]:::data
C["16.1 w-7"]:::data
D["16_1w7"]:::data
E(["FATools::convert_fa_name(style = 2, notation = ''n-'')"]):::func
A --> E
B --> E
C--> E
D --> E
F(["16:1 n-7"])
E -->|returns | F:::result

classDef data stroke:#787276, stroke-width:3
classDef func fill:#ff9933
classDef result stroke:#000, stroke-width:3
```

#### Instrument Response Factor Mapping

Another useful feature of **FATools** is it’s ability to quantitate
compounds for which the user doesn’t have external standards. In gas
chromatography similar compounds generally have similar response factors
(RF). This means it’s possible to map RF values from standards to
similar compounds that aren’t in the standards.

In some GC/MS software packages this process often involves workarounds
that aren’t easily traceable or reproducible. **FATools** handles this
task simply when you pass an optional data frame showing how you want
compounds mapped to standards into the FATools::convert_area_to_conc()
function.

### Example Scripts

**FATools** documentation is pretty sparse at the moment. Vignettes for
each function will be added shortly, but, in the mean time, if you’d
like to see an example of how **FATools** is used to post-process fatty
acid GC/MS data, you can find an example script and test data here:
[github.com/miketommus/example-fatty-acid-analysis](https://github.com/miketommus/example-fatty-acid-analysis)

![](https://github.com/miketommus/example-fatty-acid-analysis/blob/master/assets/fatools.png?raw=true)

## Contributing

**FATools** is in the early stage of development right now and it’s
architechture might change quite drastically in the near future. As a
result, outside contibutors should hold-off on submitting pull-requests
for the time being to avoid wasted time/effort. I expect this to change
as the package matures!

### Development notes

If you’d like to learn more about the development progress of
**FATools** and follow along as new features are developed, visit the
**FATools** development notes repository:
[github.com/miketommus/FATools_dev](https://github.com/miketommus/FATools_dev)

### Reporting Issues & Bugs

Right now, the only bug/issue reports accepted are from those doing
early testing. If you have (or can find) miketommus’ non-public contact
information feel free to report any issues you find.
