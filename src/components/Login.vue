<template>
    <div id="new-login">
        <div>
            <input type="text" id="loginname" placeholder="Login Name"/>
        </div>
        <div>
            <input type="password" id="password" placeholder="Password"/>
        </div>
        <div>
            <input type="password" id="verify-password" placeholder="Verify Password"/>
        </div>
        <div>
            <input type="button" id="login-btn" value="Login" v-on:click="login" />
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
        login() {
            var p=document.getElementById("password");
            var vp=document.getElementById("verify-password");
            var l=document.getElementById("loginname");

            if (p.value!=vp.value || l.value=="") {
                alert("WRONG!");
            } else {
                this.callback(l.value,p.value);
            }
        }
    }
}
</script>
<style scoped>
</style>