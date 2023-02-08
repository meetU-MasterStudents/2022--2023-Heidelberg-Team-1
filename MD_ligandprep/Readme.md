# Ligand Processing for MD simulation
---

The `.out.pdqt` files were given by autodock vina. The first model was extracted and saved as individual `.pdbqt` file with the prefix `model1`. The `.pdbqt` files were then loaded in Avogadro and the corresponding reference `.mol2` files were downloaded from the zinc database and saved in the directory `zinc_database/`. By one versus one comparisons, the missing atoms and bonds were added and the resulting structure was saved as `.mol2` and `.pdb` file formats. The bonds in the `.mol2` were sorted by the `sort_mol2_bonds.pl` script using following command:

```
perl sort_mol2_bonds.pl model1_moleculeX.mol2 model1_moleculeX_fix.mol2
```
After the these processing steps the autodock vina results are ready for further preparation for the MD simulation.