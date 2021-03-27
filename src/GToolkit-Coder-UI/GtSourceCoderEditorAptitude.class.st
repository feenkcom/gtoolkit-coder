Class {
	#name : #GtSourceCoderEditorAptitude,
	#superclass : #GtSourceCoderAptitude,
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
GtSourceCoderEditorAptitude >> editorElement [
	<return: #GtSourceCoderEditorElement>

	^ editorElement
]

{ #category : #initialization }
GtSourceCoderEditorAptitude >> initialize [
	super initialize.
	
	editorElement := self newEditorElement.
	actions := self newActionsElement.

	self addChangeAddChildAs: { #content . GtSourceCoderEditorId uniqueInstance asSymbol } with: [ editorElement ].
	self addChangeAddChildAs: #(content actions) with: [ actions ].
	
	self add: (BrLayoutResizerAptitude new inherit: editorElement)
]

{ #category : #'instance creation' }
GtSourceCoderEditorAptitude >> newActionsElement [
	^ GtCoderActionsElement new
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderEditorAptitude >> newEditorElement [
	^ GtSourceCoderEditorElement new
]

{ #category : #hooks }
GtSourceCoderEditorAptitude >> onCoderChanged: aGtSourceCoderUIModel [
	actions coderUIModel: aGtSourceCoderUIModel.
	editorElement textualCoderViewModel: aGtSourceCoderUIModel
]
