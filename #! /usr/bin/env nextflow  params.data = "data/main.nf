#! /usr/bin/env nextflow

params.data = "data/*.fastq"
process sayHello {
    input:
    path file from Channel.fromPath(params.data)

    script:
    """
    echo 'Processing: $file'
    """
}
