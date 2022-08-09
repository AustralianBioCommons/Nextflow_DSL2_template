#!/usr/bin/env nextflow

/// To use DSL-2 will need to include this
nextflow.enable.dsl=2

// =================================================================
// main.nf is the pipeline script for a nextflow pipeline
// Should contain the following sections:
	// Import subworkflows
	// Log info function
	// Help function 
	// Main workflow structure
	// Some tests to check input data, essential arguments

// Examples are included for each section. Remove them and replace
// with project-specific code. For more information on nextflow see:
// https://www.nextflow.io/docs/latest/index.html and the SIH Nextflow
// upskilling repo @ INSERT REPO PATH 
//
// ===================================================================

// Import subworkflows to be run in the workflow
// Each of these is a separate .nf script saved in modules/
// Add as many of these as you need. The example below will
// look for the process called process in modules/moduleName.nf
// Include { process } from './modules/moduleName'
include { processOne } from './modules/process1'
include { processTwo } from './modules/process2'

// Define channels 
cohort_ch = Channel.fromPath("${params.cohort}")
outDir_ch = Channel.fromPath("${params.outDir}")

/// Print a header for your pipeline 

log.info """\

      ============================================
      ============================================
         N A M E  O F  Y O U R  P I P E L I N E 
      ============================================
      ============================================

 -._    _.--'"`'--._    _.--'"`'--._    _.--'"`'--._    _  
    '-:`.'|`|"':-.  '-:`.'|`|"':-.  '-:`.'|`|"':-.  '.` :    
  '.  '.  | |  | |'.  '.  | |  | |'.  '.  | |  | |'.  '.:    
  : '.  '.| |  | |  '.  '.| |  | |  '.  '.| |  | |  '.  '.  
  '   '.  `.:_ | :_.' '.  `.:_ | :_.' '.  `.:_ | :_.' '.  `.  
         `-..,..-'       `-..,..-'       `-..,..-'       `       


                ~~~~ Version: 1.0 ~~~~
 

 Created by the Sydney Informatics Hub, University of Sydney

 Find documentation and more info @ GITHUB REPO DOT COM

 Cite this pipeline @ INSERT DOI

 Log issues @ GITHUB REPO DOT COM

 All of the default parameters are set in `nextflow.config`
 """

/// Help function 
// This is an example of how to set out the help function that 
// will be run if run command is incorrect (if set in workflow) 
// or missing/  

def helpMessage() {
    log.info"""
  Usage:  nextflow run <PATH TO REPO>/myPipeline-nf <args> --outDir

  Required Arguments:
	--outDir		Specify path to output directory

	--cohort		Specify full path and name of sample
				input file (tab separated).
    """.stripIndent()
}

/// Main workflow structure. Include some input/runtime tests here.
// Make sure to comment what each step does for readability. 

workflow {

// Show help message if --help is run or if any required params are not 
// provided at runtime

        if ( params.help ){
        // Invoke the help function above and exit
              helpMessage()
              exit 1

        // consider adding some extra contigencies here.
        // could validate path of all input files in list?
        // could validate indexes for input files exist?
        // could validate indexes for reference exist?
        // confirm with each tool, any requirements for their run?

// if none of the above are a problem, then run the workflow
	} else {
	
	// Run process 1 example
	processOne(cohort_ch, outDir_ch)
	
	// process 2 example 
	processTwo(processOne.out)
}}

workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outDir/REPORTNAME" : "Oops .. something went wrong" )
}
