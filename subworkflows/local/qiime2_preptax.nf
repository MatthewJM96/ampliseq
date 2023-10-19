/*
 * Prepares reference taxonomy for either training a classifier or for use in consensus
 * blast classification.
 */

include { FORMAT_TAXONOMY_QIIME } from '../../modules/local/format_taxonomy_qiime'
include { QIIME2_EXTRACT        } from '../../modules/local/qiime2_extract'

workflow QIIME2_PREPTAX {
    take:
    ch_qiime_ref_taxonomy //channel, list of files
    FW_primer //val
    RV_primer //val

    main:
    FORMAT_TAXONOMY_QIIME ( ch_qiime_ref_taxonomy )

    ch_ref_database = FORMAT_TAXONOMY_QIIME.out.fasta.combine(FORMAT_TAXONOMY_QIIME.out.tax)
    ch_ref_database
        .map {
            db ->
                def meta = [:]
                meta.FW_primer = FW_primer
                meta.RV_primer = RV_primer
                [ meta, db ] }
        .set { ch_ref_database }
    QIIME2_EXTRACT ( ch_ref_database )

    emit:
    qza      = QIIME2_EXTRACT.out.qza
    versions = QIIME2_EXTRACT.out.versions
}
