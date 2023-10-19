/*
 * Taxonomic classification with QIIME2
 */

include { QIIME2_INSEQ                    } from '../../modules/local/qiime2_inseq'
include { QIIME2_CLASSIFY_CONSENSUS_BLAST } from '../../modules/local/qiime2_classify_consensus_blast'

workflow QIIME2_TAXONOMY_CONSENSUS_BLAST {
    take:
    ch_fasta
    reference_reads

    main:
    QIIME2_INSEQ ( ch_fasta )
    QIIME2_CLASSIFY_CONSENSUS_BLAST ( QIIME2_INSEQ.out.qza, reference_reads )

    emit:
    qza     = QIIME2_CLASSIFY_CONSENSUS_BLAST.out.qza
    tsv     = QIIME2_CLASSIFY_CONSENSUS_BLAST.out.tsv
    versions= QIIME2_INSEQ.out.versions
}
