package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"path"
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
	req.Header.Add("User-Agent", `Mac:com.mikekreuzer.ripley:0.2.0 (by /u/mikekreuzer)`)

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

func writeBytes(fileName string, b []byte) {
	f, err := os.Create(fileName)
	throw(err)
	defer f.Close()
	_, err = f.Write(b)
	throw(err)
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

	// json
	theDate := time.Now()
	data := &Output{theDate.Format("January 2006"), theDate.Format(time.RFC3339), languages}
	b, err := json.Marshal(data)
	throw(err)
	var out bytes.Buffer
	json.Indent(&out, b, "", " \t")

	// file name
	fileNameParts := []string{"new-", theDate.Format("01-2006"), ".json"}
	fileName := path.Join("data", strings.Join(fileNameParts, ""))

	// write file
	writeBytes(fileName, out.Bytes())
}
