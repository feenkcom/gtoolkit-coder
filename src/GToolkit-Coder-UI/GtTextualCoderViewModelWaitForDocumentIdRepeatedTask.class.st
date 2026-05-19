Class {
	#name : #GtTextualCoderViewModelWaitForDocumentIdRepeatedTask,
	#superclass : #BlRepeatedTask,
	#instVars : [
		'textualCoderViewModel',
		'onUpdatedBlock',
		'onMissedBlock',
		'maxRepetitions',
		'counter'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #initialization }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> initialize [
	super initialize.
	
	onUpdatedBlock := [ :aTextualCoderViewModel :aDocumentId | ].
	onMissedBlock := [ :aTextualCoderViewModel | ].
	
	"Wait delay * maxRepetitions time, 
	which is approximately 500ms * 144 = 72 seconds"
	maxRepetitions := 144.
	counter := 0.
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> maxRepetitions [
	^ maxRepetitions
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> maxRepetitions: anInteger [
	maxRepetitions := anInteger
]

{ #category : #private }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> missed [
	onMissedBlock ifNotNil: [ :aBlock |
		aBlock cull: textualCoderViewModel ].
	self stop.
]

{ #category : #hooks }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> onEnqueuedInElement: anElement [
	element == anElement 
		ifFalse: [ counter := 0 ].

	super onEnqueuedInElement: anElement.
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> onMissedBlock [

	^ onMissedBlock
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> onMissedBlock: aBlock [

	onMissedBlock := aBlock
]

{ #category : #'api - running' }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> onRun [
	| documentId |
	textualCoderViewModel ifNil: [ self missed. ^ self ].
	counter > maxRepetitions ifTrue: [ self missed. ^ self ].
	counter := counter + 1.
	
	documentId := textualCoderViewModel documentId ifNil: [ ^ self ].
	
	onUpdatedBlock ifNotNil: [ :aBlock |
		aBlock cull: textualCoderViewModel cull: documentId ].
	self stop
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> onUpdatedBlock [
	^ onUpdatedBlock
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> onUpdatedBlock: aBlock [
	onUpdatedBlock := aBlock
]

{ #category : #'api - running' }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> stop [ 
	super stop.
	counter := 0.
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> textualCoderViewModel [
	^ textualCoderViewModel
]

{ #category : #accessing }
GtTextualCoderViewModelWaitForDocumentIdRepeatedTask >> textualCoderViewModel: anObject [
	textualCoderViewModel := anObject
]
