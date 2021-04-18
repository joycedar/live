;
var admin_ticketChange_wrap = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".admin_ticketChange_wrap .save").click(function(){
            var btn_target = $(this);
            if( btn_target.hasClass("disabled") ){
                common_ops.alert("正在处理!!请不要重复提交~~");
                return;
            }

            var id_target = $(".admin_ticketChange_wrap input[name=id]");
            var id = id_target.val();

            var trainId_target = $(".admin_ticketChange_wrap input[name=trainId]");
            var trainId = trainId_target.val();

            var date_target = $(".admin_ticketChange_wrap input[name=date]");
            var date = date_target.val();

            var leaveTime_target = $(".admin_ticketChange_wrap input[name=leaveTime]");
            var leaveTime = leaveTime_target.val();

            var termianl_target = $(".admin_ticketChange_wrap select[name=termianl]");
            var termianl = termianl_target.val();

            var fromStation_target = $(".admin_ticketChange_wrap select[name=fromStation]");
            var fromStation = fromStation_target.val();

            var seatCategory_target = $(".admin_ticketChange_wrap select[name=seatCategory]");
            var seatCategory = seatCategory_target.val();

            if( date.length < 1 ){
                common_ops.tip( "请输入符合规范的日期~~",date_target );
                return false;
            }

            if( trainId.length < 1 ){
                common_ops.tip( "请输入符合规范的车次~~",trainId_target );
                return false;
            }


          if( fromStation.length < 1 ){
                common_ops.tip( "请输入符合规范的发车站~~",fromStation_target );
                return false;
            }

          if( termianl.length < 1 ){
                common_ops.tip( "请输入符合规范的终点站~~",termianl_target );
                return false;
            }

          if( leaveTime.length < 1 ){
                common_ops.tip( "请输入符合规范的日期~~",leaveTime_target );
                return false;
            }

          if( seatCategory.length < 1 ){
                common_ops.tip( "请输入符合规范的座位~~",seatCategory_target );
                return false;
          }


            btn_target.addClass("disabled");

            var data = {
                date:date,
                leaveTime:leaveTime,
                id:id,
                fromStation:fromStation,
                termianl:termianl,
                seatCategory:seatCategory,
                trainId:trainId
            };

            $.ajax({
                url:common_ops.buildUrl( "/admin/ticketChange" ),
                type:'POST',
                data:data,
                dataType:'json',
                success:function( res ){
                    btn_target.removeClass("disabled");
                    var callback = null;
                    if( res.code == 200 ){
                        callback = function(){
                            window.location.href = common_ops.buildUrl("/admin/ticketList");
                        }
                    }
                    common_ops.alert( res.msg,callback );
                }
            });
        });
    }
};

$(document).ready( function(){
    admin_ticketChange_wrap.init();
} );