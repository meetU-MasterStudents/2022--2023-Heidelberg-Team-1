# Files for MD Simulation
---
For top 10 candidates a folder is created containing the prepared protein structure (`.pdb`) and small molecule (`mol2` + `pdb`). In the next step the force field for the small molecule is created using `acpype`:
```
acpype -i small_molecule.mol2
```

This command will create a folder `small_molecule.acpype/` containing the necessary files (`_GMX.itp`, `_GMX.gro`, `.prm`) for the next steps. For convenience, you can rename these files to `ligand.file` and change the folder name to `ligand.acpype/`, but the ligand name in the `.itp` file has to be changed to `ligand`. In the next step the topology for `6zsl` is prepared using following commands:
```
gmx pdb2gmx -f 6zsl_vega_woP04.pdb -o 6zsl_processed.gro
```
The `AMBER91SB` force field and the water model `TIP3` is selected (5;1).

In the next step, the `6zsl_processed.gro` file is copied and renamed to `complex.gro`. The atom coordinates from `ligand.acpype/ligand_GMX.gro` are copied and pasted into complex.gro. **The number of atoms in `complex.gro` (in the header) has to be adapted accordingly.** In the next step, the `topol.top` is modified:
```
; Include forcefield parameters
#include "amber99sb.ff/forcefield.itp"

; Include ligand topology
#include "./ligand.acpype/ligand_GMX.itp"

; Include chain topologies
#include "topol_Protein_chain_A.itp"
#include "topol_Protein_chain_B.itp"
#include "topol_Ion_chain_C.itp"
#include "topol_Ion_chain_E.itp"

; Include water topology
#include "amber99sb.ff/tip3p.itp"

; Include ligand parameters
;#include "./ligand.acpype/ligand_CHARMM.prm"

#ifdef POSRES_WATER
; Position restraint for each water oxygen
[ position_restraints ]
;  i funct       fcx        fcy        fcz
   1    1       1000       1000       1000
#endif

; Include topology for ions
#include "amber99sb.ff/ions.itp"

[ system ]
; Name
Protein_ligand in water

[ molecules ]
; Compound        #mols
Protein_chain_A     1
Protein_chain_B     1
Ion_chain_C         1
Ion_chain_E         1
ligand              1
```

The ligand topology in `; Include ligand topology`, the ligand parameters in `; Include ligand parameters` and under `[ molecules ]` one ligand instance is added.  

The next steps can be looked up at the [tutorial](http://www.mdtutorials.com/gmx/complex/) from PhD Justin Lemkul.