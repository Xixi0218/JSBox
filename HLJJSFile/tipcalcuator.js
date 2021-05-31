$vc.config({
    props: {
        title: '小费计算器',
        rectEdge: $rectEdge.none
    }
})

$ui.render({
    views: [{
            type: "TableView",
            props: {
                bgColor: $color("#f5f5f5")
            },
            layout: {
                flexDirection: "column",
                flex: 1,
                alignItems: "center"
            }
        }]
})

$http.get({
    url: "https://www.v2ex.com/api/topics/hot.json",
    handler: function (resp) {
        $console.log(resp.data[2].node.avatar_large);
        $("aaa").object.src = resp.data[2].node.avatar_large;
    }
})
