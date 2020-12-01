<template>
    <div id="hello-world-app">
        {{msg}}
        <div>
            <app-convos v-bind:convos="convos"></app-convos>
        </div>
        {{message}}
        <div>
            <app-convo-participants v-bind:convoParticipants="convoParticipants"></app-convo-participants>
        </div>
    </div>
</template>

<script type="text/javascript">
    import Convos from "./components/Conversation.vue"
    import ConvoParticipants from "./components/ConversationParticipant.vue"

    export default {
        components: {
            'app-convos': Convos,
            'app-convo-participants': ConvoParticipants
        },
        data () { 
          return {
            msg: "Conversations",
            message: 'Conversation Participants',
            result: '',
            responseAvailabe: false,
            convos: [],
            convoParticipants: [],
            fetchingConvos: false
          } // data return object
        },
        methods: {
            initialize() {
                if (!this.fetchingConvos) {
                    this.fetchingConvos = true;
                    this.fetchAPIData("cq_cl",this.parseConvoList);
                }
            }, // initialize
            fetchAPIData(func,callback) {
                this.responseAvailable = false;
                fetch("https://childsheartyoga.com/api.aspx?pf=" + func, {
                    "method": "GET",
                    "headers": {
                    }
                })
                .then(response => { 
                    if(response.ok){
                        return response.json();    
                    } else{
                        alert("Server returned " + response.status + " : " + response.statusText);
                    }
                })
                .then(response => {
                    if (callback != null && callback != undefined) {
                        callback(response);
                        this.responseAvailable = true;
                    }
                })
                .catch(err => {
                    console.log(err);
                })
            } //fetchAPIData
            ,parseConvoList(response) {
                this.result = "";
                var l = this.convos.length;
                for (var x = 0; x < l; x++) {
                    this.convos.pop();
                }
                for (var x = 0; x < response.length; x++) {
                    var temp = response[x].result.split("_~_");
                    this.convos.push({
                        id: temp[0],
                        name: temp[1],
                        callback: this.fetchConvoParticipants,
                        callback2: this.removeConversation
                    });
                    this.result += temp[0] + "," + temp[1] + "~";
                }
                this.fetchingConvos = false;                
                setTimeout(()=>{this.initialize()},5000);
            } // parseConvoList
            , removeConversation(id) {
                this.fetchAPIData("cq_cd&idc=" + id, null);
            } // removeConversation
            , fetchConvoParticipants(id){
                this.fetchAPIData("cq_ccl&idc=" + id,this.parseConvoParticipantList);
            } // fetchConvoParticipants
            , parseConvoParticipantList(response) {
                var l = this.convoParticipants.length;
                for (var x = 0; x < l; x++) {
                    this.convoParticipants.pop();
                }
                for(var x=0;x<response.length;x++) {
                    var temp=response[x].result.split("_~_");
                    this.convoParticipants.push({
                        id: temp[0],
                        name: temp[1],
                        callback: this.removeConvoParticipant,
                        note: temp[2],
                        convoId: temp[3]
                    });
                }
            } // parseConvoParticipantList
            , removeConvoParticipant(id,cid) {
                //this.fetchAPIData("cq_ccd&idc=" + id, this.fetchConvoParticipants(cid));
            } // removeConvoParticipant
        } //methods
        , mounted(){
            this.initialize();
        }, // mounted
    } // export
</script>
