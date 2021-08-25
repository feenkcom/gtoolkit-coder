"
1. Coder controller
Is applied on a specific instance of the source coder editor and plays a role of the glue between Coder UI and Coder model


"
Class {
	#name : 'GtSourceCoderRefactoringController',
	#superclass : 'Object',
	#instVars : [
		'coder',
		'sourceElement',
		'originalSource'
	],
	#category : 'GToolkit-Coder-AddOns-! Core'
}

{ #category : 'private - attributes' }
GtSourceCoderRefactoringController >> addRefactoringChangesPreview: aRefactoring at: aTextPosition [
	self
		addRefactoringChangesPreview: aRefactoring
		at: aTextPosition
		whenComplete: nil
]

{ #category : 'private - attributes' }
GtSourceCoderRefactoringController >> addRefactoringChangesPreview: aRefactoring at: aTextPosition whenComplete: aBlock [
	self removeRefactoringAttribute.
	aRefactoring isNil
		ifTrue: [ ^ self ].

	(self sourceText from: aTextPosition to: aTextPosition)
		attributes: {
			(GtRefactoringChangesAttribute new
				refactoring: aRefactoring;
				completionAction: aBlock) }
]

{ #category : 'private' }
GtSourceCoderRefactoringController >> allowSave [
	self sourceElement textualCoderViewModel allowSaveDueTo: self
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> coder [
	^ coder
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> coder: methodCoder [
	coder := methodCoder
]

{ #category : 'executing' }
GtSourceCoderRefactoringController >> execute [
	[
		self saveSource.
		self safelyExecute ]
			on: Error
			do: [ :ex |
				self refactoringFailed.
				NonInteractiveTranscript stderr
					nextPutAll: ('[{1}] {2}' format: { self class name . ex asString });
					cr.
				
				(ex signalerContext stack first: 20) do: [ :eachStackEntry |
					NonInteractiveTranscript stderr
						nextPutAll: eachStackEntry printString;
						cr ].
					
				ex return ]
]

{ #category : 'private' }
GtSourceCoderRefactoringController >> preventSave [
	self sourceElement textualCoderViewModel preventSaveDueTo: self
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> refactoring [
	^ self subclassResponsibility
]

{ #category : 'executing' }
GtSourceCoderRefactoringController >> refactoringFailed [
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> refactoringName [
	^ self subclassResponsibility
]

{ #category : 'private - attributes' }
GtSourceCoderRefactoringController >> removeRefactoringAttribute [
	self sourceEditor text
		clearAttributes: [ :each | each class = GtRefactoringChangesAttribute ]
]

{ #category : 'private' }
GtSourceCoderRefactoringController >> restoreText [
	self setText: originalSource
]

{ #category : 'executing' }
GtSourceCoderRefactoringController >> safelyExecute [
	self subclassResponsibility
]

{ #category : 'executing' }
GtSourceCoderRefactoringController >> saveSource [
	originalSource := self sourceText copy
]

{ #category : 'private' }
GtSourceCoderRefactoringController >> setText: aStringOrText [
	self sourceElement
		text: aStringOrText asRopedText;
		onTextModified
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> sourceEditor [
	^ self sourceElement editor
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> sourceElement [
	^ sourceElement
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> sourceElement: textElement [
	sourceElement := textElement
]

{ #category : 'accessing' }
GtSourceCoderRefactoringController >> sourceText [
	^ self sourceEditor text
]
