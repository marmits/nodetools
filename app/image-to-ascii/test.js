
const imageToAscii = require("image-to-ascii");

imageToAscii("marmits.png", (err, res) => {
  console.log(err || res);
});
