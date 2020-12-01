<template>
    <div id="hello-world-app">
        {{msg}}
        <div id="convo-manager-div">
            <app-convo-manager ref="appconvomanager" v-bind:callback="convoManagerCallback"></app-convo-manager>
        </div>
        <div>
            <div id="convo-list-message-div">
                {{conversationsListMsg}}
            </div>
            <app-convos ref="appconvolist" v-bind:convos="convos"></app-convos>
        </div>
        <div>
            <span id="convo-participant-message">{{message}}</span> <span id="current-convo"></span>
        </div>
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
            convoName: '',
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
                        callback2: this.removeConversation,
                        callback3: this.joinConversation
                    });
                    this.result += temp[0] + "," + temp[1] + "~";
                }
                this.fetchingConvos = false;
                this.$refs.appconvomanager.endProcessing();
                this.$refs.appconvolist.resetList();
                setTimeout(()=>{this.initialize()},5000);
            } // parseConvoList
            , removeConversation(id) {
                this.fetchAPIData("cq_cd&idc=" + id, null);
            } // removeConversation
            , fetchConvoParticipants(id,cname){
                this.setConvoName(cname);
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
                this.fetchConvoParticipants(this.convoId,this.convoName);
            } // refreshConvoParticipants
            , createConversation(name) {
                this.fetchAPIData("cq_ca&e=" + name, null);
            } // createConversation
            , joinConversation(id,name,notes,cname) {
                this.setConvoName(cname);
                this.convoId=id;
                this.convoName=cname;
                this.fetchAPIData("cq_cca&idc="+id+"&n="+name+"&no="+notes, this.refreshConvoParticipants);
            } // joinConversation
            , setConvoName(cname) {
                var e=document.getElementById("current-convo");
                if (e!=null) {
                    e.innerText=cname;
                }
            }
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
