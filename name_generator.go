package main

import "math/rand"

const fileNameMaxSize = 128
var allowedChars = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
var fileExtensions = []string{"", ".sh", ".exe", ".cpp", ".java", ".py", ".go", ".mp3", ".mp4", ".pkg", ".jpeg", ".png", ".pdf", ".gzip", ".txt", ".dat", ".bat", ".xlsx", ".vhd", ".tar.gz", ".deb"}
var fileSizes = []string{"1K", "10K", "100K", "1M", "10M", "100M", "1G", "10G"}

func randSeq(n int) string {
	b := make([]rune, n)
	for i := range b {
		if i == 0 {
			b[i] = allowedChars[rand.Intn(len(allowedChars) - 10)]
		} else {
			b[i] = allowedChars[rand.Intn(len(allowedChars))]
		}
	}
	return string(b)
}

func fileNameAndSize() (string, string) {
	fileSizeIndex := rand.Intn(1000)
	var fileSize string
	if fileSizeIndex < 400 {
		fileSize = fileSizes[0]
	} else if fileSizeIndex < 800 {
		fileSize = fileSizes[1]
	} else if fileSizeIndex < 900 {
		fileSize = fileSizes[2]
	} else if fileSizeIndex < 950 {
		fileSize = fileSizes[3]
	} else if fileSizeIndex < 990 {
		fileSize = fileSizes[4]
	}  else if  fileSizeIndex < 998 {
		fileSize = fileSizes[5]
	} else if fileSizeIndex < 999 {
		fileSize = fileSizes[6]
	} else {
		fileSize = fileSizes[7]
	}
	return randSeq(rand.Intn(fileNameMaxSize) + 1) + fileExtensions[rand.Intn(len(fileExtensions))], fileSize
}

func folderName() string {
	return randSeq(rand.Intn(fileNameMaxSize) + 1)
}
