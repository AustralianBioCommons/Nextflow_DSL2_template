#!/bin/env nextflow 

// Enable DSL-2 syntax
nextflow.enable.dsl=2

// Define the process
process processOne {	
	cpus "${params.cpus}"
	debug = true //turn to false to stop printing command stdout to screen
	container "${params.ubuntu_container}"
	publishDir "${params.outDir}/process1", mode: 'copy'

	// See: https://www.nextflow.io/docs/latest/process.html#inputs
	// each input needs to be placed on a new line
	input:
	path cohort_ch

	// See: https://www.nextflow.io/docs/latest/process.html#outputs
	// each new output needs to be placed on a new line
	output:
	path ("processed_cohort.txt"), emit: File
	
	// this is an example of some code to run in the code block 
	script:
	"""
	cat ${params.input} | tr '[a-z]' '[A-Z]' \
		> processed_cohort.txt
	"""
}