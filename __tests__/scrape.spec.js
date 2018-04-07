const fetch = require('node-fetch'),
  path = require('path'),
  scrape = require('../lib/scrape'),
  addIndexAndPercentages = scrape.test.addIndexAndPercentages,
  requestAsync = scrape.test.requestAsync,
  saveJSONFile = scrape.test.saveJSONFile;

jest.mock('node-fetch');

describe('requestAsync()', () => {
  test('it gets a subreddit page (currently using fetch()), & scrapes subscriber data from it', () => {
    requestAsync({
      name: 'Ada',
      url: 'https://www.reddit.com/r/ada/'
    }, fetch).then(lang => {
      expect(lang).toEqual({
        'name': 'Ada',
        'subscribers': 300000,
        'subsstring': '300,000',
        'url': 'https://www.reddit.com/r/ada/'
      });
    });
  });

  test('it throws an error with badly formatted subscriber info on a page', () => {
    requestAsync({
      name: 'Not a subreddit',
      url: 'https://www.reddit.com/r/no-subscriber-info/'
    },
    fetch).then(lang => {
      expect(lang).rejects.toThrow();
    })
      // eslint-disable-next-line no-unused-vars
      .catch(_err => {});
  });

  test('it throws an error with a bad URL', () => {
    requestAsync({
      name: 'Not a subreddit',
      url: 'https://www.reddit.com/r/who-knows/'
    },
    fetch).then(lang => {
      expect(lang).rejects.toThrow('https://www.reddit.com/r/javascript/ threw an error');
    })
      // eslint-disable-next-line no-unused-vars
      .catch(_err => {});
  });
});

describe('addIndexAndPercentages()', () => {
  test('it expects an array', () => {
    expect(() => {
      addIndexAndPercentages('not an array');
    }).toThrow('addIndexAndPercentages expects an array');
  });

  test('it calculates and returns indexes and percentages', () => {
    let input = [{
        name: 'Ada',
        url: 'https://www.reddit.com/r/ada/',
        subscribers: 75
      },
      {
        name: 'JavaScript',
        url: 'https://www.reddit.com/r/javascript/',
        subscribers: 25
      }],
      expectedResult = [{
        index: 1,
        name: 'Ada',
        url: 'https://www.reddit.com/r/ada/',
        percentage: '75.0',
        subscribers: 75
      },
      {
        index: 2,
        name: 'JavaScript',
        url: 'https://www.reddit.com/r/javascript/',
        percentage: '25.0',
        subscribers: 25
      }],
      output = addIndexAndPercentages(input);
    expect(output).toEqual(expectedResult);
  });
});

describe('saveJSONFile()', () => {
  const data = 'This is data',
    expectedData = {
      title: 'dateString',
      dateScraped: 'dateString',
      data: data
    },
    errorCB = (err) => {
      if (err) throw err;
    },
    expectedFileName = path.join('out', 'dateString.json'),
    mockComparisonFunc = jest.fn(),
    mockFs = jest.genMockFromModule('fs'),
    mockMoment = jest.fn(() => {
      return {
        format: () => {
          return 'dateString';
        }
      };
    });

  test('it writes data and title based on month/year to a file named after the month/year, calls a comparison function', () => {
    mockFs.writeFile = jest.fn();
    saveJSONFile(data, mockFs, mockMoment, mockComparisonFunc, errorCB);
    expect(mockFs.writeFile).toHaveBeenCalledWith(expectedFileName, JSON.stringify(expectedData, null, 2), errorCB);
    expect(mockComparisonFunc).toHaveBeenCalledWith(expectedData);
  });

  test('it uses the default error function', () => {
    mockFs.writeFile = jest.fn();
    saveJSONFile(data, mockFs, mockMoment, mockComparisonFunc);
    expect(mockFs.writeFile).toHaveBeenCalledWith(expectedFileName, JSON.stringify(expectedData, null, 2), expect.any(Function));
    expect(mockComparisonFunc).toHaveBeenCalledWith(expectedData);
  });

  test('it throws errors', () => {
    mockFs.writeFile = jest.fn();
    expect(() => {
      saveJSONFile(data, null, mockMoment, mockComparisonFunc);
    }).toThrow(TypeError);
  });
});

describe('getParallel()', () => {

  function flushPromises() {
    return new Promise(resolve => setImmediate(resolve));
  }

  const languages = [{
      name: 'Ada',
      url: 'https://www.reddit.com/r/ada/'
    },
    {
      name: 'Agda',
      url: 'https://www.reddit.com/r/agda/'
    }],
    languagesWithNumbers = [{
      name: 'Ada',
      url: 'https://www.reddit.com/r/ada/',
      subscribers: 75
    },
    {
      name: 'Agda',
      url: 'https://www.reddit.com/r/agda/',
      subscribers: 25
    }],
    languagesFinalMocked = [{
      'index': 1,
      'name': 'Ada',
      'percentage': 'Calc',
      'subscribers': 75,
      'url': 'https://www.reddit.com/r/ada/'
    },
    {
      'index': 1,
      'name': 'Agda',
      'percentage': 'Calc',
      'subscribers': 25,
      'url': 'https://www.reddit.com/r/agda/'
    }],
    languagesFinalEndToEnd = [{
      'index': 1,
      'name': 'Ada',
      'percentage': '50.0',
      'subscribers': 300000,
      'subsstring': '300,000',
      'url': 'https://www.reddit.com/r/ada/'
    },
    {
      'index': 2,
      'name': 'Agda',
      'percentage': '50.0',
      'subscribers': 300000,
      'subsstring': '300,000',
      'url': 'https://www.reddit.com/r/agda/'
    }],
    mockRequestAsync = jest.fn()
    // eslint-disable-next-line no-unused-vars
      .mockReturnValueOnce(new Promise((resolve, _reject) => {
        resolve(languagesWithNumbers[0]);
      }))
    // eslint-disable-next-line no-unused-vars
      .mockReturnValueOnce(new Promise((resolve, _reject) => {
        resolve(languagesWithNumbers[1]);
      })),
    mockAddIndexAndPercentages = jest.fn(lang => {
      if (Array.isArray(lang)) {
        return lang.map(lang => {
          lang.index = 1;
          lang.percentage = 'Calc';
          return lang;
        });
      }
    }),
    mockSaveJSONFile = jest.fn(),
    mockFs = jest.genMockFromModule('fs');

  test('it calls the other scrape functions, piping data between them', async () => {
    scrape.getParallel(languages, mockSaveJSONFile, mockFs, mockRequestAsync, mockAddIndexAndPercentages);

    await flushPromises();
    expect(mockRequestAsync).toHaveBeenCalledWith(languages[0], fetch);
    expect(mockRequestAsync).toHaveBeenCalledWith(languages[1], fetch);
    expect(mockAddIndexAndPercentages).toHaveBeenCalledWith(languagesWithNumbers);
    expect(mockSaveJSONFile).toHaveBeenCalledWith(languagesFinalMocked, mockFs, expect.any(Function), expect.any(Function));
  });

  test('it calls the default functions (apart from saveJSONFile())', async () => {
    scrape.getParallel(languages, mockSaveJSONFile, mockFs, requestAsync, addIndexAndPercentages);
    await flushPromises();
    expect(mockSaveJSONFile).toHaveBeenCalledWith(languagesFinalEndToEnd, mockFs, expect.any(Function), expect.any(Function));
  });
});
