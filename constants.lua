local C = {}
C.debug = {
    logging_enabled = false,
}
C.mod_name = "quick-calculator"
C.gui = {
    main_frame = C.mod_name .. "-main-frame",
    input_textfield = C.mod_name .. "-input-textfield",
    result_textfield = C.mod_name .. "-result-textfield",
    cross_button = C.mod_name .. "-cross-button",
    history_button = C.mod_name .. "-history-button",
    history = {
        pattern = "^quick%-calculator%-history[%a%-]+_(%d+)$",
        expression_label = C.mod_name .. "-history-expression-label_",
        result_label = C.mod_name .. "-history-result-label_",
        flow = C.mod_name .. "-history-flow_",
    },
}
C.toggle_shortcut = "quick-calculator-toggle"

return C
