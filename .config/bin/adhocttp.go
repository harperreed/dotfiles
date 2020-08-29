package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"path"
)

var (
	host = flag.String("host", "0.0.0.0", "IP address to bind to")
	port = flag.Int("port", 8000, "TCP port to listen on")
)

var Usage = func() {
	fmt.Fprintf(os.Stderr, "Usage of %s:\n", os.Args[0])
	flag.PrintDefaults()
}

func main() {
	prog := path.Base(os.Args[0])
	log.SetFlags(0)
	log.SetPrefix(prog + ": ")

	flag.Usage = Usage
	flag.Parse()

	if flag.NArg() > 1 {
		Usage()
		os.Exit(1)
	}

	dir := "."
	if flag.NArg() == 1 {
		dir = flag.Arg(0)
	}

	log.Printf("Serving %q at http://%s:%d/", dir, *host, *port)
	http.Handle("/", http.FileServer(http.Dir(dir)))
	addr := fmt.Sprintf("%s:%d", *host, *port)
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal(err)
	}
}
