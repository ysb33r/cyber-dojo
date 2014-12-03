/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.pieChart = function(nodes) {
    // Chart.js http://www.chartjs.org/docs/
    var options = {
      segmentShowStroke : true,
      segmentStrokeWidth: 1,
      segmentStrokeColor : '#757575',
      animationEasing : 'easeOutExpo'
    };
    var plural = function(n,word) {
      return "" + n + " " + word + (n == 1 ? "" : "s");
    }
    nodes.each(function() {
      var self = $(this);
      var count = function(of) {
        return self.data(of + '-count');
      };
      var   redCount = count('red');
      var amberCount = count('amber');
      var greenCount = count('green');
      var timedOutCount = count('timed-out');

      var title = "" +
        plural(redCount,   'red') + ', ' +
        plural(amberCount, 'amber') + ', ' +
        plural(greenCount, 'green') + ', ' +
        plural(timedOutCount, 'timeout');
      $(this).closest('td').prop('title', title);

      var data = [
          { value:   redCount, color: '#F00' },
          { value: amberCount+timedOutCount, color: '#FC3' },
          { value: greenCount, color: '#0F0' },
      ];

      var ctx = $(this)[0].getContext('2d');
      var key = $(this).data('key');
      var totalCount = redCount + amberCount + greenCount + timedOutCount;
      var animation = ($.data(document.body, key) != totalCount);
      options['animation'] = animation;
      new Chart(ctx).Pie(data,options);
      $.data(document.body, key, totalCount);
      if (timedOutCount > 0) {
        $('#timed-out-total').html(plural(timedOutCount, 'time out'));
      }
    });
  };

  return cd;
})(cyberDojo || {}, $);
