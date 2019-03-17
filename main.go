package main

import (
    "fmt"
    // "log"
    "net/http"
    "math/rand"
    "os"
    "io/ioutil"
    "time"
)

func handler(w http.ResponseWriter, r *http.Request) {
    rand.Seed(time.Now().UnixNano())

    dir, _ := os.Getwd()
    images, _ := ioutil.ReadDir(fmt.Sprintf("%s/assets/", dir))

    maxImages := len(images)
    img := rand.Intn(maxImages - 1) + 1

    path := fmt.Sprintf("%s/assets/%d.png", dir, img)

    w.Header().Set("Content-Type", "image/jpeg")
    http.ServeFile(w, r, path)
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}