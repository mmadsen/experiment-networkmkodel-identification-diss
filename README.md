# Experiment: Network Model Identification #

Given the success of `experiment-seriation-classification` in correctly identifying samples of seriations from regional temporal network models, the next steps are to:

1.  Create many network models, to ensure that results are not idiosyncratic to a single structural graph.   
1.  Construct a much larger database of simulated CT across the collection of randomly generated network models.  
1.  Capture all of the network model, simulation, and analytic pipeline hyperparameters in the database in such a way that we can use them in analyzing identification failures and successes later.

A further requirement is to include all of the network models likely to be relevant to the Mississippian data set in my dissertation.  The earlier seriation classification experiments were driven by exploring whether identification was possible, and the network model set was not comprehensive.  


## Note on Structure ##

In the previous experiments, subdirectories under `experiments` often contained paired experiments, or even comparisons of 4 different network models.  One of the goals of v1.4 of the `seriationct` software package was to create a robust simulation and data processing pipeline, capable of running in parallel on a cluster unattended.  

To this end:

1.  Each subdirectory represents the network model instances, simulation runs, sampling and postprocessing, and seriations derived from a single network model specification.  
1.  Each subdirectory is now created by `seriationct-create-experiment-directory.sh`, which unpacks and customizes the current experiment template which matches the given release of `seriationct` itself.  Keeping experiment template/directory trees in sync with software was increasingly problematic.

## CT Simulations ##

All simulations of cultural transmission in this experiment series are performed with the following prior distributions and hyperparameters:

```json
{
    "theta_low": 0.00005,
    "theta_high": 0.0001,
    "maxinittraits": 5,
    "numloci": 3,
    "popsize": 250,
    "simlength": 10000,
    "samplefraction" : 0.5,
    "migrationfraction_low" : 0.05,
    "migrationfraction_high" : 0.1,
    "replicates" : 1
}
```

In addition, all simulations are strictly unbiased transmission, where individuals interact with other individuals in the same local subpopulation.  Flow of cultural traits between local subpopulations occurs by individuals migrating between localities according to the `migrationfraction` hyperparameter.  

Each individual in the population carries three independent dimensions of cultural variability, which evolve separately.  What is tracked in the database are the frequency of **combinations**, which are analogous to archaeological types or classes (compared to the usual practice of tracking single trait frequencies).  


## Network Models ##


### Model #1:  ni-pnn-1000 ###

This experiment creates 100 probabilistic-nearest-neighbor regional temporal networks, and performs 1000 simulation runs across these 100 networks, ensuring that each network receives 10 simulation runs to characterize stochastic variability in CT outcomes.  

The network models are created from the following prior distributions and hyperparameters:

```json
{
  "network_type": "pnn",
  "network_generator": "seriationct-build-spatial-neighbor-network.py",
  "mean_edges_perpopulation_low": 1.1,
  "mean_edges_perpopulation_high": 4.0,
  "sd_edges_perpopulation_low": 0.1,
  "sd_edges_perpopulation_high": 1.0,
  "exponential_coefficient_low": 1.0,
  "exponential_coefficient_high": 4.0,
  "edgeweight": 10,
  "num_populations_per_slice": 32,
  "spatial_aspect_ratio": 1.0,
  "slices": 10
}
```

Some networks generated according to this specification will be more "nearest neighbor-y" than others, since the degree to which vertices are linked within any time slice is governed by an exponential decay kernel.  Higher values of the exponent in the decay kernel yield a tighter bound on distances within which vertices will be linked.  

Understanding how identifiability changes given this hyperparameter, is a key question.  It is possible that low values create a wide distribution of edge distances, and thus become indistinguishable from simple random connection models of various types.  


#### Archived Data ####

A data archive (tar format) that includes full raw, intermediate, and finished seriations is [available on Amazon S3](https://s3.amazonaws.com/madsen-dissertation/experiment-networkmkodel-identification-diss/ni-pnn-1000-data.tar)


## Experiment Outline ##

First, a random collection of network models, derived from the above hyperparameter specification, are generated.  

Second, simulation runs are generated from the simulation hyperparameter specification.  
Innovation rates and migration fractions are chosen uniformly at random from the ranges given for each simulation run.  Populations evolve for 10000 generations, giving approximately 1000 transmission events per individual during a time slice (i.e., step in the regional metapopulation evolution).  Given that we discard approximately 3000 generations to allow the population to reach mutation-copying equilibrium before we start sampling, this represents approximately monthly opportunities for learning or copying an artifact over a total duration of almost 600 years, which roughly matches the Mississippian period in much of the eastern United States.

The raw data from each community in a simulated network model are then aggregated over the duration that community persists, giving us a time averaged picture of the frequency of cultural traits.  

I then perform the following sampling steps:

1.  I take a sample of each time averaged data collection similar to the size of a typical archaeological surface collection:  500 samples are taken without replacement from each community, with probability proportional to class frequency.  This yields a smaller set of classes, since many hundreds or thousands of combinations are only seen once or twice in the simulation data, and thus are very hard to measure from empirical samples.

2.  I then take a sample of communities to seriate.  From each of the two network models, I take temporally stratified samples, with 3 communities per time slice sampled out of the 64 present in each slice.  In real sampling situations, we would not know how communities break down temporally, but we often do attempt to get samples of assemblages which cover our entire study duration.  In the case of Model #1, we take a 5% sample of communities in each time slice.  In the case of Model #2, given the different structure of the model, we take a 12% sample of communities in each time slice.  

3.  Within the overall sample from each simulation run, comprised now of the time averaged class frequencies from 30 sampled communities, I examine the classes/types themselves, and drop any types (columns) which do not have data values for at least 3 communities.  This is standard pre-processing for seriation analyses (or was in the Fordian manual days of seriation analysis) since without more than 3 values, a column does not contribute to ordering the communities.  

The [IDSS Seriation](https://github.com/clipo/idss-seriation) package is then used to seriate the stratified, filtered data files for each simulation run.  The "minmax-by-weight" solutions are what we will work with for classification and inference.


