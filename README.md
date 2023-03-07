# Nextflow DSL2 template

This is a template for creating Nextflow DSL2 pipelines. **This template is still in development, with further features and improved documentation to be added.** 

**Check out the [Nextflow guides](https://github.com/Sydney-Informatics-Hub/Nextflow_DSL2_template/tree/main/guides)** for tips and examples of various challenging aspects of writing Nextflow code for beginners. We're progressively developing it as we write our own Nextflow pipelines.    

## Description  
[Nextflow](https://www.nextflow.io/) is open source and scalable workflow management software, initially developed for bioinformatics. It enables the development and running of integrated, reproducible workflows consisting of multiple processes, various environment management systems, scripting languages, and software packages. While Nextflow is designed to have a minimal learning curve as it doesnt require end users to learn new programming languages, its extensive capabilities, use of Groovy syntax, and [comprehensive documentation](https://www.nextflow.io/docs/latest/index.html) can be overwhelming for users who aren't well versed in programming and software development.  

We developed this template to aid beginners in developing their own Nextflow workflows. Depending on your needs you can edit the files here to develop your own bioinformatics workflows. 

## Installing Nextflow

Depending on the system you're working on there are a few options for installing and running Nextflow including reproducible options like bioconda and Singularity. See [here](https://nf-co.re/usage/installation) for installation instructions. 

Once you have installed Nextflow, you can configure it to run on your system. This template only provides the standard `nextflow.config` file. See [here](https://nf-co.re/usage/configuration#running-nextflow-on-your-system) for tips on creating your own configuration files from the team at nf-core. Also see [here](https://www.nextflow.io/blog/2021/nextflow-developer-environment.html) for some set up tips.

## Using this repository 

This repository contains an example workflow with two processes, one that follows on from the other. The example processes contain a small bash command each that play around with the text in `samples.txt` (provided). It is currently only designed for small workflows that can be run with any of the provided config files. 

As is standard for all nextflow pipelines, when the template is run from within the `Nextflow_DSL2_template` repository, some details will be printed to the screen, and a number of directories will be created in the `Nextflow_DSL2_template` repository. This includes: 
* A `work/` directory 
* A `.nextflow.log` file
* A `.nextflow/` directory 
* Outputs specified by the example code: `results/` which contains results and `runInfo` which contains runtime reports.

Run the workflow with the standard profile (requires Singularity), with:

```
nextflow run main.nf \
	--input samples.txt \
	-c config/standard.config
```

If you are working on either Setonix or Gadi HPCs, you will need to specify absolute paths to your input file and edit the provided infrastructure-specific config file according to your project space and user ID. For example, to run on NCI's Gadi HPC:

```
nextflow run main.nf \
	--input /scratch/ab11/gs5555/Nextflow_DSL2_template/samples.txt \
	-c /scratch/ab11/gs5555/Nextflow_DSL2_template/config/gadi.config
```

This repository is structured as follows: 

```
Nextflow_DSL2_template
├── LICENSE
├── README.md
├── cleanup
├── config
    ├── gadi.config
│   ├── nimbus.config
│   ├── setonix.config
│   └── standard.config
├── main.nf
├── guides 
├── modules
│   ├── process1.nf
│   └── process2.nf
├── nextflow.config
├── run_pipeline
└── samples.txt
```
The main components for using this template are: 
* `main.nf` 
* `nextflow.config` 
* `modules/` 
* `config/`

Some extra components for running this template are: 
* `cleanup`: removes workdir, results directory, as well as hidden nextflow logs and directories that will be generated when the template example is run. To use: `bash cleanup` 
* `run_pipeline`: runs the nextflow command for this template. To use: `bash run_pipeline` 
* `samples.txt`: contains an example file to be processed with the example processes in the template. 
* `guides`: short explainers of how to construct various features using nextflow. This will be added to progressively.  

### What's in `main.nf`? 

This is the primary pipeline script which pulls additional code for subprocesses from the `module/` directory. It contains: 
* DSL-2 enable command 
* A customisable header for the pipeline that will be printed to the screen when run with `nextflow run main.nf` 
* A customisable help command for the pipeline that can be printed when `nextflow run main.nf --help` is run. This can also be customised to be run when default/required arguments are not provided. To do this, see the `workflow` help function. 
* Channel defintions to be included in the workflow. See [here](https://www.nextflow.io/docs/latest/dsl2.html#channel-forking) for more details.  
* The main workflow structure that determines which processes will be run in what order (based on input and outputs provided). This template only includes 2 templates. This is required by DSL-2 syntax. 
* A customisable statement printed to the screen upon workflow completion. The statement to be printed depends on whether the workflow completed successfully. 

### What's in `nextflow.config`? 

This is the main configuration script that Nextflow looks for when you run `nextflow run main.nf`. It contains a number of property definitions that are used by the pipeline. A key feature of Nextflow is the ability to separate workflow implementation from the underlying execution platformm using this configuration file. Since we can add additional configuration files for different run environments (i.e. job schedulers, use of singularity vs bioconda) each configuration file can contain conflicting settings and parameters listed in this file can be overwritten in the run command by specifiying relevant commands. See [here](https://www.nextflow.io/docs/latest/config.html#configuration-file) for details on the heirarchy of confuration files. This file contains: 
* Mainfest for defining some metadata including authorship, link to the repo, workflow version, etc 
* Mandated minimal version of Nextflow that can be used to run this pipeline 
* Resume function that allows the pipeline to start up at the last successful process if the run fails part way through (currently enabled) 
* Various profile definitions that can be activated when launching a pipeline. These can be used together, depending on their requirements. We can define various profiles depending on the system you're using. See [here](https://www.nextflow.io/docs/latest/config.html?highlight=profiles#config-profiles) for more details on what sorts of things can be included here. 
* Default parameters for running the pipeline. These include default file names, containers, paths, etc. These can be overwritten when launching the pipeline. 
* Customisable workflow run info reports with `dag{}`, `report{}`, `timeline{}`, and `trace{}`. You can specify where to output these run summary files. 

### What's in `config/`? 

This directory contains various profile modules for configuring the pipeline run. Some care should be taken when using these config profiles. See the [Nextflow documentation](https://nextflow.io/docs/latest/config.html#config-profiles) for more details.

This directory contains the following profiles:
* `nimbus`: this profile is specific to Pawsey Supercomputing Centre's Nimbus cloud. It enables the use of Docker. 
* `standard`: this is the default profile which runs Singularity.
* `setonix`: this profile is specific to Pawsey Supercomputing Centre's Setonix HPC. It enables the use of the SLURM job scheduler and Singularity.  
* `gadi`: this profile is specific to the National Computational Infrastructure's Gadi HPC. It enables the use of the PBS Pro job scheduler and Singularity 

### What's in `modules/`?

This directory contains all sub-workflows to be run with `nextflow run main.nf`. It is considered good practice to split out processes into separate `.nf` files and store them here, rather than including them all in the `main.nf` file. This directory is referenced in `main.nf` by using [`include {x} from ./modules/process`](https://www.nextflow.io/docs/latest/dsl2.html#modules). These process scripts currently contain all code to be run in the `script:` block. 

Each `.nf` script contains the process to be run, in addition to details of which container to be used, where to publish the output for the process. 

### Monitoring workflow run 

A great feature of Nextflow is its ability to produce [metric reports](https://www.nextflow.io/docs/latest/metrics.html#) on run execution including walltime, I/O, and resource usage for each report. These are currently enabled in the `nextflow.config` template.  

## Recommended coding conventions 

We're currently working on this. Some recommendations regarding code structure and syntax for Nextflow workflows coming soon! 

## Resources 
* [Nextflow training workshop materials](https://training.seqera.io/) 
* [Nextflow YouTube channel](https://www.youtube.com/c/Nextflow)  
* [Nextflow quick start guide](https://www.nextflow.io/index.html#GetStarted)
* [Intro to Nextflow workflows](https://carpentries-incubator.github.io/workflows-nextflow/01-getting-started-with-nextflow/index.html)
* [Nextflow's nf-core pipelines](https://nf-co.re/)
* [NF-camp tutorial converting rnaseq-nf pipeline to DSL2](https://github.com/nextflow-io/nfcamp-tutorial)  
* [DSL2 pipeline structure walkthrough video from nf-core](https://www.youtube.com/watch?v=0xjc7PkF1Bc)
* [DSL2 modules tutorial video](https://www.youtube.com/watch?v=6k9lWewSBYc)  
* [Intro to DSL2 video](https://www.youtube.com/watch?v=I-hunuzsh6A&t=658s)  
* [Nextflow for data intensive pipelines from Pawsey Supercomputing Center](https://www.youtube.com/watch?v=bIRLbYPWHoM)
* [A great self guided DSL2 tutorial](https://antunderwood.gitlab.io/bioinformant-blog/posts/building_a_dsl2_pipeline_in_nextflow/)  
* [Australian BioCommons workflow documentation guidelines](https://github.com/AustralianBioCommons/doc_guidelines)

## Acknowledgements 

The work presented here was developed by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney and the Australian BioCommons which is enabled by NCRIS via Bioplatforms Australia. 
