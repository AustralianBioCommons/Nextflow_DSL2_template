# How to: run a process for each line in a text file

|Nextflow feature     |Tags                                   |DSL2             |
|---------------------|---------------------------------------|-----------------|
|Processes, operators |workflow, csv, txt, input, multi-sample|:heavy_check_mark:|

## Scenario  

You need to process multiple samples at once using an input sample file, rather than pointing to a directory housing all files to be processed. The input sample file is a multi-column text file, separated by commas or tabs. An example of the input cohort file: 

|sampleID|bam                 |
|--------|--------------------|
|sample1 |/path/to/sample1.bam|
|sample2 |/path/to/sample2.bam|
|sample3 |/path/to/sample3.bam|
|sample4 |/path/to/sample4.bam|

## The fix

Nextflow `operators` allow you to connect channels to each other and transform values emitted by a channel. Here, we can create a channel for this input file using two distinct operators to split the rows of the input file into distinct entries to be processed. The [`splitCsv`](https://www.nextflow.io/docs/latest/operator.html#splitcsv) operator allows you to parse text that is emitted by a channel and split or group various columns. The [`map`](https://www.nextflow.io/docs/latest/operator.html#map) operator can then be used to convert the row into a tuple, tying the sampleID entry to the bam entry in the example above. 

In this example `samtoolsStats.nf` below, we are running samtools stats over multiple bam files. In addition to the bam input files, Samtools stats requires a reference assembly so this has been included. 

```
// define required input parameters
params.cohort = "./samples.tsv" // this can be overwritten when specified in the run command
params.samtoolscontainer = 'docker://quay.io/biocontainers/samtools:1.15--h1170115_1'
params.ref = false // this needs to be specified in the run command 
params.outDir = false // this needs to be specified in the run command

// define samtools stats process to be run  
process samtoolsStats {
        debug true
        publishDir "${params.outDir}/${sampleID}", mode: 'copy'

        // resource parameters. currently set to 4 CPUs
        cpus "${params.cpus}"

        // Run with samtools v1.15 container
        container "${params.samtoolscontainer}"

        input:
        tuple val(sampleID), file(bam)
        file(ref)

        output:
        tuple val(sampleID), path("${sampleID}.samtools.stats"), emit: samtools_stats

        script:
        """
        samtools stats \
        --reference ${params.ref} \
        --threads 4 \
        ${bam} > ${sampleID}.samtools.stats
        """
}

// run workflow (only one process)
workflow {

// Before running the workflow split cohort file to collect info for each sample
  cohort = Channel.fromPath(params.cohort)
                  .splitCsv(header: true, sep:"\t")
                  .map { row -> tuple(row.sampleID, file(row.bam)) }

// Run samtoolsStats
        samtoolsStats(cohort, file(params.ref))
}

```

Run the command above with:

```
nextflow run samtoolsStats.nf --cohort samples.txt --ref ./hg38.fa --outDir ./statsOut
```

## Considerations 

- You can define the cohort channel inside or outside of the `workflow{}` block. If it's inside, just make sure it precedes the process consuming it
- `.splitCsv` can be applied to all kinds of text files, just specify the delimiter with `sep:` 
- if your input file doesn't have a header, you can use `.map{}`, specifying row integers. Remember Nextflow is zero-based so the first column would be row[0] 

