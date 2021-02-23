function [coeff, Zin] = wireDipoleAntenna(L, a, nSegments, excitedSeg, freq, k, V, printData)
    %%%%%%%%%%%%%%%%%
    % input variables
    %%%%%%%%%%%%%%%%%
    % L = length of the wire
    % a = radius of the wire
    % nSegments = number of segments in the wire
    % freq = frequency
    % k = free space wave number
    % V = applied voltage
    % printData = flag to print output data

    %%%%%%%%%%%%%%%%%%
    % output variables
    %%%%%%%%%%%%%%%%%%
    % coeff = weights of the basis functions
    % Zin = input impedance of the wire
    
    % solving using gap generation model method
    e0 = 8.85418*1e-12;  % permittivity of free space
    w = 2*pi*freq;  % angular frequency
    delta = L/nSegments;  % step size
    Ezi = zeros(nSegments, 1);  % incident em wave
    Ezi(excitedSeg) = V/delta;  % electric field at the excited segment
    z = zeros(nSegments, 1);  % central points of each section

    z(1) = (-L/2)+(delta/2);
    for m = 2:nSegments
        z(m) = z(m-1)+delta; 
    end

    A = zeros(nSegments, nSegments);
    syms x;
    for m = 1:nSegments
        for n = 1:nSegments
            r = sqrt(a^2+(z(m)-x)^2);
            Ker = (exp(-1j*k*r)/(r^5))*((1+1j*k*r)*(2*r*r-3*a*a)+((k*a*r)^2));
            A(m, n) = (1/(4*pi*w*e0*1j))*int(Ker, x, z(n)-delta/2, z(n)+delta/2);
        end
    end

    coeff = pinv(A)*(-Ezi);  % the weights of pulses
    Zin = V/alpha(excitedSeg);
    
    % TODO add code to print data
end