# call this script like this with Administrator privilege:
# .\create-jpeg-file-links.ps1 -i 'C:\Users\Default\Documents' -o 'C:\Users\Default\Downloads'
Param(
    # input folder
    [parameter(mandatory=${true})][string]${i},
    # output folder
    [parameter(mandatory=${true})][string]${o}
)
# Stop if error occurs
${ErrorActionPreference} = 'Stop'

Write-Host "input folder is ${i}"
Write-Host "output folder is ${o}"

Function findAllJpegFile {
    Param(
        [string]${input_folder},
        [string]${output_folder}
    )
    # check whether or not input folder is same with output folder
    if((Join-Path ${input_folder} '') -eq (Join-Path ${output_folder} '')) {
        Write-Error "input folder and output folder is same. folder: ${input_folder}"
    }
    ${files} = Get-ChildItem -Recurse -File -Include @('*.jpg','*.jpeg','*.JPG', '*.JPEG') -Path ${input_folder}
    return ${files}
}

Function createFileShortcut {
    Param(
        [string[]]${files},
        [string]${output_folder}
    )
    for (${i}=0; ${i} -lt ${files}.Count; ${i}++){
        ${file} = ${files}[${i}]
        ${file_name} = Split-Path ${file} -leaf
        ${link_file} = Join-Path ${output_folder} ${file_name}
        New-Item -ItemType SymbolicLink -Path ${link_file} -Target ${file}
    }
}

${files} = findAllJpegFile ${i} ${o}
createFileShortcut ${files} ${o}

