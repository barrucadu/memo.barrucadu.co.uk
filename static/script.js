var showContents = true;
var savedContents = "";

function toggle_contents() {
    const contents = document.getElementById("contents");

    showContents = !showContents;
    if (showContents) {
        contents.innerHTML = savedContents;
    } else {
        contents.innerText = "";
    }
}

window.onload = () => {
    // Hide contents box
    savedContents = document.getElementById("contents").innerHTML;
    toggle_contents();
}
