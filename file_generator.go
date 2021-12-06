package main

import (
	"encoding/csv"
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"
)

const (
	defaultFolderPath = "folders.csv"
	defaultFilePath   = "files.csv"
)

// ----------------------- Name Generation Logic -----------------------------------------------------------------------

const fileNameMaxSize = 64

var allowedChars = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
var fileExtensions = []string{"", ".sh", ".exe", ".cpp", ".java", ".py", ".go", ".mp3", ".mp4", ".pkg", ".jpeg", ".png",
	".pdf", ".gzip", ".txt", ".dat", ".bat", ".xlsx", ".vhd", ".tar.gz", ".deb"}
var fileSizes = []string{"1K", "10K", "100K", "1M", "10M", "100M", "1G", "10G"}
var cmmProbability = []int{400, 700, 800, 900, 1000, 1010, 1011, 1011}
var seededRand = rand.New(rand.NewSource(time.Now().UnixNano()))

func randSeq(n int) string {
	b := make([]rune, n)
	for i := range b {
		if i == 0 {
			b[i] = allowedChars[seededRand.Intn(len(allowedChars)-10)]
		} else {
			b[i] = allowedChars[seededRand.Intn(len(allowedChars))]
		}
	}
	return string(b)
}

func fileNameAndSize() (string, string) {
	fileSizeIndex := rand.Intn(cmmProbability[len(cmmProbability)-1])
	fileSize := "1K"
	for i := 0; i < len(cmmProbability); i++ {
		if fileSizeIndex <= cmmProbability[i] {
			fileSize = fileSizes[i]
			break
		}
	}
	return randSeq(rand.Intn(fileNameMaxSize)+1) + fileExtensions[rand.Intn(len(fileExtensions))], fileSize
}

func folderName() string {
	return randSeq(rand.Intn(fileNameMaxSize) + 1)
}

type fileEntity struct {
	name       string
	parentPath string
	sizeIfFile string
}

type folderEntity struct {
	path string
}

func saveFolderNamesToFile(folders *[]folderEntity, saveToPath string) {
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
		writer.Write([]string{folder.path})
	}
	writer.Flush()
}

func saveFileNamesToFile(entities *[]fileEntity, saveToPath string) {
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

func generateFilesAndFolders(basePath string, numEntity, numFolders, maxEntityPerLevel int) (*[]fileEntity, *[]folderEntity) {
	files, folders := make([]fileEntity, numEntity), make([]folderEntity, numFolders)
	fileCountSoFar, filesGenerated, folderCountSoFar, foldersGenerated := 0, false, 0, false

	for !filesGenerated || !foldersGenerated {
		dirQueue := make([]string, 0)
		dirQueue = append(dirQueue, basePath+folderName())
		for len(dirQueue) > 0 {
			dirSize := len(dirQueue)
			for i := 0; i < dirSize; i++ {
				relativePath := dirQueue[0]
				dirQueue = dirQueue[1:]
				folderCount := rand.Intn(maxEntityPerLevel) + 1
				for j := 0; j < folderCount && !foldersGenerated; j++ {
					dirName := relativePath + "/" + folderName()
					dirQueue = append(dirQueue, dirName)
					folders[folderCountSoFar] = folderEntity{path: dirName}
					folderCountSoFar += 1
					if folderCountSoFar >= numFolders {
						foldersGenerated = true
						break
					}
				}
				fileCount := maxEntityPerLevel - folderCount
				for j := 0; j < fileCount && !filesGenerated; j++ {
					fileName, fileSize := fileNameAndSize()
					files[fileCountSoFar] = fileEntity{
						name:       fileName,
						parentPath: relativePath + "/",
						sizeIfFile: fileSize,
					}
					fileCountSoFar += 1
					if fileCountSoFar >= numEntity {
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
	arguments := os.Args[1:]
	var numEntity, numFolders, maxEntityPerLevel int
	numEntity, _ = strconv.Atoi(arguments[0])
	maxEntityPerLevel, _ = strconv.Atoi(arguments[1])
	numFolders = numEntity / 10
	generationPath := arguments[2]
	files, _ := generateFilesAndFolders(generationPath, numEntity, numFolders, maxEntityPerLevel)
	//saveFolderNamesToFile(folders, defaultFolderPath)
	saveFileNamesToFile(files, defaultFilePath)
}
