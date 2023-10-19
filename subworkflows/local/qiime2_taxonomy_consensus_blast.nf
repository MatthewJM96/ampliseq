/*
 * Taxonomic classification with QIIME2
 */

include { QIIME2_INSEQ                    } from '../../modules/local/qiime2_inseq'
include { QIIME2_CLASSIFY_CONSENSUS_BLAST } from '../../modules/local/qiime2_classify_consensus_blast'

workflow QIIME2_TAXONOMY_CONSENSUS_BLAST {
    take:
    ch_fasta
    ch_classifier

    main:
    QIIME2_INSEQ ( ch_fasta )
    QIIME2_CLASSIFY_CONSENSUS_BLAST ( ch_classifier, QIIME2_INSEQ.out.qza )

    emit:
    qza     = QIIME2_CLASSIFY.out.qza
    tsv     = QIIME2_CLASSIFY.out.tsv
    versions= QIIME2_INSEQ.out.versions
}
