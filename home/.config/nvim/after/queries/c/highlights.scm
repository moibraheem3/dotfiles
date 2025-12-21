;; extends

; (function_definition 
;     (type_identifier) @internal (#eq? @internal "internal"))
;
; (declaration
;     (type_identifier) @global_var (#eq? @global_var "global_var"))

((type_identifier) @keyword.directive
  (#any-of? @keyword.directive
    "internal" "global_var" "local_persist"))

(ERROR) @Type
