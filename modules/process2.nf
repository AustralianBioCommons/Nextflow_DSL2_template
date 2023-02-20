#!/bin/env nextflow

// Enable DSL-2 syntax
nextflow.enable.dsl=2

// Define the process
process processTwo {
	cpus "${params.cpus}"
	debug = true //turn to false to stop printing command stdout to screen
	container "${params.ubuntu_container}"
	publishDir "${params.outDir}/process2", mode: 'copy'

	// See: https://www.nextflow.io/docs/latest/process.html#inputs
	// each input needs to be placed on a new line
	input:
	path("processed_cohort.txt")

	// See: https://www.nextflow.io/docs/latest/process.html#outputs
    // each new output needs to be placed on a new line
	output:
	path('processed_cohort2.txt')

    // this is an example of some code to run in the code block
	script:
	"""
    tac processed_cohort.txt | rev \
    	> processed_cohort2.txt
	"""
 }