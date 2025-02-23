#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement

doc: >
  Workflow for pulling input files for `calculate_mutation_models`
  from Synapse, running the analysis, and storing the output on
  Synapse. For more information on any given input parameter, 
  refer to the corresponding tool's CWL definition. 

inputs:
  synapse_config: File
  features_synapse_id: string
  groups_synapse_id: string
  mutations_synapse_id: string
  output_parent_synapse_id: string
  input_file_type: string?
  output_file: string?
  output_file_type: string?
  feature_sample_column: string?
  feature_name_column: string?
  feature_value_column: string?
  group_sample_column: string?
  group_name_column: string?
  mutation_name_columns: string[]?
  mutation_name_separator: string?
  mutation_sample_column: string?
  mutation_status_column: string?
  num_significant_digits: int?

outputs: 

  - id: output_synapse_id
    type: string
    outputSource: syn_store/file_id

steps:

  - id: syn_get_features
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: features_synapse_id
    out:
      - filepath
  
  - id: syn_get_groups
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: groups_synapse_id
    out:
      - filepath
  
  - id: syn_get_mutations
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: mutations_synapse_id
    out:
      - filepath

  - id: calculate_mutation_models
    run: steps/calculate_mutation_models/calculate_mutation_models.cwl
    in: 
      input_feature_file: syn_get_features/filepath
      input_group_file: syn_get_groups/filepath
      input_mutation_file: syn_get_mutations/filepath
      input_file_type: input_file_type
      output_file: output_file
      output_file_type: output_file_type
      feature_sample_column: feature_sample_column
      feature_name_column: feature_name_column
      feature_value_column: feature_value_column
      group_sample_column: group_sample_column
      group_name_column: group_name_column
      mutation_name_columns: mutation_name_columns
      mutation_name_separator: mutation_name_separator
      mutation_sample_column: mutation_sample_column
      mutation_status_column: mutation_status_column
      num_significant_digits: num_significant_digits
    out:
      - mutation_models

  - id: syn_store
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-store-tool.cwl
    in: 
      - id: synapse_config
        source: synapse_config
      - id: file_to_store
        source: calculate_mutation_models/mutation_models
      - id: parentid
        source: output_parent_synapse_id
      - id: name
        source: output_file 
      # The following is commented out until the following PR is merged.
      # Only then can these arguments be used. Update the CWL URL accordingly.
      # https://github.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/pull/30
      # - id: used
      #   source: [features_synapse_id, groups_synapse_id, mutations_synapse_id]
      # - id: executed
      #   valueFrom: $(["https://github.com/CRI-iAtlas/iatlas-workflows/blob/v1.1/Calculate_Mutation_Models/workflow/steps/calculate_mutation_models/calculate_mutation_models.cwl"])
    out: 
      - file_id

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4621-1589
    s:email: bruno.grande@sagebase.org
    s:name: Bruno Grande
