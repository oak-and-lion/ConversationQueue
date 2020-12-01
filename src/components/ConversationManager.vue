<template>
    <div id="new-convo">
        <h4>New Conversation</h4>
        <div>
            <span id="new-convo-name-label">Name</span>
            <input type="text" id="new-convo-name"/>
            <input type="button" value="Create" v-on:click="createConvo"/>
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
            callback(id);
        }
    }
}
</script>