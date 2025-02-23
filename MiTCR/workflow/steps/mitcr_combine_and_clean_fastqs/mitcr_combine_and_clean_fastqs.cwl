#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- python3.7
- /usr/local/bin/combine_and_clean_fastqs.py

doc: "preprocessing before mitcr"

hints:
- class: ResourceRequirement
  ramMin: 10000
  tmpdirMin: 25000
- class: DockerRequirement
  dockerPull: quay.io/cri-iatlas/mitcr_combine_and_clean_fastqs:1.0


inputs:

- id: fastq_array
  type: File[]
  inputBinding:
    prefix: --fastqs
  doc: fastq files in the format of ".fastq" or ".fq"

outputs:

- id: fastq
  type: File
  outputBinding:
    glob: "reads.fq"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


