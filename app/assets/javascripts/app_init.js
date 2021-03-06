$(function(){
  MonkeyApp.init();
});

var MonkeyApp = (function(){

  var _ajaxEvents = function(){
    //desktop forms
    $('#caffeine_form').on('ajax:success', _getCaffeineChart);
    $('#bac_form').on('ajax:success', _getBACChart);
    $('#nicotine_form').on('ajax:success', _getNicotineChart);
    //mobile forms
    $('#s_caffeine_form').on('ajax:success', _getCaffeineChart);
    $('#s_bac_form').on('ajax:success', _getBACChart);
    $('#s_nicotine_form').on('ajax:success', _getNicotineChart);
    //sign in
    $('.signin_form form').on('ajax:success', _authenticate)
    $('.signin_form form').on('ajax:error', _errorMessage)
  }

  var _toggleSignInForm = function(){
    $('.signin_form').toggle();
    if(_mobileUser()){
      LowerNav.toggleNavHeight();
    }
    $('#user_user_name').focus();
  }

  var _toggleAbout = function() {
    event.preventDefault();
    $('#blurb').toggleClass('hidden');
    $('#about').toggleClass('hidden');
  }

  var _clearCookies = function(){
    $.removeCookie('dataObj')
  }

  var _bindEvents = function(){
    $('#lower_nav a').click(function(event){
      LowerNav.toggleForms(event.target)
    });
    $(".arrow").click(LowerNav.toggleNavHeight);
    $('#signin').click(MonkeyApp.toggleSignInForm);
    $('#signout').click(_clearCookies);
    $('#login_form').submit(_clearCookies);
    $(window).resize(_toggleLayout);
    $('#about_button').click(_toggleAbout);
  }

  var _mobileUser = function(){
    return $(document).width() <= 680
  }

  var _cookieCheck = function(){
    $.cookie.json = true;
    if ($.cookie('dataObj') && $('#svg-container').length > 0){
      Chart.render($.cookie('dataObj'));
    }
  }

  var _toggleLayout = function(){
    if(_mobileUser()){
      SignUp.mobileMode();
      LowerNav.mobileMode();
    }
    else
    {
      SignUp.desktopMode();
      LowerNav.desktopMode();
    }
  }

  var _renderChart = function(dataObj){
    $.cookie('dataObj', dataObj);
    Chart.render(dataObj);
    if (_mobileUser()){
      LowerNav.toggleNavHeight();
    }
  }
  var _authenticate = function(event, data){
    window.location.href = '/'
  }

  var _errorMessage = function(event, xhr){
    $('.error_container').html(xhr.responseText);
  }

  var _getBACChart = function(event, data){
    var dataObj = SubstanceDataParser.BACData(data);
    _renderChart(dataObj);
  }

  var _getCaffeineChart = function(event, data){
    var dataObj = SubstanceDataParser.caffeineData(data);
    _renderChart(dataObj);
  }

  var _getNicotineChart = function(event, data){
    var dataObj = SubstanceDataParser.nicotineData(data);
    _renderChart(dataObj);
  }

  return{
    init: function(){
      _toggleLayout();
      _ajaxEvents();
      _bindEvents();
      _cookieCheck();
    },

    toggleSignInForm: function(){
      _toggleSignInForm();
    },
  }
})()