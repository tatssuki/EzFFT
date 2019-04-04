# EzFFT
EzFFT is a wrapper package for FFTW.


## Installation

## usage
```
using EzFFT

ts = 1e-8
tl = 0.0:ts:0.001-ts
f = 20*1e3
xxx = Float64[]
for t in tl
    push!(xxx, ifelse(sin(2pi*f*t)>0.0, 1.0, -1.0))
end
res = 20*log10.(ezfft(xxx, ts, window=:rectangular))
ezplot(res, ts, xlabel="MHz", ylabel="dB")
```

![simulation result](https://user-images.githubusercontent.com/1778092/55560886-286e3700-572c-11e9-9f51-eb2daf441d23.png)


### window functions
|window function name  | sybol  |
|---|---|
|rectangular  |:rectangular  |

