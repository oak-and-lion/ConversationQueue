<template>
    <div id="hello-world-app">
        {{msg}}
        <div>
            <app-convos v-bind:convos="convos"></app-convos>
        </div>
    </div>
</template>

<script type="text/javascript">
    import Convos from "./components/Conversation.vue"
    export default {
        components: {
            'app-convos': Convos
        },
        data () { 
          return {
            msg: "Conversations",
            message: '',
            result: '',
            responseAvailabe: false,
            convos: []
          } // data return object
        },
        methods: {
            initialize() {
                this.fetchAPIData("cq_cl",this.parseConvoList);
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
                    callback(response);
                    this.responseAvailable = true;
                })
                .catch(err => {
                    console.log(err);
                })
            } //fetchAPIData
            ,parseConvoList(response) {
                this.result = "";
                for (var x = 0; x < response.length; x++) {
                    var temp = response[x].result.split("_~_");
                    this.convos.push({
                        id: temp[0],
                        name: temp[1]
                    });
                    this.result += temp[0] + "," + temp[1] + "~";
                }
            } // parseConvoList
        } //methods
        , mounted(){
            this.initialize();
        }, // mounted
    } // export
</script>
