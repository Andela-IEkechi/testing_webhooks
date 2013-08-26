$(function(){
	$(document).on('submit', "form[data-confirm-with]", function(e){
		var elementsToCheck=$(this).attr('data-confirm-input-selectors');
		var mustConfirm = false;
		$(this).find(elementsToCheck).each(function(index, element){
			if ($(element).val() == "" || $(element).val() == null){
				mustConfirm = true;				
			}
		})
		if(mustConfirm && !confirm($(this).attr('data-confirm-with'))){
			return false;
		}
	});

	$(document).on('click', "[data-toggle]", function(e){
		var elementsToToggle=$(this).attr('data-toggle');
		if($(this).html() == $(this).attr('data-shown')){
			$(elementsToToggle).hide();
			$(this).html($(this).attr('data-hidden'))
		}else{
			$(elementsToToggle).show();
			$(this).html($(this).attr('data-shown'))
		}		
	});

	
});
