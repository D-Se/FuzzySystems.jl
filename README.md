<center>

# FuzzySystems.jl <img src="docs/src/assets/logo.png" align="right" width="120"/>

</center>
:warning: This package is in early development :warning:


`FuzzySystems.jl` is a [julia][] modeling toolbox to approximate human reasoning through [fuzzy][wiki] inference. *fast*, *robust* and *ergonomic* fuzzy logic module and inference engines to derrive `if x then y` rules for practical applications.

<details>
  <summary> <b> 2. Functionality </b> </summary>

### 2.1 Fuzzy Logic
Logical reasoning with vague or imprecise statements.

A logic is a specification of fuzzy set operations. Each `Logic` contains a negation, t-norm, s-norm and implication function. Implemented are Zadeh, Drastic, Product, Łukasiewicz, Fodor, Frank, Hamacher, Schweizer-Sklar, Dombi, Aczel-Alsine, Sugeno-Weber, Dubios-Prade and Yu logics.

Membership interfaces `μ` and `μ!` support the following curves, and their type-II variants:

|  μ       	|    μ     	|
|:---:	    |:---:	    |
|gaussian  	|Pi      	  |
|bell   	  |triangular |
|sigmoid   	|trapezoid 	|
|S 	        |linear     |
|Z    	    |singleton  |

### 2.2 Inference engines
  <center> 

  This section is :construction: under construction :construction:, please post an [issue][].

  </center>
  Many automatic rule inference methods exist. Implemented are space partition, neuro-fuzzy, genetic algorithms, cluster and heuristics-based methods.

  |Name     |Task  |Type      |Author                          | Year |  DOI                                              |
  |:---:    |:---: |:---:     |:---:	                         |:---: |:---:                                              |
  |WM       |R     |space     |Wang & Mendel                   |1992  |<sub><sup>10.1109/21.199466<sup></sub>             |
  |Chi      |C     |space     |Chi, Yan & Pham                 |1996  |<sub><sup>10.1142/3132<sup></sub>                  |
  |Ishibuchi|C     |space     |Ishibuchi & Nakashima           |2001  |<sub><sup>10.1109/91.940964<sup></sub>             |
  |ANFIS    |R     |neuro     |Jang                            |1993  |<sub><sup>10.1109/21.256541<sup></sub>             |
  |HyFIS    |R     |neuro     |Kim & Kasabov                   |1999  |<sub><sup>10.1016/s0893-6080(99)00067-2<sup></sub> |
  |SBC      |R     |cluster   |Yager & Filev                   |1994  |<sub><sup>10.3233/IFS-1994-2301<sup></sub>         |
  |DENFIS   |R     |cluster   |Chi                             |2002  |<sub><sup>10.1109/91.995117<sup></sub>             |
  |Thrift   |R     |genetic   |Thrift                          |1991  |<sub><sup>none<sup></sub>                          |
  |MOGUL    |R     |genetic   |Cordon et al.                   |1999  |<sub><sup>10.1002/(SICI)MOGUL<sup></sub>           |
  |GCCL     |C     |genetic   |Ishibuchi, Nakashima & Murata   |1999  |<sub><sup>10.1109/3477.790443<sup></sub>           |
  |GMBL     |C     |genetic   |Ishibuchi, Yamamoto & Nakashima |2005  |<sub><sup>10.1109/TSMCB.2004.842257<sup></sub>     |
  |SLAVE    |C     |genetic   |Gonzalez & Perez                |2001  |<sub><sup>10.1109/3477.931534<sup></sub>           |
  |LT       |C     |genetic   |Alcala, Fernandez & Herrera     |2007  |<sub><sup>10.1109/TFUZZ.2006.889880<sup></sub>     |
  |HGD      |R     |gradient  |Ishibuchi et al.                |1993  |<sub><sup>10.1109/FUZZY.1993.327419<sup></sub>     |
  |FIR-DM   |R     |gradient  |Nomura, Hayashi & Wakami        |1992  |<sub><sup>10.1109/FUZZY.1992.258618<sup></sub>     |

</details>
<details>
  <summary> <b> 3. Software Comparisons </b> </summary>
  Numerous fuzzy implementations exist for different use cases.

  ### Feature comparison
  |Software            |Language |Type II |Auto rule |
  |:---:               |:---:    |:---:   |:---:     |
  |FuzzySystems.jl     |Julia    |✅     |✅        |
  |[Fuzzy.jl][]        |Julia    |❌     |❌        |
  |[frbs][]            |R        |✅     |✅        |
  |[sets][]            |R        |❌     |❌        |
  |[lfl][]             |R        |❌     |❌        |
  |[FuzzyR][]          |R        |✅     |❌        |
  |[scikit-fuzzy][]    |Python   |❌     |❌        |
  |[Matlab][]          |Matlab   |✅     |❌        |
  |...                 |...      |...     |...       |
</details>

<details>
  <summary> <b> 4. Roadmap </b> </summary>

  #### Upcoming changes
  ```diff  
  + Implement poopular engines
  + Implement algebra
  + norm generators

  - Dependencies
```  
</details>
<details>
  <summary> <b> 5. Examples </b> </summary>

  :construction: Coming soon :construction:

  #### Starting a system
  ```julia
  using FuzzySystems
  mf = gaussian(0, 1)
  μ(0.5, mf)
  ```
</details>

[julia]: https://julialang.org/
[wiki]: https://en.wikipedia.org/wiki/Fuzzy_logic

<!-- External packages -->

[Fuzzy.jl]:     https://github.com/phelipe/Fuzzy.jl
[frbs]:         https://github.com/cran/frbs
[sets]:         https://github.com/cran/sets
[lfl]:          https://github.com/cran/lfl
[FuzzyR]:       https://github.com/cran/FuzzyR
[scikit-fuzzy]: https://github.com/scikit-fuzzy/scikit-fuzzy
[Matlab]:       https://www.mathworks.com/products/fuzzy-logic.html
<!-- Internal links -->
[issue]: https://github.com/D-Se/FRBS.jl/issues
