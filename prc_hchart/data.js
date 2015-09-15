var jq = $.noConflict();

jq(function() {
	//Highcharts with mySQL and PHP - Ajax101.com

	var months = [];
	var days = [];
	var switch1 = true;
	jq.get('values.php', function(data) {

		data = data.split('/');
		for (var i in data) {
			if (switch1 == true) {
				months.push(data[i]);
				switch1 = false;
			} else {
				days.push(parseFloat(data[i]));
				switch1 = true;
			}

		}
		months.pop();

		jq('#chart').highcharts({
			chart : {
				type : 'spline'
			},
			title : {
				text : 'Highcharts with mySQL, PHP and AJAX'
			},
			subtitle : {
				text : 'Source: Ajax101.com'
			},
			xAxis : {
				title : {
					text : 'Months'
				},
				categories : months
			},
			yAxis : {
				title : {
					text : 'Days'
				},
				labels : {
					formatter : function() {
						return this.value + 'days'
					}
				}
			},
			tooltip : {
				crosshairs : true,
				shared : true,
				valueSuffix : ''
			},
			plotOptions : {
				spline : {
					marker : {
						radius : 4,
						lineColor : '#666666',
						lineWidth : 1
					}
				}
			},
			series : [{

				name : 'Days',
				data : days
			}]
		});
	});
}); 
