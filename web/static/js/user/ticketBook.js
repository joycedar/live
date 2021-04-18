;
var user_ticketBook_ops = {
    init:function(){
        this.eventBind();
    },

    eventBind:function(){
        $(".user_ticketBook_wrap .buy").click( function(){
            var btn_target = $(this);

            if( btn_target.hasClass("disabled") ){
                common_ops.alert("正在处理!!请不要重复提交~~");
                return;
            }
            var trainId = $(".user_ticketBook_wrap input[name=id]").val();
            var date = $(".user_ticketBook_wrap input[name=date]").val();
            var fromStation = $(".user_ticketBook_wrap input[name=fromStation]").val();
            var terminal = $(".user_ticketBook_wrap input[name=terminal]").val();
            var identification = $(".user_ticketBook_wrap input[name=identification]").val();
            var name = $(".user_ticketBook_wrap input[name=name]").val();
            var phone = $(".user_ticketBook_wrap input[name=phone]").val();
            var seatCategory = $(".user_ticketBook_wrap select[name=seatCategory]").val();
            var category = $(".user_ticketBook_wrap input[name=category]").val();
            var leaveTime  = $(".user_ticketBook_wrap input[name=leaveTime]").val();

            if( trainId == undefined || trainId.length < 1){
                common_ops.alert( "请选择正确的座位类型~~" );
                return;
            }

            if( date == undefined || date.length < 1){
                common_ops.alert( "请选择正确的日期" );
                return;
            }

            if( fromStation == undefined || fromStation.length < 1){
                common_ops.alert( "请选择正确的始发站" );
                return;
            }
            if( terminal == undefined || terminal.length < 1){
                common_ops.alert( "请选择终点站" );
                return;
            }
            if( identification == undefined || identification.length < 1){
                common_ops.alert( "请输入符合规范的身份证" );
                return;
            }
            if( category == undefined || category.length < 1){
                common_ops.alert( "请选择火车类型" );
                return;
            }
            if( seatCategory == undefined || seatCategory.length < 1){
                common_ops.alert( "请选择座位类型" );
                return;
            }
            if( name == undefined || name.length < 1){
                common_ops.alert( "请输入正确的名字" );
                return;
            }
            if( phone == undefined || phone.length < 1){
                common_ops.alert( "请输入正确的电话" );
                return;
            }

            btn_target.addClass("disabled");

            $.ajax({
                url:common_ops.buildUrl("/user/ticketBook"),
                type:'POST',
                data:{
                        'trainId':trainId,
                        'date':date,
                        'fromStation':fromStation,
                        'terminal':terminal,
                        'identification':identification,
                        'name':name,
                        'phone':phone,
                        'seatCategory':seatCategory,
                        'category':category,
                        'leaveTime':leaveTime
                },
                dataType:'json',
                success:function(res){
                    btn_target.removeClass("disabled");
                    var callback = null;
                    if( res.code == 200 ){
                        callback = function(){
                            window.location.href = common_ops.buildUrl("/user/ticketOps");
                        }
                    }
                    common_ops.alert( res.msg,callback );
                }
            });
        });
    }
}//var user_login_ops

$(document).ready( function(){
    user_ticketBook_ops.init();
} );