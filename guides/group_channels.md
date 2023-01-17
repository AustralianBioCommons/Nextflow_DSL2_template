# How to: group channels by sampleID

|Nextflow feature     |Tags                                   |DSL2             |
|---------------------|---------------------------------------|-----------------|
| Channels |operator, combine, group|:heavy_check_mark:|

## Scenario  

A process requires the output of a previous process and a separate input channel that defines a tuple grouping a unique sampleID with a file. These channels need to be combined for each sampleID before the second process can be run. For example: the optimised run of GRIDSS requires a number of steps to be run separately. The first step `preprocess` generates a working directory that is used by the subsequent steps `assembly` and `call`. This working directory needs to be input to the `call/assembly` step along with the corresponding normal and tumour bams.  

## The fix

When writing a Nextflow pipeline that can process multiple samples in parallel, inputs and outputs for each process should be defined as a tuple matching a specific sampleID where needed. This ensures samples are processed linearly and do not get mixed up with one another. Using the `emit:` function we can take the output of a process and join it with another channel using the `combine` operator. 

For example: in the gridss_preprocess step, we output a directory (named using the sampleID), as `gridss_working`: 
```
output:
tuple val(sampleID), path("${sampleID}/*"), emit: gridss_working
```

In the `main.nf` file, we created a channel before the `gridss_call` process that combines this output with the input channel:
```
input = checkInputs.out
        .splitCsv(header:true, sep:"\t")
        .map { row -> tuple(row.sampleID, file(row.normalBAM), file(row.tumourBAM))}
```

Using the [`combine` operator](https://www.nextflow.io/docs/latest/operator.html#combine) and specifying which field to group the channels by: 
```
gridssCallInput = gridss_preprocess.out.gridss_working
                .combine(input, by: 0)
                .view()
```

Both the input and gridss_working channels are tuples that start with `val(sampleID)`, so we can combine our channels using the first field (Nextflow is zero-based). In the case of the example above, this is the output when run on 2 samples: 
```
[T115991B2, /scratch/er01/gs5517/SomaticStructuralV-nf/work/1d/39b60310ca67745060f08a5ecd3c0c/T115991B2, /scratch/er01/gs5517/workflowTesting/Somatic-StructuralV/Bams/test_T115991B2-N.bam, /scratch/er01/gs5517/workflowTesting/Somatic-StructuralV/Bams/test_T115991B2-T.bam]
[T531207, /scratch/er01/gs5517/SomaticStructuralV-nf/work/aa/697300cdab1260c68a8e0459753235/T531207, /scratch/er01/gs5517/workflowTesting/Somatic-StructuralV/Bams/test_T531207-N.bam, /scratch/er01/gs5517/workflowTesting/Somatic-StructuralV/Bams/test_T531207-T.bam]
```

Here, for each sample, we've created a channel consisting of the sampleID, working directory, normal BAM, and tumour BAM. 

## Considerations 

[Nextflow operators](https://www.nextflow.io/docs/latest/operator.html)
