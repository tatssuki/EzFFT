module EzFFT
using FFTW, Plots

export ezfft, ezplot
export make_log_ln

function make_log_ln(st, ed)
    mxx, zxx = [], []

    stj = floor(Int64, log10(st))
    enj = floor(Int64, log10(ed))

    sti = floor(Int64, st / 10^Float64(stj))
    eni = floor(Int64, ed / 10^Float64(enj))

    for j in stj:enj, i in 1:9
        if j == enj && i > eni
        else
            push!(mxx, i*10^Float64(j))
            x = 10^Float64(j)
            if x >= 1.0
                x = convert(Int64, x)
            end
            push!(zxx, ifelse(i==1, string(x), ""))
        end
    end

    return mxx, zxx
end


function rectangular(dl::Array{Float64,1})
    return dl
end

function ezfft(ds::Array{Float64, 1}, ts::Float64; window=:rectangular)
    maxhz = 1/ts
    minhz = length(ds)/ts

    res = abs.(fft(eval(Expr(:call, window, ds)))./ length(ds) .*2.0)
    res = res[1:round(Int64, length(res)/2.0)]
    popfirst!(res)
    return res
end

function ezplot(ds::Array{Float64, 1}, ts::Float64; ylabel="", xlabel="MHz", fontsize=16)
    if xlabel == "MHz"
        wxx = 1e6
    elseif xlabel == "kHz"
        wxx = 1e3
    else
        wxx = 1.0
    end
    frqmax = round(Int64, 1/ts)
    frqmax = round(Int64, 1/ts)/wxx
    frqmin = frqmax/length(ds)/2
    frqset = (frqmin:frqmin:frqmax/2)

    mxx, zxx = make_log_ln(frqmin, frqmax)
    plot(frqset, ds, xticks=(mxx, zxx), xscale=:log10, legend=false)
    plot!(xlabel="[$(xlabel)]", ylabel="[$(ylabel)]", tickfont=font(fontsize), legendfont=font(fontsize), guidefont=font(fontsize))
end

end # module


# test code
#=
using EzFFT

ts = 1e-8
tl = 0.0:ts:0.001-ts
f = 20*1e3
xxx = Float64[]
for t in tl
    push!(xxx, sin(2pi*f*t))
end

res = 20*log10.(ezfft(xxx, ts))
#res = 20*log10.(ezfft(xxx, ts))
ezplot(res, ts, xlabel="MHz")
=#
