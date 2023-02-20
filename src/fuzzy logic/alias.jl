# Unexported yet supported synonyms to facilitate interoperability.
# Legacy and popular software

const MF_ALIAS = @aliasdict {
    Gaussian      G     g   gauss           gaussmf
    Bell          B     b   bell      gbell gbellmf
    Triangular    T     t   triangle        trimf
    Trapezoid     Q     q   trap            trapmf
    Sigmoid       S     s   sig             sigmf
    S_shape       SS    ss                  smf
    Z_shape       ZS    zs                  zmf
    Lins          LS    ls
    Linz          LZ    lz
    Singleton     single
    Pi            π
}

const OP_ALIAS = @aliasdict {
    Gödel_Dumett.T minimum min MIN zadeh_t
    Gödel_Dumett.S maximum max MAX zadeh_s
    Gödel_Dumett.I gödel

    Algebraic.T algebraic_product    ∏_algebraic         algprod   algor
    # probor is a MATLAB misnomer
    Algebraic.S algebraic_sum        ∑_algebraic         algsum    algand probor
    Algebraic.I goguen

    Drastic.T drastic_product      ∏_drastic           drasprod  drasor
    Drastic.S drastic_sum          ∑_drastic           drassum   drasand
    Drastic.I drastic

    Einstein.T einstein_product    ∑_einstein           einprod   einor
    Einstein.S einstein_sum        ∑_einstein           einsum    einand

    Hamacher.T hamacher_product    ∏_hamacher           hamprod   hamor
    Hamacher.S hamacher_sum        ∑_hamacher           hamsum    hamand

    Łukasiewicz.T bold_intersection    bounded_difference            boundor
    Łukasiewicz.S bounded_sum          ∑_bounded           boundsum  boundand
    Łukasiewicz.I łukasiewicz

    Fodor.T nilpotent_minimum                        nilmin    nilor
    Fodor.S nilpotent_maximum                        nilmax    niland
    Fodor.I fodor

    maximum                    max MAX
    minimum                    min MIN

    KDⁱ kleene-dienes
    Rⁱ reichenbach
    Mⁱ mizumoto
    DPⁱ dubois-prade largest_S
    Zⁱ zadeh
    Zⁱ² zadeh_late
    Wⁱ weber
    Sⁱ sharp
    GRⁱ gaines-rescher
    Wuⁱ wu
    Yⁱ yager
}
#=
function op(name, x, y)
    name == :bounded_sum ? 𝙇ˢ(x, y)::Float64 :
    name == :einstein_sum ? 𝙀ˢ(x, y)::Float64 :
    name == :hamacher_sum ? 𝙃ˢ(x, y)::Float64 :
    name == :drastic_sum ? 𝘿ˢ(x, y)::Float64 :
    throw("invalid function alias")
end
 =#
