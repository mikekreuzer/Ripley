package main

type Output struct {
	TopTable   []*Lang
	Tail       []*Lang
	Last       *Lang
	DateString string
}

type Lang struct {
	Index       int    `json:"index"`
	Name        string `json:"name"`
	Url         string `json:"url"`
	Subscribers int    `json:"subscribers"`
	SubsString  string `json:"subsstring"`
	Percentage  string `json:"percentage"`
}

type BySubs []*Lang

func (a BySubs) Len() int           { return len(a) }
func (a BySubs) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a BySubs) Less(i, j int) bool { return a[i].Subscribers < a[j].Subscribers }

var Languages = []*Lang{
	&Lang{0, "Ada", "https://www.reddit.com/r/ada/", 0, "?", "0"},
	&Lang{0, "Assembly", "https://www.reddit.com/r/asm", 0, "?", "0"},
	&Lang{0, "C", "https://www.reddit.com/r/C_Programming", 0, "?", "0"},
	&Lang{0, "Clojure", "https://www.reddit.com/r/clojure", 0, "?", "0"},
	&Lang{0, "COBOL", "https://www.reddit.com/r/cobol", 0, "?", "0"},
	&Lang{0, "CoffeeScript", "https://www.reddit.com/r/coffeescript", 0, "?", "0"},
	&Lang{0, "C#", "https://www.reddit.com/r/csharp", 0, "?", "0"},
	&Lang{0, "C++", "https://www.reddit.com/r/cpp", 0, "?", "0"},
	&Lang{0, "D", "https://www.reddit.com/r/d_language", 0, "?", "0"},
	&Lang{0, "Dart", "https://www.reddit.com/r/dartlang", 0, "?", "0"},
	&Lang{0, "Elixir", "https://www.reddit.com/r/elixir", 0, "?", "0"},
	&Lang{0, "Elm", "https://www.reddit.com/r/elm", 0, "?", "0"},
	&Lang{0, "Erlang", "https://www.reddit.com/r/erlang", 0, "?", "0"},
	&Lang{0, "Forth", "https://www.reddit.com/r/Forth", 0, "?", "0"},
	&Lang{0, "Fortran", "https://www.reddit.com/r/fortran", 0, "?", "0"},
	&Lang{0, "F#", "https://www.reddit.com/r/fsharp", 0, "?", "0"},
	&Lang{0, "Go", "https://www.reddit.com/r/golang", 0, "?", "0"},
	&Lang{0, "Groovy", "https://www.reddit.com/r/groovy", 0, "?", "0"},
	&Lang{0, "Haskell", "https://www.reddit.com/r/haskell", 0, "?", "0"},
	&Lang{0, "Java", "https://www.reddit.com/r/java", 0, "?", "0"},
	&Lang{0, "JavaScript", "https://www.reddit.com/r/javascript", 0, "?", "0"},
	&Lang{0, "Julia", "https://www.reddit.com/r/julia", 0, "?", "0"},
	&Lang{0, "Lisp", "https://www.reddit.com/r/lisp", 0, "?", "0"},
	&Lang{0, "Lua", "https://www.reddit.com/r/lua", 0, "?", "0"},
	&Lang{0, "Nim", "https://www.reddit.com/r/nim", 0, "?", "0"},
	&Lang{0, "Objective C", "https://www.reddit.com/r/ObjectiveC", 0, "?", "0"},
	&Lang{0, "Pascal", "https://www.reddit.com/r/delphi", 0, "?", "0"},
	&Lang{0, "Perl", "https://www.reddit.com/r/perl", 0, "?", "0"},
	&Lang{0, "PHP", "https://www.reddit.com/r/php", 0, "?", "0"},
	&Lang{0, "Prolog", "https://www.reddit.com/r/prolog", 0, "?", "0"},
	&Lang{0, "Python", "https://www.reddit.com/r/Python", 0, "?", "0"},
	&Lang{0, "Ruby", "https://www.reddit.com/r/ruby", 0, "?", "0"},
	&Lang{0, "Rust", "https://www.reddit.com/r/rust", 0, "?", "0"},
	&Lang{0, "Scala", "https://www.reddit.com/r/scala", 0, "?", "0"},
	&Lang{0, "Scheme", "https://www.reddit.com/r/scheme/", 0, "?", "0"},
	&Lang{0, "Scratch", "https://www.reddit.com/r/scratch/", 0, "?", "0"},
	&Lang{0, "Swift", "https://www.reddit.com/r/swift", 0, "?", "0"},
	&Lang{0, "TCL", "https://www.reddit.com/r/tcl", 0, "?", "0"},
	&Lang{0, "TypeScript", "https://www.reddit.com/r/typescript", 0, "?", "0"},
	&Lang{0, "Visual Basic", "https://www.reddit.com/r/visualbasic", 0, "?", "0"},
}
