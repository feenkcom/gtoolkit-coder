Class {
	#name : 'GtSlotVariablesBindings',
	#superclass : 'Object',
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#instVars : [
		'object'
	],
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'comparing' }
GtSlotVariablesBindings >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ object = anObject object
]

{ #category : 'binding' }
GtSlotVariablesBindings >> bindingNames [
	^ object slotNames
]

{ #category : 'binding' }
GtSlotVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ object class
		slotNamed: aSymbol
		ifFound: [ :aSlot | aSlot ]
		ifNone: [ nil ]
]

{ #category : 'testing' }
GtSlotVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ object class
		slotNamed: aSymbol
		ifFound: [ :slot | true ]
		ifNone: [ false ]
]

{ #category : 'comparing' }
GtSlotVariablesBindings >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ object hash
]

{ #category : 'accessing' }
GtSlotVariablesBindings >> object [

	^ object
]

{ #category : 'accessing' }
GtSlotVariablesBindings >> object: anObject [

	object := anObject
]
