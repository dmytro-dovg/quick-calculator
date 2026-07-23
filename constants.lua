local C = {}
C.debug = {
    logging_enabled = true,
}
C.mod_name = "quick-calculator"
C.gui = {
    main_frame = C.mod_name .. "-main-frame",
    input_textfield = C.mod_name .. "-input-textfield",
    result_textfield = C.mod_name .. "-result-textfield",
    cross_button = C.mod_name .. "-cross-button",
}

return C
