#!/bin/env nextflow

// Enable DSL-2 syntax
nextflow.enable.dsl=2

// Define the process
/// This example takes output from process1 and splits file into one file per line
process processTwo {

	// Unhash container command below and edit name of container
	/// if using Docker/Singularity containers
        // container "${params.container}
	
	// where to publish the outputs
        publishDir "${params.outDir}/process2", mode: 'copy'

	// See: https://www.nextflow.io/docs/latest/process.html#inputs
        /// each input needs to be placed on a new line
	input:
	path(process1_txt)

        // See: https://www.nextflow.io/docs/latest/process.html#outputs
        // each new output needs to be placed on a new line
	output:
	path('processed_cohort2.txt')

        // this is an example of some code to run in the code block
        /// this process just reverses all the text from the report output
	/// by process1
	script:

	"""
        tac $process1_txt | rev \
        > ./processed_cohort2.txt
	"""
 }
