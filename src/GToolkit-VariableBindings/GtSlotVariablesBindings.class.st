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

{ #category : 'accessing' }
GtSlotVariablesBindings >> object [

	^ object
]

{ #category : 'accessing' }
GtSlotVariablesBindings >> object: anObject [

	object := anObject
]
