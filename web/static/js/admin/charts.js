;
//画图通用组件，虽然估计很难统一，但是总要走出第一步了
var charts_ops = {
    drawLine:function(target,date){
        chart:{
            type:'spline'
        },
        xAxis:{
            categories:date.categories
        },
        series:date.series
        });
    }
};