package main

import (
	"encoding/csv"
	"fmt"
	"math/rand"
	"os"
)

const (
	basePath = "/mnt/f/RandomData/base/"
	defaultFolderPath = "folders.csv"
	defaultFilePath = "files.csv"
)


type FileEntity struct {
	name string
	parentPath string
	sizeIfFile string
}

func SaveFolderNamesToFile(folders *[]string, saveToPath string) {
	folderHandler, err := os.Create(saveToPath)
	if err != nil {
		fmt.Println(err.Error())
	}
	defer func(folders *os.File) {
		_ = folders.Close()
	}(folderHandler)

	writer := csv.NewWriter(folderHandler)
	defer writer.Flush()
	writer.Write([]string{"Name"})
	for _, folder := range *folders {
		writer.Write([]string{folder})
	}
	writer.Flush()
}

func SaveFileNamesToFile(entities *[]FileEntity, saveToPath string) {
	folderHandler, err := os.Create(saveToPath)
	if err != nil {
		fmt.Println(err.Error())
	}
	defer func(folders *os.File) {
		_ = folders.Close()
	}(folderHandler)

	writer := csv.NewWriter(folderHandler)
	defer writer.Flush()
	writer.Write([]string{"Name", "Parent", "Size"})
	for _, entity := range *entities {
		writer.Write([]string{entity.name, entity.parentPath, entity.sizeIfFile})
	}
	writer.Flush()
}


func generateFolders(basePath string, numEntity, numFolders, maxEntityPerLevel int) (*[]FileEntity, *[]string) {
	files, folders := make([]FileEntity, numEntity - numFolders), make([]string, numFolders)
	fileCountSoFar, filesGenerated, folderCountSoFar, foldersGenerated := 0, false, 0, false

	for !filesGenerated || !foldersGenerated {
		dirQueue := make([]string, 0)
		dirQueue = append(dirQueue, basePath + folderName())
		for len(dirQueue) > 0 {
			dirSize := len(dirQueue)
			for i := 0; i < dirSize; i++ {
				relativePath := dirQueue[0]
				dirQueue = dirQueue[1:]
				folderCount := rand.Intn(maxEntityPerLevel) + 1
				for j := 0; j < folderCount && !foldersGenerated; j++ {
					dirName := relativePath + "/" + folderName()
					dirQueue = append(dirQueue, dirName)
					folders[folderCountSoFar] = dirName
					folderCountSoFar += 1
					if folderCountSoFar >= numFolders {
						foldersGenerated = true
						break
					}
				}
				fileCount := maxEntityPerLevel - folderCount
				for j := 0; j < fileCount && !filesGenerated; j++ {
					fileName, fileSize := fileNameAndSize()
					files[fileCountSoFar] = FileEntity{
						name:       fileName,
						parentPath: relativePath + "/",
						sizeIfFile: fileSize,
					}
					fileCountSoFar += 1
					if fileCountSoFar >= numEntity - numFolders {
						filesGenerated = true
						break
					}
				}

			}
		}
	}
	return &files, &folders
}

func main() {
	var numEntity, numFolders, maxEntityPerLevel int
	numEntity, maxEntityPerLevel = 1000, 5
	numFolders = numEntity / 10
	files, folders := generateFolders(basePath, numEntity, numFolders, maxEntityPerLevel)
	SaveFolderNamesToFile(folders, defaultFolderPath)
	SaveFileNamesToFile(files, defaultFilePath)
}