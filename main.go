package main

import (
	"fmt"
	"net/http"
)

func getRoot(w http.ResponseWriter, r *http.Request) {
}

func main() {
	http.HandleFunc("/", getRoot)

	if err := http.ListenAndServe(":8080", nil); err == nil {
		fmt.Printf("Listen error")
	}
}
