function [Matrix,Index] = permute_repetitions(N,K)
if nargin ~= 2
    error('permute_repetitions requires two arguments. See help.')
end

if isempty(N) || K == 0,
   Matrix = [];  
   Index = Matrix;
   return
elseif floor(K) ~= K || K<0 || ~isreal(K) || numel(K)~=1 
    error('Second argument should be a real positive integer. See help.')
end

LN = numel(N);  % Used in calculating the Matrix and Index.

if K==1
    Matrix = N(:); % This one is easy to calculate.
    Index = (1:LN).';
    return
elseif LN==1
    Index = ones(K,1);
    Matrix = N(1,Index);
    return  
end

CLS = class(N);

if ischar(N)
    CLS = 'double';  % We will deal with this at the end.
    flg = 1;
    N = double(N);
else
    flg = 0;
end

L = LN^K;  % This is the number of rows the outputs will have.
Matrix = zeros(L,K,CLS);  % Preallocation.
D = diff(N(1:LN));  % Use this for cumsumming later.
LD = length(D);  % See comment on LN. 
VL = [-sum(D) D].';  % These values will be put into Matrix.
% Now start building the matrix.
TMP = VL(:,ones(L/LN,1,CLS));  % Instead of repmatting.
Matrix(:,K) = TMP(:);  % We don't need to do two these in loop.
Matrix(1:LN^(K-1):L,1) = VL;  % The first column is the simplest.

if nargout==1
    % Here we only have to build Matrix the rest of the way.
    for ii = 2:K-1
        ROWS = 1:LN^(ii-1):L;  % Indices into the rows for this col.
        TMP = VL(:,ones(length(ROWS)/(LD+1),1,CLS));  % Match dimension.
        Matrix(ROWS,K-ii+1) = TMP(:);  % Build it up, insert values.
    end

else
    % Here we have to finish Matrix and build Index.
    Index = zeros(L,K,CLS);  % Preallocation.
    VL2 = ones(size(VL),CLS);  % Follow the logic in VL above.
    VL2(1) = 1-LN;  % These are the drops for cumsum.
    TMP2 = VL2(:,ones(L/LN,1,CLS));  % Instead of repmatting.
    Index(:,K) = TMP2(:);  % We don't need to do two these in loop.
    Index(1:LN^(K-1):L,1) = 1;  

    for ii = 2:K-1
        ROWS = 1:LN^(ii-1):L;  % Indices into the rows for this col.
        F = ones(length(ROWS)/(LD+1),1,CLS);  % Don't do it twice!
        TMP = VL(:,F);  % Match dimensions.
        TMP2 = VL2(:,F);
        Matrix(ROWS,K-ii+1) = TMP(:); % Build them up, insert values.
        Index(ROWS,K-ii+1) = TMP2(:);  
    end
    
    Index(1,:) = 1;  % The first row must be 1 for proper cumsumming.
    Index = cumsum(Index);  % This is the time hog.
end

Matrix(1,:) = N(1);  % For proper cumsumming.
Matrix = cumsum(Matrix);  % This is the time hog.

if flg
    Matrix = char(Matrix);  % char was implicitly cast to double above.
end
