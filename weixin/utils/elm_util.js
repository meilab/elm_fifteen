var elmApp = require('../elm.js').WxMain.worker();
var R = require('../vendor/ramda.min.js');
let currentListeners = [];
let nextListeners = currentListeners;

let init = () => {
    elmApp.ports.modelOut.subscribe((model) => {
        let listeners = currentListeners = nextListeners;

        listeners.map((listener) => {
            listener(model);
        })
    })
}

let subscribe = (listener) => {
    if(typeof listener !== 'function') {
        throw new Error ('Expected Listener to be a function.')
    }
    let isSubscribed = true;
    nextListeners = R.append(listener, currentListeners);

    return function unsubscribe() {
        if ( !isSubscribed ) {
            return
        }

        isSubscribed = false;

        nextListeners = R.without([listener], currentListeners);
    }
}

let sendMsg = (msg) => {
    console.log(msg);
    elmApp.ports.messagesIn.send(msg);
}

module.exports = {
    init,
    subscribe,
    sendMsg
}
