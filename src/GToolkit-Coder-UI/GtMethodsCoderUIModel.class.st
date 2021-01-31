Class {
	#name : #GtMethodsCoderUIModel,
	#superclass : #GtCodersUIModel,
	#instVars : [
		'focusedCoderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Methods Model'
}

{ #category : #'api - interations' }
GtMethodsCoderUIModel >> addNewCoder [
	| aNewCoder |
	
	aNewCoder := self coder addNewCoder.
	self
		expandCoder: aNewCoder;
		focusCoder: aNewCoder.
	^ aNewCoder
]

{ #category : #updating }
GtMethodsCoderUIModel >> coderUIModelFor: aCoder [
	^ aCoder asCoderUIModel expanded: false
]

{ #category : #accessing }
GtMethodsCoderUIModel >> elementClass [
	^ GtMethodsCoderElement
]

{ #category : #'api - interations' }
GtMethodsCoderUIModel >> expandCoder: aMethodCoder [
	coderUIModels
		detect: [ :eachCoderUIModel | eachCoderUIModel coder = aMethodCoder ]
		ifFound: [ :targetCoderUIModel | targetCoderUIModel expanded: true ]
]

{ #category : #'api - interations' }
GtMethodsCoderUIModel >> focusCoder: aMethodCoder [
	coderUIModels
		detect: [ :eachCoderUIModel | eachCoderUIModel coder = aMethodCoder ]
		ifFound: [ :targetCoderUIModel | self focusCoderUIModel: targetCoderUIModel ]
]

{ #category : #'api - focus' }
GtMethodsCoderUIModel >> focusCoderUIModel: aCoderUIModel [
	(focusedCoderUIModel notNil
		and: [ focusedCoderUIModel ~= aCoderUIModel ])
		ifTrue: [ focusedCoderUIModel focused: false.
			focusedCoderUIModel := nil ].
	focusedCoderUIModel := aCoderUIModel.
	focusedCoderUIModel focused: true
]

{ #category : #accessing }
GtMethodsCoderUIModel >> focusedCoderUIModel [
	<return: #GtCoderUIModel>

	^ focusedCoderUIModel
]

{ #category : #'api - focus' }
GtMethodsCoderUIModel >> unfocusCoderUIModel: aCoderUIModel [
	focusedCoderUIModel = aCoderUIModel
		ifTrue: [ focusedCoderUIModel := nil ].

	aCoderUIModel hasFocus: false
]
