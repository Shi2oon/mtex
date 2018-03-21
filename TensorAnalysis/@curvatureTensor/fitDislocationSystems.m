function rho = fitDislocationSystems(kappa,dS,varargin)
% fit dislocation systems to a curvature tensor
%
% Formulae are taken from the paper:
%
% Pantleon, Resolving the geometrically necessary dislocation content by
% conventional electron backscattering diffraction, Scripta Materialia,
% 2008
%
% Syntax
%
%   rho = calcDislocationDensities(kappa,dS)
%
%   % compute complete curvature tensor
%   kappa = dS.dislocationTensor * rho;
%
% Input
%  kappa - (incomplete) @curvatureTensor
%  dS    - list of @dislocationSystem 
%
% Output
%  rho - dislocation densities 


% ensure we consider also negative line vector
dS = [dS,-dS];

% compute the curvatures corresponding to the dislocations
dT = curvature(dS.dislocationTensor);

% options for linprog algorithms
options = optimset('algorithm','interior-point','Display','off',...
  'TolX',10^-12,'TolFun',10^-12);

rho = nan(size(dS));
for i = 1:length(kappa)

  % try to find coefficients
  % b_1,...,b_n such that b_1 + b_2 + ... b_n is minimal and
  % b_1 dT_1(1:2,:) + b_2 dT_2(1:2,:) + ... + b_n dT_n(1:2,:) = kappa(1:2,:)

  A = reshape(dT.M(:,1:2,i,:),6,[]); % the system of equations
  y = reshape(kappa.M(:,1:2,i),6,1); % the right hand side
  u = dS(i,:).u; % the line energies
  
  % determine coefficients rho with A * rho = y and such that sum |rho_j|
  % is minimal. This is equivalent to the requirement 
  %  rho>=0 and sum(u_jrho_j) -> min 
  % which is the linear programming problem solved below
  try %#ok<TRYNC>
    
    rho(i,:) = linprog(u,[],[],A,y,zeros(size(A,2),1),[],1,options);
 
    progress(i,length(kappa),' fitting: ');

  end
      
end

rho = rho(:,1:size(rho,2)/2) - rho(:,size(rho,2)/2+1:end);
