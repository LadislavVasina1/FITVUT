const char MAIN_page[] = R"=====(
<!DOCTYPE html>
<html>
<head>
  <title>Heart rate sensor</title>
  <style>
    body{
      margin: 0;
      padding: 0;
      background: rgb(2,0,36);
      background: linear-gradient(180deg, rgba(2,0,36,1) 0%, rgba(9,121,61,1) 2%, rgba(0,212,255,1) 100%);
    }
    .center1 {
      display: flex;
      justify-content: center;
      align-items: center;
      text-align: center;
      min-height: 80vh;
      text-align: center;
      font-family: Helvetica;
      font-size: 80px;
    }
    .center2 {
      display: flex;
      justify-content: center;
      align-items: center;
      text-align: center;
      min-height: 20vh;
      text-align: center;
      font-family: Helvetica;
      font-size: 40px;
    }
  </style>
</head> 
<body>
<div class="center1">
<b id="bmp">XXX</b><br>
</div>
<div class="center2">
<p style="float:left" id="time"></p>
</div>
<script>

setInterval(function() {
  getData();
}, 1000);

function getData() {
  let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("bmp").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "readData", true);
  xhttp.send();
}

(function () {
    function checkTime(i) {
        return (i < 10) ? "0" + i : i;
    }

    function startTime() {
        var today = new Date(),
            h = checkTime(today.getHours()),
            m = checkTime(today.getMinutes()),
            s = checkTime(today.getSeconds());
        document.getElementById('time').innerHTML = h + ":" + m + ":" + s;
        t = setTimeout(function () {
            startTime()
        }, 500);
    }
    startTime();
})();
</script>
</body>
</html>
)=====";