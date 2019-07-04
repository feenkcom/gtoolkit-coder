Class {
	#name : #GtClassDefinitionCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'classOrMetaClass'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'as yet unclassified' }
GtClassDefinitionCoder class >> forClass: aBehavior [
	^ self new
		classOrMetaClass: aBehavior;
		yourself
]

{ #category : #accessing }
GtClassDefinitionCoder >> classOrMetaClass [
	^ classOrMetaClass
]

{ #category : #accessing }
GtClassDefinitionCoder >> classOrMetaClass: anObject [
	classOrMetaClass := anObject.
	self source: classOrMetaClass definition
]

{ #category : #'initialize-release' }
GtClassDefinitionCoder >> initializeAddOns [
	super initializeAddOns.
	addOns addStyler: BrRBTextStyler new.
	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousIcons accept
		action: [ self doItAll ].
	addOns clearChanges
]

{ #category : #testing }
GtClassDefinitionCoder >> isModified [
	^ classOrMetaClass definition ~= self source
]

{ #category : #updating }
GtClassDefinitionCoder >> newRbAST: aString [
	| ast |
	ast := RBParser parseFaultyExpression: aString.
	ast doSemanticAnalysis.
	^ ast
]
