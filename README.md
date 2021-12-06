# Performance Testing - AzCopy

## Generate file names
Inside `file_generator.sh` file, go to L3 and change the NumberOfFiles, NumberOfItemsPerLevel, and LocalGenerationPath
```bash
go run file_generator.go $NumberOfFiles $NumberOfItemsPerLevel $LocalGenerationPath
```

## Creating files
Run with elevated permission if required.
```bash
sh file_generator.sh
```