;
var admin_trianInfoChange_wrap = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".admin_trianInfoChange_wrap .save").click(function(){
            var btn_target = $(this);
            if( btn_target.hasClass("disabled") ){
                common_ops.alert("正在处理!!请不要重复提交~~");
                return;
            }
            var id_target = $(".admin_trianInfoChange_wrap input[name=id]");
            var id = id_target.val();

            var category_target = $(".admin_trianInfoChange_wrap select[name=category]");
            var category = category_target.val();
            console.log(category)

            var date_target = $(".admin_trianInfoChange_wrap input[name=date]");
            var date = date_target.val();


            var leaveTime_target = $(".admin_trianInfoChange_wrap input[name=leaveTime]");
            var leaveTime = leaveTime_target.val();

            var address_target = $(".admin_trianInfoChange_wrap input[name=address]");
            var address = address_target.val();

            var fromStation_target = $(".admin_trianInfoChange_wrap select[name=fromStation]");
            var fromStation = fromStation_target.val();

            var terminal_target = $(".admin_trianInfoChange_wrap select[name=terminal]");
            var terminal = terminal_target.val();

            var firstClassSeat_target = $(".admin_trianInfoChange_wrap input[name=firstClassSeat]");
            var firstClassSeat = firstClassSeat_target.val();

            var secondClassSeat_target = $(".admin_trianInfoChange_wrap input[name=secondClassSeat]");
            var secondClassSeat = secondClassSeat_target.val();

            var softSeat_target = $(".admin_trianInfoChange_wrap input[name=softSeat]");
            var softSeat = softSeat_target.val();

            var hardSeat_target = $(".admin_trianInfoChange_wrap input[name=hardSeat]");
            var hardSeat = hardSeat_target.val();


            var restFirstClassSeat_target = $(".admin_trianInfoChange_wrap input[name=restFirstClassSeat]");
            var restFirstClassSeat = restFirstClassSeat_target.val();

            var restSecondClassSeat_target = $(".admin_trianInfoChange_wrap input[name=restSecondClassSeat]");
            var restSecondClassSeat = restSecondClassSeat_target.val();

            var restSoftSeat_target = $(".admin_trianInfoChange_wrap input[name=restSoftSeat]");
            var restSoftSeat = restSoftSeat_target.val();

            var restHardSeat_target = $(".admin_trianInfoChange_wrap input[name=restHardSeat]");
            var restHardSeat = restHardSeat_target.val();


            if( firstClassSeat.length < 1 ){
                common_ops.tip( "请输入符合规范的一等座数量~~",firstClassSeat_target );
                return false;
            }


            btn_target.addClass("disabled");

            var data = {
                id:id,
                category:category,
                leaveTime: leaveTime,
                fromStation: fromStation,
                terminal:terminal,
                firstClassSeat:firstClassSeat,
                secondClassSeat:secondClassSeat,
                hardSeat:hardSeat,
                softSeat:20,
                restFirstClassSeat:restFirstClassSeat,
                restSecondClassSeat:restSecondClassSeat,
                restHardSeat:restHardSeat,
                restSoftSeat:restSoftSeat,
                date:date
            };

            $.ajax({
                url:common_ops.buildUrl( "/admin/trainInfoChange" ),
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
    admin_trianInfoChange_wrap.init();
} );