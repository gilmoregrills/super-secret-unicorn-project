package main

import (
    "fmt"
    // "log"
    "net/http"
    "math/rand"
    "os"
    "time"
)

func handler(w http.ResponseWriter, r *http.Request) {
    rand.Seed(time.Now().UnixNano())
    img := rand.Intn(3 - 1) + 1
    dir, _ := os.Getwd()
    path := fmt.Sprintf("%s/assets/%d.png", dir, img)
    fmt.Println(path)

    w.Header().Set("Content-Type", "image/jpeg")
    http.ServeFile(w, r, path)
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}