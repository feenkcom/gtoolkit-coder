Class {
	#name : #GtSnippetBindings,
	#superclass : #Object,
	#traits : 'GtBindingsTrait + TGtAssert',
	#classTraits : 'GtBindingsTrait classTrait + TGtAssert classTrait',
	#instVars : [
		'bindings',
		'receiver'
	],
	#category : #'GToolkit-VariableBindings-Core'
}

{ #category : #comparing }
GtSnippetBindings >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ receiver = anObject receiver and: [ bindings = anObject bindings ]
]

{ #category : #converting }
GtSnippetBindings >> asDictionary [
	<return: #Dictionary>
	^ bindings copy
]

{ #category : #adding }
GtSnippetBindings >> at: aSymbol put: anObject [ 
	self assert: [ aSymbol isSymbol ] description: [ 'Variable name should be a symbol' ].
	bindings 
		at: aSymbol 
		put: ((WorkspaceVariable named: aSymbol) value: anObject)
]

{ #category : #binding }
GtSnippetBindings >> bindingOf: aSymbol [
	^ bindings
		at: aSymbol 
		ifPresent: [ :aValue | aValue ] 
		ifAbsent: [ nil ]
]

{ #category : #accessing }
GtSnippetBindings >> bindings [
	^ bindings
]

{ #category : #'gt-extension' }
GtSnippetBindings >> gtBindingsFor: aView [
	<gtView>
	^ bindings gtItemsFor: aView
]

{ #category : #binding }
GtSnippetBindings >> hasBindingOf: aSymbol [
	^ bindings includesKey: aSymbol
]

{ #category : #comparing }
GtSnippetBindings >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ receiver hash bitXor: bindings hash
]

{ #category : #initialization }
GtSnippetBindings >> initialize [
	super initialize.
	bindings := Dictionary new.
	receiver := nil.
]

{ #category : #accessing }
GtSnippetBindings >> names [ 

	^ bindings keys
]

{ #category : #accessing }
GtSnippetBindings >> receiver [
	^ receiver
]

{ #category : #accessing }
GtSnippetBindings >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
GtSnippetBindings >> receiverClass [
	^ self receiver class
]

{ #category : #removing }
GtSnippetBindings >> remove: aSymbol [
	self assert: [ aSymbol isSymbol ] description: [ 'Variable name should be a symbol' ].
	bindings 
		removeKey: aSymbol
		ifAbsent: [ "ignore" ]
]
