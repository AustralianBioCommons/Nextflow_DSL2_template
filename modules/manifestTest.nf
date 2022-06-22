#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

process manifestTesting {

    input:
        path bamList

    output:
        file "manifest.csv"

    script:
    templates 'validate_manifest.py'
