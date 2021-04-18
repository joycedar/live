;
var user_register_ops = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".user_register_wrap .save").click(function(){
            var btn_target = $(this);
            if( btn_target.hasClass("disabled") ){
                common_ops.alert("正在处理!!请不要重复提交~~");
                return;
            }

            var name_target = $(".user_register_wrap input[name=name]");
            var name = name_target.val();

            var identification_target = $(".user_register_wrap input[name=identification]");
            var identification = identification_target.val();

            var minor_target = $(".user_register_wrap input[name=minor]");
            var minor = minor_target.val();

            var address_target = $(".user_register_wrap input[name=address]");
            var address = address_target.val();


            var mobile_target = $(".user_register_wrap input[name=mobile]");
            var mobile = mobile_target.val();

            var email_target = $(".user_register_wrap input[name=email]");
            var email = email_target.val();

            var name_target = $(".user_register_wrap input[name=name]");
            var name = name_target.val();

            var password_target = $(".user_register_wrap input[name=password]");
            var password = password_target.val();

            if( name.length < 1 ){
                common_ops.tip( "请输入符合规范的姓名~~",name_target );
                return false;
            }


            if(  email.length < 1 ){
                common_ops.tip( "请输入符合规范的邮箱~~",email_target );
                return false;
            }

            if( minor.length < 1 ){
                common_ops.tip( "请输入符合规范的民族~~",minor_target );
                return false;
            }

            if( password.length < 6 ){
                common_ops.tip( "请输入符合规范的登录密码~~",password_target );
                return false;
            }

            if( mobile.length < 1 ){
                common_ops.tip( "请输入符合规范的手机号码~~",mobile_target );
                return false;
            }

           if( identification.length < 1 ){
                common_ops.tip( "请输入符合规范的手机号码~~",identification_target );
                return false;
            }


            btn_target.addClass("disabled");

            var data = {
                name: name,
                identification:identification,
                phone: mobile,
                email: email,
                password:password,
                minor:minor,
                address:address
            };

            $.ajax({
                url:common_ops.buildUrl( "/user/register" ),
                type:'POST',
                data:data,
                dataType:'json',
                success:function( res ){
                    btn_target.removeClass("disabled");
                    var callback = null;
                    if( res.code == 200 ){
                        callback = function(){
                            window.location.href = common_ops.buildUrl("/login");
                        }
                    }
                    common_ops.alert( res.msg,callback );
                }
            });


        });
    }
};

$(document).ready( function(){
    user_register_ops.init();
} );