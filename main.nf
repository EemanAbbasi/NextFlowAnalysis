#! /usr/bin/env nextflow

params.reads = 'data/*.fastq'
params.genome = 'genome.fa'
params.outdir = './results'

process AlignReads {
    input:
    tuple val(sample), path(reads) from Channel.fromFilePairs(params.reads)

    output:
    path "${sample}.bam" into bamFiles

    """
    bwa mem -t 8 ${params.genome} ${reads[0]} ${reads[1]} | samtools sort -o ${sample}.bam -
    """
}

process CallVariants {
    input:
    path bamFile from bamFiles

    output:
    path "${bamFile.baseName}.vcf" into vcfFiles

    """
    bcftools mpileup -Ou -f ${params.genome} ${bamFile} | bcftools call -mv -Ov -o ${bamFile.baseName}.vcf
    """
}

workflow {
    publishDir params.outdir, mode: 'copy'
    bamFiles.collect()
    vcfFiles.collect()
}
