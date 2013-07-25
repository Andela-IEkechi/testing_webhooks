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
});
