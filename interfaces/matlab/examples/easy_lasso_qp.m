%% Lasso problem

% Problem dimensions and sparity
n = 10;
m = 10*n;
dens_lvl = 0.5;

rng(1);
% Generate data
Ad = sprandn(m, n, dens_lvl);
x_true = (rand(n, 1) > 0.5).*randn(n, 1) / sqrt(n);
bd = Ad*x_true + .5*randn(m, 1);
gamma = 1;

%   minimize	y.T * y + gamma * np.ones(n).T * t
%   subject to  y = Ax
%               -t <= x <= t
P = blkdiag(sparse(n, n), 2*speye(m), sparse(n, n));
q = [zeros(m+n,1); gamma*ones(n,1)];
In = speye(n);
Onm = sparse(n, m);
A = [Ad, -eye(m), sparse(m, n);
     In, Onm, -In;
     In, Onm, In];
l = [bd; -Inf*ones(n,1); zeros(n,1)];
u = [bd; zeros(n,1); Inf*ones(n,1)];

solver = osqp;
solver.setup(P, q, A, l, u, 'verbose', true, 'linsys_solver', 'mkl pardiso');
res = solver.solve();


%solver.codegen('test')