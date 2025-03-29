## List of known bugs


## Log of updates
**MatBaseX-v1.3 - 2025.03.05:** 

	General Updates:
-> Renamed the software package to 'MatBaseX' to reflect that this software package aims to summarise both material properties & x-ray interactions with matter
-> Significant update to all MATLAB Apps, making them more consistent, modular and efficient to run. 
-> Added options to both export (*.txt) and save (*.mat) data from all database sources within all MATLAB Apps

	1/ Material Properties Database (MPD):
-> New dedicated app that allows the user to add, edit and remove new material compounds with ease.
-> Options to undo all changes and revert to its default state.
-> This can be continuously updated, and all other Apps will call on the values that are defined here.

	2/ Crystallography Viewer (CRYS):



	3/ Photoionization Binding Energy Database (BE):

	4/ Photoionization Cross-Section and Asymmetry Database (XSECT):

	5/ Electron Inelastic Mean Free Path Database (IMFP):

	6/ XPS Sensitivity Factor (SF):

	7/ X-Ray Absorption Edge Database (XAE):

	8/ X-Ray Atomic Scattering Factor Database (XASF):

	9/ PES Data Analysis Software:




**v1.2 - 2024.09.03:** 
-> Updated all MatBase Apps to make them consistent and more modular so they run more efficiently.
--> App_MatBase_IMFP: 
----> Updated and added a new field to show the standard deviation of the IMFP for a given electron kientic energy.
----> Added a new IMFP formalism (JTP method).
--> App_MatBase_Photoionization: 
----> Large update which now allows the user to select the cross-section formalism (Scofield 1973, Yeh & Lindau 1985, Trzhaskovskaya 2018, Cant 2022) and export tabulated cross-section data as a *.txt file over a user-defined photo energy range. 
----> Added new buttons to make plotting of individual or all core-levels more efficient. 
----> Added new buttons to plot the binding energy spectrum of each element, as well as the option to export this as a *.txt file.
--> App_MatBase_PESModelViewer: 
----> A new app that lets the user view all the available PES Models.
--> App_MatBase_PESCurveFitter: 
----> A new app that lets the user curve-fit XPS / PES data.

**v1.0.2 - 2023.11.11:** 
-> Updated the Materials Properties Database (MPD)
---> Added new column called stoichiometry. This is an integer scalar of the stoiciometry of the material (e.g. for elements, stoic = 1, for molecules of the form G_gH_h, the stoiciometry is g + h). Used in the IMFP calculatios.
-> Updated the Photoionisation Cross-Section and Asymmetry Database (PIXSAD)
---> Added 1973 Scofield Database
---> Added 1985 Yeh & Lindau Database
---> Added 2018 Trzhaskovskaya HAXPES Database
---> Added 2022 Cant Database
-> Updated the Photoionisation Energy and Fluorescence Database (PIEFD)
---> Added 1993 Moulder Database
---> Added 2022 Cant Database
-> Updated the IMFP Database
---> Added literature sources for each calculation method.
---> Added the more recent S3 and S4 formalism to determine the effective attenuation length (EAL).

**v1.0.1 - 2023.09.06:** 
--> New App: PES Intensity Modelling of an N-Layer system.

**v1.0.0 - 2023.07.21:** MatBase published.