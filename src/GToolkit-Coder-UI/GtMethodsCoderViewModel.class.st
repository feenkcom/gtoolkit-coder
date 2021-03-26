Class {
	#name : #GtMethodsCoderViewModel,
	#superclass : #GtCodersUIModel,
	#instVars : [
		'focusedCoderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Methods Model'
}

{ #category : #'api - interations' }
GtMethodsCoderViewModel >> addNewCoder [
	| aNewCoder |
	
	aNewCoder := self coder addNewCoder.
	self
		expandCoder: aNewCoder;
		focusCoder: aNewCoder.
	^ aNewCoder
]

{ #category : #updating }
GtMethodsCoderViewModel >> coderUIModelFor: aCoder [
	^ aCoder asCoderUIModel
		expanded: false;
		selfObject: self coder object
]

{ #category : #accessing }
GtMethodsCoderViewModel >> elementClass [
	^ GtMethodsCoderElement
]

{ #category : #'api - interations' }
GtMethodsCoderViewModel >> expandCoder: aMethodCoder [
	coderUIModels
		detect: [ :eachCoderUIModel | eachCoderUIModel coder = aMethodCoder ]
		ifFound: [ :targetCoderUIModel | targetCoderUIModel expanded: true ]
]

{ #category : #'api - interations' }
GtMethodsCoderViewModel >> focusCoder: aMethodCoder [
	coderUIModels
		detect: [ :eachCoderUIModel | eachCoderUIModel coder = aMethodCoder ]
		ifFound: [ :targetCoderUIModel | self focusCoderUIModel: targetCoderUIModel ]
]

{ #category : #'api - focus' }
GtMethodsCoderViewModel >> focusCoderUIModel: aCoderUIModel [
	(focusedCoderUIModel notNil
		and: [ focusedCoderUIModel ~= aCoderUIModel ])
		ifTrue: [ focusedCoderUIModel focused: false.
			focusedCoderUIModel := nil ].
	focusedCoderUIModel := aCoderUIModel.
	focusedCoderUIModel focused: true
]

{ #category : #accessing }
GtMethodsCoderViewModel >> focusedCoderUIModel [
	<return: #GtCoderUIModel>

	^ focusedCoderUIModel
]

{ #category : #'api - focus' }
GtMethodsCoderViewModel >> unfocusCoderUIModel: aCoderUIModel [
	focusedCoderUIModel = aCoderUIModel
		ifTrue: [ focusedCoderUIModel := nil ].

	aCoderUIModel hasFocus: false
]
