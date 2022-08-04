#!/usr/bin/env nextflow

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

include { workflow_1_1 } from './modules/work1.nf'
include { workflow_1_2 } from './modules/work1.nf'

/// To use DSL-2 will need to include this
nextflow.enable.dsl=2

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
// or missing 

def helpMessage() {
    log.info"""

  Usage:  nextflow run <PATH TO REPO>/myPipeline-nf <args>

  Required Arguments:
	--flag		Description of flag function

    """.stripIndent()
}

/// Define workflow 
// Import subworkflows to be run in the workflow
// Each of these is a separate .nf script saved in modules/
// Add as many of these as you need. The example below will
// look for the process called process in modules/moduleName.nf
// Include { process } from './modules/moduleName'
include { workflow_1_1 } from './modules/work1.nf'
include { workflow_1_2 } from './modules/work1.nf'

/// Main workflow structure. Include some input/runtime tests here.
// Make sure to comment what each step does for readability. 

workflow {

// Show help message if the user specifies --help or if any required params 
// are not provided at runtime

        if ( params.help || params.outDir == false ){
        // Invoke the help function above and exit
              helpMessage()
              exit 1

        // consider adding some extra contigencies here.
        // could validate path of all input files in list
        // could validate indexes for input files exist
        // could validate indexes for reference exist
        // confirm with each tool, any requirements for their run

// if none of the above are a problem, run the workflow
	} else {
	
	// run workflow 1.1
	workflow_1_1()
	
	// run workflow 1.2
	workflow_1_2()
	}
}

