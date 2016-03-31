package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"
	"os"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/PuerkitoBio/goquery"
)

func getCount(client *http.Client, language *Lang, wg *sync.WaitGroup) {
	defer wg.Done()

	req, err := http.NewRequest("GET", language.Url, nil)
	throw(err)
	req.Header.Add("User-Agent", `Mac:com.mikekreuzer.ripley:0.1.0 (by /u/mikekreuzer)`)

	resp, err := client.Do(req)
	throw(err)
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		doc, err := goquery.NewDocumentFromReader(resp.Body)
		throw(err)

		countAsString := doc.Find("span.subscribers").First().Find("span.number").First().Text()
		if countAsString != "" {
			count, err := strconv.Atoi(strings.Replace(countAsString, ",", "", -1))
			throw(err)
			language.Subscribers = count
			language.SubsString = countAsString
		}
	} else {
		fmt.Println("%s - %s", http.StatusText(resp.StatusCode), language.Url)
	}
}

func outputTotal(languages []*Lang, tableSize int) {
	sort.Sort(sort.Reverse(BySubs(Languages)))

	total := 0
	for i, language := range languages {
		language.Index = i + 1
		total += language.Subscribers
	}

	for _, language := range languages {
		perc := float64(language.Subscribers) / float64(total) * 100.0
		language.Percentage = strconv.FormatFloat(perc, 'f', 1, 64)
	}
	plate, err := template.ParseFiles("tableTemplate.html")
	throw(err)

	// for the site
	data := &Output{languages[0:tableSize],
		languages[tableSize : len(languages)-1],
		languages[len(languages)-1],
		time.Now().Format("January 2, 2006")}
	err = plate.Execute(os.Stdout, data)
	throw(err)

	// to archive
	b, err := json.Marshal(languages)
	throw(err)
	var out bytes.Buffer
	json.Indent(&out, b, "", " \t")
	out.WriteTo(os.Stdout)
}
