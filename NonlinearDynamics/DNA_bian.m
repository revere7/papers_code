%% 子函数 DNA编码
% 按照8种编码方式，num数值为8，分别为8中不同的方式，A(i,j)的值不同，
%  A（i，j）=0，代表8位二进制中的 00
%  A（i，j）=1，代表8位二进制中的 01
%  A（i，j）=2，代表8位二进制中的 10
%  A（i，j）=其他，代表8位二进制中的 11
function fv=DNA_bian(array,num)
t=length(array);
a1=bitand(array,192)/64;
a2=bitand(array,48)/16;
a3=bitand(array,12)/4;
a4=bitand(array,3);
A=[a1,a2,a3,a4];    %t行4t列
if num==1
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='A';
            elseif A(i,j)==1
                fv(i,j)='C';
            elseif A(i,j)==2
                fv(i,j)='G';
            else
                fv(i,j)='T';
            end
        end
    end
elseif num==2
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='A';
            elseif A(i,j)==1
                fv(i,j)='G';
            elseif A(i,j)==2
                fv(i,j)='C';
            else
                fv(i,j)='T';
            end
        end
    end
elseif num==3
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='T';
            elseif A(i,j)==1
                fv(i,j)='C';
            elseif A(i,j)==2
                fv(i,j)='G';
            else
                fv(i,j)='A';
            end
        end
    end
elseif num==4
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='T';
            elseif A(i,j)==1
                fv(i,j)='G';
            elseif A(i,j)==2
                fv(i,j)='C';
            else
                fv(i,j)='A';
            end
        end
    end
elseif num==5
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='G';
            elseif A(i,j)==1
                fv(i,j)='A';
            elseif A(i,j)==2
                fv(i,j)='T';
            else
                fv(i,j)='C';
            end
        end
    end
elseif num==6
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='G';
            elseif A(i,j)==1
                fv(i,j)='T';
            elseif A(i,j)==2
                fv(i,j)='A';
            else
                fv(i,j)='C';
            end
        end
    end
elseif num==7
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='C';
            elseif A(i,j)==1
                fv(i,j)='A';
            elseif A(i,j)==2
                fv(i,j)='T';
            else
                fv(i,j)='G';
            end
        end
    end
else
    for i=1:t
        for j=1:4*t
            if A(i,j)==0
                fv(i,j)='C';
            elseif A(i,j)==1
                fv(i,j)='T';
            elseif A(i,j)==2
                fv(i,j)='A';
            else
                fv(i,j)='G';
            end
        end
    end
end