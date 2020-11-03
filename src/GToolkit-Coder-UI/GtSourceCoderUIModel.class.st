Class {
	#name : #GtSourceCoderUIModel,
	#superclass : #GtCoderUIModel,
	#instVars : [
		'hasFocus',
		'expanded',
		'editorState'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderUIModel >> editorState [
	^ editorState
]

{ #category : #accessing }
GtSourceCoderUIModel >> editorState: anObject [
	editorState := anObject
]

{ #category : #accessing }
GtSourceCoderUIModel >> elementClass [
	^ GtExpandableCoderElement
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> expanded [
	^ expanded
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> focused [
	<return: #Boolean>

	^ hasFocus
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> focused: aBoolean [
	hasFocus = aBoolean
		ifTrue: [ ^ self ].

	hasFocus := aBoolean.

	codersUIModel ifNotNil: [ :theCoders |
		aBoolean
			ifTrue: [ theCoders focusCoderUIModel: self  ]
			ifFalse: [ theCoders unfocusCoderUIModel: self ] ]
]

{ #category : #initialization }
GtSourceCoderUIModel >> initialize [
	super initialize.
	
	hasFocus := false.
	expanded := true
]
