Class {
	#name : #GtSourceCoderExpandedContentElement,
	#superclass : #GtSourceCoderContentElement,
	#instVars : [
		'editorElement',
		'actions',
		'tags'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #initialization }
GtSourceCoderExpandedContentElement >> initialize [
	super initialize.

	editorElement := self newEditorElement.
	actions := self newActionsElement.
	tags := self newTagsElement. 

	"self addChildren: { editorElement . actions . tags }."
	self addChildren: { editorElement . actions }.
	self addAptitude: (BrLayoutResizerAptitude new inherit: editorElement)
]

{ #category : #'instance creation' }
GtSourceCoderExpandedContentElement >> newActionsElement [
	^ GtCoderActionsElement new
		margin: (BlInsets top: 5);
		id: #actions;
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderExpandedContentElement >> newEditorElement [
	^ GtSourceCoderEditorElement new
]

{ #category : #initialization }
GtSourceCoderExpandedContentElement >> newTagsElement [
	^ GtPharoMethodCoderTagsElement new
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom.
			c
				margin: (BlInsets
						top: 5
						left: 5
						bottom: 2
						right: 5) ]
]

{ #category : #'api - textual coder view model' }
GtSourceCoderExpandedContentElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.

	actions coderViewModel: textualCoderViewModel.
	editorElement textualCoderViewModel: textualCoderViewModel.
	"tags pharoMethodCoderViewModel: textualCoderViewModel"
]
