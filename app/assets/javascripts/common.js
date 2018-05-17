/**
 * Created by crystal on 7/11/17.
 */

//判断变量是否存在，不是一个空对象，或者未定义，或者不等于空字符串
function isPresent(obj) {
    return (obj != null && obj != undefined && obj != '')
}

//判断变量是不是一个空对象，或者未定义，或者空字符串
function isBlank(obj) {
    return (obj == null || obj == undefined || obj == '')
}


//初始化日期控件
function initDateFields(dateField,format,minView,maxView) {
    var me = $(dateField);
    var startView = 2;
    var options = {format: format, todayBtn: "linked", language: "zh-CN", minView: minView,maxView: maxView,autoclose: true, startView: startView, bootcssVer: 3};
    me.datetimepicker(options).datetimepicker('show');
    if (me.attr("id") == "start") {
        me.datetimepicker("setEndDate", $("#end").val());
    }
    else if (me.attr("id") == "end") {
        me.datetimepicker("setStartDate", $("#start").val());
    }
}


$(function () {

    $('a[rel=modal]').on('click', function(e){
        e.preventDefault();
        var href = $(this).attr('href');
        openModal(href);
    });

});


function openModal(href) {
    // var modalTitle = $.i18n("loading"),
    var modalTitle = "loading",
        modalDialog = $("#linkModal");
    if (modalDialog.length == 0) {
        modalDialog = buildModal();
        $('body').append(modalDialog);
    } else {
        $(".modal-footer", modalDialog).html("");
    }
    $(".modal-header h3", modalDialog).text(modalTitle);
    modalDialog.modal('show');
    //服务器加载数据需要时间，一闪而过体验不好
    modalDialog.html('');
    if (href.indexOf('#') == 0) {
        modalDialog.html($(href).html())
    } else {
        href += href.indexOf("?") > 0 ? "&_dom_id=null" : "?_dom_id=null #exampleModal";
        modalDialog.load(href, function () {
            $('form', modalDialog).each(function () {
                var $form = $(this),
                    $action = $form.attr("action");
                if ($action) {
                    $action += $action.indexOf("?") > 0 ? "&_dom_id=linkModal" : "?_dom_id=linkModal";
                }
                $form.data("remote", true);
                $form.attr("action", $action);
            });
        });
    }
}


function buildModal() {
    return $('<div id="linkModal"></div>' );
}