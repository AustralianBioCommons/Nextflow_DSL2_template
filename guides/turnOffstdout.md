# How to: Print (or don't) stdout of a process to screen

|Nextflow feature     |Tags                                   |DSL2             |
|---------------------|---------------------------------------|-----------------|
| Process, debug |stdout |:heavy_check_mark:/:x:|

## Scenario  

By default the standard output printed by each process is ignored by Nextflow. This feature is controlled by the `debug` feature which can be set to `true/false`. This can be a useful inclusion, especially during workflow development, to check you've correctly constructed your process. 

## The fix

By setting `debug true` within the `nextflow.config` or each `module/process.nf` script you can have stdout for the current top running process printed to the terminal screen. For example in the manta.nf process below, we set debug true: 
 
```
// run manta structural variant detection and convert inversions
process manta {
	debug true
	publishDir "${params.outDir}/${sampleID}", mode: 'copy'
	container "${params.mulled__container}"

input:
	tuple val(sampleID), file(bam), file(bai)
	path(ref)
	path(ref_fai)

output:
  tuple val(sampleID), path("manta/Manta_${sampleID}.candidateSmallIndels.vcf.gz")      , emit: manta_small_indels
  tuple val(sampleID), path("manta/Manta_${sampleID}.candidateSmallIndels.vcf.gz.tbi")  , emit: manta_small_indels_tbi
  tuple val(sampleID), path("manta/Manta_${sampleID}.candidateSV.vcf.gz")               , emit: manta_candidate
  tuple val(sampleID), path("manta/Manta_${sampleID}.candidateSV.vcf.gz.tbi")           , emit: manta_candidate_tbi
  tuple val(sampleID), path("manta/Manta_${sampleID}.diploidSV.vcf.gz")                 , emit: manta_diploid
  tuple val(sampleID), path("manta/Manta_${sampleID}.diploidSV.vcf.gz.tbi")             , emit: manta_diploid_tbi
  tuple val(sampleID), path("manta/Manta_${sampleID}.diploidSV_converted.vcf.gz")       , emit: manta_diploid_convert
  tuple val(sampleID), path("manta/Manta_${sampleID}.diploidSV_converted.vcf.gz.tbi")   , emit: manta_diploid_convert_tbi

script:
	// TODO: add optional parameters. 
	// define custom functions for optional flags
	// def manta_bed = mantaBED ? "--callRegions $params.mantaBED" : ""
	"""
	# configure manta SV analysis workflow
		configManta.py \
		--normalBam ${bam} \
		--referenceFasta ${params.ref} \
		--runDir manta \

	# run SV detection 
	manta/runWorkflow.py -m local -j 12

	# clean up outputs
	mv manta/results/variants/candidateSmallIndels.vcf.gz \
		manta/Manta_${sampleID}.candidateSmallIndels.vcf.gz
	mv manta/results/variants/candidateSmallIndels.vcf.gz.tbi \
		manta/Manta_${sampleID}.candidateSmallIndels.vcf.gz.tbi
	mv manta/results/variants/candidateSV.vcf.gz \
		manta/Manta_${sampleID}.candidateSV.vcf.gz
	mv manta/results/variants/candidateSV.vcf.gz.tbi \
		manta/Manta_${sampleID}.candidateSV.vcf.gz.tbi
	mv manta/results/variants/diploidSV.vcf.gz \
		manta/Manta_${sampleID}.diploidSV.vcf.gz
	mv manta/results/variants/diploidSV.vcf.gz.tbi \
		manta/Manta_${sampleID}.diploidSV.vcf.gz.tbi
	
	# convert multiline inversion BNDs from manta vcf to single line
	convertInversion.py \$(which samtools) ${params.ref} \
		manta/Manta_${sampleID}.diploidSV.vcf.gz \
		> manta/Manta_${sampleID}.diploidSV_converted.vcf

	# zip and index converted vcf
	bgzip manta/Manta_${sampleID}.diploidSV_converted.vcf
	tabix manta/Manta_${sampleID}.diploidSV_converted.vcf.gz
	"""
} 

```

## Considerations 


