(() => {
  // Only for github.
  let host = window.location.host;
  if (!host.endsWith("github.com")) {
    return;
  }

  let disableFuckingIndention = () => {
    let lineNumbers = document.querySelectorAll(".react-line-number")
    lineNumbers.forEach(
      (element) => element.style["padding-right"] = "0px"
    )

    document.querySelector("#read-only-cursor-text-area").style["padding-left"] = "74px"

    let codeLines = document.querySelectorAll(".react-file-line.html-div")
    codeLines.forEach(
      (element) => element.style["padding-left"] = "2px"
    )

    let codeLineContents = document.querySelectorAll(".react-code-line-contents")
    codeLineContents.forEach(
      (element) => element.style["padding-left"] = "0px"
    )
  };

  let disableFuckingIndentationInterval = setInterval(disableFuckingIndention, 500);
  setTimeout(() => {
    clearInterval(disableFuckingIndentationInterval)
  }, 10000);

})();
