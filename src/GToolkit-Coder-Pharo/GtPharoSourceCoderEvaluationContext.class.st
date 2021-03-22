Class {
	#name : #GtPharoSourceCoderEvaluationContext,
	#superclass : #GtSourceCoderEvaluationContext,
	#instVars : [
		'notifications',
		'bindingStrategy',
		'receiverObject'
	],
	#category : #'GToolkit-Coder-Pharo-Context'
}

{ #category : #binding }
GtPharoSourceCoderEvaluationContext >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #LiteralVariable or: nil>
	
	^ self bindingStrategy bindingOf: aSymbol
]

{ #category : #accessing }
GtPharoSourceCoderEvaluationContext >> bindingStrategy [
	<return: #GtBindingStrategy>

	^ bindingStrategy
]

{ #category : #accessing }
GtPharoSourceCoderEvaluationContext >> bindingStrategy: aGtBindingStrategy [
	bindingStrategy := aGtBindingStrategy
]

{ #category : #hack }
GtPharoSourceCoderEvaluationContext >> correctFrom: fromIndex to: toIndex with: aString [
	NonInteractiveTranscript stdout
		nextPut: $[;
		nextPutAll: self coder class name;
		nextPut: $];
		space;
		nextPutAll: 'Correct from';
		space;
		print: fromIndex;
		space;
		nextPutAll: ' to ';
		print: toIndex;
		nextPutAll: ' with ';
		print: aString;
		cr.

	self coder
		correctFrom: sourceInterval first + fromIndex - 1
		to: sourceInterval first + toIndex - 1
		with: aString.

	sourceInterval := sourceInterval first to: sourceInterval last + aString size - (toIndex - fromIndex + 1)
]

{ #category : #hack }
GtPharoSourceCoderEvaluationContext >> editor [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #binding }
GtPharoSourceCoderEvaluationContext >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ self bindingStrategy hasBindingOf: aSymbol
]

{ #category : #initialization }
GtPharoSourceCoderEvaluationContext >> initialize [
	super initialize.

	bindingStrategy := GtNoBindings new.
	notifications := OrderedCollection new
]

{ #category : #hack }
GtPharoSourceCoderEvaluationContext >> notify: message at: anIndex in: aString [
	"Hack to work with pharo compiler"
	| aCompleteTextIndex |
	
	aCompleteTextIndex := evaluatedInterval first + anIndex - 1.
	
	NonInteractiveTranscript stdout
		nextPut: $[;
		nextPutAll: self coder class name;
		nextPut: $];
		space;
		nextPutAll: (message copyReplaceAll: '->' with: '') trimmed;
		space;
		nextPutAll: 'at ';
		print: aCompleteTextIndex;
		cr.

	notifications add: (message -> aCompleteTextIndex).
	
	self coder
		notifyParseError: message
		at: aCompleteTextIndex
]

{ #category : #hack }
GtPharoSourceCoderEvaluationContext >> paragraph [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #accessing }
GtPharoSourceCoderEvaluationContext >> receiverObject [
	"Return an object that should be bound to `self`"

	^ receiverObject
]

{ #category : #accessing }
GtPharoSourceCoderEvaluationContext >> receiverObject: anObject [
	"Assign an object that should be bound to self"

	receiverObject := anObject
]

{ #category : #hack }
GtPharoSourceCoderEvaluationContext >> text [
	"Hack to work with pharo compiler"

	^ coder currentSourceString
]

{ #category : #hack }
GtPharoSourceCoderEvaluationContext >> textMorph [
	"Hack to handle inserting local variables"

	^ self
]
