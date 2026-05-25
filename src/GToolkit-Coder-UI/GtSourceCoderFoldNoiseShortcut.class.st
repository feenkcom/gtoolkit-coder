Class {
	#name : #GtSourceCoderFoldNoiseShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderFoldNoiseShortcut >> description [
	^ 'Folds instrumentation messages'
]

{ #category : #initialization }
GtSourceCoderFoldNoiseShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftN
]

{ #category : #accessing }
GtSourceCoderFoldNoiseShortcut >> name [
	^ 'Fold Noise'
]

{ #category : #evaluation }
GtSourceCoderFoldNoiseShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
	| folding |
	folding := nil.
	aBrTextEditor styledTextAttributesDo: [ :someAttributes | 
		someAttributes
			detect: [ :eachAttribute | eachAttribute class == GtTextFolderAttributeV2 ]
			ifFound: [ :aFoundAttribute | 
				folding ifNil: [ folding := aFoundAttribute isExpanded ].
				aFoundAttribute isExpanded: folding not.
				aFoundAttribute applyExpandedOrCollapsedIn: aBrEditorElement ] ]
]
