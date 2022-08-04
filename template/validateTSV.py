#!/usr/bin/env python3

import pandas as pd
import os

# The file path of the sample input TSV file (provided by the user)
# is encoded by Nextflow by the following expression
bamList = "${bamList}"
# Now the Python variable `manifest_csv` contains the local filepath
# which contains the file which was specified by the user

# Make sure we can find the file
assert os.path.exists(bamList), f"Cannot find {manifest_csv} in the local process folder"

# Try to read in the file as a TSV
print(f"Reading in {bamList} as TSV")
df = pd.read_tsv(bamList)
print(f"Read in {df.shape[0]:,} rows and {df.shape[1]:,} columns")

# Note in the lines below how the newline character needs to be escaped
# This is due to the way that Nextflow treats template files, and interpolating
# variables from the process namespace
column_list_str = "\\n".join([n for n in df.columns.values])
print(f"Columns: \\n{column_list_str}")

# Now we need to make sure that all of the expected columns are present
for cname in ['sample', 'bam']:
    assert cname in df.columns.values, f"Manifest file must contain a column {cname}"

# At this point, everything checks out
print("Everything checks out")
