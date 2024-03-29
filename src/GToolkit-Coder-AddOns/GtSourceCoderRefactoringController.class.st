"
1. Coder controller
Is applied on a specific instance of the source coder editor and plays a role of the glue between Coder UI and Coder model


"
Class {
	#name : #GtSourceCoderRefactoringController,
	#superclass : #Object,
	#instVars : [
		'originalSource',
		'sourceCoderViewModel',
		'refactoringPreviewAttributes',
		'element'
	],
	#category : #'GToolkit-Coder-AddOns-! Core'
}

{ #category : #private }
GtSourceCoderRefactoringController >> allowSave [
	self sourceCoderViewModel allowSaveDueTo: self
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> cancelRefactoring [
	self cleanUp.
	self restoreText
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> cleanUp [
	self removeRefactoringAttribute.
	self allowSave
]

{ #category : #executing }
GtSourceCoderRefactoringController >> execute [
	[ self saveSource.
	self safelyExecute ]
		on: Error
		do: [ :ex | 
			self refactoringFailed.
			(ex isKindOf: RBRefactoringError)
				ifTrue: [ self inform: self refactoringName , ': ' , ex messageText ]
				ifFalse: [ self informException: ex.
					NonInteractiveTranscript stderr
						nextPutAll: ('[{1}] {2}'
								format: {self class name.
										ex asString});
						cr.

					(ex signalerContext stack first: 20)
						do: [ :eachStackEntry | 
							NonInteractiveTranscript stderr
								nextPutAll: eachStackEntry printString;
								cr ] ].
			self cancelRefactoring.
			ex return ]
]

{ #category : #executing }
GtSourceCoderRefactoringController >> executeIn: anElement [
	element := anElement.
	^ self execute
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> inform: aString [
	element ifNil: [ ^ super inform: aString ].
	element
		showNotification: (GtNotificationMessage new
				showNotifications;
				message: aString)
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> informException: anException [
	element
		showNotification: (GtObjectNotificationMessage new
				message: ('[{1}] {2}'
						format: {anException class name.
								anException messageText});
				object: anException copy freeze;
				showNotifications)
]

{ #category : #private }
GtSourceCoderRefactoringController >> preventSave [
	self sourceCoderViewModel preventSaveDueTo: self
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> refactoring [
	^ self subclassResponsibility
]

{ #category : #executing }
GtSourceCoderRefactoringController >> refactoringFailed [
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> refactoringName [
	^ self subclassResponsibility
]

{ #category : #'private - attributes' }
GtSourceCoderRefactoringController >> removeRefactoringAttribute [
	refactoringPreviewAttributes ifNil: [ ^ self ].
	self sourceCoderViewModel
		removeCoderTextAttributes: refactoringPreviewAttributes.
	refactoringPreviewAttributes := nil
]

{ #category : #private }
GtSourceCoderRefactoringController >> restoreText [
	self setText: originalSource
]

{ #category : #executing }
GtSourceCoderRefactoringController >> safelyExecute [
	self subclassResponsibility
]

{ #category : #executing }
GtSourceCoderRefactoringController >> saveSource [
	originalSource := self sourceText copy
]

{ #category : #private }
GtSourceCoderRefactoringController >> setText: aStringOrText [	
	self sourceCoderViewModel
		sourceText: aStringOrText asRopedText
		from: self
		synchronously: true
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> sourceCoderViewModel [
	<return: #GtSourceCoderViewModel>

	^ sourceCoderViewModel
]

{ #category : #initialization }
GtSourceCoderRefactoringController >> sourceCoderViewModel: aSourceCoderViewModel [
	sourceCoderViewModel := aSourceCoderViewModel
]

{ #category : #accessing }
GtSourceCoderRefactoringController >> sourceText [
	^ self sourceCoderViewModel sourceText copy
]
