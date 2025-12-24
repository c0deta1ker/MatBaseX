function photon_wavelength_nm = convert_eV_to_nm(photon_energy_eV)
% photon_wavelength_nm = convert_eV_to_nm(photon_energy_eV)
%   This function converts an input photon energy in eV to a photon
%   wavelength in nm.
pc = physics_constants();
photon_wavelength_nm = 1e9 .* pc.h .* pc.c ./ (photon_energy_eV .* pc.e);
end