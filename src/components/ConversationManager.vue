<template>
    <div id="new-convo">
        <h4>New Conversation</h4>
        <div id="new-convo-controls">
            <span id="new-convo-name-label">Name</span>
            <input type="text" id="new-convo-name"/>
            <input type="button" value="Create" v-on:click="createConvo"/>
        </div>
        <div id="new-convo-processing">
        Processing.... please wait
        </div>
    </div>
</template>
<script>
export default {
    props: {
        callback: {
            type: Function,
            required: true
        }
    },
    data(){
        return {

        }
    },
    methods: {
        createConvo() {
            var e = document.getElementById("new-convo-name");
            this.callback(encodeURI(e.value));
            e.value = "";
            document.getElementById("new-convo-processing").style.display="block";
            document.getElementById("new-convo-controls").style.display="none";
        },
        endProcessing() {
            var p = document.getElementById("new-convo-processing");
            var e = document.getElementById("new-convo-controls");
            p.style.display="none";
            e.style.display="inline-block";
        }
    }
}
</script>
<style scoped>
    #new-convo-processing {
        display:none;
    }
</style>