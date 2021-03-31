Class {
	#name : #GtSourceCoderViewModel,
	#superclass : #GtTextualCoderViewModel,
	#instVars : [
		'evaluationResult'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #'api - actions' }
GtSourceCoderViewModel >> debug [
	^ self selection isEmpty
		ifTrue: [ self debugAll ]
		ifFalse: [ self debugIt: self selectedTextInterval ]
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> debugAll [
	^ self coderModel debugInContext: self evaluationContext all
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> debugIt: aTextInterval [
	^ self coderModel debugInContext: (self evaluationContext
		from: aTextInterval first to: aTextInterval last)
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> discardChanges [
	self coder discardChanges
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doIt [
	"Evaluate a piece of source code within a selection interval or everything if nothing is selected and return a result"
	<return: #Object>
	
	^ self doItRequestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doIt: aTextInterval [
	"Evaluate a piece of source code within an interval and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>
	
	^ self doIt: aTextInterval requestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doIt: aTextInterval requestedBy: aRequesterObject [
	"Evaluate source code within given text interval and return the result"

	^ self coderModel doItInContext: (self evaluationContext
		from: aTextInterval first to: aTextInterval last;
		requesterObject: aRequesterObject)
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAll [
	"Evaluate the whole source code and return the result"

	^ self doItAllRequestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAllRequestedBy: aRequesterObject [
	"Evaluate the whole source code independent from the selection and return the result"

	^ self coder doItInContext: (self evaluationContext
		all;
		requesterObject: aRequesterObject)
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAndGo [
	"Evaluate selected source code or everything if there is nothing selected and inspect the result"

	^ self selection isEmpty
		ifTrue: [ self doItAndGoAll ]
		ifFalse: [ self doItAndGo: self selectedTextInterval ]
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAndGo: aTextInterval [
	"Evaluate a piece of source code within an interval and inspect a result."

	^ self coder doItAndGoInContext: (self evaluationContext from: aTextInterval first to: aTextInterval last)
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAndGoAll [
	"Evaluate the whole source code and inspect the result"

	^ self coder doItAndGoInContext: self evaluationContext all
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItRequestedBy: aRequesterObject [
	"Evaluate selected source code or everything if there is nothing selected and return the result"

	^ self selection isEmpty
		ifTrue: [ self doItAllRequestedBy: aRequesterObject ]
		ifFalse: [ self doIt: self selectedTextInterval requestedBy: aRequesterObject ]
]

{ #category : #accessing }
GtSourceCoderViewModel >> elementClass [
	^ GtExpandableSourceCoderElement
]

{ #category : #'private - evaluation' }
GtSourceCoderViewModel >> evaluationContext [
	<return: #GtSourceCoderEvaluationContext>

	^ self coderModel evaluationContext
		requesterObject: self
]

{ #category : #accessing }
GtSourceCoderViewModel >> evaluationResult [
	^ evaluationResult
]

{ #category : #accessing }
GtSourceCoderViewModel >> evaluationResult: anObject [
	evaluationResult := anObject
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> printIt [
	"Evaluate selected source code or everything if there is nothing selected and print the result"

	^ self selection isEmpty
		ifTrue: [ self printItAll ]
		ifFalse: [ self printIt: self selectedTextInterval ]
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> printIt: aTextInterval [
	"Evaluate a piece of source code within an interval and print a result."

	^ self coder printItInContext: (self evaluationContext from: aTextInterval first to: aTextInterval last)
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> printItAll [
	"Evaluate the whole source code and print the result"

	^ self coder printItInContext: self evaluationContext all
]

{ #category : #'private - evaluation' }
GtSourceCoderViewModel >> selectedTextInterval [
	<return: #Interval>
	| anInterval |
	anInterval := 1 to: 0.
	self selection do: [ :eachMonotoneSelection | 
		anInterval := eachMonotoneSelection from + 1 to: eachMonotoneSelection to ].
	^ anInterval
]
