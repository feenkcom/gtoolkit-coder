Class {
	#name : #GtClassSuperclassDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtClassSuperclassDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #'instance creation' }
GtClassSuperclassDefinition class >> named: aSuperclassName [
	^ self new named: aSuperclassName
]

{ #category : #converting }
GtClassSuperclassDefinition >> asDefinitionString [
	^ self hasSuperclass 
		ifTrue: [ self name ]
		ifFalse: [ 'ProtoObject' ]
]

{ #category : #'api - superclass' }
GtClassSuperclassDefinition >> canBeSuperclass: anObject [
	^ anObject isClass and: [ anObject isMeta not ]
]

{ #category : #'api - accepting' }
GtClassSuperclassDefinition >> differenceWith: aClassSuperclassDefinition [
	<return: #GtCodeDefinitionDifference>
	
	^ self name = aClassSuperclassDefinition name
		ifTrue: [ GtNoDefinitionDifference new ]
		ifFalse: [ GtClassSuperclassDefinitionDifference new
			oldName: aClassSuperclassDefinition name;
			newName: self name ]
]

{ #category : #'api - superclass' }
GtClassSuperclassDefinition >> doesClassExist: aClassName [
	<return: #Boolean>

	^ self class environment includesKey: aClassName
]

{ #category : #'private - errors' }
GtClassSuperclassDefinition >> errorClassDoesNotExist: aSymbol [ 
	"Create an error notification that there is no class with a given name"

	GtBehaviorCoderHeaderSuperclassDoesNotExistError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtClassSuperclassDefinition >> errorSuperclassNotApplicable: aSymbol [
	"Create an error notification that a given code artefact can not be used as a superclass"

	GtBehaviorCoderHeaderSuperclassNotApplicableError signalFor: aSymbol
]

{ #category : #testing }
GtClassSuperclassDefinition >> exists [
	^ self hasSuperclass not
		or: [ Smalltalk globals includesKey: self name ]
]

{ #category : #initialization }
GtClassSuperclassDefinition >> fromClass: aClass [
	name := aClass superclass
		ifNil: [ #nil ]
		ifNotNil: [ :aSuperclass | aSuperclass name ]
]

{ #category : #testing }
GtClassSuperclassDefinition >> hasClassVariableNamed: aString [
	self hasSuperclass
		ifFalse: [ ^ false ].
	^ (Smalltalk globals at: self name ifAbsent: [ ProtoObject ])
		allClassVarNames includes: aString asSymbol
]

{ #category : #testing }
GtClassSuperclassDefinition >> hasSlotNamed: aString [
	self hasSuperclass
		ifFalse: [ ^ false ].
	^ (Smalltalk globals at: self name ifAbsent: [ ProtoObject ])
		allInstVarNames includes: aString asSymbol
]

{ #category : #'api - superclass' }
GtClassSuperclassDefinition >> hasSuperclass [
	^ self name ~= #nil
]

{ #category : #initialization }
GtClassSuperclassDefinition >> initialize [
	super initialize
]

{ #category : #accessing }
GtClassSuperclassDefinition >> name [
	^ name
]

{ #category : #accessing }
GtClassSuperclassDefinition >> name: aSymbol [
	| anOldName aSuperclassName aSuperclass |

	aSuperclassName := aSymbol asSymbol.
	(self doesClassExist: aSuperclassName)
		ifFalse: [ self errorClassDoesNotExist: aSuperclassName ].
	
	aSuperclass := self class environment at: aSuperclassName.
	(self canBeSuperclass: aSuperclass)
		ifFalse: [ self errorSuperclassNotApplicable: aSuperclassName ].
	
	anOldName := name.
	name := aSuperclass name.
	
	anOldName = name
		ifTrue: [ ^ self ].
	
	self
		notifySuperclassRenamed: self
		from: anOldName
		to: name
]

{ #category : #initialization }
GtClassSuperclassDefinition >> named: aSuperclassName [
	name := aSuperclassName
]

{ #category : #'private - notifying' }
GtClassSuperclassDefinition >> notifySuperclassRenamed: aGtClassSuperclassDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorSuperclassRenamed new
		owner: self parent;
		superclass: aGtClassSuperclassDefinition;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #printing }
GtClassSuperclassDefinition >> printOn: aStream [
	aStream print: self name
]
