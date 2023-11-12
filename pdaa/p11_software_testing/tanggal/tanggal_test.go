package tanggal_test

import (
	"testing"
	"tugasrpll/tanggal"

	"github.com/stretchr/testify/assert"
)

func TestNextDate(t *testing.T) {
	type TestCase struct {
		name                                     string
		inputDay, inputMonth, inputYear          int
		expectedDay, expectedMonth, expectedYear int
		expectError                              string
	}

	testCases := []TestCase{
		// test kondisi awal
		{
			name:          "should return error when day is less than 1",
			inputDay:      0,
			inputMonth:    1,
			inputYear:     2012,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid day",
		},
		{
			name:          "should return error when day is greater than 31",
			inputDay:      32,
			inputMonth:    1,
			inputYear:     2012,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid day",
		},
		{
			name:          "should return error when month is less than 1",
			inputDay:      1,
			inputMonth:    0,
			inputYear:     2012,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid month",
		},
		{
			name:          "should return error when month is greater than 12",
			inputDay:      1,
			inputMonth:    13,
			inputYear:     2012,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid month",
		},
		{
			name:          "should return error when year is less than 1812",
			inputDay:      1,
			inputMonth:    1,
			inputYear:     1811,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid year",
		},
		{
			name:          "should return error when year is greater than 2012",
			inputDay:      1,
			inputMonth:    1,
			inputYear:     2013,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid year",
		},

		// test kondisi naik satu tahun
		{
			name:          "should return 1, 1, 2011 when input 31, 12, 2011",
			inputDay:      31,
			inputMonth:    12,
			inputYear:     2011,
			expectedDay:   1,
			expectedMonth: 1,
			expectedYear:  2012,
			expectError:   "",
		},

		// test kondisi naik satu bulan
		{
			name:          "should return 1, 2, 2012 when input 31, 1, 2012",
			inputDay:      31,
			inputMonth:    1,
			inputYear:     2012,
			expectedDay:   1,
			expectedMonth: 2,
			expectedYear:  2012,
			expectError:   "",
		},
		{
			name:          "should return error when input 31, 4, 2012",
			inputDay:      31,
			inputMonth:    4,
			inputYear:     2012,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid day",
		},
		{
			name:          "should return 1, 5, 2012 when input 30, 4, 2012",
			inputDay:      30,
			inputMonth:    4,
			inputYear:     2012,
			expectedDay:   1,
			expectedMonth: 5,
			expectedYear:  2012,
			expectError:   "",
		},

		// test kondisi naik satu bulan dari Februari
		{
			name:          "should return 1, 3, 2012 when input 29, 2, 2012 on non-leap year",
			inputDay:      29,
			inputMonth:    2,
			inputYear:     2012,
			expectedDay:   1,
			expectedMonth: 3,
			expectedYear:  2012,
			expectError:   "",
		},
		{
			name:          "should return error when input 29, 2, 2011 on non-leap year",
			inputDay:      29,
			inputMonth:    2,
			inputYear:     2011,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid day",
		},
		{
			name:          "should return 1, 3, 2010 when input 28, 2, 2010 on leap year",
			inputDay:      28,
			inputMonth:    2,
			inputYear:     2010,
			expectedDay:   1,
			expectedMonth: 3,
			expectedYear:  2010,
			expectError:   "",
		},
		{
			name:          "should return error when input 28, 2, 2008 on non-leap year",
			inputDay:      28,
			inputMonth:    2,
			inputYear:     2008,
			expectedDay:   0,
			expectedMonth: 0,
			expectedYear:  0,
			expectError:   "invalid day",
		},

		// test kondisi naik satu hari
		{
			name:          "should return 31, 1, 2012 when input 30, 1, 2012",
			inputDay:      30,
			inputMonth:    1,
			inputYear:     2012,
			expectedDay:   31,
			expectedMonth: 1,
			expectedYear:  2012,
			expectError:   "",
		},
		{
			name:          "should return 2, 1, 2012 when input 1, 1, 2012",
			inputDay:      1,
			inputMonth:    1,
			inputYear:     2012,
			expectedDay:   2,
			expectedMonth: 1,
			expectedYear:  2012,
			expectError:   "",
		},
	}

	for _, testCase := range testCases {
		t.Run(testCase.name, func(t *testing.T) {
			// Arrange
			// no initializations

			// Act
			day, month, year, err := tanggal.NextDate(testCase.inputDay, testCase.inputMonth, testCase.inputYear)

			// Assert
			if testCase.expectError != "" {
				assert.Errorf(t, err, testCase.expectError)
				return
			}

			assert.NoError(t, err)
			assert.Equal(t, testCase.expectedDay, day)
			assert.Equal(t, testCase.expectedMonth, month)
			assert.Equal(t, testCase.expectedYear, year)
		})
	}
}
