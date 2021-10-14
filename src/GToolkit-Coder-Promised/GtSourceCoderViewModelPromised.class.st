Class {
	#name : #GtSourceCoderViewModelPromised,
	#superclass : #GtTextualCoderViewModelPromised,
	#instVars : [
		'evaluationResult'
	],
	#category : #'GToolkit-Coder-Promised'
}

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> debug [
	^ self selection isEmpty
		ifTrue: [ self debugAll ]
		ifFalse: [ self debugIt: self selectedTextInterval ]
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> debugAll [
	^ self coderModel debugInContext: self evaluationContext all
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> debugIt: aTextInterval [
	^ self coderModel debugInContext: (self evaluationContext
		from: aTextInterval first to: aTextInterval last)
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> discardChanges [
	self coder discardChanges
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doIt [
	"Evaluate a piece of source code within a selection interval or everything if nothing is selected and return a result"
	<return: #Object>
	
	^ self doItRequestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doIt: aTextInterval [
	"Evaluate a piece of source code within an interval and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>
	
	^ self doIt: aTextInterval requestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doIt: aTextInterval requestedBy: aRequesterObject [
	"Evaluate source code within given text interval and return the result"

	^ self coderModel doItInContext: (self evaluationContext
		from: aTextInterval first to: aTextInterval last;
		requesterObject: aRequesterObject)
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doItAll [
	"Evaluate the whole source code and return the result"

	^ self doItAllRequestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doItAllRequestedBy: aRequesterObject [
	"Evaluate the whole source code independent from the selection and return the result"

	^ self coder doItInContext: (self evaluationContext
		all;
		requesterObject: aRequesterObject)
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doItAndGo [
	"Evaluate selected source code or everything if there is nothing selected and inspect the result"

	^ self selection isEmpty
		ifTrue: [ self doItAndGoAll ]
		ifFalse: [ self doItAndGo: self selectedTextInterval ]
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doItAndGo: aTextInterval [
	"Evaluate a piece of source code within an interval and inspect a result."

	^ self coder doItAndGoInContext: (self evaluationContext from: aTextInterval first to: aTextInterval last)
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doItAndGoAll [
	"Evaluate the whole source code and inspect the result"

	^ self coder doItAndGoInContext: self evaluationContext all
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> doItRequestedBy: aRequesterObject [
	"Evaluate selected source code or everything if there is nothing selected and return the result"

	^ self selection isEmpty
		ifTrue: [ self doItAllRequestedBy: aRequesterObject ]
		ifFalse: [ self doIt: self selectedTextInterval requestedBy: aRequesterObject ]
]

{ #category : #accessing }
GtSourceCoderViewModelPromised >> elementClass [
	^ super elementClass
	"^ GtExpandableSourceCoderElement"
]

{ #category : #'private - evaluation' }
GtSourceCoderViewModelPromised >> evaluationContext [
	<return: #GtSourceCoderEvaluationContext>

	^ self coderModel evaluationContext
		requesterObject: self
]

{ #category : #accessing }
GtSourceCoderViewModelPromised >> evaluationResult [
	^ evaluationResult
]

{ #category : #accessing }
GtSourceCoderViewModelPromised >> evaluationResult: anObject [
	evaluationResult := anObject
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> printIt [
	"Evaluate selected source code or everything if there is nothing selected and print the result"

	^ self selection isEmpty
		ifTrue: [ self printItAll ]
		ifFalse: [ self printIt: self selectedTextInterval ]
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> printIt: aTextInterval [
	"Evaluate a piece of source code within an interval and print a result."

	^ self coder printItInContext: (self evaluationContext from: aTextInterval first to: aTextInterval last)
]

{ #category : #'api - actions' }
GtSourceCoderViewModelPromised >> printItAll [
	"Evaluate the whole source code and print the result"

	^ self coder printItInContext: self evaluationContext all
]

{ #category : #'private - evaluation' }
GtSourceCoderViewModelPromised >> selectedTextInterval [
	<return: #Interval>
	| anInterval |
	anInterval := 1 to: 0.
	self selection do: [ :eachMonotoneSelection | 
		anInterval := eachMonotoneSelection from + 1 to: eachMonotoneSelection to ].
	^ anInterval
]
