;
var admin_ticketSearch_ops = {
    init:function(){
        this.eventBind();
    },
    eventBind:function(){
        $(".wrap_ticketList .search").click(function(){
             $(".wrap_ticketList ").submit();
        });
    }
};


$(document).ready( function(){
    admin_ticketSearch_ops.init();
} );