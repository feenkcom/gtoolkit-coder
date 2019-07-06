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

{ #category : #elements }
GtClassDefinitionCoder >> breadcrumbItemElements [
	<return: #Collection of: #BrButton>
	| theNamedActions |
	"Array (name -> action)"
	theNamedActions := Array
		streamContents: [ :aStream | 
			| aPackage aPackageName aClass |
			aPackage := self classOrMetaClass package.
			aPackageName := aPackage ifNil: [ '' ] ifNotNil: #name.
			aClass := self classOrMetaClass.
			aStream
				nextPut: aPackageName -> [ :aButton | aButton phlow spawnObject: aPackage ];
				nextPut:
					aClass name
						->
							[ :aButton | aButton phlow spawnObject: (GtClassCoder forClass: aClass) ] ].
	^ theNamedActions
		collect: [ :eachNamedAction | 
			BrButton new
				look:
					(BrGlamorousLabelLook new
						foreground: BrGlamorousColors defaultButtonTextColor;
						fontSize: 12);
				label: eachNamedAction key;
				action: eachNamedAction value ]
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
