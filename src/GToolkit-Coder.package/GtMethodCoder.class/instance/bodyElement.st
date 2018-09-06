converting
bodyElement
	| styler completionStrategy completionController editorElement editor |
	styler := BrRBMethodBodyTextStyler new.
	styler classOrMetaClass: class.
	styler methodPatternSource: ast pattern source.
	editor := BrTextEditor new.
	editor styler: styler.
	editor text: bodySource asRopedText.
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