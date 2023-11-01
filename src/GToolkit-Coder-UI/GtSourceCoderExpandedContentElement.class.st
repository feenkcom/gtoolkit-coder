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

{ #category : #accessing }
GtSourceCoderExpandedContentElement >> actions [
	^ actions
]

{ #category : #initialization }
GtSourceCoderExpandedContentElement >> initialize [
	super initialize.

	editorElement := self newEditorElement.
	actions := self newActionsElement.

	self addChildren: { editorElement . actions }.
	self addAptitude: (BrLayoutResizerAptitude new inherit: editorElement)
]

{ #category : #'instance creation' }
GtSourceCoderExpandedContentElement >> newActionsElement [
	^ GtSourceCoderActionsElement new
		margin: (BlInsets top: 5);
		id: #actions;
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderExpandedContentElement >> newEditorElement [
	^ GtSourceCoderEditorElement new
]

{ #category : #'api - textual coder view model' }
GtSourceCoderExpandedContentElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.

	actions coderViewModel: textualCoderViewModel.
	editorElement textualCoderViewModel: textualCoderViewModel
]
