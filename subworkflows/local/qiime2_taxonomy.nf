/*
 * Taxonomic classification with QIIME2
 */

include { QIIME2_CLASSIFY               } from '../../modules/local/qiime2_classify'

workflow QIIME2_TAXONOMY {
    take:
    ch_fasta
    ch_classifier

    main:
    QIIME2_CLASSIFY ( ch_classifier, ch_fasta )

    emit:
    qza      = QIIME2_CLASSIFY.out.qza
    tsv      = QIIME2_CLASSIFY.out.tsv
    versions = QIIME2_CLASSIFY.out.versions
}
