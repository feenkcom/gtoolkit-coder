Extension { #name : #PrettyTextDiffBuilder }

{ #category : #'*GToolkit-Coder' }
PrettyTextDiffBuilder >> newStyler [
	^ BrRBTextStyler new classOrMetaClass: sourceClass
]
