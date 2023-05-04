*  `Final_candidates_sorted`:
Logan's 119 DN gene list

*  `Dsim/Dyak_synteny_positions`:
Query_gene_ID	upstream_Flybase_ID	downstream_Flybase_ID	chromosome	start	end

*  `Dsim/Dyak_synteny_manual_check`:
If orthologs were found on two different chromosome: output
Query_gene_ID	upstream_Flybase_ID	downstream_Flybase_ID	up_chromosome	down_chromosome

If one ortholog is missing, output
Query_gene_ID	upstream_Flybase_ID	downstream_Flybase_ID	up_chromosome	down_chromosome	position_of_up/down

*  `Synteny_ortholog_positions`:
Species	Query_gene_ID	Species_chromosome	start	end	length
Dsim	G3298	2R	9952727	9963505	10778

*  `Synteny_positions_and_orthologs`:
Query_gene_type	Query_gene_ID	dmel_chr	start	end	dmel_nearest_upstream_gene	dmel_distance_to_up	dmel_nearest_downstream_gene	dmel_distance_to_down	dsim_nearest_upstream_geme	dsim_nearest_downstream_gene	dyak_nearest_upstream_gene	dyak_nearest_downstream_gene

*  Used dmel r6.41 gtf to determine intronic vs. intergenic

*  Used dmel r6.41 concat fasta

*  Perl scripts used:

```
perl /home/juliecridland/scripts/get_synteny_positions_dmel.pl Final_candidates_sorted /data/FlyRef/dmel_orthologs_in_drosophila_species_fb_2021_02.tsv Synteny_positions_and_orthologs
```

#### Get the positions of the orthologs

```
perl /home/juliecridland/scripts/get_ortholog_positions_for_synteny.pl yak Synteny_positions_and_orthologs /data/FlyRef/Dyak_gene_ranges Dyak_synteny_positions Dyak_synteny_manual_check
 
perl /home/juliecridland/scripts/get_ortholog_positions_for_synteny.pl sim Synteny_positions_and_orthologs /data/FlyRef/Dsim_gene_ranges Dsim_synteny_positions Dsim_synteny_manual_check
```

#### Make a fasta with a region around the candidates

```
perl /home/ygeluo/scripts/synteny/get_region_X_around_candidates.pl Final_candidates_sorted 5000 /data/ygeluo/AG_Denovo/dmel-all-chromosome-r6.41.concat.fasta DN_plus5kb.fasta DN_all_positions
```

#### Blast the output to the outgroup genomes

```
blastn -db /data/FlyRef/blast/dsim-all-chromosome-r2.02 -query DN_plus5kb.fasta -out DN_plus5kb.to.Dsim.align -outfmt 6 -evalue 1e-6
 
blastn -db /data/FlyRef/blast/dyak-chromosome-r1.05 -query DN_plus5kb.fasta -out DN_plus5kb.to.Dyak.align -outfmt 6 -evalue 1e-6
```

#### Get the positions of the outgroup matches

```
perl /home/ygeluo/scripts/synteny/get_synteny_regions.pl DN_all_positions . Synteny_ortholog_positions > Synteny_ortholog_no_match
```

#### Next compare the blasted positions to the expected region based on orthologous genes

```
perl /home/juliecridland/scripts/compare_ortholog_positions_to_candidate_ortho_blast.pl Dsim_synteny_positions Synteny_ortholog_positions Dsim_synteny_confirmed > Dsim_synteny_not_confirmed
 
perl /home/juliecridland/scripts/compare_ortholog_positions_to_candidate_ortho_blast.pl Dyak_synteny_positions Synteny_ortholog_positions Dyak_synteny_confirmed > Dyak_synteny_not_confirmed

```
