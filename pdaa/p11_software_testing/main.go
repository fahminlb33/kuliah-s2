package main

import (
	"fmt"
	"tugasrpll/tanggal"
)

func main() {
	// to hold input
	var day, month, year int

	// ask for input
	fmt.Printf("Enter date (dd mm yyyy): ")
	_, err := fmt.Scanln(&day, &month, &year)
	if err != nil {
		panic(err)
	}

	// get next date
	nextDay, nextMonth, nextYear, err := tanggal.NextDate(day, month, year)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Next date from %d-%d-%d is %d-%d-%d\n", day, month, year, nextDay, nextMonth, nextYear)
}
