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

  Input Data:

  --bamList             A file containing paths to all input BAM files.
                        Must be formatted as TSV file with columns:
                        sampleID\tbamFile. All BAMs must be indexed by
			htslib/samtools (.bai).

  Reference Data:

  --genomeFASTA         Reference genome file, in FASTA format. This file 
			must be indexed with samtools (.fai).

  --includeBED          Genomic regions to be included in SV detection,
                        in BED format.

  Output:

  --outDir              Directory location for output files.

  Optional arguments:

  --excludeBED          Highly recommended. Problematic genomic regions to
                        be ignored (default: OFF)

  --callerSupport	Minimum number of supporting callers required for a
			SV to be included in final merged structural variant
			VCF (default: ${params.Ncallers})

    """.stripIndent()
}


/// Define workflow 
// Import subworkflows to be run by workflow
// Each of these is a separate .nf script saved in modules/
// Add as many of these as you need. The example below will
// look for the process called process in modules/moduleName.nf

//include { process } from './modules/moduleName'
include { manifestTesting } from './modules/manifestTest'


/// Main workflow structure. Include some input/runtime tests here.
// Make sure to comment what each step does for clarity.

workflow ExampleWorkflow {

// Show help message if the user specifies --help or if any required params 
// are not provided at runtime

        if ( params.help || params.outDir == false || params.bamList == false || params.genomeFASTA == false || params.includeBED == false ){
        // Invoke the help function above and exit
              helpMessage()
              exit 1

        // consider adding some extra contigencies here.
        // could validate path of all Bams in list
        // could validate indexes for bams exist
        // could validate indexes for reference exist
        // confirm with each tool, any requirements for their run

// if none of the above are a problem, run the workflow
} else {

        manifestTest(Channel.fromPath(params.bamList))

        exit 1
}}

/// Run workflow 
workflow { ExampleWorkflow() }
