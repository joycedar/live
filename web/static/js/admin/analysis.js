;
var dashboard_index_ops = {
    init:function(){
        this.drawChart();
    },
    drawChart:function(){
        charts_ops.setOption();
        $.ajax({
            url:common_ops.buildUrl("/admin/analysis/station"),
            dataType:'json',
            success:function( res ){
                charts_ops.drawLine( $('#station'),res.data )
            }
        });

        $.ajax({
            url:common_ops.buildUrl("/admin/analysis/trainId"),
            dataType:'json',
            success:function( res ){
                charts_ops.drawLine( $('#trainId'),res.data )
            }
        });

        $.ajax({
            url:common_ops.buildUrl("/admin/analysis/date"),
            dataType:'json',
            success:function( res ){
                charts_ops.drawLine( $('#date'),res.data )
            }
        });
    }
};

$(document).ready( function(){
    dashboard_index_ops.init();
});