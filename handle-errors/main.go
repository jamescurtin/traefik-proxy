// Webserver that returns pretty HTTP error codes
package main

import (
	"html/template"
	"log"
	"net/http"
	"strconv"
)

// Determines if input value is a valid HTTP error code
func isHTTPErrorCode(i int) bool {
	if (i >= 400) && (i <= 599) {
		return true
	} else {
		return false
	}
}

// Renders HTML template with the provided status code. The status code is both
// inserted as text in the HTML body and set as the status of the response.
func renderTemplate(w http.ResponseWriter, statusCode int) {
	w.WriteHeader(statusCode)

	t, err := template.ParseFiles("status.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	err = t.Execute(w, statusCode)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

// Handles incoming requests. If the path of the request is a valid HTTP error
// code, return a landing page for that status. Otherwise, return a 404
func handler(w http.ResponseWriter, r *http.Request) {
	requestPath := r.URL.Path[1:]

	requestPathInt, err := strconv.Atoi(requestPath)
	if err != nil {
		renderTemplate(w, 404)
		return
	}

	if isErrorCode := isHTTPErrorCode(requestPathInt); isErrorCode == false {
		renderTemplate(w, 404)
		return
	}

	renderTemplate(w, requestPathInt)
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
