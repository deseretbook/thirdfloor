// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

window.ready = function () {
  var setMenuHideTimeout = function(){
    return setTimeout(function(){
      if ($('.pure-menu').hasClass('pure-menu-open')) {
        $('.pure-menu').removeClass('pure-menu-open');
        menuLink.show();
      }
    }, 1000);
  };
  
  var menuLink = $('#menu-link');
  var menuHiderId = setMenuHideTimeout();
  
  $('#menu-link').on('click, mouseover', function(eventData) {
    if (!$('.pure-menu').hasClass('pure-menu-open')) {
      menuLink.hide();
      $('.pure-menu').addClass('pure-menu-open');
    }
  });

  $('#menu').on('mouseleave', function(eventData) {
    menuHiderId = setMenuHideTimeout();
  });

  $('#menu').on('mouseenter', function(eventData) {
    clearTimeout(menuHiderId);
  });
};

$(document).on('page:load', window.ready);

$(document).ready(window.ready);
