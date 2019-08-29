require("./style.css");

const { Elm } = require("./elm/Main");

Elm.Main.init({
  node: document.getElementById("elm-root")
});
