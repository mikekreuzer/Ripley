const getComparison = require('../lib/compare'),
  compare = getComparison.test.compare,
  template = getComparison.test.template,
  path = require('path');

describe('compare()', () => {
  test('it compares two data sets and calls template() - when there\'s a change', () => {
    let mockTemplate = jest.fn((input) => {
        return input;
      }),
      newData = {
        data: [{
          name: 'langOne',
          index: 1
        }, {
          name: 'langTwo',
          index: 2
        }, {
          name: 'langThree',
          index: 3
        }]
      },
      oldData = {
        data: [{
          name: 'langOne',
          index: 2
        }, {
          name: 'langTwo',
          index: 1
        }]
      },
      outPath = 'path',
      result = {
        dateScraped: undefined,
        oldTitle: undefined,
        paraData: [],
        tableData: [{
          delta: '<img src="https://mikekreuzer.github.io/Ripley/assets/up.png" alt="Up" width="24" height="16" style="margin-top:2px;margin-bottom:-2px;"> from  2',
          index: 1,
          name: 'langOne'
        },
        {
          delta: '<img src="https://mikekreuzer.github.io/Ripley/assets/down.png" alt="Down" width="24" height="16" style="margin-top:2px;margin-bottom:-2px;"> from  1',
          index: 2,
          name: 'langTwo'
        },
        {
          delta: 'New',
          index: 3,
          name: 'langThree'
        }],
        title: undefined
      };

    compare(newData, oldData, outPath, mockTemplate);

    expect(mockTemplate).toHaveBeenCalledWith(result, outPath);
  });

  test('it compares two data sets and calls template()  - when there\'s no change', () => {
    let mockTemplate = jest.fn((input) => {
        return input;
      }),
      newData = {
        data: [{
          name: 'langOne',
          index: 1
        }, {
          name: 'langTwo',
          index: 2
        }]
      },
      oldData = {
        data: [{
          name: 'langOne',
          index: 1
        }, {
          name: 'langTwo',
          index: 2
        }]
      },
      outPath = 'path',
      result = {
        dateScraped: undefined,
        oldTitle: undefined,
        paraData: [],
        tableData: [{
          delta: '&nbsp;',
          index: 1,
          name: 'langOne'
        },
        {
          delta: '&nbsp;',
          index: 2,
          name: 'langTwo'
        }],
        title: undefined
      };

    compare(newData, oldData, outPath, mockTemplate);

    expect(mockTemplate).toHaveBeenCalledWith(result, outPath);
  });
});

describe('template()', () => {
  test('it reads a template, & renders data to a file named after the month/year', () => {
    let data = 'data',
      errorFn = (err) => {
        if (err) throw err;
      },
      mockFs = jest.genMockFromModule('fs'),
      mockMoment = jest.fn(() => {
        return {
          format: () => {
            return 'MM-YYYY';
          }
        };
      }),
      mockMustache = jest.genMockFromModule('mustache'),
      outPath = 'path',
      filePath = path.join(outPath, 'MM-YYYY.md');
    mockFs.readFile = jest.fn((_path, _format, CB) => {
      CB(false, 'file');
    });
    mockMustache.render = jest.fn(() => {
      return 'HTML';
    });
    mockFs.writeFile = jest.fn();

    template(data, outPath, mockFs, mockMoment, mockMustache, errorFn);

    expect(mockFs.readFile).toHaveBeenCalled();
    expect(mockFs.writeFile).toHaveBeenCalledWith(filePath, 'HTML', errorFn);
  });
});

describe('getComparison()', () => {
  let data = 'data',
    oldData = 'data',
    mockComp = jest.fn(),
    mockFs = jest.genMockFromModule('fs'),
    mockMoment = jest.fn(() => {
      return {
        format: () => {
          return '2000–01';
        },
        subtract: jest.fn().mockReturnThis()
      };
    }),
    outPath = 'path';

  beforeEach(() => {
    mockComp.mockReset();
  });

  test('it calls the other comparison functions, piping data between them', () => {
    let mockTemplateReadCB = (err, oldData) => {
      if (err) console.log(err);
      mockComp(data, oldData);
    };
    mockFs.readFile = jest.fn((_path, _format, templateReadCB) => {
      templateReadCB(null, oldData);
    });

    getComparison.getComparison(data, outPath, mockFs, mockMoment, mockComp, mockTemplateReadCB);

    expect(mockFs.readFile).toHaveBeenCalledWith(path.join(__dirname, '..', 'data', '2000–01.json'), 'utf8', mockTemplateReadCB);
    expect(mockMoment).toHaveBeenCalled();
    expect(mockComp).toHaveBeenCalledWith(data, oldData);
  });

  test('it throws file system errors before calling compare()', () => {
    let mockTemplateReadCB = (err, oldData) => {
      if (err) throw err;
      mockComp(data, oldData);
    };
    mockFs.readFile = jest.fn((_path, _format, templateReadCB) => {
      templateReadCB('throw this error', oldData);
    });

    expect(() => {
      getComparison.getComparison(data, outPath, mockFs, mockMoment, mockComp, mockTemplateReadCB);
    }).toThrow('throw this error');

    expect(mockFs.readFile).toHaveBeenCalled();
    expect(mockMoment).toHaveBeenCalled();
    expect(mockComp).not.toHaveBeenCalled();
  });
});
