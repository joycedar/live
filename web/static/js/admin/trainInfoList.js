;
var admin_ticketSearch_ops = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".train_Info_wrap_search .search").click(function(){
             $(".train_Info_wrap_search ").submit();
        });
    }
};


$(document).ready( function(){
    admin_ticketSearch_ops.init();
} );