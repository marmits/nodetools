
const imageToAscii = require("image-to-ascii");

imageToAscii("https://octodex.github.com/images/octofez.png", (err, res) => {
  console.log(err || res);
});
