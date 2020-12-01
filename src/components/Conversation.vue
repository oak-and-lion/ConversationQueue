<template>
    <div id="convos">
        <ul id="convos-list">
            <li v-for='(convo,id) in convos' :key="id" :item-convo-id="convo.id">
                <span :convo-id="convo.id">{{convo.name}}</span>
                <input type="button" v-on:click="processCmd('s',convo.id,convo.callback,convo.name)" value="Show"/>
                <input type="button" v-on:click="processCmd('d',convo.id,convo.callback2,convo.name)" value="Delete"/>
                <input type="text" placeholder="Your Name"/>
                <input type="text" placeholder="Topic Notes"/>
                <input type="button" v-on:click="processCmd('j',convo.id,convo.callback3,convo.name)" value="Join"/>
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
        processCmd(action,id,callback,cname) {
            this.dressControls(action,id);
            this.makeCallback(action,id,callback,cname);
        }, //processCmd
        dressControls(action,id) {
            if (action=="d") {
                var e=document.querySelectorAll('[item-convo-id="'+id+'"]');
                if (e!=null && e.length>0) {
                    e[0].style.textDecoration="line-through";
                    for(var y=1;y<e[0].children.length;y++) {
                        e[0].children[y].style.display="none";
                    }
                }
            }
        }, // dressControls
        makeCallback(action,id,callback,cname) {
            if (callback!=null) {
                switch (action) {
                    case "j":
                        var e=document.querySelectorAll('[item-convo-id="'+id+'"]');
                        if (e!=null && e.length>0) {
                            if (e[0].children!=null && e[0].children.length>=6) {
                                callback(id,e[0].children[3].value,e[0].children[4].value,cname);
                            }else {
                                callback(id,null,null,cname);
                            }
                        } else {
                            callback(id,null,null,cname);
                        }
                        break;
                    default:
                        callback(id,cname);
                        break;
                }
            }
        }, // makeCallback
        resetList() {
            var l=document.getElementById("convos-list");
            if (l!=null) {
                for(var x=0;x<l.children.length;x++) {
                    l.children[x].style.textDecoration="";
                    for(var y=1;y<l.children[x].children.length;y++) {
                    l.children[x].children[y].style.display="inline-block";
                    }
                }
            }
        } // resetist
    }
}
</script>