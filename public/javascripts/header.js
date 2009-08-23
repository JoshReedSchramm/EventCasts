$(document).ready(function() {
	var pop_up_active = false;
	$('a#my_groups_header_link').cluetip({
		sticky: true, 
		closePosition: 'title',
		arrows: false,
		dropShadow: false,
		positionBy: 'bottomTop',
		fx: {
			open: 'fadeIn',
			openSpeed: ''
		},
		topOffset: 25,
		leftOffset: 20,
		activation: 'click'
	});
});