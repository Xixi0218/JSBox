var global = this;
(function () {

    // 获取当前id对应的view
    global.$ = function (id) {
        return oc_id_map_view(id);
    };

    // 定义常数
    global.$align = {
        left: 0,
        center: 1,
        right: 2,
        justified: 3,
        natural: 4
    };

    global.$contentMode = {
        scaleToFill: 0,
        scaleAspectFit: 1,
        scaleAspectFill: 2,
        redraw: 3,
        center: 4,
        top: 5,
        bottom: 6,
        left: 7,
        right: 8,
    };

    global.$btnType = {
        custom: 0,
        system: 1,
        disclosure: 2,
        infoLight: 3,
        infoDark: 4,
        contactAdd: 5,
    };
    
    global.$edge = {
        none: 0,
        top: 1 << 0,
        left: 1 << 1,
        bottom: 1 << 2,
        right: 1 << 3,
    };
    
    global.$rectEdge = {
        none: $edge.none,
        top: $edge.top,
        left: $edge.left,
        bottom: $edge.bottom,
        right: $edge.right,
        all: ($edge.top|$edge.left|$edge.bottom|$edge.right)
    };
    
    global.$listStyle = {
        plain: 0,
        grouped: 1,
        insetGrouped: 2,
    };
    
    global.$selectStyle = {
        none: 0,
        blue: 1,
        gray: 2,
        defaultStyle: 3
    };

    global.$scrollDirection = {
        vertical: 0,
        horizontal: 1
    };
    
    global.$font = function(v1,v2) {
        return oc_font(v1,v2);
    };
    
    global.$color = function(color,alpha) {
        if (alpha == undefined) {
             return oc_color(color,1);
        } else {
             return oc_color(color,alpha);
        }
    };
    
    // 打印
    global.$console = {
        log: function (data) {
            oc_log(data);
        }
    };
    
    // 网络请求
    global.$http = {
        request : function(data){
            oc_request(data);
        },
        get : function(data) {
            data.method = 'GET';
            oc_request(data);
        },
        post : function(data) {
            data.method = 'POST';
            oc_request(data);
        },
    };
    
    // 添加方法
    global.addJsProperty = function(name,property) {
      Object.defineProperty(Object.prototype,name, {value: property});
    }

    // ui展示
    global.$ui = {
        render: function (data) {
            oc_ui('render', data);
        },
        push: function (data) {
            oc_ui('push', data);
        },
        alert: function (data) {
            oc_ui('alert', data);
        },
        loading: function (data) {
            oc_ui('loading', data);
        }
    };
    
    // vc配置
    global.$vc = {
        config: function (data) {
            vc_config('config', data)
        }
    }
    
})()



