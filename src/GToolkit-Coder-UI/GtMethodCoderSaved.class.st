Class {
	#name : #GtMethodCoderSaved,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'method',
		'previousMethod'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method Events'
}

{ #category : #testing }
GtMethodCoderSaved >> isSameMethod [
	previousMethod ifNil: [ ^ false ].
	method ifNil: [ ^ false ].

	^ method methodClass = previousMethod methodClass
		and: [ method selector = previousMethod selector ]
]

{ #category : #accessing }
GtMethodCoderSaved >> method [

	^ method
]

{ #category : #accessing }
GtMethodCoderSaved >> method: aCompiledMethod [

	method := aCompiledMethod
]

{ #category : #accessing }
GtMethodCoderSaved >> previousMethod [
	^ previousMethod
]

{ #category : #accessing }
GtMethodCoderSaved >> previousMethod: aCompiledMethodOrNil [
	previousMethod := aCompiledMethodOrNil
]
