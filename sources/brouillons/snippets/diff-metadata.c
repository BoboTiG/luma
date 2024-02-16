/* https://github.com/git/git/blob/v2.43.0/diff.c#L4480-L4484 */
static void fill_metainfo(
    struct strbuf *msg,
    const char *name,
    const char *other,
    struct diff_filespec *one,
    struct diff_filespec *two,
    struct diff_options *o,
    struct diff_filepair *p,
    int *must_show_header,
    int use_color
) {
    /* (…) */
    strbuf_addf(
        msg,
        "%s%sindex %s..%s",
        line_prefix,
        set,
        diff_abbrev_oid(&one->oid, abbrev),
        diff_abbrev_oid(&two->oid, abbrev)
    );
    if (one->mode == two->mode) {
        strbuf_addf(msg, " %06o", one->mode);
    }
}
