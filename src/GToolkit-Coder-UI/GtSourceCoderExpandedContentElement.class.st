Class {
	#name : #GtSourceCoderExpandedContentElement,
	#superclass : #GtSourceCoderContentElement,
	#instVars : [
		'editorElement',
		'actions'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

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
	^ GtCoderActionsElement new
		margin: (BlInsets top: 5);
		id: #actions;
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderExpandedContentElement >> newEditorElement [
	^ GtSourceCoderEditorElement new
		id: GtSourceCoderEditorId uniqueInstance
]

{ #category : #'api - textual coder view model' }
GtSourceCoderExpandedContentElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	actions coderUIModel: textualCoderViewModel.
	editorElement textualCoderViewModel: textualCoderViewModel
]
