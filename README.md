
Just a collection of things I (sometimes) use on a daily basis

##### Vim section
    Remove blank spaces at the end of the line
    :%s/\s\+$//e
    
    Replace backslash with forward slash
    :%s/\\/\//g

    Add stuff at the begining of any string
    :%s!^!!

    Add stuff to the end of any string
    :%s/$/,/
##### Sed section
    Replace blocks of numbers
    sed -E 's/[0-9]+/{something-here}/g'
    
    Remove last char of string
    sed 's/{change-here}$//
    
    Remove/replace char after match
    sed 's/{change-here}.*/ZZZ/g'

    #Replace blocks of strings between patterns (e.g =)
    sed -E 's/=([A-Z]+)/{change-here}/g

##### jq section
    URL encode
    printf %s "1" | base64 -w0 | jq -sRr @uri

    Find exact match
    jq '.[] | select(.<param>=="<value>")' file
    jq .<param>('value')
    
    Exclude null values
    jq '.[] | select(. != null)'

    Fetch any that starts with
    jq ' .[] | select(. | startswith("<string>"))'

##### grep section
    extract lines that ends with N digits
    grep -E "[0-9]{4}"

    grep match, but shows everything else
    greo -iz ""


#### uniqs
    Merge files of line from each
    paste -d "\n" file1 file2 > out

    Sort uniqs by their beginning
    sort -ut '{delimeter-here}' -k1,1 (use it carefully)

#### Powershell
    Find files given a certain extension and get their content
    ForEach ($files in Get-ChildItem -Force -recurse){if ($files -Like "*.txt"){echo $files | Get-Content}}

    Based64 file content encoding
    [convert]::ToBase64String((gc file.txt -Encoding byte))
