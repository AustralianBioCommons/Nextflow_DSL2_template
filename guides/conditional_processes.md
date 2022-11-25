# How to: create optional processes

|Nextflow feature     |Tags                                   |DSL2             |
|---------------------|---------------------------------------|-----------------|
| Processes, workflow |conditional loops, flexbility|:heavy_check_mark:|

## Scenario  

Give users the options of which processes to execute by specifying a flag in their run command. 

## The fix

Processes that can be run optionally need to be wrapped in an if/else loop within the `workflow{}` section of the `main.nf` script. In the example below users can specify whether they run samtools flagstat or samtools stat commands for less or more verbose summary metrics output, respectively. 
 
```
workflow {

// Show help message if --help is run or if any required params are not
// provided at runtime

        if ( params.help || params.cohort == false || params.ref ==false ){
        // Invoke the help function above and exit
              helpMessage()
              exit 1

        // consider adding some extra contigencies here.

// if none of the above are a problem, then run the workflow
        } else {

        // Check inputs
        checkInputs(Channel.fromPath(params.cohort, checkIfExists: true))

        // Split cohort file to collect info for each sample
        cohort = checkInputs.out
                        .splitCsv(header: true, sep:"\t")
                        .map { row -> tuple(row.sampleID, file(row.bam), file(row.bai)) }

        if (params.flagstat) {
        // Run samtoolsFlagstats
        samtoolsFlag(cohort)
        }

        // Run samtoolsStats if --flagstat not specified
        else { samtoolsStats(cohort, file(params.ref))
        }

}}


```

This snippet was sourced from the [bamQC-nf pipeline](https://github.com/Sydney-Informatics-Hub/bamQC-nf). 


## Considerations 

- Conditional if/else loops are also useful for formatting checks before a pipeline is run, as in the above code where Nextflow first checks the required flags are specified before running the workflow.   
