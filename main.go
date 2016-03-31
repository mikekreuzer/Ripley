package main

import (
	"net/http"
	"sync"
	// "time"
)

func throw(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	var wg sync.WaitGroup

	client := &http.Client{}
	for _, language := range Languages {
		wg.Add(1)
		// time.Sleep(4500 * time.Millisecond) // naïve Reddit rate limit pause
		go getCount(client, language, &wg)
	}

	wg.Wait()
	outputTotal(Languages, 20)
}
