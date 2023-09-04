#!/usr/bin/env bash

set -eux

# filtering pandora VCF to SNPs and Phased SNPs
if [[ ! -f pandora_multisample_genotyped.vcf.gz ]]; then
    bgzip -f pandora_multisample_genotyped.vcf
fi

tabix -f pandora_multisample_genotyped.vcf.gz
bcftools view -i 'INFO/VC="SNP" || INFO/VC="PH_SNPs"' pandora_multisample_genotyped.vcf.gz > pandora_multisample_genotyped.snps_only.vcf

# compressing and indexing the vcf
if [[ ! -f pandora_multisample_genotyped.snps_only.vcf.gz ]]; then
    bgzip -f pandora_multisample_genotyped.snps_only.vcf
fi
tabix -f pandora_multisample_genotyped.snps_only.vcf.gz

# building the tree
PATH="lyve-SET/scripts":$PATH perl lyve-SET/scripts/set_processPooledVcf.pl pandora_multisample_genotyped.snps_only.vcf.gz
