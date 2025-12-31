function photon_energy_eV = convert_nm_to_eV(photon_wavelength_nm)
% photon_energy_eV = convert_nm_to_eV(photon_wavelength_nm)
%   This function converts an input photon wavelength in nm to a photon 
%   energy in eV.
pc = physics_constants();
photon_energy_eV = 1e9 .* pc.h .* pc.c ./ (photon_wavelength_nm .* pc.e);
end