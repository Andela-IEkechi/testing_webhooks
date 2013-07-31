
$(function() {
	$( "#sortable-states" ).sortable({
			placeholder: "well well-small alert alert-info"
		  }
		);	
		// to cater for adding/sorting/removing of inner elements
	  	$("#sortable-states").on("DOMSubtreeModified", function(event){
	  		if($(event.target).is("div#sortable-states")){
	  		  adjustStatesSortableIndexes();
	  		}	  	   
	    });
	});
    
    function adjustStatesSortableIndexes(){
		$("#sortable-states .ui-state-default [data-sort-index]").each(function(index, element){
			$(element).val(index * 1000 );
		})
    }