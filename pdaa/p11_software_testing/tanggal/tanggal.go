package tanggal

import "errors"

func NextDate(day, month, year int) (int, int, int, error) {
	// cek constraint awal
	if day < 1 || day > 31 {
		return 0, 0, 0, errors.New("invalid day")
	}
	if month < 1 || month > 12 {
		return 0, 0, 0, errors.New("invalid month")
	}
	if year < 1812 || year > 2012 {
		return 0, 0, 0, errors.New("invalid year")
	}

	// cek apakah bisa naik satu tahun
	if day == 31 && month == 12 {
		return 1, 1, year + 1, nil
	}

	// cek apakah bisa naik satu bulan
	// bulan dengan 31 hari
	if day == 31 {
		if month == 1 || month == 3 || month == 5 || month == 7 ||
			month == 8 || month == 10 {
			return 1, month + 1, year, nil
		}
		return 0, 0, 0, errors.New("invalid day")
	}

	// bulan dengan 30 hari
	if day == 30 {
		if month == 4 || month == 6 || month == 9 || month == 11 {
			return 1, month + 1, year, nil
		}
	}

	// bulan Februari
	if day == 29 && month == 2 {
		if year%4 == 0 {
			return 1, month + 1, year, nil
		}
		return 0, 0, 0, errors.New("invalid day")
	}

	if day == 28 && month == 2 {
		if year%4 != 0 {
			return 1, month + 1, year, nil
		}
		return 0, 0, 0, errors.New("invalid day")
	}

	// naik satu hari
	return day + 1, month, year, nil
}
