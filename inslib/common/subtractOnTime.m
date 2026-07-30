function [err,delta]=subtractOnTime(ref,est)
% ti1=ref(1,1);
% ti2=est(1,1);
% ti=max(ti1,ti2);
% if ti1<ti2
%     [~,j]=min(abs(ref(:,1)-ti));
%     ref=ref(j:end,:);
% else
%      [~,j]=min(abs(est(:,1)-ti));
%     est=est(j:end,:);
% end
% tf1=ref(end,1);
% tf2=est(end,1);
% tf=min(tf1,tf2);
% if tf1<tf2
%     [~,j]=min(abs(est(:,1)-tf));
%     est=est(1:j,:);
% else
%     [~,j]=min(abs(ref(:,1)-tf));
%     ref=ref(1:j,:);
% end
N=size(ref,1);
err=zeros(size(ref));
% delta = zeros(N,1);
% S=10000;
for k=1:N
%     if k+S<N
%         if k<=S
%             [delta(k),j]=min(abs(est(1:k+S,1)-ref(k,1)));
%         else
%             [delta(k),j]=min(abs(est(k-S:k+S,1)-ref(k,1)));
%             j=j+k-S-1;
%         end
%     else
      [~,j]=min(abs(est(:,1)-ref(k,1)));
%      j=j+k-1;
%     end
%      if delta(k) > 0.01
%          disp('error!')
%          break
%      end
     err(k,:)=ref(k,:)-est(j,:);
     if abs(err(k,4))>50
         err(k,4)=0;
     end
     if ~mod(k,round(N/10))
     fprintf('*')
     end
  end
end

