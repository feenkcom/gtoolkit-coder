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

	self addChangeAddChildAs: { #content . GtSourceCoder sourceEditorName } with: [ editorElement ].
	self addChangeAddChildAs: #(content actions) with: [ actions ].
	
	self add: (BrLayoutResizerLook new inherit: editorElement)
]

{ #category : #initialization }
GtSourceCoderEditorLook >> initializeListeners [
	super initializeListeners.
	
	self when: GtCoderSaveUIModelWish do: [ :anEvent | self onSaveSourceCoderUIModel: anEvent coderUIModel ]
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
	editorElement sourceCoderUIModel: aGtSourceCoderUIModel
]

{ #category : #hooks }
GtSourceCoderEditorLook >> onSaveSourceCoderUIModel: aGtSourceCoderUIModel [
	editorElement onSaveSourceCoderUIModel: aGtSourceCoderUIModel
]
