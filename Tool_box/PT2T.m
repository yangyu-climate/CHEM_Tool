function Temp = PT2T(T,P)
    P = P/1000;
    Temp = T.*(P.^(2/7));