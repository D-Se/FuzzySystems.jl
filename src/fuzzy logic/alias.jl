# Unexported yet supported synonyms to facilitate interoperability.
# Legacy and popular software

const MF_ALIAS = @alias {
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

const OP_ALIAS = @alias {
    𝙂ᵗ minimum min MIN zadeh_t
    𝙂ˢ maximum max MAX zadeh_s
    𝙂ⁱ gödel

    𝘼ᵗ algebraic_product    ∏_algebraic         algprod   algor
    # probor is a MATLAB misnomer
    𝘼ˢ algebraic_sum        ∑_algebraic         algsum    algand probor
    𝘼ⁱ goguen

    𝘿ᵗ drastic_product      ∏_drastic           drasprod  drasor
    𝘿ˢ drastic_sum          ∑_drastic           drassum   drasand
    𝘿ⁱ drastic

    𝙀ᵗ einstein_product    ∑_einstein           einprod   einor
    𝙀ˢ einstein_sum        ∑_einstein           einsum    einand

    𝙃ᵗ hamacher_product    ∏_hamacher           hamprod   hamor
    𝙃ˢ hamacher_sum        ∑_hamacher           hamsum    hamand

    𝙇ᵗ bold_intersection    bounded_difference            boundor
    𝙇ˢ bounded_sum          ∑_bounded           boundsum  boundand
    𝙇ⁱ łukasiewicz

    𝙁ᵗ nilpotent_minimum                        nilmin    nilor
    𝙁ˢ nilpotent_maximum                        nilmax    niland
    𝙁ⁱ fodor

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

function op(name, x, y)
    name == :bounded_sum ? 𝙇ˢ(x, y)::Float64 :
    name == :einstein_sum ? 𝙀ˢ(x, y)::Float64 :
    name == :hamacher_sum ? 𝙃ˢ(x, y)::Float64 :
    name == :drastic_sum ? 𝘿ˢ(x, y)::Float64 :
    throw("invalid function alias")
end
