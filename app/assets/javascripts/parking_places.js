// Parking places jquery

// iCheck js
  $('.icheck-me').on('ifChecked', function(event){
    $(this).attr('value', 'true');
  });
  $('.icheck-me').on('ifUnchecked', function(event){
    $(this).attr('value', 'false');
  });
  $('.icheck-me').iCheck({
    checkboxClass: 'icheckbox_square-orange',
    increaseArea: '30%'
  });

  // For form submit on enter
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });

  // mobile no validation
  $('#txtPhone').blur(function(e) {
    if (validatePhone('txtPhone')) {
      $('#spnPhoneStatus').html('Valid');
      $('#spnPhoneStatus').css('color', 'green');
    }
    else {
      $('#spnPhoneStatus').html('Invalid');
      $('#spnPhoneStatus').css('color', 'red');
    }
  });

  // $('.timepicker').timepicker()
  $('.timepicker').clockpicker({
    autoclose: true,
    placement: "top",
    twelvehour: true
  });

  function validatePhone(txtPhone) {
    var a = document.getElementById(txtPhone).value;
    var filter = /^((\+[1-9]{1,4}[ \-]*)|(\([0-9]{2,3}\)[ \-]*)|([0-9]{2,4})[ \-]*)*?[0-9]{3,4}?[ \-]*[0-9]{3,4}?$/;
    if (filter.test(a)) {
      return true;
    }
    else {
      return false;
    }
  }

  // $(".icheck-me").on('change', function() {
  //   if ($(this).is(':checked')) {
  //     $(this).attr('value', 'true');
  //   } else {
  //     $(this).attr('value', 'false');
  //   }
  // });