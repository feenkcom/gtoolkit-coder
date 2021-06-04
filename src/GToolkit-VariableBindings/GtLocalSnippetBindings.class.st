"
GtLocalSnippetBindings provide a multi-tier set of bindings, allowing snippets to have local variables, e.g.  `thisSnippet`, and shared variables.

 
1. # Internal Representation and Key Implementation Points.


1. ## Instance Variables

	localBindings:		<IdentityDictionary> 	Bindings local to the user of these bindings
	sharedBindings:		<GtSnippetBindings>	Bindings shared amongst muiltiple users


1. ## Implementation Points


"
Class {
	#name : #GtLocalSnippetBindings,
	#superclass : #Object,
	#traits : 'GtBindingsTrait + TGtAssert',
	#classTraits : 'GtBindingsTrait classTrait + TGtAssert classTrait',
	#instVars : [
		'sharedBindings',
		'localBindings'
	],
	#category : #'GToolkit-VariableBindings-Core'
}

{ #category : #comparing }
GtLocalSnippetBindings >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ sharedBindings = anObject sharedBindings
		and: [ localBindings = anObject localBindings ]
]

{ #category : #accessing }
GtLocalSnippetBindings >> allNames [ 

	^ self localNames, self sharedNames 
]

{ #category : #converting }
GtLocalSnippetBindings >> asDictionary [
	<return: #Dictionary>
	| dictionary |
	
	dictionary := localBindings copy.
	dictionary addAll: sharedBindings bindings.
	^ dictionary
]

{ #category : #accessing }
GtLocalSnippetBindings >> at: aSymbol put: anObject [ 
	"By default, bindings are global"

	^ localBindings
		at: aSymbol
		ifPresent: [ localBindings at: aSymbol put: anObject ]
		ifAbsent: [ sharedBindings at: aSymbol put: anObject ].

]

{ #category : #binding }
GtLocalSnippetBindings >> bindingOf: aSymbol [

	^ localBindings
		at: aSymbol 
		ifPresent: [ :aValue | aValue ] 
		ifAbsent: [ sharedBindings bindingOf: aSymbol ]
]

{ #category : #'gt-extension' }
GtLocalSnippetBindings >> gtBindingsFor: aView [
	<gtView>
	^ self asDictionary gtItemsFor: aView
]

{ #category : #binding }
GtLocalSnippetBindings >> hasBindingOf: aSymbol [
	^ (sharedBindings hasBindingOf: aSymbol) or: [ localBindings includesKey: aSymbol ]
]

{ #category : #comparing }
GtLocalSnippetBindings >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ sharedBindings hash bitXor: localBindings hash
]

{ #category : #initialization }
GtLocalSnippetBindings >> initialize [ 

	super initialize.
	localBindings := IdentityDictionary new.
]

{ #category : #accessing }
GtLocalSnippetBindings >> localAt: aSymbol put: anObject [ 

	self assert: [ aSymbol isSymbol ] description: [ 'Variable name should be a symbol' ].
	localBindings 
		at: aSymbol 
		put: ((WorkspaceVariable named: aSymbol) value: anObject)
]

{ #category : #accessing }
GtLocalSnippetBindings >> localBindings [
	^ localBindings
]

{ #category : #accessing }
GtLocalSnippetBindings >> localBindings: anObject [
	localBindings := anObject
]

{ #category : #accessing }
GtLocalSnippetBindings >> localNames [
	"Answer the names of the local bindings"

	^ localBindings keys
]

{ #category : #copying }
GtLocalSnippetBindings >> postCopy [
	sharedBindings := sharedBindings copy.
	localBindings := localBindings copy
]

{ #category : #accessing }
GtLocalSnippetBindings >> receiver [ 

	^ sharedBindings receiver
]

{ #category : #accessing }
GtLocalSnippetBindings >> receiver: anObject [

	sharedBindings receiver: anObject
]

{ #category : #accessing }
GtLocalSnippetBindings >> receiverClass [
	^ sharedBindings receiver class
]

{ #category : #removing }
GtLocalSnippetBindings >> remove: aSymbol [
	self assert: [ aSymbol isSymbol ] description: [ 'Variable name should be a symbol' ].
	localBindings 
		removeKey: aSymbol
		ifAbsent: [ sharedBindings remove: aSymbol ]
]

{ #category : #accessing }
GtLocalSnippetBindings >> sharedBindings [
	^ sharedBindings
]

{ #category : #accessing }
GtLocalSnippetBindings >> sharedBindings: anObject [
	sharedBindings := anObject
]

{ #category : #accessing }
GtLocalSnippetBindings >> sharedNames [

	^ sharedBindings names
]
