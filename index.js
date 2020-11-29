var hello = new Vue({
    el: "#hello-world-app",
    data: {
        msg: "Vue js Hello World - Your First Vue.js App",
      message: 'Welcome Engineering Training',
      result: '',
      responseAvailabe: false
    },
    methods: {
     fetchAPIData(func,) {
        this.responseAvailable = false;
        fetch("https://childsheartyoga.com/api.aspx?pf=" + func, {
            "method": "GET",
            "headers": {
            }
        })
        .then(response => { 
            if(response.ok){
                return response.json()    
            } else{
                alert("Server returned " + response.status + " : " + response.statusText);
            }
        })
        .then(response => {
            this.result = response.users; 
            this.responseAvailable = true;
        })
        .catch(err => {
            console.log(err);
        })
     } //fetchAPIData
    } //methods
  });