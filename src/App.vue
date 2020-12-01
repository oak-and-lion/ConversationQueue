<template>
    <div id="hello-world-app">
        {{msg}}
        <div id="convo-manager-div">
            <app-convo-manager v-bind:callback="convoManagerCallback"></app-convo-manager>
        </div>
        <div>
            <div id="convo-list-message-div">
                {{conversationsListMsg}}
            </div>
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
    import ConvoManager from "./components/ConversationManager.vue"

    export default {
        components: {
            'app-convos': Convos,
            'app-convo-participants': ConvoParticipants,
            'app-convo-manager': ConvoManager
        },
        data () { 
          return {
            msg: "Conversations",
            message: 'Conversation Participants',
            conversationsListMsg: "Active Conversations",
            result: '',
            responseAvailabe: false,
            convos: [],
            convoParticipants: [],
            fetchingConvos: false,
            convoId: 0,
            convoManagerCallback: this.createConversation
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
                this.convoId = cid;
                this.fetchAPIData("cq_ccd&idc=" + id, this.refreshConvoParticipants);
            } // removeConvoParticipant
            , refreshConvoParticipants() {
                this.fetchConvoParticipants(this.convoId);
            } // refreshConvoParticipants
            , createConversation() {
                this.fetchAPIData("cq_cc", null);
            } // createConversation
        } //methods
        , mounted(){
            this.initialize();
        }, // mounted
    } // export
</script>
<style scoped>
    #convo-manager-div{
        margin-bottom: 10px;
    }
    #convo-list-message-div{
        font-weight:bold;
        font-size: large;
    }
</style>
