macro ⚠️(id) @warn warning[id] end

macro ⛔(id)
    msg, type = exception[id]
    quote
        msg = replace($msg, "~" => StackTraces.stacktrace()[1].func)
        if occursin(r"(?<=#)\D+", msg) msg = replace(msg, r"#(\d+)?" => "") end
        throw($type(msg))
    end 
end

#warning = Base.ImmutableDict(
warning = Dict(
    :pred_out_of_range => "new data contains values outside of the range of training data",
)

#exception = Base.ImmutableDict(
exception = Dict(
    :interval => ("x ∉ [0, 1], fuzzy logic is undefined outside the unit interval", DomainError),
    :algebra => ("selected incompatible algebra",                               ArgumentError),
    :parameter => ("invalid parameter in ~",                                    ArgumentError),
    :order => ("malformed shape, reorder arguments in ~",                       ArgumentError),
    :broadcast => ("longer object is not multiple of shorter",                  ArgumentError)
)

function bounds(x)
    0 <= x <= 1 && return nothing
    @⛔ interval
end

function bounds(x::Matrix)
    extrema(x, init = (0, 1)) == (0, 1) && return nothing
    @⛔ interval
end
