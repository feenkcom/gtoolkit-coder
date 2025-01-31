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
	aBrTextEditor text
		attributesDo: [ :arr | 
			arr
				detect: [ :att | att class == GtTextFolderAttribute ]
				ifFound: [ :att | 
					folding ifNil: [ folding := att isExpanded ].
					att isExpanded: folding not.
					att applyExpandedOrCollapsedAttributesOnText: aBrTextEditor text ] ]
]
