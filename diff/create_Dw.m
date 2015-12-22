function Dw = create_Dw(w, N, f1, fg, isaddition)
% Creates the forward difference matrix (without dl division).  For the backward
% difference matrix, take the transpose or conjugate transpose appropriately, as
% shown in create_Ds().
%
% f1: factor multiplied to the first element in the w-direction (for implementing the symmetry boundary)
% fg: factor multiplied to the ghost element in the w-direction (for implementing the Bloch boundary)

chkarg(istypesizeof(w, 'Axis') || istypesizeof(w, 'Dir'), '"w" should be instance of Axis or Dir.');
chkarg(istypesizeof(N, 'int', [1 w.count]), '"N" should be length-%d row vector with integer elements.', w.count);
chkarg(istypesizeof(f1, 'complex'), '"f1" should be complex.');
chkarg(istypesizeof(fg, 'complex'), '"fg" should be complex.');

if nargin < 5  % no isaddition
	isaddition = false;
end
chkarg(istypesizeof(isaddition, 'logical'), '"isaddition" should be logical.');

% Translate spatial indices (i,j,k) into matrix indices.
Ntot = prod(N);
row_ind = 1:Ntot;
col_ind_curr = 1:Ntot;

col_ind_next = reshape(1:Ntot, N);
shift = zeros(1, w.count);
shift(w) = -1;
col_ind_next = circshift(col_ind_next, shift);

a_curr = ones(N);
a_ind = {':', ':', ':'};
a_ind{w} = 1;
a_curr(a_ind{:}) = f1;

a_next = ones(N);
a_ind = {':', ':', ':'};
a_ind{w} = N(w);
a_next(a_ind{:}) = fg;

% Create the sparse matrix.
if ~isaddition
	a_curr = -a_curr;  % make Dw to perform subtraction
end

Dw = sparse([row_ind(:); row_ind(:)], [col_ind_curr(:); col_ind_next(:)], ...
	[a_curr(:); a_next(:)], Ntot, Ntot);
