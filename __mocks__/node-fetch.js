// eslint-disable-next-line no-unused-vars
module.exports = (url, _options) => {
  if (url == 'https://www.reddit.com/r/ada/' || url == 'https://www.reddit.com/r/agda/') {
    return Promise.resolve({
      text: () => {
        return `<html><body>
          <span class="subscribers">
            <span class="number">300,000</span>&#32;
            <span class="word">readers</span>
          </span>
          </body></html>`;
      }
    });
  } else if (url == 'https://www.reddit.com/r/no-subscriber-info/') {
    return Promise.resolve({
      text: () => {
        return `<html><body>
          <span class="subscribers">
            <span class="number">No number to parse</span>&#32;
            <span class="word">readers</span>
          </span>
          </body></html>`;
      }
    });
  } else {
    return Promise.reject(`${url} threw an error`);
  }
};
