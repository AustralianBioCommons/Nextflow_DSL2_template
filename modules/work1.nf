#!/usr/bin/env nextflow

// Enable DSL-2 syntax
nextflow.enable.dsl=2

// Import workflow1 process, specifying the location of inputs, outputs, script

// Run subworkflow 1

  process workflow_1_1 {
     // Unhash container command below and edit name of container to be used if using Docker/Singularity containers
        // container "${params.container}

        // where to publish the outputs
        publishDir "${params.outDir}/workflow1", mode: 'copy', overwrite: true
	
	params.printphrase = 'this is a nextflow workflow template'
	
	input:
	val phrase

	output:
	file '/results/chunk_*'
	
	script:
	template 'workflow1.1.sh'

  }

// Run subworkflow 2

  process workflow_1_2 {

	publishDir "${params.outDir}/workflow1", mode: 'copy', overwrite: true

	input:
	file '/results/chunk_*'

        output:
	stdout

        script:
        template 'workflow1.2.sh'

  }

// Define workflow to be run
workflow testing_wf1{

	take:
	workflow2_ch

	// define the processes to be executed 
	main: 

	// Run subworkflow 1.1
	params.printphrase = 'this is a nextflow workflow template'
	workflow_1_1(phrase)

	// Run subworkflow 1.2
	workflow_1_2() 
 
	// Output of subworkflow
	//emit:
	//outFile 

}
