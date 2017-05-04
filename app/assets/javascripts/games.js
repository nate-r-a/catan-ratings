$(function() {
  $('.arrow').each(function() {
    
    var degrees = -$(this).data("diff") * 100 / 120;
    
    $(this).css("transform", "rotate("+degrees+"deg)");
  });
});

