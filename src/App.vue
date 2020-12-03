<template>
    <div id="hello-world-app">
        <div id="main">
            <div id="title">
                {{msg}}
            </div>
            <div id="convo-manager-div">
                <app-convo-manager ref="appconvomanager" v-bind:callback="convoManagerCallback"></app-convo-manager>
                <div>
                    <input type="button" id="showLoginBtn" v-on:click="toggleLogin" value="Show Login"/>
                </div>
                <div id="login">
                    <div id="loginMsg">
                        {{loginMsg}}
                    </div>
                    <app-login ref="" v-bind:callback="loginCallback"></app-login>
                </div>
            </div>
            <div>
                <div>
                    <input type="text" id="roomFilter" placeholder="Room Name" />
                    <input type="button" id="getConvosBtn" value="Get Conversations" v-on:click="initialize"/>
                </div>
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
    </div>
</template>

<script type="text/javascript">
    import Convos from "./components/Conversation.vue"
    import ConvoParticipants from "./components/ConversationParticipant.vue"
    import ConvoManager from "./components/ConversationManager.vue"
    import Login from "./components/Login.vue"

    export default {
        components: {
            'app-convos': Convos,
            'app-convo-participants': ConvoParticipants,
            'app-convo-manager': ConvoManager,
            'app-login': Login
        },
        data () { 
          return {
            msg: "Conversations",
            message: 'Conversation Participants',
            conversationsListMsg: "Active Conversations",
            loginMsg: "Login",
            result: '',
            responseAvailabe: false,
            convos: [],
            convoParticipants: [],
            fetchingConvos: false,
            convoId: 0,
            convoName: '',
            convoManagerCallback: this.createConversation,
            loginCallback: this.logUserIn
          } // data return object
        },
        methods: {
            initialize() {
                if (!this.fetchingConvos) {
                    this.fetchingConvos = true;
                    var n=document.getElementById("roomFilter").value;
                    if (n.length>0) {
                        this.fetchAPIData("cq_cl&n="+n,this.parseConvoList);
                    }
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
                this.fetchAPIData("cq_cd&idc=" + id + "&n=" + localStorage.clientId, null);
            } // removeConversation
            , fetchConvoParticipants(id,cname){
                this.convoName=cname;
                this.setConvoName();
                this.fetchAPIData("cq_ccl&idc=" + id + "&n=" + localStorage.clientId,this.parseConvoParticipantList);
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
                this.fetchAPIData("cq_ccd&idc=" + id + "&n=" + localStorage.clientId, this.refreshConvoParticipants);
            } // removeConvoParticipant
            , refreshConvoParticipants() {
                this.fetchConvoParticipants(this.convoId,this.convoName);
            } // refreshConvoParticipants
            , createConversation(name) {
                this.fetchAPIData("cq_ca&e=" + name + "&n=" + localStorage.clientId, null);
            } // createConversation
            , joinConversation(id,name,notes,cname) {
                this.convoId=id;
                this.convoName=cname;
                this.setConvoName();
                this.fetchAPIData("cq_cca&idc="+id+"&n="+name+"&no="+notes, this.refreshConvoParticipants);
            } // joinConversation
            , setConvoName(cname) {
                var e=document.getElementById("current-convo");
                if (e!=null) {
                    e.innerText=this.convoName;
                }
            } // setConvoName
            , logUserIn(un,pw) {
                this.fetchAPIData("cq_cu&n="+un+"&no="+pw,this.parseLogin);
            } // logUserIn
            , parseLogin(response) {
                for (var x = 0; x < response.length; x++) {
                    localStorage.clientId = response[x].result;
                    document.getElementById("main").style.display="block";
                    document.getElementById("login").style.display="none";
                    this.initialize();
                }
            } // parseLogin
            , toggleLogin() {
                var e=document.getElementById("login");
                var b=document.getElementById("showLoginBtn");
                if (e.style.display=="none") {
                    e.style.display="block";
                    b.value="Hide Login";
                } else {
                    e.style.display="none";
                    b.value="Show Login";
                }
            } // toggleLogin
        } //methods
        , mounted(){
            if (localStorage.clientId) {
                this.initialize();
            } else {
                document.getElementById("new-convo").style.display="none";
            }
        }, // mounted
    } // export
</script>
<style scoped>
    #title{
        font-size:x-large;
        font-weight:bold;
        text-decoration:underline;
    }
    #convo-manager-div{
        margin-bottom: 10px;
    }
    #convo-list-message-div{
        font-weight:bold;
        font-size: large;
    }
    #loginMsg {
        font-size:x-large;
        font-weight:bold;
        text-decoration: underline;
    }
    #login {
        display:none;
    }
</style>
