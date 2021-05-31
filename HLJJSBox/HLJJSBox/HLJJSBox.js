var gloabl = this
;(function() {
    gloabl.$console = {
        log: function(data) {
            oc_log(data);
        }
    };

    _customMethods = {
        // 布局里的关系
        __lp : function(prop) {
            return oc_LayoutProperty(this,prop);
        },
        // 布局里的方法
        __lr : function(methodName) {
            var slf = this;
            return function() {
                var args = Array.prototype.slice.call(arguments);
                return oc_LayoutRelation(slf,methodName,args[0]);
            };
        },
    }
    
    for (var method in _customMethods) {
        if (_customMethods.hasOwnProperty(method)) {
            Object.defineProperty(Object.prototype, method, {value: _customMethods[method], configurable:false, enumerable: false})
        }
    }

    gloabl.$ui = {
        render: function(data) {
            oc_ui('render', data);
        },
        push: function(data) {
            oc_ui('psuh', data);
        },
        alert: function(data) {
            oc_ui('alert', data);
        },
        loading: function(data) {
            oc_ui('loading', data);
        }
    };
})()