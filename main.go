package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

var (
	hostname string
	apiURL   string
)

func init() {
	var err error
	hostname, err = os.Hostname()
	if err != nil {
		log.Fatalf("Failed to get hostname: %v", err)
	}
	apiURL = os.Getenv("API_URL")
}

func appendAPIContent(html string) string {
	if apiURL == "" {
		return html
	}

	resp, err := http.Get(apiURL)
	if err != nil {
		log.Printf("Failed to fetch API content: %v", err)
		return html
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Failed to read API response: %v", err)
		return html
	}

	return html + string(body)
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	html := fmt.Sprintf("<h1>Hello, World from %s!</h1>", hostname)
	response := appendAPIContent(html)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	fmt.Fprint(w, response)
}

func apiHandler(w http.ResponseWriter, r *http.Request) {
	html := fmt.Sprintf("<p>Calling %s</p>", hostname)
	response := appendAPIContent(html)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	fmt.Fprint(w, response)
}

func main() {
	host := os.Getenv("HOST")
	if host == "" {
		host = "0.0.0.0"
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	addr := fmt.Sprintf("%s:%s", host, port)

	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/api", apiHandler)

	fmt.Printf("Starting server on %s\n", addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
