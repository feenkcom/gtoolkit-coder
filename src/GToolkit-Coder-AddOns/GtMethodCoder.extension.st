Extension { #name : #GtMethodCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> initializeAddOns [
	super initializeAddOns.
	"addOns addStyler: GtCoderCommentStyler new."
	addOns addStyler: (GtFixItStyler new sourceCoder: self).
	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousVectorIcons accept
		action: [ :anEditorElement | self saveFrom: anEditorElement ].
	addOns
		addDropDownWithPreviewAction: 'Remove' translated
		icon: BrGlamorousVectorIcons remove
		action: [ :anEditorElement | self removeFrom: anEditorElement ]
		stencil: [ :element | self buildRemoveMethodLabel: element ].
	addOns
		addMainAction: 'Browse' translated
		icon: BrGlamorousVectorIcons browse
		action: [ :anEditorElement | self browseFrom: anEditorElement ].
	addOns clearChanges
]
