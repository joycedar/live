;
var admin_presentAdd_wrap = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".admin_presentAdd_wrap .save").click(function(){
            var btn_target = $(this);
            if( btn_target.hasClass("disabled") ){
                common_ops.alert("正在处理!!请不要重复提交~~");
                return;
            }

            var presentId_target = $(".admin_presentAdd_wrap input[name=presentId]");
            var presentId = presentId_target.val();

            var presentName_target = $(".admin_presentAdd_wrap input[name=presentName]");
            var presentName = presentName_target.val();

            var money_target = $(".admin_presentAdd_wrap select[name=moneyCategory]");
            var money = money_target.val();



            if( presentName_target.length < 1 ){
                common_ops.tip( "请输入符合规范的名字",presentName_target );
                return false;
            }

            if( money_target.length < 1 ){
                common_ops.tip( "请输入符合规范的金钱数量",money_target );
                return false;
            }

            btn_target.addClass("disabled");

            var data = {
                money:money,
                presentName:presentName,
                presentId:presentId
            };

            $.ajax({
                url:common_ops.buildUrl( "/admin/presentAdd" ),
                type:'POST',
                data:data,
                dataType:'json',
                success:function( res ){
                    btn_target.removeClass("disabled");
                    var callback = null;
                    if( res.code == 200 ){
                        callback = function(){
                            window.location.href = common_ops.buildUrl("/admin/presentList");
                        }
                    }
                    common_ops.alert( res.msg,callback );
                }
            });
        });
    }
};

$(document).ready( function(){
    admin_presentAdd_wrap.init();
} );