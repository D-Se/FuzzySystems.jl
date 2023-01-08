```@raw html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">

<style>
    a, a:hover, a:visited, a:active {color: inherit; text-decoration: none; }
    .float-child { width: 45%; height: 100px; float: left; padding: 5px; } 
    .fa-beat-hover:hover {
        -webkit-animation: fa-beat 1.0s infinite linear;
        -moz-animation: fa-beat 1.0s infinite linear;
        -o-animation: fa-beat 1.0s infinite linear;
        animation: fa-beat 1.0s infinite linear;
    }
    p { clear:both; }
    .nut { display: none; }
    .shell:hover .nut { display: block; }
    #feature ul, #feature li {
        margin: 0; 
        padding: 0;
        text-align: left;
    }
</style>

<center>
   <h1>FuzzySystems.jl</h1>
   <p><i>Fuzzy expert systems and logic module for approximate imprecise reasoning</i></p>
   <div class="float-container">
      <div class="float-child">
         <a href="https://stackoverflow.com/questions/tagged/julia?sort=Newest" style="float:right"><i class="fa-brands fa-stack-overflow fa-beat-hover fa-2x"></i></a>
      </div>
      <div class="float-child">
         <iframe src="https://ghbtns.com/github-btn.html?user=D-Se&repo=FuzzySystems.jl&type=star&count=true&size=large" style="height: 70px; width: 150px; float: left" frameborder="0" scrolling="0" title="GitHub"></iframe>
      </div>
   </div>
      <div>
      <hr style="clear:both"><h3>Features</h3>
      <div id="feature">
        <ul style="list-style: none; display: grid; grid-template-columns: auto auto auto auto;">
            <li>&nbsp;</li>
            <li>
                <div class="shell">
                    <i class="fa-solid fa-list fa-beat-hover fa-3x"></i>&nbsp;&nbsp;Fuzzy API
                    <div class="nut">
                        <pre>
                            <code>
@rule cheap tip    = poor service | rancid food
@rule average tip  = good service
@rule generous tip = excellent service | delicious food

@var in service {
    poor:       T₄ 0 0 2 4,
    good:       T₃ 3 5 7,
    excellent:  T₄ 6 8 10 10
}
@var in food {
    rancid:     T₄ 0 0 3 6,
    delicious:  T₄ 4 7 10 10
}

@var out tip {
    cheap:      T₄ 10 10 20 30,
    average:    T₃ 20 30 40,
    generous:   T₄ 30 40 50 50
}
                                </code>
                            </pre>
                    </div>
                </div>
            </li>
            <li>&nbsp;</li>
            <li><a href="reference/api"><i class="fa-solid fa-book fa-beat-hover fa-3x"></i></a>&nbsp;&nbsp;Documented</li>
            <li>&nbsp;</li>
            <li>
                <div class="shell">
                    <i class="fa-solid fa-chart-area fa-beat-hover fa-3x"></i>&nbsp;&nbsp;Membership
                    <div class="nut">
                        <table>
                            <tr> <th></th> <th></th> <th></th> </tr>
                            <tr>
                                <td>Gaussian</td> <td>Generalized Bell</td> <td>Linear</td>
                             </tr>
                            <tr>
                                <td>Triangular</td> <td>Trapezoid</td> <td>Sigmoid</td>
                            </tr>
                            <tr>
                                <td>S</td> <td>Z</td> <td>π</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </li>
            <li>&nbsp;</li>
            <li><a href="reference/api"><i class="fa-solid fa-gauge-high fa-beat-hover fa-3x"></i></a>&nbsp;&nbsp;Fast</li>
        </ul>
        </div>
    </div>

    <br/><br/>

   <img src="assets/FIS.svg" title="Fuzzy System">
</center>
```