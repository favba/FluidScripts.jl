function makeModel(Model::String)

N, Fil = getnfilter()

outp = "Model_$Model"
isdir(outp) || mkdir(outp)

tm11 = "$(outp)/Tm11"
tm12 = "$(outp)/Tm12"
tm13 = "$(outp)/Tm13"
tm22 = "$(outp)/Tm22"
tm23 = "$(outp)/Tm23"
tm33 = "$(outp)/Tm33"

t11 = "$(Fil)T11_N$N"
t12 = "$(Fil)T12_N$N"
t13 = "$(Fil)T13_N$N"
t22 = "$(Fil)T22_N$N"
t23 = "$(Fil)T23_N$N"
t33 = "$(Fil)T33_N$N"

d11 = "$(Fil)D11_N$N"
d12 = "$(Fil)D12_N$N"
d13 = "$(Fil)D13_N$N"
d22 = "$(Fil)D22_N$N"
d23 = "$(Fil)D23_N$N"
d33 = "$(Fil)D33_N$N"

p11 = "$(Fil)P11_N$N"
p12 = "$(Fil)P12_N$N"
p13 = "$(Fil)P13_N$N"
p22 = "$(Fil)P22_N$N"
p23 = "$(Fil)P23_N$N"
p33 = "$(Fil)P33_N$N"

if Model in ("I", "II", "III")
  if Model == "I"
    doinchunks(propmodel,input=(t11,t22,t33,t12,t13,t23,d11,d22,d33,d12,d13,d23),
                        output=(tm11,tm22,tm33,tm12,tm13,tm23,"$(outp)/alpha","$(outp)/ratio"))
  elseif Model == "II"
    doinchunks(inphmodel,input=(t11,t22,t33,t12,t13,t23,d11,d22,d33,d12,d13,d23),
                        output=(tm11,tm22,tm33,tm12,tm13,tm23,"$(outp)/alpha0","$(outp)/alpha1","$(outp)/alpha2","$(outp)/ratio"))
  elseif Model == "III"
    doinchunks(propmodel,input=(t11,t22,t33,t12,t13,t23,p11,p22,p33,p12,p13,p23),
                        output=(tm11,tm22,tm33,tm12,tm13,tm23,"$(outp)/alpha","$(outp)/ratio"))
  end

elseif Model in ("V", "VI")
  if Model == "V"
    doinchunks(mixmodel,input=(t11,t22,t33,t12,t13,t23,
                        "Model_I/Tm11","Model_I/Tm22","Model_I/Tm33","Model_I/Tm12","Model_I/Tm13","Model_I/Tm23",
                        "Model_III/Tm11","Model_III/Tm22","Model_III/Tm33","Model_III/Tm12","Model_III/Tm13","Model_III/Tm23"),
                         output=(tm11,tm22,tm33,tm12,tm13,tm23,"$(outp)/ratio"))
  else
    doinchunks(mixmodel,input=(t11,t22,t33,t12,t13,t23,
                        "Model_II/Tm11","Model_II/Tm22","Model_II/Tm33","Model_II/Tm12","Model_II/Tm13","Model_II/Tm23",
                        "Model_III/Tm11","Model_III/Tm22","Model_III/Tm33","Model_III/Tm12","Model_III/Tm13","Model_III/Tm23"),
                         output=(tm11,tm22,tm33,tm12,tm13,tm23,"$(outp)/ratio"))
  end
end

return 0
end
