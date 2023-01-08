#= function standardize!(matrix; dims = 1, unit = true)
    transform!(fit(UnitRangeTransform, matrix, dims = dims, unit = unit), matrix)
end =#

# source: https://github.com/TensorDecompositions/NMFk.jl/blob/e2a9aef8a1ba79c7695568942f8816a904a2cb04/src/NMFkMatrix.jl
function normalize(a::AbstractMatrix, dim::Integer)
	normalize!(copy(a), dim)
end

function normalize!(a::AbstractMatrix, dim::Integer; amin::AbstractArray=matrixmin(a, dim), amax::AbstractArray=matrixmax(a, dim), rev::Bool=false, log::Bool=false, logv::AbstractVector=fill(log, size(a, dim)), offset::Number=1)
    zflag = falses(length(amin))
	lamin = copy(amin)
	lamax = copy(amax)
	for (i, m) in enumerate(lamin)
		nt = ntuple(k->(k == dim ? i : Colon()), ndims(a))
		av = view(a, nt...)
		if logv[i]
			iz = av .<= 0
			siz = sum(iz)
			if siz == length(iz)
				av .= abs.(av)
			end
			iz = av .<= 0
			siz = sum(iz)
			siz > 0 && (av[iz] .= NaN)
			av .= log10.(av)
			if siz > 0
				av[iz] .= minimum(av) - offset
				zflag[i] = true
			end
			lamin[nt...] .= minimum(av)
			lamax[nt...] .= maximum(av)
		end
	end
	dx = lamax .- lamin
	if length(dx) > 1
		i0 = dx .== 0
		dx[i0] .= 1
	end
	if rev
		a .= (lamax .- a) ./ dx
		return a, lamax, lamin, zflag
	else
		a .= (a .- lamin) ./ dx
		return a, lamin, lamax, zflag
	end
end

function denormalize(a::AbstractArray, aw...)
	denormalize!(copy(a), aw...)
end
function denormalize!(a::AbstractArray, amin, amax)
	if all(amax .>= amin)
		a .= a .* (amax - amin) .+ amin
	else
		a .= a .* (amax - amin) .+ amin
	end
	return a
end

function matrixmin(a::AbstractMatrix, dim::Integer)
	amin = map(i-> minimum(a[ntuple(k->(k == dim ? i : Colon()), ndims(a))...]), 1:size(a, dim))
	if dim == 2
		amin = permutedims(amin)
	end
	return amin
end

function matrixmax(a::AbstractMatrix, dim::Integer)
	amax = map(i-> maximum(a[ntuple(k->(k == dim ? i : Colon()), ndims(a))...]), 1:size(a, dim))
	if dim == 2
		amax = permutedims(amax)
	end
	return amax
end

function infer_range(data)
    vcat(minimum(data, dims = 1), maximum(data, dims = 1))
end