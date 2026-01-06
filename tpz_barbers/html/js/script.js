
function CloseNUI() {

  $("#main").fadeOut();
  $(".main-section").hide();
  $(".groom-selected-section").hide();

  $.post('http://tpz_barbers/close', JSON.stringify({}));
}

$(function() {

	window.addEventListener('message', function(event) {
		
    var item = event.data;

		if (item.type == "enable") {
			document.body.style.display = item.enable ? "block" : "none";

      $(".main-section").show();

      if (item.enable) {
        $("#main").fadeIn(1000);
      }

    } else if (item.action == "reset_components_list") {
      
      $("#groom-selected-comps-list").html('');

    } else if (item.action == "set_information") {

      $("#main-title").text(item.title);
      $("#main-hair-button").text(item.locales['NUI_HAIR_BUTTON']);
      $("#main-hairoverlay-button").text(item.locales['NUI_GROOM_OVERLAY']);
      $("#main-beard-button").text(item.locales['NUI_BEARD_BUTTON']);
      $("#main-beardstabble-button").text(item.locales['NUI_BEARDSTABBLE_BUTTON']);
      $("#main-close-button").text(item.locales['NUI_CLOSE']);
      $("#groom-selected-back-button").text(item.locales['NUI_BACK']);

      document.getElementById('main-info-text').innerHTML = item.locales['NUI_MAIN_PAGE_DESCRIPTION'];

      // We remove beard and beardstabble if ped is a female.
      // We also move the top position of exit button for better view.
      if (item.ismale == 0){
        $("#main-beard-button").hide();
        $("#main-beardstabble-button").hide();
        $("#main-hairoverlay-button").show();
        $('#main-close-button').css('margin-top', '32%');

      }else {
        $("#main-beard-button").show();
        $("#main-beardstabble-button").show();
        $("#main-hairoverlay-button").hide();
        $('#main-close-button').css('margin-top', '35.5%');
      }

    } else if (item.action == "insertGroomCategoryElements") {

      let res = item.result;

      let current = res.current;
      let max = res.max

      if (res.category == 'hair' || res.category == 'beard') {
        $("#groom-selected-comps-list").css('top', '38.3%');

      } else {

        if (res.type == 'opacity') {

          if (current == 10 || current == 1.0) {
            current = "1.0";
          }

          if (current == 0.0) {
            current = "0.0";
          }

          max = "1.0";
        }

        $("#groom-selected-comps-list").css('top', '30.5%');
      }

      $("#groom-selected-comps-list").append(
        `<div class="groom-selected-comps-list-title">${res.label}</div>
				<div class="groom-selected-comps-list-selector">
				  <div class="groom-selected-comps-list-nav-container">
					<button id="groom-selected-comps-list-prev" category ="${res.category}" type ="${res.type}">⟨</button>
					<div id="groom-selected-comps-list-currentNumber" class = "groom-currentNumber-${res.category}-${res.type}" >${current} / ${max}</div>
					<button id="groom-selected-comps-list-next" category ="${res.category}" type ="${res.type}">⟩</button>
				  </div>
				</div>`
      );

    } else if (item.action == 'selectedGroomCategory') {

      let res = item.result;
      $("#groom-selected-title").text(res.title);
      $("#groom-selected-info-text").text(res.description);

      $(".groom-selected-section").fadeIn();

      let margin = res.max > 3 ? 80.1 : 79.9;

      $("#groom-selected-comps-list").css('left', margin + "vw");

      CURRENT_GROOM_CATEGORY_ITEM = res.current_texture_id;
      MAXIMUM_GROOM_CATEGORY_ITEMS = res.max_texture_id;

      CURRENT_GROOM_COLOR_ITEM = res.current_color;
      MAXIMUM_GROOM_COLOR_ITEMS = res.max_colors;

      let opacity = res.current_opacity != 10 ? convertToInt(res.current_opacity) : 10;
      CURRENT_GROOM_OPACITY_ITEM = opacity;

    } else if (item.action == 'selectedEyesCategory') {

      $("#eyes-texture-id-currentNumber").text(item.current + " / " + item.max);

      MAX_OVERLAYS_INFO_EYES_TEXTURE_ID = item.max;

    } else if (item.action == 'updateGroomSpecificData') {

      MAXIMUM_GROOM_COLOR_ITEMS = item.max_colors;
      $(".groom-currentNumber-" + item.category + "-color").text("1 / " + item.max_colors);
      $(".groom-currentNumber-" + item.category + "-opacity").text("1.0 / 1.0");

    } else if (item.action == "close") {
      CloseNUI();
    }

  });

  /* ------------------------------------------------
  ------------------------------------------------ */ 

  $("#main").on("click", "#main-close-button", function () {
    PlayButtonClickSound();
    CloseNUI();
  });

  $("#main").on("click", "#groom-selected-back-button", function () {
    PlayButtonClickSound();

    $(".groom-selected-section").hide();
    $(".main-section").show();

    $.post('http://tpz_barbers/back', JSON.stringify({}));

  });

  $("#main").on("click", "#main-hair-button", function () {
    PlayButtonClickSound();
    $.post('http://tpz_barbers/request_selected_groom_data', JSON.stringify({
      category: 'hair',
      title: 'hair',
    }));

    $(".main-section").fadeOut();

  });

  $("#main").on("click", "#main-hairoverlay-button", function () {
    PlayButtonClickSound();
    $.post('http://tpz_barbers/request_selected_groom_data', JSON.stringify({
      category: 'overlay',
      title: 'overlay',
    }));

    $(".main-section").fadeOut();

  });

  $("#main").on("click", "#main-beard-button", function () {
    PlayButtonClickSound();
    $.post('http://tpz_barbers/request_selected_groom_data', JSON.stringify({
      category: 'beard',
      title: 'beard',
    }));

    $(".main-section").fadeOut();

  });

  $("#main").on("click", "#main-beardstabble-button", function () {
    PlayButtonClickSound();
    $.post('http://tpz_barbers/request_selected_groom_data', JSON.stringify({
      category: 'beardstabble',
      title: 'beardstabble',
    }));

    $(".main-section").fadeOut();

  });
  /* ------------------------------------------------
  ------------------------------------------------ */ 


});
