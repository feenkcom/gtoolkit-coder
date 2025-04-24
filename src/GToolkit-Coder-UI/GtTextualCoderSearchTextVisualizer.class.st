Class {
	#name : #GtTextualCoderSearchTextVisualizer,
	#superclass : #BrEditorSearchTextVisualizer,
	#instVars : [
		'textualCoderViewModel',
		'actions'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #accessing }
GtTextualCoderSearchTextVisualizer >> action: aBlock [
	"Add action this is executed on every finished styler.
	The action is NOT executed in a UI process."

	actions := self actions copyWith: aBlock
]

{ #category : #accessing }
GtTextualCoderSearchTextVisualizer >> actions [
	^ actions ifNil: [ actions := Array empty ]
]

{ #category : #accessing }
GtTextualCoderSearchTextVisualizer >> actions: anObject [
	actions := anObject
]

{ #category : #'api - displaying' }
GtTextualCoderSearchTextVisualizer >> executeActionInContext: aBrEditorSearchTextVisualizerContext [
	self textualCoderViewModel ifNil: [ ^ self ].

	self actions
		do: [ :eachBlock | eachBlock cull: aBrEditorSearchTextVisualizerContext cull: self textualCoderViewModel ]
]

{ #category : #'api - displaying' }
GtTextualCoderSearchTextVisualizer >> scrollContext: aBrEditorSearchTextVisualizerContext [
	self textualCoderViewModel ifNil: [ ^ self ].

	self textualCoderViewModel
		scrollToLine: aBrEditorSearchTextVisualizerContext selectedLine
		withCharacterPosition: aBrEditorSearchTextVisualizerContext selectedStartPosition
]

{ #category : #'api - displaying' }
GtTextualCoderSearchTextVisualizer >> selectionContext: aBrEditorSearchTextVisualizerContext [
	self textualCoderViewModel ifNil: [ ^ self ].
	
	self scrollContext: aBrEditorSearchTextVisualizerContext.
	self executeActionInContext: aBrEditorSearchTextVisualizerContext.
]

{ #category : #accessing }
GtTextualCoderSearchTextVisualizer >> textualCoderViewModel [
	^ textualCoderViewModel
]

{ #category : #accessing }
GtTextualCoderSearchTextVisualizer >> textualCoderViewModel: anObject [
	textualCoderViewModel := anObject
]
