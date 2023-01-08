# Fuzzy system

Fuzzy systems approximate imprecise reasoning in practical identification, regression and classification tasks. Each system consists of [Fuzzification](@ref), a [Knowledge base](@ref), an [Inference engine](@ref) and [Defuzzification](@ref).

!!! note "Ex: Julia as primary language - Mamdani"
    $$Would\ you\ recommend\ Julia?$$

    !!! warning "Context"
        |variable   |choices                                    |
        |:---       |:---                                       |
        |`syntax`   |{easy, hard\}                              |
        |`code`|{very slow, slow, medium, fast, very fast}      |
        |`help`|{rude, neutral, friendly}                       |
    
    !!! tip "Knowledge Base"
        
        `| min`, `& max`, `? Zadeh`, `! standard`

        |IF    |antecedent                                   |THEN    |consequent             |
        |:---  |:---                                         |:---    |:---                   |
        |**IF**|hard syntax                                  |**THEN**|discommend             |
        |**IF**|easy syntax \| fast code                     |**THEN**|weakly recommend       |
        |**IF**|fast code & easy syntax & friendly help  |**THEN**|strongly recommend     |

## Fuzzification
Transforming values into fuzzy values representing truth degrees in ``[0, 1]``.

**Type I**  - single membership value. 

Synonym *Mamdani* system.

**Type II** - range of membership values.

Synonym *Takani Sugeno Tang (TSK)*. Uses two functions for each variable, the boundary representing uncertainty.

## Knowledge base

**database (theoretical)**
A database specifies *how* to perform set operations.

|Op     |Math      |Classic set |Symbol  |Fuzzy set         |
|:---:  |:---:     |:---:       |:---:   |:---:             |
|AND    |``A ∧ B`` |Conjunction |`&`     |s-norm, t-conorm  |
|OR     |``A ∩ B`` |Intersection|`\|`    |t-norm            |
|NOT    |``¬A``    |Complement  |`!`, `~`|negation          |
|THEN   |``A ⟹ B``|Implication | `?`   |implication       |
**rulebase (practical)**

A collection of fuzzy rules that infer outputs based on input variables.

Rulebases may be obtained
* manually, from human experts
* automatically, from algorithms

## Inference engine

Inference engines search for structure and fit parameters. Many approaches exist, including clustering, gradient descent, neural networks, heuristics, genetic algorithms and others.
 
## Defuzzification
 Aggregation operation to translate degrees of truth to a crisp value.

