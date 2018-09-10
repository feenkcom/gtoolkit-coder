converting
bodyElement
	| styler completionStrategy completionController editorElement editor text |
	styler := BrRBMethodBodyTextStyler new.
	styler classOrMetaClass: class.
	styler methodPatternSource: ast pattern source.
	editor := BrTextEditor new.
	editor styler: styler.
	text := bodySource asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}.
	editor text: text.
	editorElement := BrEditorElement new.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	editorElement editor: editor.
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: class.
	completionStrategy methodPattern: ast pattern.
	completionController := GtCompletionController on: editorElement strategy: completionStrategy.
	completionController install.
	^ editorElement