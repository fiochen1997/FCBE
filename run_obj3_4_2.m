function [F,obj_aa,bdl,Z] = run_obj3_4_2(X,Z1,Z2,c,F,Y,l_s,l_e)
%normal zhavemaxnumber
    iniF = F;
    [n,~] = size(Z1);
%     F = rand(n,c);
    % FFF = n2nc(Y);
    % FFF = ones(n,c)*(1/c);
%     F = FFF;
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

%          figure(1)
%          plot(obj_a,'b');
%          title('Y update')
%         toc
        
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
             fprintf('目标函数上升after update all once\n')%此处目标函数上升是因为F变了（但上升不多）
        end
        if oiter>1 && abs(obj_aa(oiter-1)-obj_aa(oiter))<1e-4
            fprintf('break \n')
            break;
        end
         
    end


%     
%     figure(7)    
%     clf;
%     YY = n2nc(Y);
%     Ytc = ones(n,c)/c;
%     Yt1 = [ones(n,1),zeros(n,c-1)];
%     plot(trace(YY'*Z*YY)*ones(length(obj_aa),1),'r');hold on;
%     plot(trace(Ytc'*Z*Ytc)*ones(length(obj_aa),1),'y');hold on;
%     plot(trace(Yt1'*Z*Yt1)*ones(length(obj_aa),1),'g');hold on;
% %     plot(trace(F'*Z*F)*ones(length(obj_aa),1),'b');hold on;
%     plot(obj_aa,'b');hold on;
%     legend('gnd','Ytc','Yt1','res')
%     title('objective update')
%     
%     
%     figure(8)
%     imagesc(F);
%     figure(10)
%     plot(bdl,'b');
%     title('lbd')
%     [~,res] = max(F');
%     figure(9)
%     clf;
%     gscatter(X(:,1),X(:,2),res);
%     % record
% %     F_true = n2nc(Y);
% %     obj_tru = trace(F_true'*Z*F_true)*ones(1,iter+1);
% % 
% % 
% %     figure(z)
% %     clf;
% %     subplot(1,3,1)
% % %     plot(obj_tri,'g');hold on;%trivial
% %     plot(obj_tru,'r');hold on;%true
% % %     plot(obj_des,'k');hold on;%discrete
% %     plot(obj_a,'b'); hold on;
% %     title(num2str(min(eig(Z)),5))
% %     
% %     
% %     figure(z)
% %     subplot(1,3,2)
% %     imagesc(F);colorbar;
% %     title('F')
%     

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