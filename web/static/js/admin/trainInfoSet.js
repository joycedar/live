;
var admin_trainInfo_wrap = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".admin_trainInfo_wrap .save").click(function(){
            var btn_target = $(this);
            if( btn_target.hasClass("disabled") ){
                common_ops.alert("正在处理!!请不要重复提交~~");
                return;
            }

            var trainId_target = $(".admin_trainInfo_wrap input[name=trainId]");
            var trainId = trainId_target.val();

            var category_target = $(".admin_trainInfo_wrap select[name=category]");
            var category = category_target.val();

            var date_target = $(".admin_trainInfo_wrap input[name=date]");
            var date = date_target.val();

            var leaveTime_target = $(".admin_trainInfo_wrap input[name=leaveTime]");
            var leaveTime = leaveTime_target.val();

            var fromStation_target = $(".admin_trainInfo_wrap select[name=fromStation]");
            var fromStation = fromStation_target.val();

            var terminal_target = $(".admin_trainInfo_wrap select[name=terminal]");
            var terminal = terminal_target.val();

            var firstClassSeat_target = $(".admin_trainInfo_wrap input[name=firstClassSeat]");
            var firstClassSeat = firstClassSeat_target.val();

            var secondClassSeat_target = $(".admin_trainInfo_wrap input[name=secondClassSeat]");
            var secondClassSeat = secondClassSeat_target.val();

            var softSeat_target = $(".admin_trainInfo_wrap input[name=softSeat]");
            var softSeat = softSeat_target.val();


            var hardSeat_target = $(".admin_trainInfo_wrap input[name=hardSeat]");
            var hardSeat = hardSeat_target.val();


            if( trainId.length < 1 ){
                common_ops.tip( "请输入符合规范的车次~~",trainId_target );
                return false;
            }


            if( fromStation.length < 1 ){
                common_ops.tip( "请输入符合规范的出发站~~",fromStation_target );
                return false;
            }

            if( firstClassSeat.length < 1 ){
                common_ops.tip( "请输入符合规范的一等座数量~~",firstClassSeat_target );
                return false;
            }


            if( secondClassSeat.length < 1 ){
                common_ops.tip( "请输入符合规范的二等座数量~~",secondClassSeat_target );
                return false;
            }

            if( softSeat.length < 1 ){
                common_ops.tip( "请输入符合规范的软卧~~",softSeat_target );
                return false;
            }

            if( hardSeat.length < 1 ){
                common_ops.tip( "请输入符合规范的硬卧~~",hardSeat_target );
                return false;
            }



            btn_target.addClass("disabled");

            var data = {
                trainId: trainId,
                category:category,
                leaveTime: leaveTime,
                fromStation: fromStation,
                terminal:terminal,
                firstClassSeat:firstClassSeat,
                secondClassSeat:secondClassSeat,
                hardSeat:hardSeat,
                softSeat:softSeat,
                date:date
            };

            $.ajax({
                url:common_ops.buildUrl( "/admin/trainInfoSet" ),
                type:'POST',
                data:data,
                dataType:'json',
                success:function( res ){
                    btn_target.removeClass("disabled");
                    var callback = null;
                    if( res.code == 200 ){
                        callback = function(){
                            window.location.href = common_ops.buildUrl("/admin/trainInfoList");
                        }
                    }
                    common_ops.alert( res.msg,callback );
                }
            });
        });
    }
};

$(document).ready( function(){
    admin_trainInfo_wrap.init();
} );