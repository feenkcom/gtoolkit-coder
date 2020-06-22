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
GtClassDefinitionCoder >> breadcrumbNamedActions [
	^ classOrMetaClass
		ifNil: [ #() ]
		ifNotNil: [ Array
				streamContents: [ :aStream | 
					| aPackage aPackageName aClass |
					aPackage := classOrMetaClass package.
					aPackageName := aPackage ifNil: [ '' ] ifNotNil: #name.
					aClass := classOrMetaClass.
					aStream
						nextPut: aPackageName -> [ :aButton | aButton phlow spawnObject: aPackage ];
						nextPut:
							aClass name
								->
									[ :aButton | aButton phlow spawnObject: (GtClassCoder forClass: aClass) ] ] ]
]

{ #category : #accessing }
GtClassDefinitionCoder >> classOrMetaClass [
	^ classOrMetaClass
]

{ #category : #accessing }
GtClassDefinitionCoder >> classOrMetaClass: anObject [
	classOrMetaClass := anObject.
	self
		source: classOrMetaClass definition;
		updateCollapsedSource
]

{ #category : #subscriptions }
GtClassDefinitionCoder >> definitionChanged: anAnnouncement [
	anAnnouncement classAffected == classOrMetaClass
		ifFalse: [ ^ self ].
	self
		source: classOrMetaClass definition;
		updateCollapsedSource
]

{ #category : #private }
GtClassDefinitionCoder >> evaluateSource: aString showPrintString: aBoolean [
	^ self
		evaluateBlock: [ (classOrMetaClass ifNil: [ Smalltalk ]) compiler
				source: aString;
				receiver: self object;
				context: self context;
				requestor: (self evaluationRequester source: aString);
				failBlock: [ ^ self flag: 'insert error adornment' ];
				evaluate ]
		showPrintString: aBoolean
]

{ #category : #'initialize-release' }
GtClassDefinitionCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addStyler: BrRBTextStyler new;
		addMainAction: 'Save' translated
			icon: BrGlamorousVectorIcons accept
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
	self doSemanticAnalysis: ast.
	^ ast
]

{ #category : #subscriptions }
GtClassDefinitionCoder >> subscribeToSystem [
	SystemAnnouncer uniqueInstance weak
		when:
			ClassModificationApplied , ClassModifiedClassDefinition
				, ClassParentRenamed , ClassRenamed
		send: #definitionChanged:
		to: self
]
