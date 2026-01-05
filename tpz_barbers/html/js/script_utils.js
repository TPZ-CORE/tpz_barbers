
let CURRENT_GROOM_CATEGORY_ITEM = 1;
let MAXIMUM_GROOM_CATEGORY_ITEMS = 1;

let CURRENT_GROOM_COLOR_ITEM = 1;
let MAXIMUM_GROOM_COLOR_ITEMS = 1;

let CURRENT_GROOM_OPACITY_ITEM = 10;

let HAS_COOLDOWN = false;

document.addEventListener("DOMContentLoaded", function () {

  $("#main").fadeOut();

  displayPage("main-section", "visible");
  $(".main-section").fadeOut();

  displayPage("groom-selected-section", "visible");
  $(".groom-selected-section").fadeOut();
});

function PlayButtonClickSound() {
  var audio = new Audio('./audio/button_click.wav');
  audio.volume = 0.3;
  audio.play();
}

function displayPage(page, cb){
  document.getElementsByClassName(page)[0].style.visibility = cb;

  [].forEach.call(document.querySelectorAll('.' + page), function (el) {
    el.style.visibility = cb;
  });
}

function ResetCooldown(){ setTimeout(function () { HAS_COOLDOWN = false; }, 500); }

function convertSelectorValue(val) {
  if (val < 0 || val > 10) {
    return val;
  }
  const scaled = (val / 10).toFixed(1); // 0.1, 0.2, ..., 1.0
  return `${scaled}`;
}

function convertToInt(val) {
  const num = parseFloat(val); // handle both string and number inputs
  if (num < 0 || num > 1) {
    return val;
  }
  return Math.round(num * 10); // scale back up to integer
}