Class {
	#name : #GtSlotVariablesBindings,
	#superclass : #Object,
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#instVars : [
		'object'
	],
	#category : #'GToolkit-VariableBindings-Bindings'
}

{ #category : #comparing }
GtSlotVariablesBindings >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ object = anObject object
]

{ #category : #binding }
GtSlotVariablesBindings >> bindingNames [
	^ object class gtSlotNames, object class classVarNames
]

{ #category : #binding }
GtSlotVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ object class
		gtSlotNamed: aSymbol
		ifFound: [ :aSlot | aSlot ]
		ifNone: [
			object class isInstanceSide
				ifTrue: [ object class
					classVariableNamed: aSymbol
					ifAbsent: [ nil ] ]
				ifFalse: [ object
					classVariableNamed: aSymbol
					ifAbsent: [ nil ] ] ]
]

{ #category : #binding }
GtSlotVariablesBindings >> bindingValueOf: aSymbol [
	"aSymbol is a variable name.
	Return a value of the variable."

	^ (self bindingOf: aSymbol) ifNotNil: [ :aSlot | 
		aSlot isClassVariable
			ifTrue: [ aSlot value ]
			ifFalse: [ aSlot read: self object ] ]
]

{ #category : #testing }
GtSlotVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ object class
		gtSlotNamed: aSymbol
		ifFound: [ :slot | true ]
		ifNone: [ object class isInstanceSide
			ifTrue: [ object class hasClassVarNamed: aSymbol ]
			ifFalse: [ object hasClassVarNamed: aSymbol ] ]
]

{ #category : #comparing }
GtSlotVariablesBindings >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ object hash
]

{ #category : #accessing }
GtSlotVariablesBindings >> object [

	^ object
]

{ #category : #accessing }
GtSlotVariablesBindings >> object: anObject [

	object := anObject
]

{ #category : #printing }
GtSlotVariablesBindings >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: object;
		nextPut: $)
]
