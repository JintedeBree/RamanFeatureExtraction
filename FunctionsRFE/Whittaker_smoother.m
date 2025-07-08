function [data_filtered, baseline]=Whittaker_smoother(data, p, y)

% input is a [N x M] matrix of N rows and M columns. each column contains a
% spectrum that is smoothed using this function. 

% the whittaker smoother uses the following function:
% S=sum(w*(y(i)-z(i))^2) + y*sum((delta^2 z(i))^2)
%   w=p if y > z;   w=1-p if y =< z;
%   delta^2 z(i) = (z(i) - 2*z(i-1) + z(i-2))

% the smoother algorithm tries to minimize the variable S. This means that
% a large value for y means a large punishment on sum((delta^2 z)^2) which
% which means a large punishment on curvature in the smoothed function.

% to keep S low the part sum(w*(y-z)^2) will be minimized which is done by
% fitting z to y (y being the spectrum and z being the fitted function). 
% choosing a small value for p means having a low punishment on functions
% with y > z (Thus typically Raman bands you do not want to smoothe those).

% there is no quantitative way to choose suitable p and y values. This is a
% trial and error process with which you have to get some familiarity by
% doing it.

N=size(data,1);
number=size(data,2);
D=diff(speye(N),2);
w=ones(N,1);

for n=1:number;
    for it=1:10
        W=spdiags(w,0,N,N);
        C=chol(W+y*D'*D);
        baseline(:,n)=C\(C'\(w.*data(:,n)));
        w=p*(data(:,n)>baseline(:,n))+(1-p)*(data(:,n)<baseline(:,n));
    end
end

data_filtered=data-baseline;
