#!/bin/env nextflow 

// Enable DSL-2 syntax
nextflow.enable.dsl=2

// Define the process
/// This example takes input manifest and capitalises sampleID
process processOne {
        cpus "${params.cpus}"
	debug = true

	// Unhash container command below and edit name of container
	// if using Docker/Singularity containers
        //container "${params.container}

	// where to publish the outputs
        publishDir "${params.outDir}/process1", mode: 'copy'

	// See: https://www.nextflow.io/docs/latest/process.html#inputs
	/// each input needs to be placed on a new line
	input:
	path input
	path outDir

	// See: https://www.nextflow.io/docs/latest/process.html#outputs
	// each new output needs to be placed on a new line
	output:
	path ("./processed_cohort.txt")
	
	// this is an example of some code to run in the code block 
	/// this process just capitalises all letters in the file
	/// and outputs to new file
	script:
	"""
	cat ${params.input} | tr '[a-z]' '[A-Z]' \
	> ./processed_cohort.txt
	"""
}
