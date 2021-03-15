Class {
	#name : #GtSourceCoderEditorLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'sourceCoderUIModel',
		'editorElement',
		'interactions',
		'completion',
		'actions'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #accessing }
GtSourceCoderEditorLook >> editorElement [
	<return: #GtSourceCoderEditorElement>

	^ editorElement
]

{ #category : #initialization }
GtSourceCoderEditorLook >> initialize [
	super initialize.
	
	editorElement := self newEditorElement.
	actions := self newActionsElement.

	self addChangeAddChildAs: { #content . GtSourceCoderEditorId uniqueInstance asSymbol } with: [ editorElement ].
	self addChangeAddChildAs: #(content actions) with: [ actions ].
	
	self add: (BrLayoutResizerLook new inherit: editorElement)
]

{ #category : #'instance creation' }
GtSourceCoderEditorLook >> newActionsElement [
	^ GtCoderActionsElement new
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderEditorLook >> newEditorElement [
	^ GtSourceCoderEditorElement new
]

{ #category : #hooks }
GtSourceCoderEditorLook >> onCoderChanged: aGtSourceCoderUIModel [
	actions coderUIModel: aGtSourceCoderUIModel.
	editorElement textualCoderViewModel: aGtSourceCoderUIModel
]
