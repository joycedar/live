;
var user_ticketSearch_ops = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".user_ticketSearch_wrap .search").click(function(){
             $(".user_ticketSearch_wrap ").submit();
        });
    }
};


$(document).ready( function(){
    user_ticketSearch_ops.init();
} );