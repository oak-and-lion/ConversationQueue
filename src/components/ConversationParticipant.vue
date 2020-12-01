<template>
    <div id="convo-participants">
        <ul>
            <li v-for='(convo,id) in convoParticipants' :key="id">
                <span :convo-id="convo.id">{{convo.name}}</span>
                <span>Note:</span> <span>{{convo.note}}</span>
                <input type="button" v-on:click="resolve(convo.id,convo.callback,convo.convoId)" value="Resolve"/>
            </li>
        </ul>
    </div>
</template>
<script>
export default {
    props: {
        convoParticipants: {
            type: Array,
            required: true
        }
    },
    data(){
        return {

        }
    },
    methods: {
        resolve(id,callback,cid) {
            callback(id,cid);
        }
    }
}
</script>