const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

var currentServeId = -1;
var wsList = {}

function getOnServeId(){
    currentServeId = currentServeId + 1; 
    return currentServeId;
}




wss.on('connection', function connection(ws) {
    
    var onServeId = getOnServeId();
    var oponente = null;
    var battle_read = false;
    var playerData;
    var server_master = false
    wsList[onServeId] = ws;

    console.log('Cliente '+ onServeId +' se conectou');
    
    
    freeMach(ws)    
    
    ws.on('message', function incoming(message) {
        
        tratarJson(ws,JSON.parse(message));
        
    });

    ws.on('close', function close() {

        if(ws.oponente != undefined){
            //ws.oponente.send(preFabJason('dc', ws.onServeId));
            ws.oponente.oponente=null
        }
        
        console.log('Cliente '+ onServeId +' se desconectou');

    });
    
});


function freeMach(ws){

    wss.clients.forEach(function each(valor) {
        if (valor != ws  && valor.oponente == null){
            ws.oponente = valor;
            valor.oponente = ws;
            ws.server_master = true;
            ws.send(preFabJason("start","P1"))
            ws.oponente.send(preFabJason("start","P2"))
            console.log("Partida encotrada!");
            return;
        }
    
    })

}

function update(){
    
}

function preFabJason(type,msg='',data=''){
    var json = {
        type:type,
        msg:msg,
        data:data
    };
    return JSON.stringify(json)

}

function tratarJson(ws,m){

    switch(m.type) {
        case "close":
            process.exit()
        case "update":
            playerData = m.data;
            if(ws.oponente != null){
                ws.oponente.send(preFabJason('update','', playerData));
            }
            break;
        
        default:

    } 

}
