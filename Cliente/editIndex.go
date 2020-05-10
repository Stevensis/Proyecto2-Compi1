package main

import (
	"fmt"
	"html/template"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	Prueba := "Prueba A ver"
	t := template.Must(template.ParseFiles("index.html"))
	t.Execute(w, Prueba)
}

func main() {
	fmt.Printf("hello, world\n")
	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("css/"))))
	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("js/"))))

	http.HandleFunc("/", index)

	fmt.Printf("listening 8000")
	http.ListenAndServe(":8000", nil)
}
