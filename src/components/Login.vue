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
            <div>
                <span>Create</span> <input type="checkbox" id="new-login-check" v-on:change="newLoginChange"/>
            </div>
            <input type="button" id="login-btn" value="Login" v-on:click="login" />
            <input type="button" id="logout-btn" value="Logout" v-on:click="logout"/>
        </div>
    </div>
</template>
<script>
export default {
    props: {
         callback: {
            type: Function,
            required: true
        },
        logoutCallback: {
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
            var n=document.getElementById("new-login-check");

            if (n.checked && (p.value!=vp.value || l.value=="")) {
                alert("WRONG!");
            } else {
                this.callback(l.value,p.value);
            }
        } // login
        , newLoginChange() {
            var l=document.getElementById("new-login-check");
            if (l.checked) {
                document.getElementById("verify-password").style.display="inline";
            } else {
                document.getElementById("verify-password").style.display="none";
            }
        } // newLoginChange
        , logout() {
            this.logoutCallback();
        } // logout
    }
}
</script>
<style scoped>
    #verify-password {
        display:none;
    }
</style>