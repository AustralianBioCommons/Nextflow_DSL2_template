# How to: emit optional outputs

|Nextflow feature     |Tags                                   |DSL2             |
|---------------------|---------------------------------------|-----------------|
|Processes |emit, output|:heavy_check_mark:|

## Scenario  

Some files are optionally output by processes, however if they are expected by Nextflow but not actually created, Nextflow will throw an error and stop running.

## The fix

To allow for flexibility in the outputs that are created we can use the `optional: true` option when emitting files. In the example below, Smoove will sometimes not output split and disc bam files, depending on the input bam file. These files are useful for data visualisation and interpretation, so we want to output them where possible in the final output. We can use emit: <name>, optional: true to avoid Nextflow crashing if these files are not output:
 
```
process smoove {
	debug true
	publishDir "${params.outDir}/${sampleID}", mode: 'copy'

	// resource parameters. Developer suggests good scaling up to 2-3 CPUs
    cpus "${task.cpus}"

        // Run with container
	container "${params.smoove__container}"
	
	input:
	tuple val(sampleID), file(bam), file(bai)
	path(ref)
	path(ref_fai)

	output:
	path("smoove/${sampleID}-smoove.genotyped.vcf.gz")      , emit: smoove_geno
	path("smoove/${sampleID}-smoove.genotyped.vcf.gz.csi")  , emit: smoove_geno_csi
	path("smoove/${sampleID}.split.bam")                    , emit: smoove_split, optional: true
	path("smoove/${sampleID}.split.bam.csi")                , emit: smoove_split_csi, optional: true
	path("smoove/${sampleID}.disc.bam")                     , emit: smoove_disc, optional: true
	path("smoove/${sampleID}.disc.bam.csi")                 , emit: smoove_disc_csi, optional: true
	path("smoove/${sampleID}.histo")                        , emit: smoove_histo, optional: true
	
	script:
	// TODO: suggest printing stats as per: https://github.com/brwnj/smoove-nf/blob/master/main.nf 
	"""
	smoove call --name ${sampleID} \
	--fasta ${params.ref} \
	--outdir smoove \
	--processes 4 \
	--genotype ${bam}

	"""
} 

```

## Considerations 

* See this [GitHub Issue](https://github.com/nextflow-io/nextflow/discussions/1980) 

