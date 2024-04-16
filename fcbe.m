function [F,obj_aa,bdl,Z] = fcbe(X,Z1,Z2,c,F,Y,l_s,l_e)
%normal zhavemaxnumber
    iniF = F;
    [n,~] = size(Z1);

    F = F./sum(F,2);% 行和为1
    
    lbd = l_s;
    Z = lbd*lbd*Z1-lbd*Z2;
    obj_aa=[];
    obj_aa(1) = trace(F'*Z*F);
    convo = 0;
    for oiter = 1:10
%         tic
        %% update Y:
        F = trFTDF(Z,F,1);
       
        %% update lbd
%         tic
        aa = trace(F'*Z1*F);
        bb = trace(F'*Z2*F);
        fprintf('aa = %d, bb = %d\n',aa,bb)
        lbd = bb/(2*aa);
        lbd = min(lbd,l_e);   
        bdl(oiter) = lbd;
%         toc   
        %% record
%         ZZ00 = Z;
        Z = lbd*lbd*Z1-lbd*Z2;
        obj_aa(oiter+1) = trace(F'*Z*F);
        if obj_aa(oiter+1)>obj_aa(oiter)
             fprintf('obj raise after update all once\n')
        end
        if oiter>1 && abs(obj_aa(oiter-1)-obj_aa(oiter))<1e-4
            fprintf('break \n')
            break;
        end
         
    end


end


function Y = Y_Initialize_km(X,c)
% X: num*dim
n = size(X,1);
labels = kmeans(X,c);
Y = zeros(n,c);
for i = 1:n
    Y(i,labels(i))=1;
end
% Y = sparse(Y);
end