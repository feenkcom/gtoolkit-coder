Class {
	#name : #GtCodersUIModel,
	#superclass : #Object,
	#instVars : [
		'coders',
		'coderUIModels',
		'focusedCoderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtCodersUIModel >> coderUIModels [
	^ coderUIModels
]

{ #category : #accessing }
GtCodersUIModel >> coderUIModels: anObject [
	coderUIModels := anObject
]

{ #category : #accessing }
GtCodersUIModel >> coders [
	^ coders
]

{ #category : #accessing }
GtCodersUIModel >> coders: anObject [
	coders := anObject.
	self updateCoderUIModels
]

{ #category : #'api - focus' }
GtCodersUIModel >> focusCoderUIModel: aCoderUIModel [

	focusedCoderUIModel = aCoderUIModel
		ifFalse: [
			focusedCoderUIModel := nil.
			focusedCoderUIModel hasFocus: false ].

	focusedCoderUIModel := aCoderUIModel.
	focusedCoderUIModel hasFocus: true
]

{ #category : #accessing }
GtCodersUIModel >> focusedCoderUIModel [
	^ focusedCoderUIModel
]

{ #category : #'api - focus' }
GtCodersUIModel >> unfocusCoderUIModel: aCoderUIModel [
	focusedCoderUIModel = aCoderUIModel
		ifTrue: [ focusedCoderUIModel := nil ].
		
	aCoderUIModel hasFocus: false
]

{ #category : #updating }
GtCodersUIModel >> updateCoderUIModels [
	coderUIModels := coders coders collect: [ :eachCoder | eachCoder asCoderUIModel expanded: false ]
]
