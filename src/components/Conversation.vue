<template>
    <div id="convos">
        <ul>
            <li v-for='(convo,id) in convos' :key="id">
                <span :convo-id="convo.id">{{convo.name}}</span>
                <input type="button" v-on:click="showConvo(convo.id)" value="Show"/>
            </li>
        </ul>
    </div>
</template>
<script>
export default {
    props: {
        convos: {
            type: Array,
            required: true
        }
    },
    data(){
        return {

        }
    },
    methods: {
        showConvo(id) {
            console.log(id);
        }
    }
}
</script>