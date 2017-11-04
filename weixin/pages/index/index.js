//index.js
var elm_util = require('../../utils/elm_util.js')
//获取应用实例
var app = getApp()
Page({
  data: {
    motto: 'Hello World',
    userInfo: {},
    password: ""
  },
  //事件处理函数
  bindViewTap: function() {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
    onPhraseInput: function(e) {
        elm_util.sendMsg(["PhraseInput", e.detail.value])
    },
    onServiceInput: function(e) {
        elm_util.sendMsg(["ServiceInput", e.detail.value])
    },
    onPwLengthInput: function(e) {
        elm_util.sendMsg(["PwLengthInput", e.detail.value])
    },
    onPwModeChange: function(e) {
        elm_util.sendMsg(["PwModeChange", e.detail.value])
    },
    onStateChange: function(newState) {
        this.setData({ password: newState })
    },
  onLoad: function () {
    console.log('onLoad')
    elm_util.subscribe(this.onStateChange);
    var that = this
    //调用应用实例的方法获取全局数据
    app.getUserInfo((userInfo) => {
        that.setData({
            userInfo
        })
    })
  }
})
