library(argparse)

parser = argparse::ArgumentParser(description = "")

parser$add_argument(
    "--cohorts",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--samples",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--features",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--feature_classes",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--min_value",
    default = NULL,
    type = "double"
)

parser$add_argument(
    "--max_value",
    default = NULL,
    type = "double"
)

args <- parser$parse_args()

argument_list <- purrr::map_if(args, is.null, ~return(NA)) 

result <- purrr::invoke(
    iatlas.api.client::query_feature_values,
    argument_list
)

print(result)

arrow::write_feather(
    result, 
    "feature_values.feather", 
    compression = "uncompressed"
)




